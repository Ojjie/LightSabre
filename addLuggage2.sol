pragma solidity ^0.5.0;

contract addLuggage2{
    string public name;
    // uint public luggageCount;
    // mapping(uint => Luggage) public luggages;
    mapping(string => Luggage) private luggageStore;
    mapping(address => mapping(string => sentrecieved)) private walletStore;

    struct Luggage{
        uint weight;
        bool initialized;
    }

    struct sentrecieved {
        bool sent;
        bool recieved;
    }

    // event LuggageAdded (
    //     uint id,
    //     string owner_name,
    //     uint price,
    //     uint weight,
    //     address payable owner,
    //     bool sent,
    //     uint airport_id,
    //     string airport_name
    // );

    event AssetCreate(address account, string uuid, uint weight);
    event RejectCreate(address account, string uuid, string message);
    event AssetTransfer(address from, address to, string uuid);
    event RejectTransfer(address from, address to, string uuid, string message);

    function createAsset(string memory uuid, uint weight) public {
 
        if(luggageStore[uuid].initialized) {
            emit RejectCreate(msg.sender, uuid, "Asset with this UUID already exists.");
            return;
        }
    
        luggageStore[uuid] = Luggage(weight, true);
        sentrecieved memory a;
        a.sent = false;
        a.recieved = false;
        walletStore[msg.sender][uuid] = a;
        emit AssetCreate(msg.sender, uuid, weight);
    }

    // function transferAsset(address to, string memory uuid) public {
    //     if(!luggageStore[uuid].initialized) {
    //         emit RejectTransfer(msg.sender, to, uuid, "No asset with this UUID exists");
    //         return;
    //     }
    //     if(walletStore[msg.sender][uuid]) {
    //         emit RejectTransfer(msg.sender, to, uuid, "Sender does not own this asset.");
    //         return;
    //     }
    //     walletStore[msg.sender][uuid] = false;
    //     walletStore[to][uuid] = true;
    //     emit AssetTransfer(msg.sender, to, uuid);
    // }
    function sendAsset(address to, string memory uuid) public {
        if(!luggageStore[uuid].initialized) {
            emit RejectTransfer(msg.sender, to, uuid, "No asset with this UUID exists");
            return;
        }
        if(!walletStore[msg.sender][uuid].recieved) {
            emit RejectTransfer(msg.sender, to, uuid, "Sender did not recieve this luggage.");
            return;
        }
        walletStore[msg.sender][uuid].sent = true;
        // walletStore[to][uuid] = true;
        emit AssetTransfer(msg.sender, to, uuid);
    }

    function recieveAsset(address to, string memory uuid) public {
        if(!luggageStore[uuid].initialized) {
            emit RejectTransfer(msg.sender, to, uuid, "No asset with this UUID exists");
            return;
        }
        // if(!walletStore[msg.sender][uuid].recieved) {
        //     emit RejectTransfer(msg.sender, to, uuid, "Sender did not recieve this luggage.");
        //     return;
        // }
        walletStore[msg.sender][uuid].recieved = true;
        // walletStore[to][uuid] = true;
        emit AssetTransfer(msg.sender, to, uuid);
    }

    function getAssetByUUID(string memory uuid) public view returns (uint) {
        return (luggageStore[uuid].weight);
    }

    function isOwnerOf(address owner, string memory uuid) public view returns (bool) {
        if(walletStore[owner][uuid].recieved && !walletStore[owner][uuid].sent) {
            return true;
        }
        return false;
}

    // function addLuggage(string memory _owner_name, uint _price, uint _weight, string memory _airport_name, uint _airport_id) public {
    //     // Require a valid name
    //     require(bytes(_owner_name).length > 0, "Invalid Owner name");

    //     // Require a valid price
    //     require(_price > 0,"Invalid Price");

    //     //Require a valid weight
    //     require(_weight>0,"Invalid Weight");

    //     //Require a valid airport name
    //     require(bytes(_airport_name).length > 0,"Invalid airport name");

    //     //Require a valid id
    //     require(_airport_id>0, "Invalid ID");
        
    //     // Make sure parameters are correct
    //     // Increment Luggage count
    //     luggageCount ++;
        
    //     // Create the product
    //     luggages[luggageCount] = Luggage(luggageCount, _owner_name, _price, _weight, msg.sender, true, _airport_name, _airport_id);
        
    //     // Trigger an event
    //     emit LuggageAdded(luggageCount, _owner_name, _price, _weight, msg.sender, true, _airport_name, _airport_id);

    // }
}