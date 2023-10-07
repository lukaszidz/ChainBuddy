from rasa_sdk import Action
from dotenv import load_dotenv
import requests
import os


class ActionGetAccountInfo(Action):
    def __init__(self) -> None:
        load_dotenv()
        self.buddy_api_url = os.environ.get('BUDDY_API_URL')

    def name(self):
        return "action_get_account_info"

    def run(self, dispatcher, tracker, domain):        
        account_address = tracker.get_slot("account_address")
        response = requests.get(f"{self.buddy_api_url}/account_info/{account_address}")
        dispatcher.utter_message(text=f"Account info: {response.json()}")

class ActionBuyBuddyToken(Action):
    def name(self):
        return "action_buy_buddy_token"

    def run(self, dispatcher, tracker, domain):
        account_address = tracker.get_slot("account_address")
        signer_key = tracker.get_slot("signer_key")
        amount = 1  # This could also be extracted from user message if needed
        payload = {
            "account_address": account_address,
            "signer_key": signer_key,
            "amount": amount
        }
        
        response = requests.post(f"{self.buddy_api_url}/execute_transaction", json=payload)
        # Assume the API returns a message on success
        dispatcher.utter_message(text=f"Transaction result: {response.json().get('message')}")
