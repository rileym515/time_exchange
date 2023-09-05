#!/usr/bin/env python3
import requests
import boto3
import sys, getopt

apiclient = boto3.client('apigateway')

def getKey(key_id):

    api_key = apiclient.get_api_key(apiKey=key_id, includeValue=True)
    print("API Key response"
    print(api_key)
    return api_key["value"]

def hitApi(key_value, api_url):

    headers = {'x-api-key' : key_value}
    get_msg_url = f'{api_url}/mytime?name=Mike'

    get_msg = requests.get(get_msg_url, headers=headers)
    get_msg_resp = get_msg.content
    if "Hello Mike" in str(get_msg_resp):
      print("Response with name returned")
    else:
      print("Error: Name not in response")
      sys.exit(4)

def controller(api_url, key_id):

    key_value = getKey(key_id)
    hitApi(key_value, api_url)

def set_vars(argv):

    api_url = ""
    key_id = ""

    try:
        opts, args = getopt.getopt(argv,"ha:k:")
    except getopt.GetoptError:
        print('Usage: -a <api ID> -k <api key ID>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('Usage: -a <api ID> -k <api key ID>')
            sys.exit()
        elif opt == ('-a'):
            api_url = arg.replace('"','')
            print(f"API URL is - {api_url}")
        elif opt == ('-k'):
            key_id = arg.replace('"','')
            print(f"Key ID is - {key_id}")

    controller(api_url, key_id)

# Let's begin here
if __name__ == "__main__":
    set_vars(sys.argv[1:])
