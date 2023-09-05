#!/usr/bin/env python3

import os
from datetime import datetime

def createGreeting(name):

    now         = datetime.now()
    human_time  = now.strftime("%H:%M:%S")

    greeting = f"Hello {name}, welcome to the Time Exchange.\nThe current time is {human_time}"
    return greeting

# Lambda calls this function to begin 
def lambda_handler(event, context):

    name = event['queryStringParameters']['name']
    greeting = createGreeting(name)

    responseObject = {}
    responseObject['statusCode'] = 200
    responseObject['headers'] = {}
    responseObject['headers']['Content-Type'] = 'application/json'
    responseObject['body'] = greeting

    #Return the response object through API Gateway
    return responseObject
