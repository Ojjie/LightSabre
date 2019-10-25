pragma solidity ^0.5.0;

contract addLuggage2{
    string public name;
    mapping(string => Luggage) private luggageStore;
    mapping(string => mapping(string => sentrecieved)) private walletStore;

    struct Luggage{
        uint weight;
        bool initialized;
        string airport_initial;
    }

    struct sentrecieved {
        bool sent;
        string airport_sent;
        bool received;
        string airport_received;
    }

    event AssetCreate(string account, string uuid, uint weight);
    event RejectCreate(string account, string uuid, string message);
    event AssetTransfer(string from, string to, string uuid);
    event RejectTransfer(string from, string to, string uuid, string message);

    function createAsset(string memory uuid, uint weight, string memory airport_initial) public {
        if(luggageStore[uuid].initialized) {
            emit RejectCreate(airport_initial, uuid, "Asset with this UUID already exists.");
            return;
        }

        luggageStore[uuid] = Luggage(weight, true, airport_initial);
        sentrecieved memory a;
        a.sent = false;
        a.received = true;
        walletStore[airport_initial][uuid] = a;
        emit AssetCreate(airport_initial, uuid, weight);
    }
    
    function sendAsset(string memory airport_from, string memory airport_to, string memory uuid) public {
        if(!luggageStore[uuid].initialized) {
            emit RejectTransfer(airport_from, airport_to, uuid, "No asset with this UUID exists");
            return;
        }
        if(!walletStore[airport_from][uuid].received) {
            emit RejectTransfer(airport_from, airport_to, uuid, "Sender did not recieve this luggage.");
            return;
        }
        walletStore[airport_from][uuid].sent = true;
        walletStore[airport_from][uuid].airport_sent = airport_to;
        // walletStore[to][uuid] = true;
        emit AssetTransfer(airport_from, airport_to, uuid);
    }

    function recieveAsset(string memory airport_from, string memory airport_to, string memory uuid) public {
        if(!luggageStore[uuid].initialized) {
            emit RejectTransfer(airport_from, airport_to, uuid, "No asset with this UUID exists");
            return;
        }
        if(!walletStore[airport_from][uuid].sent) {
            emit RejectTransfer(airport_from, airport_to, uuid, "Sender did not send the luggage");
            return;
        }
        walletStore[airport_to][uuid].received = true;
        walletStore[airport_to][uuid].airport_received = airport_from;
        // walletStore[to][uuid] = true;
        emit AssetTransfer(airport_from, airport_to, uuid);
    }

    function getAssetByUUID(string memory uuid) public view returns (uint, string memory) {
        return (luggageStore[uuid].weight, luggageStore[uuid].airport_initial);
    }

    function isOwnerOf(string memory owner, string memory uuid) public view returns (bool) {
        if(walletStore[owner][uuid].received && !walletStore[owner][uuid].sent) {
            return true;
        }
        return false;
    }

    function append(string memory a, string memory b, string memory c, string memory d, string memory e, string memory f) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b, c, d, e, f));
    }

    function trackLuggage(string memory uuid) public view returns (string memory)  {
        string memory cur_airport = luggageStore[uuid].airport_initial;
        string memory output = "";
        sentrecieved memory cur_sr = walletStore[luggageStore[uuid].airport_initial][uuid];
        while(cur_sr.sent) {
            output = append(output, "Luggage sent from ",cur_airport," to ",cur_sr.airport_sent,"\n");
            if(walletStore[cur_sr.airport_sent][uuid].received) {
                output = append(output, "Luggage received at ",cur_sr.airport_sent," from ",walletStore[cur_sr.airport_sent][uuid].airport_received,"\n");
            }
            cur_airport = cur_sr.airport_sent;
            cur_sr = walletStore[cur_airport][uuid];
        }
        return output;
    }
}

// addluggage2 = await addLuggage2.deployed()
// ac = await web3.eth.getAccounts()
// addluggage2.createAsset("123", 123, "Bangalore")
// addluggage2.isOwnerOf("Bangalore", "123")
// addluggage2.sendAsset("Bangalore", "Chennai", "123")
// addluggage2.isOwnerOf("Chennai", "123")
// addluggage2.recieveAsset("Bangalore", "Chennai", "123")
// addluggage2.isOwnerOf("Chennai", "123")
// addluggage2.trackLuggage("123")
