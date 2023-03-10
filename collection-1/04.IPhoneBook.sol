// SPDX-License-Identifier:MIT
pragma solidity 0.8;

interface IPhoneBook {
    function add(address _who, string memory _phone) external /*onlyOwner*/ returns (uint _id);
    function modify(uint _id, address _who, string memory _phone) external /*onlyOwner*/;
    function remove(uint _id) external /*onlyOwner*/;
    function validUser(address _valid) external /*onlyOwner*/ returns (address);
    function unvalidUser(address _valid) external /*onlyOwner*/ returns (address);
    
    function isValidUser(address _valid) external view returns (bool);
    function where(address _who, string memory _phone) external view returns (uint _id);
    function where(string memory _phone) external view returns (uint _id);
    function where(address _who) external view returns (uint _id);
    function viewAddress(uint id) external view returns (address);
    function viewTel(uint id) external view returns (string memory);
    function lastId() external view returns (uint);
    function theOwner() external view returns (address);
}
