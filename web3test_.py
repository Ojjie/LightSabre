import json
from web3 import Web3, HTTPProvider
from web3.contract import ConciseContract


# compile your smart contract with truffle first
truffleFile = json.load(open('src/abis/addLuggage2.json'))
abi = truffleFile['abi']
bytecode = truffleFile['bytecode']

# web3.py instance
w3 = Web3(HTTPProvider("http://127.0.0.1:7545"))
print(w3.isConnected())
contract_address = Web3.toChecksumAddress("0x31F416460D0EA0116138719D2defABF8b167137D")

# Contract instance
contract_instance = w3.eth.contract(abi=abi, address=contract_address)

print('Contract value: {}'.format(contract_instance.functions.locateMyLuggage("5e011308-cd6d-438b-84f5-7ab23ed91aa1").call()))