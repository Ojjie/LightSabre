# LightSabre

## Description

 - A major problem in the Airlines industry is the loss of luggage and property. Almost 35% of the Airlines losses incurred are due to loss of luggage and it is found that this can be avoided by using a decentralized server which has an advantage over conventional databases in that it cannot be hacked into and modified.
 - There are currently a multitude of players involved in this process, who could synchronize by sharing information, which would save airlines costs. This way, the customer and the airline can know where the luggage is at any time.
 - It is also a transparent way to deal with the user’s property so it could even lead to increased business with said airline
 - Our web application will notify the user of the current location of his/her luggage and the path taken by the luggage
 - The server side application includes an option for the airline to mine (add or remove) a block from the blockchain network.
 - Airlines can access the entire blockchain and resolve conflicts within the server side app.

## Requirements

 - Node Package Manager (npm)
 - All npm requirements are listed in `package.json`
 - NPM dependencies:
   - Truffle
   - Ganache
   - Web3.js
   - Metamask
   - Solidity
 - Python dependencies:
   - Python 3.6+
   - Flask 1.0.2
   - SQLite3 (installed by default in Python3)
   - virtualenv or conda
## Instructions
   1. Zip or clone the repository from the github link provided.
   2. Open Ganache.
   3. Create a workspace and connect it to the truffle config file in the created directory.
   4. If Ganache pops with an error, install the dependencies in the directory using 'npm install'.
   5. 'truffle compile' in terminal.
   6. 'truffle migrate' in terminal.
   7. If truffle migrate does not connect to ethereum(Ganache) network use 'truffle migrate --reset'.
   8. Run metamask and create a wallet. Import private keys of an address from ganache into an account of metamask using import account.
   9. Then do 'cd flask-fileserver'.Run the flask server using 'python app.py' or 'py app.py'.
   10. Run react using 'npm run start'.
   11. Then go to http://localhost:5000.
   12. The app should be displayed.
   13. Create a login.
   14. Track or locate your luggage.
   15. If its just an airline it can add luggage,send luggage and also receive the luggage.

