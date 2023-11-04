# Flask API for Flow Blockchain

## Prerequisites

Before running the API, ensure you have the following prerequisites:

1. **Python**: Make sure you have Python 3.x installed on your system.

## Running the API

Follow these steps to run the Flask API:

Navigate to the Directory: Open a terminal and navigate to the directory where your api.py file is located.

Activate a Virtual Environment (Optional): It's a good practice to create and activate a virtual environment for your project to isolate dependencies. You can create a virtual environment using virtualenv or venv.

Run the Flask Application: To start the Flask API, use the following command:

```bash
python api.py
```

The Flask development server will start, and you'll see output indicating that the server is running. By default, the API will be accessible at http://127.0.0.1:5000/.

Accessing the API: You can access the API by making HTTP requests to the specified endpoints.

GET **/account_info<account_address>**: Retrieve account information for the specified account address.

POST **/execute_transaction**: Execute a transaction by providing account information, signer key, and amount in the request body.
