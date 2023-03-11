//SPDX-License-Identifier: MIT
pragma solidity 0.8;

error dataShadow(bytes data);

/// @title                  internal unit test
/// @dev                    deploy: PhoneBookFactory contract -> copy address of that -> deploy CheckUnit contract
/// @info                   test1 = create new -> true . test2 = check valid user . test3 = always false . test4 = always false

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

// ===== test unit =====
contract CheckUnit {
    uint id = 0;
    uint testPass = 0;
    PhoneBookFactory t;
    address _target;

    error why(address x, uint z, uint q);
    event TestPass(string message);

    constructor(address target) {
        _target = target;
    }

    function testUnit_1(string memory _phone) external {
        // generate next phonebook
        require(first_run_me( _phone), "first pass: congrats, generate succesfully!");
    }

    function testUnit_2() external {
        
        if(second_error_check()) {
            emit TestPass("second test: pass");
        } else {
            emit TestPass("second test: fail");
        }
    }

    function testUnit_3() external {
        
        if(third_error_drop()) {
            emit TestPass("third test: pass");
        } else {
            emit TestPass("third test: fail");
        }
    }

    function testUnit_4() external {

        if(fourth_error_handle_debugging()) {
            emit TestPass("fourth test: pass");
        } else {
            emit TestPass("fourth test: fail");
        }
    }

    // ===== logic ===== //
    // 1
    function first_run_me(string memory _phone) internal returns (bool pass) {
        uint tmp = testPass;
        t = PhoneBookFactory(_target);       // deploy the PhoneBookFactory, pass the address here
        t.CreateNewPhoneBook(_phone);        // example "+1-987-654-3210"
        id += 1;
        testPass += 1; 
        tmp < testPass ? pass = true : pass = false;
        emit TestPass("Congrat, Test passed!");
    }

    // 2
    function second_error_check() internal returns (bool pass) {
        uint tmp = testPass;
        t = PhoneBookFactory(_target);      // deploy the PhoneBookFactory, pass the address here
        
        require(t.isValidEditor(id - 1) == true, "Congrat, Test passed!");

        testPass += 1; 
        tmp < testPass ? pass = true : pass = false;
    }

    // 3
    function third_error_drop() internal returns (bool pass) {
        uint tmp = testPass;
        t = PhoneBookFactory(_target);      // deploy the PhoneBookFactory, pass the address here
        
        assert(t.addressOwnerFactory(id) == msg.sender);    // false - pass
        assert(t.addressOwnerFactory(id) == address(this)); // false - pass
        assert(t.addressOwnerFactory(id) == address(0));    // false - pass
        assert(t.addressOwnerFactory(id) == _target);       // true - error

        testPass += 1; // never reach code :(
        tmp < testPass ? pass = true : pass = false;
        emit TestPass("Congrat, Test passed!");
    }

    // 4
    function fourth_error_handle_debugging() internal returns (bool pass) {
        uint tmp = testPass;
        t = PhoneBookFactory(_target);      // deploy the PhoneBookFactory, pass the address here

        if(t.addressOwnerFactory(id) == msg.sender) {           // false - pass
            revert why(_target, id, 101);
        } else if(t.addressOwnerFactory(id) == address(this)) { // false - pass
            revert why(_target, id, 202);
        } else if(t.addressOwnerFactory(id) == _target) {       // true - error
            revert why(_target, id, 303);
        } else if(t.addressOwnerFactory(id) == address(0)) {    // false - pass
            revert why(_target, id, 404);
        } else {
            emit TestPass("Congrat, Test passed!");
        }

        testPass += 1;
        tmp < testPass ? pass = true : pass = false;
    }

}

/*
// exception example using try/catch:
function sendMoney(address _to, uint256 _amount) public payable {    
    try {        
        require(_amount <= 5 ether);        
        _to.transfer(_amount);    
    } 
    catch (bytes32 err) {        
        revert("Only 5 ether can be sent at a time");    
    }
}

// more infi: https://solstep.gitbook.io/solidity-steps/step-5/43-try-and-catch
*/
