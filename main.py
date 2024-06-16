import requests as r
from solana.rpc.api import Client
from pprint import pprint




URL = "https://api.mainnet-beta.solana.com/"

def main():
    client = Client(URL)

    # Get the latest block
    block = client.get_block(271803120, max_supported_transaction_version=0)

    # Print the block size
    pprint(block)

if __name__ == "__main__":
    main()