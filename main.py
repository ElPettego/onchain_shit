import requests as r
from solana.rpc.api import Client
from pprint import pprint
from os import listdir
from datetime import datetime
import pandas


def merge_folder_into_dataset(path):
    df = None
    p = "data/"
    for file in listdir(f"{p}{path}"):
        col = None
        if file.endswith(".tsv"):
            col = pandas.read_csv(f"{p}{path}/{file}", sep="\t")
        if file.endswith(".json"):
            col = pandas.read_json(f"{p}{path}/{file}")
            col["Time"] = col["t"].apply(lambda x: datetime.utcfromtimestamp(x).date().strftime("%d.%m.%Y"))
            print(col)
            # exit(10)
        if col is None:
            continue
        
        if df is None:
            df = col
            print("flag")
            continue
        df = df.join(col, how="inner", lsuffix="_l")
        print(df)
        # exit(10)
        # print(file)
        del df["Time"]
        print(df)
    # t = df["Time"].iloc[:, 0]
    # del df["Time"]
    # df = pandas.concat([t, df], axis=1)
    df.to_csv(f"{p}{path}_dataset_dbg.csv", index=False)
    print(df)

URL = "https://api.mainnet-beta.solana.com/"

def main():
    merge_folder_into_dataset("btc")
    exit(10)
    client = Client(URL)

    # Get the latest block
    block = client.get_block(271803120, max_supported_transaction_version=0)

    # Print the block size
    pprint(block)

if __name__ == "__main__":
    main()
