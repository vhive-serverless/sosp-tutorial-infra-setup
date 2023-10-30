# Backend

## Prerequisites

Python 3 & pip should be installed on your system.

## Installation

1. Navigate to the "backend" directory:
```shell
cd backend
```

2. Install the required dependencies:

```shell
pip3 install flask flask_cors
```


## Configuration

If your backend is running on HTTP and the frontend is running on HTTPS (e.g., GitHub Pages), follow these additional steps:

1. Deploy the "lambda_proxy.py" function as an AWS Lambda function. You can do this using AWS Lambda and API Gateway/Lambda Function URL.

2. Obtain a valid endpoint URL for the Lambda function. This URL will serve as the proxy between the frontend and backend. Take note of this URL. You will need to replace "Lambda_URL" in the  "frontend/src/proxy_url.js" with this URL.

### IP Allocation

Before running the backend server, you need to generate IP address and port pairs using the "generate_ip_port_pairs.py" script.

1. Open the "ips.csv" file and fill it with the IP addresses of your nodes.

2. Generate the IP:Port mapping by running the script:

```shell
python3 generate_ip_port_pairs.py
```
This will create an "ip_allocation.csv" file, which is used for allocating IPs in a round-robin manner.

## Running the Backend

Start the Flask backend server:

```shell
python3 server.py
```

The backend will allocate the IP addresses based on the "ip_allocation.csv" file.


# Frontend

## Prerequisites

Node.js and npm should be installed on your system.

## Installation

1. Navigate to the "frontend" directory:
```shell
cd frontend
```

2. Install the required dependencies:

```shell
npm install
```


## Configuration

Note : If your backend is running on HTTP and the frontend is running on HTTPS (e.g., GitHub Pages), you will need to set a proxy URL in the "proxy_url.js" file. 
Replace "{Lambda_URL}" with the actual URL of Lambda function:

```shell
 lambda_proxy_url : 'https://{Lambda_URL}/'
 ```

## Running the Frontend

Start the frontend development server:
```shell 
npm start
```

The frontend will be accessible in your web browser at http://localhost:3000.