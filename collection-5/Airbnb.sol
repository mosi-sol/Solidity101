// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8;

contract Airbnb {
    
    // Define a struct to represent a property
    struct Property {
        uint id;
        string name;
        string location;
        uint price; // price = rentalPrice * days
        bool isAvailable;
        address owner;
        uint rating;
        string comments;
        uint rentalPrice;
        bool isRented;
    }
    
    // Define a mapping to keep track of all properties
    mapping (uint => Property) public properties;
    
    // Define a variable to keep track of the number of properties
    uint public propertyCount;
    
    // Define an event to emit when a new property is added
    event PropertyAdded(uint indexed id, string name, string location, uint price, bool isAvailable, address owner);
    
    // Define an event to emit when a property is rented
    event PropertyRented(uint indexed id, address indexed renter, uint rentalPrice);

    // Define an event to emit when a property is rated
    event PropertyRated(uint indexed id, uint rate, string comment);
    
    // Define a function to add a new property
    function addProperty(string memory _name, string memory _location, uint _price, uint _rentalPrice) public {
        propertyCount++;
        properties[propertyCount] = Property(propertyCount, _name, _location, _price, true, msg.sender, 0, "", _rentalPrice, false);
        emit PropertyAdded(propertyCount, _name, _location, _price, true, msg.sender);
    }
    
    // Define a function to update the availability of a property
    function updateAvailability(uint _id, bool _isAvailable) public {
        Property storage property = properties[_id];
        require(property.owner == msg.sender, "You are not the owner of this property");
        require(property.isRented == false, "This property is currently rented");
        property.isAvailable = _isAvailable;
    }
    
    // Define a function to rate a property
    function rateProperty(uint _id, uint _rating, string memory _comments) public {
        Property storage property = properties[_id];
        require(property.isAvailable == false, "You cannot rate an available property");
        require(_rating <= 5, "Rating must be between 1 and 5");
        property.rating = _rating;
        property.comments = _comments;
        emit PropertyRated(_id, _rating, _comments);
    }
    
    // Define a function to rent a property
    function rentProperty(uint _id) payable public {
        Property storage property = properties[_id];
        require(property.isAvailable == true, "This property is not available for rent");
        require(msg.value == property.rentalPrice, "The rental price is not correct");
        property.isAvailable = false;
        property.isRented = true;
        // here would sending amount to the property owner. write in here
        emit PropertyRented(_id, msg.sender, msg.value);
    }
    
    // Define a function to get the details of a property
    function getPropertyDetails(uint _id) public view returns (string memory, string memory, uint, bool, address, uint, string memory, uint, bool) {
        Property storage property = properties[_id];
        return (property.name, property.location, property.price, property.isAvailable, property.owner, property.rating, property.comments, property.rentalPrice, property.isRented);
    }
}

// for transparency: the platform should make access (white list) for property and owner, then can add property here
// more details for each property
// can not add twice
// rate max 5 - min 1
