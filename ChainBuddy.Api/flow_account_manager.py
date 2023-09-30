from flow_py_sdk import ProposalKey, flow_client, Tx
from flow_py_sdk.signer import InMemorySigner
from flow_py_sdk import HashAlgo, SignAlgo
from flow_py_sdk.cadence import Address
from flow_py_sdk.cadence.types import UFix64

from common.config import Config

class FlowAccountManager:
    def __init__(self, ctx: Config):
        self.ctx = ctx
        self.client = None

    async def __aenter__(self):
        self.client = flow_client(
            host=self.ctx.access_node_host, port=self.ctx.access_node_port
        )
        return self

    async def __aexit__(self, exc_type, exc_value, traceback):
        if self.client is not None:
            await self.client.__aexit__(None, None, None)

    async def get_account_info(self, account_address):
        if self.client is None:
            raise RuntimeError("FlowClient is not initialized.")

        account = await self.client.get_account(address=account_address.bytes)

        return {
            "Account Address": account.address.hex(),
            "Account Balance": account.balance,
            "Account Keys": len(account.keys),
        }

    async def execute_transaction(self, account_address, signer_key, amount):
        if self.client is None:
            raise RuntimeError("FlowClient is not initialized.")

        latest_block = await self.client.get_latest_block()
        proposer = await self.client.get_account_at_latest_block(address=account_address.bytes)
        signer = InMemorySigner(hash_algo=HashAlgo.SHA3_256, sign_algo=SignAlgo.ECDSA_P256, private_key_hex=signer_key)

        with open("cadence/mint_buddy.cdc", "r") as file:
            mint_transaction = file.read()

        transaction = Tx(
            code=mint_transaction,
            reference_block_id=latest_block.id,
            payer=account_address,
            proposal_key=ProposalKey(
                key_address=account_address,
                key_id=0,
                key_sequence_number=proposer.keys[0].sequence_number,
            ),
        ).with_envelope_signature(
            account_address,
            0,
            signer,
        )
        transaction.add_arguments(Address(proposer.address), UFix64(amount))
        
        await self.client.execute_transaction(transaction)
