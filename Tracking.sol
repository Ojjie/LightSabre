pragma solidity ^0.5.0;

contract Luggage_Tracking{
    string public name;
    uint public luggageCount;
    mapping(uint => Luggage) public luggages;


    struct Luggage{
        uint id;
        string brand;
        uint price;
        uint weight;
        address payable owner;
        bool sent;
        bool received;
    }

    event LuggageAdded{
        uint id,
        string brand,
        uint price,
        uint weight,
        address payable owner,
        bool sent,
        bool received

    };

    event LuggageSent{
        uint id,
        string brand,
        uint price,
        uint weight,
        address payable owner,
        bool sent,
        bool received

    };

    constructor() public {
        name = "Luggage Tracking using Blockchain";
    }

    function addLuggage(string memory _name,uint _price) public {
        // Require a valid name
        require(bytes(_name).length >0);

        // Require a valid price
        require(_price > 0);
        
        // Make sure parameters are correct
        // Increment Luggage count
        luggageCount ++;
        // Create the product
   

        luggages[luggageCount] = Luggage(luggageCount, _name, _price, msg.sender, false);
        // Trigger an event

        emit LuggageAdded(luggageCount, _name, _price, msg.sender, false);

    }

    function sendLuggage(uint _id) public payable{
        // Fetch the product
        Luggage memory _luggage = luggages[_id];
        // Fetch the owner
        address payable _seller = _luggage.owner;
        // Make sure that the product is valid
        require(_luggage.id >0 && _luggage.id < lugggage.id < luggageCount);
        // Require that there is enough Ether in the transaction
        require(msg.value >= _luggage.price);
        // Require that the luggage has not already been sent
        require(!_luggage.sent);
        // Require that the customer is not the seller
        require(_seller != msg.sender);
        // Transfer ownership to the availer of service
        _luggage.owner = msg.sender;
        // Mark as sent
        _luggage.sent = true;
        // Update the lugggage status
        luggages[_id] = _luggage;
        // Pay by sending Ether
        address(_seller).transfer(msg.value);

        //Trigger an event
        emit LuggageSent(luggageCount, _luggage.name, _luggage.price, msg.sender, true);
    }

}