import json
import platform
import datetime
import os

def lambda_handler(event, context):
    headers = event.get("headers", {})
    user_agent = headers.get("User-Agent")
    sistema_operacional = platform.system()
    data_hora_atual = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    response_body = {
        "message": "Client Information",
        "userAgent": user_agent,
        "os": sistema_operacional,
        "dateTime": data_hora_atual
    }

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(response_body)
    }