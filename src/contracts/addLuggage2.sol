pragma solidity ^0.5.0;

contract addLuggage2{
    string public name;
    mapping(string => Luggage) private luggageStore;
    mapping(string => mapping(string => sentreceived)) private walletStore;

    struct Luggage {
        uint weight;
        bool initialized;
        string airport_initial;
    }

    struct sentreceived {
        bool sent;
        string airport_sent;
        string timestamp_sent;
        bool received;
        string airport_received;
        string timestamp_received;
    }

    event AssetCreate(string account, string uuid, uint weight);
    event RejectCreate(string account, string uuid, string message);
    event AssetTransfer(string from, string to, string uuid);
    event RejectTransfer(string from, string to, string uuid, string message);

    function createAsset(string memory _uuid, uint _weight, string memory _airport_initial, string memory _timestamp) public {

        // Require valid _uuid
        require(bytes(_uuid).length>0, "Invalid uuid");
        //Require a valid _weight
        require(_weight>0,"Invalid _Weight");
        //Require a valid initial airport
        require(bytes(_airport_initial).length>0,"Invalid initial airport");

        if(luggageStore[_uuid].initialized) {
            emit RejectCreate(_airport_initial, _uuid, "Asset with this _UUID already exists.");
            return;
        }

        luggageStore[_uuid] = Luggage(_weight, true, _airport_initial);
        sentreceived memory a;
        a.sent = false;
        a.received = true;
        a.timestamp_received = _timestamp;
        walletStore[_airport_initial][_uuid] = a;
        emit AssetCreate(_airport_initial, _uuid, _weight);
    }

    function sendAsset(string memory _airport_from, string memory _airport_to, string memory _uuid, string memory _timestamp) public {
        // Require valid _airport_from
        require(bytes(_airport_from).length>0,"Invalid source airport");
        // Require valid _airport_to
        require(bytes(_airport_to).length>0,"Invalid destination airport");
        // Require valid _uuid
        require(bytes(_uuid).length>0, "Invalid uuid");

        if(!luggageStore[_uuid].initialized) {
            emit RejectTransfer(_airport_from, _airport_to, _uuid, "No asset with this _UUID exists.");
            return;
        }
        if(!walletStore[_airport_from][_uuid].received) {
            emit RejectTransfer(_airport_from, _airport_to, _uuid, "Sender did not receive this luggage.");
            return;
        }
        if(walletStore[_airport_from][_uuid].sent) {
            emit RejectTransfer(_airport_from, _airport_to, _uuid, "Sender already sent the luggage.");
            return;
        }
        walletStore[_airport_from][_uuid].sent = true;
        walletStore[_airport_from][_uuid].airport_sent = _airport_to;
        walletStore[_airport_from][_uuid].timestamp_sent = _timestamp;
        // walletStore[to][_uuid] = true;
        emit AssetTransfer(_airport_from, _airport_to, _uuid);
    }

    function receiveAsset(string memory _airport_from, string memory _airport_to, string memory _uuid, string memory _timestamp) public {
        // Require valid _airport_from
        require(bytes(_airport_from).length>0,"Invalid source airport");
        // Require valid _airport_to
        require(bytes(_airport_to).length>0,"Invalid destination airport");
        // Require valid _uuid
        require(bytes(_uuid).length>0, "Invalid uuid");

        if(!luggageStore[_uuid].initialized) {
            emit RejectTransfer(_airport_from, _airport_to, _uuid, "No asset with this _UUID exists");
            return;
        }
        if(!walletStore[_airport_from][_uuid].sent) {
            emit RejectTransfer(_airport_from, _airport_to, _uuid, "Sender did not send the luggage");
            return;
        }
        if(walletStore[_airport_to][_uuid].received) {
            emit RejectTransfer(_airport_from, _airport_to, _uuid, "Receiver already received this luggage");
            return;
        }
        walletStore[_airport_to][_uuid].received = true;
        walletStore[_airport_to][_uuid].airport_received = _airport_from;
        walletStore[_airport_to][_uuid].timestamp_received = _timestamp;
        // walletStore[to][_uuid] = true;
        emit AssetTransfer(_airport_from, _airport_to, _uuid);
    }

    function getAssetByUUID(string memory _uuid) public view returns (uint, string memory) {
        return (luggageStore[_uuid].weight, luggageStore[_uuid].airport_initial);
    }

    function getWalletStore(string memory _airport, string memory _uuid) public view returns (bool, string memory, bool, string memory, string memory, string memory) {
        return (walletStore[_airport][_uuid].sent, walletStore[_airport][_uuid].airport_sent, walletStore[_airport][_uuid].received, walletStore[_airport][_uuid].airport_received, walletStore[_airport][_uuid].timestamp_sent, walletStore[_airport][_uuid].airport_received);
    }

    function isOwnerOf(string memory _owner, string memory _uuid) public view returns (bool) {
        if(walletStore[_owner][_uuid].received && !walletStore[_owner][_uuid].sent) {
            return true;
        }
        return false;
    }

    function append(string memory a, string memory b, string memory c, string memory d, string memory e, string memory f, string memory g, string memory h) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b, c, d, e, f, g, h));
    }

    function trackLuggage(string memory _uuid) public view returns (string memory, string memory)  {
        string memory cur_airport = luggageStore[_uuid].airport_initial;
        string memory output = "";
        string memory temp_output = "";
        sentreceived memory cur_sr = walletStore[luggageStore[_uuid].airport_initial][_uuid];
        temp_output = append("", "", "Luggage received at ",cur_airport," ",cur_sr.timestamp_received, "","\n");
        output = append(output, temp_output, "", "", "", "", "", "");
        while(cur_sr.sent) {
            temp_output = append("", "Luggage sent from ",cur_airport," to ",cur_sr.airport_sent, " ", cur_sr.timestamp_sent,"\n");
            output = append(output, temp_output, "", "", "", "", "", "");
            if(walletStore[cur_sr.airport_sent][_uuid].received) {
                temp_output = append("", "Luggage received at ",cur_sr.airport_sent," from ",walletStore[cur_sr.airport_sent][_uuid].airport_received, " ", walletStore[cur_sr.airport_sent][_uuid].timestamp_received,"\n");
                output = append(output, temp_output, "", "", "", "", "", "");
            }
            cur_airport = cur_sr.airport_sent;
            cur_sr = walletStore[cur_airport][_uuid];
        }
        return (output, temp_output);
    }

    function locateMyLuggage(string memory _uuid) public view returns (string memory) {
        string memory output = " ";
        // bool received;
        string memory temp_output;
        (output, temp_output) = trackLuggage(_uuid);
        return temp_output;
        // if(received) {
        //     output = append("Luggage received at ", cur_airport, "", "", "", "");
        //     return output;
        // }

        // else {
        //     output = append("The Luggage is still on route from ", airport_received, " to ", cur_airport, "\n", "");
        //     return output;
        // }

    }
}

// addluggage2 = await addLuggage2.deployed()
// ac = await web3.eth.getAccounts()
// addluggage2.createAsset("123", 123, "Bangalore")
// addluggage2.isOwnerOf("Bangalore", "123")
// addluggage2.sendAsset("Bangalore", "Chennai", "123")
// addluggage2.isOwnerOf("Chennai", "123")
// addluggage2.receiveAsset("Bangalore", "Chennai", "123")
// addluggage2.isOwnerOf("Chennai", "123")
// addluggage2.trackLuggage("123")
// addluggage2.locateMyLuggage("123")

// addluggage2.sendAsset("Chennai", "Mumbai", "123")
