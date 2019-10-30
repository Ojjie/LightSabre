pragma solidity ^0.5.0;

contract Luggage_Tracking{
    string public name;
    uint public luggageCount;
    mapping(uint => Luggage) public luggages;

    struct Luggage{
        uint id;
        string owner_name;
        uint price;
        uint weight;
        address payable owner;
        bool sent;
        uint airport_id;
        string airport_name;

    }
    event LuggageAdded (
        uint id,
        string owner_name,
        uint price,
        uint weight,
        address payable owner,
        bool sent,
        uint airport_id,
        string airport_name
    );
    function addLuggage(string memory _owner_name, uint _price, uint _weight, uint _airport_id , string memory _airport_name) public {
        // Require a valid name
        require(bytes(_owner_name).length > 0, "Invalid Owner name");

        // Require a valid price
        require(_price > 0,"Invalid Price");

        //Require a valid weight
        require(_weight>0,"Invalid Weight");

        //Require a valid airport name
        require(bytes(_airport_name).length > 0,"Invalid airport name");

        //Require a valid id
        require(_airport_id>0, "Invalid ID");
    
        // Make sure parameters are correct
        // Increment Luggage count
        luggageCount ++;
        
        // Create the product
        luggages[luggageCount] = Luggage(luggageCount, _owner_name, _price, _weight, msg.sender, true, _airport_id, _airport_name);
        
        // Trigger an event
        emit LuggageAdded(luggageCount, _owner_name, _price, _weight, msg.sender, true, _airport_id, _airport_name);

    }
} 