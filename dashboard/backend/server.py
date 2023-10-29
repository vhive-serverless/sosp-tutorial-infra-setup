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


from flask import Flask, request, jsonify
import csv
from flask_cors import CORS


app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})


# Function to load CSV data into a list of dictionaries
def load_csv(filename):
    data = []
    with open(filename, 'r') as csv_file:
        reader = csv.DictReader(csv_file)
        for row in reader:
            data.append(row)
    return data


def check_if_exists(csv_data, user_email):
    allocated_IP = ''
    for row in csv_data:
        allocated_user = row['User_Email']
        if allocated_user == user_email:  # Check if IP is available
            allocated_IP = row['IP']
            break

    return allocated_IP 

# Function to allocate new IPs and update
def allocate_new(csv_data, user_email):
    allocated_IP = ''
    for i in range(len(csv_data)):
        allocated_user = csv_data[i]['User_Email']
        if not allocated_user:  
            allocated_IP = csv_data[i]['IP']
            csv_data[i]['User_Email'] = user_email
            break
    return allocated_IP,csv_data

# Function to save the updated CSV
def save_csv(filename, csv_data):
    with open(filename, 'w', newline='') as csv_file:
        fieldnames = csv_data[0].keys()
        writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(csv_data)


@app.route('/allocate', methods=['GET'])
def compute():
    user_email = str(request.args.get('email'))

    filename = 'ip_allocation.csv'

    csv_data = load_csv(filename)
    allocated_IP = check_if_exists(csv_data,user_email)
    
    if(allocated_IP==''):
        csv_data_new = load_csv(filename)
        allocated_IP,updated_data = allocate_new(csv_data_new,user_email)
        save_csv(filename, updated_data)
    
    return ({
            'statusCode': 200,
            "headers": {
            "Content-Type" : "application/json",
            "Access-Control-Allow-Headers" : "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
            "Access-Control-Allow-Methods" : "OPTIONS,POST",
            "Access-Control-Allow-Credentials" : True,
            "Access-Control-Allow-Origin" : "*",
            "X-Requested-With" : "*"
        },    
        'user_vm_mapping': {
                'user': user_email,
                'vm_ip': allocated_IP.split(":")[0],
                'port': allocated_IP.split(":")[1]
    }
        })

@app.route('/get_data', methods=['GET'])
def get_data():
    
    filename = 'ip_allocation.csv'
    data = []
    with open(filename, 'r') as csv_file:
        csv_reader = csv.DictReader(csv_file)
        for row in csv_reader:
            ip_port = row['IP']
            if ':' in ip_port:
                ip, port = ip_port.split(':')
                row['IP'] = ip
                row['Ports'] = ['1000'+port+' / '+'2000'+port]
            else:
                row['Ports'] = ''
            data.append(row)

    return jsonify(data)


if __name__ == '__main__':
    app.run(port=5000,threaded=False)