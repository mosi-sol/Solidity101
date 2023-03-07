// SPDX-License-Identifier:MIT
pragma solidity 0.8;

error CanNotFound(string data);

/// @title {CRUD action} learn in phone-book training lesson
/// @author Mosi-Sol
/// @notice You can use this contract for only the most basic simulation
/// @dev All function calls are currently implemented without side effects
/// @custom:experimental this contract just for learning purposes.

contract PhoneBook {
    // ----- declare state ----- //
    struct Person {
        address contact;    // anonymous freind
        string phone;       // his/her phone number
        uint id;            // auto generated index
    }
    mapping(uint => Person) private people;     // id --> anonymous freind
    mapping(bytes => uint) private peopleHash;  // hash --> id of anonymous freind // *** solution
    uint iterate = 0;                           // auto iterate counter for indexing

    // ----- events ----- //
    event Hashing(uint indexed id, bytes hash, address contact, string txt, uint indexed date); // *** solution
    event Create(uint indexed id, address contact, string txt, uint indexed date);
    event Edit(uint indexed id, address contact, string txt, uint indexed date);
    event Remove(uint indexed id, uint indexed date);

    // ----- init ----- //
    // solution need constractur, why? watch
    constructor() {
        add(address(0), "mosi-sol");
    }

    // ----- create / edit / remove ----- //
    function add(address _who, string memory _phone) public returns (uint _id) {
        uint tmp = iterate;                                                 // *** solution
        _id = _add(_who, _phone);
        bytes memory genHash = bytes(abi.encode(_who, _phone));             // *** solution
        peopleHash[genHash] = tmp;                                          // *** solution
        emit Hashing(tmp, genHash, _who, _phone, block.timestamp);          // *** solution
    }

    // solution found !!!!!!!!!! (Q: if have address and phone, why spend time &^ power to search?)
    // where ==> O(1) - Ω(1)
    // other solution -> decode phone or address, query for each one or 1 of them!
    // but this solution very better, cuz? hash is unique!
    // why (abi.encode)? cuz encodePacked not have seprator! (very 0 in encode, removed in encodePacked)
    // why not use keccak256? cuz compute power & this example no need anymore of security by hashing.
    // example of keccak (bytes32): " bytes32(keccak256(abi.encode(_who, _phone))) " -> lins: 39, 52
    function where(address _who, string memory _phone) public view returns (uint _id) {
        uint tmp = peopleHash[bytes(abi.encode(_who, _phone))]; // now, call "id" in "people mapping"
        // require(tmp > 0, "not found!");
        if(tmp == 0) {
            revert CanNotFound("not found!");
        }
        _id = tmp;
    }

    // find by id (index), so before modify, insure about the data
    function modify(uint _id, address _who, string memory _phone) public {
        _modify(_id, _who, _phone);
    }

    // find by id (index), so before modify, insure about the data
    function remove(uint _id) public {
        _remove(_id);
    }

    // ----- read-only ----- //
    function viewFull(uint id) public view returns (Person memory) {
        return people[id];
    }

    function viewAddress(uint id) public view returns (address) {
        return people[id].contact;
    }

    function viewTel(uint id) public view returns (string memory) {
        return people[id].phone;
    }

    // show how much contact-person
    function lastId() public view returns (uint) {
        return iterate;
    }

    // find ==> linear: O(n) - Ω(n)
    function findByAddress(address _person) public view returns (string memory) {
        uint len = iterate;
        for(uint i = 0; i < len; i++){
            if(people[i].contact == _person){
                return people[i].phone;
            }
        }
        revert CanNotFound("not found!");
    }

    function findByTel(string calldata _person) public view returns (address) {
        uint len = iterate;
        bytes32 compaire = assist(_person); // 1 time call to save gas
        for(uint i = 0; i < len; i++){
            if(assist(people[i].phone) == compaire){
                return people[i].contact;
            }
        }
        revert CanNotFound("not found!");
    }
    
    function findById(address _person) public view returns (uint) {
        uint len = iterate;
        for(uint i = 0; i < len; i++){
            if(people[i].contact == _person){
                return people[i].id;
            }
        }
        revert CanNotFound("not found!");
    }

    // ----- logic ----- //
    // string compair - use in findByTel(...)
    function assist(string memory txt) private pure returns (bytes32) { 
        return bytes32(keccak256(abi.encodePacked(txt)));
    }

    // create
    function _add(address _who, string memory _phone) private returns (uint) {
        people[iterate] = Person(_who, _phone, iterate);
        emit Create(iterate, _who, _phone, block.timestamp);
        iterate++;
        return iterate;
    }

    // edit
    function _modify(uint _id, address _who, string memory _phone) private {
        require(_id <= iterate, "not valid id.");
        people[_id] = Person(_who, _phone, _id);
        emit Edit(_id, _who, _phone, block.timestamp);
    }

    // delete
    function _remove(uint _id) private {
        require(_id <= iterate, "not valid id.");
        people[_id] = Person(address(0), "", _id);
        emit Remove(_id, block.timestamp);
    }
}

// remember todo:
// -- require _addressInput != address(0), revert error
// -- in search's, founded address != address(0) [deleted position, or position 0]

// completed version: PhoneBookFinal.sol
