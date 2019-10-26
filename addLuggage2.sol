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

    function createAsset(string memory _uuid, uint _weight, string memory _airport_initial) public {
        // Require valid _uuid
        require(bytes(_uuid).length>0, "Invalid uuid");
        //Require a valid _weight
        require(_weight>0,"Invalid _Weight");
        //Require a valid initial airport
        require(bytes(_airport_initial).length>0,"Invalid initial airport");
        if(luggageStore[_uuid].initialized) {
            emit RejectCreate(_airport_initial, _uuid, "Asset with this UUID already exists.");
            return;
        }

        luggageStore[_uuid] = Luggage(_weight, true, _airport_initial);
        sentrecieved memory a;
        a.sent = false;
        a.received = true;
        walletStore[_airport_initial][_uuid] = a;
        emit AssetCreate(_airport_initial, _uuid, _weight);
    }
    
    function sendAsset(string memory _airport_from, string memory _airport_to, string memory _uuid) public {
        // Require valid _airport_from
        require(bytes(_airport_from).length>0,"Invalid source airport");
        // Require valid _airport_to
        require(bytes(_airport_to).length>0,"Invalid destination airport");
        // Require valid _uuid
        require(bytes(_uuid).length>0, "Invalid uuid");
        
        if(!luggageStore[_uuid].initialized) {
            emit RejectTransfer(_airport_from, _airport_to, _uuid, "No asset with this UUID exists");
            return;
        }
        if(!walletStore[_airport_from][_uuid].received) {
            emit RejectTransfer(_airport_from, _airport_to, _uuid, "Sender did not recieve this luggage.");
            return;
        }
        if(walletStore[_airport_from][_uuid].sent) {
            emit RejectTransfer(_airport_from, _airport_to, _uuid, "Sender already sent the luggage.");
            return;
        }
        walletStore[_airport_from][_uuid].sent = true;
        walletStore[_airport_from][_uuid].airport_sent = airport_to;
        emit AssetTransfer(_airport_from, _airport_to, _uuid);
    }

    function recieveAsset(string memory airport_from, string memory airport_to, string memory uuid) public {
        // Require valid _airport_from
        require(bytes(_airport_from).length>0,"Invalid source airport");
        // Require valid _airport_to
        require(bytes(_airport_to).length>0,"Invalid destination airport");
        // Require valid _uuid
        require(bytes(_uuid).length>0, "Invalid uuid");
        
        if(!luggageStore[_uuid].initialized) {
            emit RejectTransfer(_airport_from, _airport_to, _uuid, "No asset with this UUID exists");
            return;
        }
        if(!walletStore[airport_from][_uuid].sent) {
            emit RejectTransfer(_airport_from, _airport_to, _uuid, "Sender did not send the luggage");
            return;
        }
        walletStore[_airport_to][_uuid].received = true;
        walletStore[_airport_to][_uuid].airport_received = _airport_from;
        emit AssetTransfer(_airport_from, _airport_to, _uuid);
    }

    function getAssetByUUID(string memory uuid) public view returns (uint, string memory) {
        return (luggageStore[_uuid].weight, luggageStore[_uuid].airport_initial);
    }

    function isOwnerOf(string memory owner, string memory uuid) public view returns (bool) {
        if(walletStore[_owner][_uuid].received && !walletStore[_owner][_uuid].sent) {
            return true;
        }
        return false;
    }

    function append(string memory a, string memory b, string memory c, string memory d, string memory e, string memory f) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b, c, d, e, f));
    }

    function trackLuggage(string memory _uuid) public view returns (string memory,string memory)  {
        string memory cur_airport = luggageStore[_uuid].airport_initial;
        string memory output = "";
        sentrecieved memory cur_sr = walletStore[luggageStore[_uuid].airport_initial][_uuid];
        while(cur_sr.sent) {
            output = append(output, "Luggage sent from ",cur_airport," to ",cur_sr.airport_sent,"\n");
            if(walletStore[cur_sr.airport_sent][_uuid].received) {
                output = append(output, "Luggage received at ",cur_sr.airport_sent," from ",walletStore[cur_sr.airport_sent][_uuid].airport_received,"\n");
            }
            cur_airport = cur_sr.airport_sent;
            cur_sr = walletStore[cur_airport][_uuid];
        }
        return (output,cur_airport);
    }
    function LocateMyLuggage(string memory _uuid) public view returns (string memory) {
        
            string memory cur_airport;
            string memory output=" ";
            (output,cur_airport)=trackLuggage(_uuid);    
            return cur_airport; 
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
