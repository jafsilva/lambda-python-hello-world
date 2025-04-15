terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket  = "zelabs-tf-state"
    key     = "hellowlambda-python-hello-world/terraform.tfstate"
    region  = "us-east-1"
  }
}

# Configure o provider AWS
provider "aws" {
  region  = "us-east-1"
  default_tags {
    tags = {
      Environment = "Test"
      Owner       = "Jose Aparecido"
      Managed     = "Terraform"
    }
  }
}

# 1. Criar o Role do IAM para a Lambda
resource "aws_iam_role" "this" {
  name = "HelloWorldLambdaRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

# 2. Criar a Política do IAM para a Lambda (permite logs no CloudWatch)
resource "aws_iam_policy" "this" {
  name        = "HelloWorldLambdaPolicy"
  description = "Permissões básicas para a função Lambda (CloudWatch Logs)"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:${data.aws_region.current.name}:*:*"
      },
    ]
  })
}

# 3. Anexar a Política ao Role da Lambda
resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

# 4. Criar a Função Lambda
resource "aws_lambda_function" "this" {
  function_name = "HelloWorldLambda"
  runtime       = "python3.11"
  handler       = "lambda_main.lambda_handler"
  filename      = "lambda_main.zip"
  role          = aws_iam_role.this.arn
  memory_size   = 128
  timeout       = 30

  depends_on = [
    aws_iam_role_policy_attachment.this
  ]
}

# 5. Criar o REST API Gateway
resource "aws_api_gateway_rest_api" "this" {
  name        = "HelloWorldAPI"
  description = "API para obter informações do servidor"
}

# 6. Criar o Recurso no API Gateway
resource "aws_api_gateway_resource" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "hello"
}

# 7. Criar o Método GET no Recurso
resource "aws_api_gateway_method" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.this.id
  http_method   = "ANY"
  authorization = "NONE" # Sem autorização por enquanto
}

# 8. Configurar a Integração do Método com a Lambda (Proxy)
resource "aws_api_gateway_integration" "this" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.this.id
  http_method             = aws_api_gateway_method.this.http_method
  integration_http_method = "POST" # Lambda é sempre chamada com POST via proxy
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.this.invoke_arn
}

# 9. Criar a Implantação da API Gateway
resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  depends_on = [
    aws_api_gateway_integration.this,
    aws_api_gateway_method.this
  ]
}

resource "aws_api_gateway_stage" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  deployment_id = aws_api_gateway_deployment.this.id
  stage_name    = "default"
}



# 10. Permitir que o API Gateway invoque a Lambda
resource "aws_lambda_permission" "this" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}

# 11. Output da URL de Invocação da API
output "invoke_url" {
  value = "${aws_api_gateway_deployment.this.invoke_url}${aws_api_gateway_stage.this.stage_name}${aws_api_gateway_resource.this.path}"
}

# Data source para obter a região atual
data "aws_region" "current" {}