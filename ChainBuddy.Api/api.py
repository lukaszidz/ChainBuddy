import pathlib
from flask import Flask, request, jsonify
from flow_account_manager import FlowAccountManager
from flow_py_sdk.cadence import Address
from common.config import Config

app = Flask(__name__)
config_location = pathlib.Path(__file__).parent.resolve().joinpath("./config.json")
ctx = Config(config_location)
flow_manager = FlowAccountManager(ctx)

@app.route("/account_info/<account_address>", methods=["GET"])
async def account_info(account_address):
    async with flow_manager:
        account_info = await flow_manager.get_account_info(Address.from_hex(account_address))
    return jsonify(account_info)


@app.route("/execute_transaction", methods=["POST"])
async def execute_transaction():
    data = request.get_json()
    account_address = data.get("account_address")
    signer_key = data.get("signer_key")
    amount = data.get("amount")

    if not account_address or not signer_key:
        return jsonify({"error": "Both account_address and signer_key are required."}), 400

    async with flow_manager:
        await flow_manager.execute_transaction(Address.from_hex(account_address), signer_key, amount)
    
    return jsonify({"message": "Transaction executed successfully."})

if __name__ == "__main__":
    app.run(debug=True)
