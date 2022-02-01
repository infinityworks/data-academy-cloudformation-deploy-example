import requests
import os
import json

def lambda_handler(event, context):
    
    IP_API_ENDPOINT = os.getenv('IP_API_ENDPOINT')
       
    api_response = requests.get(IP_API_ENDPOINT + "?format=json")
    
    body = json.loads(api_response.text)
    resp = f"Public Egress IP of the Lambda Function is: {body['ip']}"
    
    print(resp)
    return resp