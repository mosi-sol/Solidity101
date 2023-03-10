//SPDX-License-Identifier: MIT
pragma solidity 0.8;

error dataShadow(bytes data);

/// @title                  internal unit test

// import "./PhoneBookRefactore.sol";
import "https://github.com/mosi-sol/Solidity101/blob/main/collection-1/03.PhoneBook_Refactor.sol"; // would same version (0.8)

contract PhoneBookFactory {
    // db of different phone book's
    PhoneBook[] public PhoneBookDB;
    uint id = 0;

    // generate new phonebook
    function CreateNewPhoneBook(string memory _phoneNumber) public {
        uint tmp = id;                                                  // tmp (error setter)
        PhoneBook phoneBook = new PhoneBook(_phoneNumber);
        PhoneBookDB.push(phoneBook);
        setValid(id);
        id += 1;

        // require(id > tmp, "");                                       // error getter - type 1

        // if(id <= tmp)                                                // error getter - type 2
        //     revert dataShadow(msg.data);
        
        assert(tmp < id);                                                // error getter - type 3
    }

    // who can edit which phone book (deployer is the valid owner for edit)
    function setValid(uint256 _phoneBookIndex) private {
        // no need to check error, cuz: automate incress id value (overflow check auyomated on ver >0.8 )
        PhoneBook(address(PhoneBookDB[_phoneBookIndex])).validUser(msg.sender); // not view, write
    }

    // same as address(this)
    function addressOwnerFactory(uint256 _phoneBookIndex) public view returns (address) {
        assert(_phoneBookIndex <= id);                                       // error getter ***
        return PhoneBook(address(PhoneBookDB[_phoneBookIndex])).theOwner(); // read
    }

    // is valid to crud?
    function isValidEditor(uint256 _phoneBookIndex, address _user) public view returns (bool) {
        assert(_phoneBookIndex <= id);                                       // error getter ***
        return PhoneBook(address(PhoneBookDB[_phoneBookIndex])).isValidUser(_user); // read
    }

    // i am valid to crud?
    function isValidEditor(uint256 _phoneBookIndex) public view returns (bool) {
        assert(_phoneBookIndex <= id);                                       // error getter ***
        return PhoneBook(address(PhoneBookDB[_phoneBookIndex])).isValidUser(msg.sender); // read
    }
}
