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
        assert(id < type(uint256).max);                                 // error getter ***
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
        // no need to check error, cuz: automate incress id value (overflow check automated on ver >0.8 )
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

contract CheckUnit {
    uint id = 0;
    PhoneBookFactory t;

    error why(address x, string y, uint z, uint q);
    event TestPass(string message);

    // assert not show you where what happend
    function error_drop(address _target, string memory _phone) public {
        t = PhoneBookFactory(_target);      // deploy the PhoneBookFactory, pass the address here
        t.CreateNewPhoneBook(_phone);       // example "+1-987-654-3210"
        
        assert(t.addressOwnerFactory(id) == msg.sender);    // false - pass
        assert(t.addressOwnerFactory(id) == address(this)); // false - pass
        assert(t.addressOwnerFactory(id) == address(0));    // false - pass
        assert(t.addressOwnerFactory(id) == _target);       // true - error

        id += 1; // never reach code :(
    }

    // show you directly where what happend!
    function error_handle_debugging(address _target, string memory _phone) public {
        t = PhoneBookFactory(_target);      // deploy the PhoneBookFactory, pass the address here
        t.CreateNewPhoneBook(_phone);       // example "+1-987-654-3210"

        if(t.addressOwnerFactory(id) == msg.sender) {           // false - pass
            revert why(_target, _phone, id, 101);
        } else if(t.addressOwnerFactory(id) == address(this)) { // false - pass
            revert why(_target, _phone, id, 202);
        } else if(t.addressOwnerFactory(id) == _target) {       // true - error
            revert why(_target, _phone, id, 303);
        } else if(t.addressOwnerFactory(id) == address(0)) {    // false - pass
            revert why(_target, _phone, id, 404);
        } else {
            emit TestPass("Congrat, Test passed!");
        }

        id += 1;
    }

}
