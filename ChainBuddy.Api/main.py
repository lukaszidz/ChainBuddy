from flow_account_manager import FlowAccountManager
from flow_py_sdk import flow_client
from common.config import Config
import pathlib
import asyncio


async def main():
    config_location = pathlib.Path(__file__).parent.resolve().joinpath("./config.json")
    ctx = Config(config_location)
    async with FlowAccountManager(ctx) as client_manager:
        account_info = await client_manager.get_account_info(
            ctx.service_account_address
        )
        for key, value in account_info.items():
            print(f"{key}: {value}")


asyncio.run(main())
