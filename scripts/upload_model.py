from argparse import ArgumentParser
import requests

parser = ArgumentParser()
parser.add_argument("-a", "--assetid", dest="assetid", required=True)
parser.add_argument("-f", "--file", dest="filepath", required=True)
parser.add_argument("-r", "--roblosecurity",
                    dest="roblosecurity", required=True)

args = parser.parse_args()

url = "https://data.roblox.com/Data/Upload.ashx?assetid=" + args.assetid
cookies = {'.ROBLOSECURITY': args.roblosecurity}
headers = {
    'Content-Type': 'application/xml',
    'User-Agent': 'roblox',
    'x-csrf-token': ''}

with open(args.filepath, 'rb') as file_reader:
    payload = file_reader.read()

    response = requests.post(
        url=url,
        data=payload,
        cookies=cookies,
        headers=headers)

    if response.status_code == 403:
        headers['x-csrf-token'] = response.headers['x-csrf-token']
        response = requests.post(
            url=url,
            data=payload,
            cookies=cookies,
            headers=headers)

    if response.status_code != 200:
        raise Exception("Request did not succeed")
