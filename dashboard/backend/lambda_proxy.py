# MIT License
#
# Copyright (c) 2023 Dilina Dehigama and EASE Lab
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import urllib3

def lambda_handler(event, context):
    
    email = event.get('queryStringParameters', {}).get('email')

    # Prepare the URL with the email parameter
    backend_url = "{backend_public_ip}/allocate?email="+email

    http = urllib3.PoolManager()
    try:
        response = http.request('GET', backend_url)
        response_data = response.data.decode('utf-8')
        print(response_data)
        if response.status == 200:
            # You can return the response content as a string
            return {
            'statusCode': 200,
            "headers": {
            "Content-Type" : "application/json",
            "Access-Control-Allow-Headers" : "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
            "Access-Control-Allow-Methods" : "OPTIONS,POST",
            "Access-Control-Allow-Credentials" : True,
            "Access-Control-Allow-Origin" : "*",
            "X-Requested-With" : "*"
        },
            'body': response_data
        }
        else:
            # Handle other status codes as needed
            return {
                "statusCode": response.status_code,
                "body": "HTTP request failed",
                "headers": {
                    "Content-Type": "application/json"
                }
            }
    except Exception as e:
        # Handle any exceptions that may occur during the request
        return {
            "statusCode": 500,
            "body": str(e),
            "headers": {
                "Content-Type": "application/json"
            }
        }
