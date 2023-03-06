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
    mapping(uint => Person) public per; // id --> anonymous freind
    uint iterate = 0;                   // auto iterate counter for indexing

    // ----- events ----- //
    event Create(uint indexed id, address contact, string txt, uint indexed date);
    event Edit(uint indexed id, address contact, string txt, uint indexed date);
    event Remove(uint indexed id, uint indexed date);

    // ----- create / edit / remove ----- //
    function add(address _client, string memory _phone) public returns (uint) {
        return _add(_client, _phone);
    }

    // find by id (index), so before modify, insure about the data
    function modify(uint _id, address _client, string memory _phone) public {
        _modify(_id, _client, _phone);
    }

    // find by id (index), so before modify, insure about the data
    function remove(uint _id) public {
        _remove(_id);
    }

    // ----- read-only ----- //
    function viewFull(uint id) public view returns (Person memory) {
        return per[id];
    }

    function viewAddress(uint id) public view returns (address) {
        return per[id].contact;
    }

    function viewTel(uint id) public view returns (string memory) {
        return per[id].phone;
    }

    // show how much contact-person
    function lastId() public view returns (uint) {
        return iterate;
    }

    // find ==> linear: O(n) - Ω(n)
    function findByAddress(address _per) public view returns (string memory) {
        uint len = iterate;
        for(uint i = 0; i < len; i++){
            if(per[i].contact == _per){
                return per[i].phone;
            }
        }
        revert CanNotFound("not found!");
    }

    function findByTel(string calldata _per) public view returns (address) {
        uint len = iterate;
        bytes32 compaire = assist(_per); // 1 time call to save gas
        for(uint i = 0; i < len; i++){
            if(assist(per[i].phone) == compaire){
                return per[i].contact;
            }
        }
        revert CanNotFound("not found!");
    }
    
    function findById(address _per) public view returns (uint) {
        uint len = iterate;
        for(uint i = 0; i < len; i++){
            if(per[i].contact == _per){
                return per[i].id;
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
    function _add(address _client, string memory _phone) private returns (uint) {
        per[iterate] = Person(_client, _phone, iterate);
        emit Create(iterate, _client, _phone, block.timestamp);
        iterate++;
        return iterate;
    }

    // edit
    function _modify(uint _id, address _client, string memory _phone) private {
        require(_id <= iterate, "not valid id.");
        per[_id] = Person(_client, _phone, _id);
        emit Edit(_id, _client, _phone, block.timestamp);
    }

    // delete
    function _remove(uint _id) private {
        require(_id <= iterate, "not valid id.");
        per[_id] = Person(address(0), "", _id);
        emit Remove(_id, block.timestamp);
    }
}
