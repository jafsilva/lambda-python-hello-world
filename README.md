# Pipeline Serveless AWS Lambda

Projeto para o artigo: [Parte 1: Deploy Serverless com AWS Lambda usando GitHub Actions e Terraform](https://www.linkedin.com/pulse/parte-1-deploy-serverless-com-aws-lambda-usando-github-jos%C3%A9-aparecido-df9vf)

---

## Sumário
1. [Pré-requisitos](#pré-requisitos)
2. [Como Executar](#como-executar)
3. [Contribuição](#contribuição)
4. [Licença](#licença)

---

## Pré-requisitos
  
Antes de começar a criação da pipeline, precisamos configurar a AWS e GitHub Actions:

1. **Conta AWS**: Crie uma conta gratuita.
2. **Configurar Conta AWS** com a criação desses itens: **AWS_ACCESS_KEY** e **AWS_SECRET_KEY**.
3. **Conta Github**: Crie uma conta gratuita.
4. Criar um novo ou realizar um fork do projeto contido no fim do artigo
5. **Configurar Github Actions**: Criar secrets e variavel para serem utilizadas na pipeline de acordo com as imagens a seguir:

---

## Como Executar

Siga todos os passos anteriores e suba o código no seu repositório remoto. Para executar o projeto:

1. Clone o repositório:
   ```bash
   git clone https://github.com/jafsilva/serveless-aws-lambda.git
   cd ci-cd-para-iniciantes
   ```
2. Configure as variáveis de ambiente no Github Actions.

---

## Contribuição

Contribuições são bem-vindas! Siga os passos abaixo:

1. Faça um fork do projeto [serveless-aws-lambda](https://github.com/jafsilva/serveless-aws-lambda.git) 
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`).
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`).
4. Faça push para a branch (`git push origin feature/nova-feature`).
5. Abra um Pull Request.

---

## Licença

Este projeto está licenciado sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---
