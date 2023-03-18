// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { PhoneBookFactory } from "Solidity101/collection-1/05.PhoneBook_Factory.sol";

contract FactoryTest is Test {
    // ----------------------------
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address owner = msg.sender;

    PhoneBookFactory public factory;
    mapping(uint => address) user;
    uint id = 0;
    uint pointer = 0;
    // ----------------------------
    
    function setUp() public {
        factory = new PhoneBookFactory();
        console.log("factory address", address(factory));
        factory.CreateNewPhoneBook("i am the first"); // create phonebook id 0
        pointer += 1;
        factory.CreateNewPhoneBook("i am the second"); // create phonebook id 1
        pointer += 1;
    }

    // ============= Part 0 =================
    
    function testSet() public { // dev perpuses
        address xyz = factory.addressOwnerFactory(0);
        user[id] = alice;
        id += 1;
        user[id] = bob;
        id += 1;
        user[id] = owner;
        id += 1;
        user[id] = msg.sender;
        id += 1;
        user[id] = address(this);
        id += 1;
        user[id] = xyz;
        console.log("factory: ", user[5]);
        console.log("alice: ", user[0]);
        console.log("bob: ", user[1]);
        console.log("owner: ", user[2]);
        console.log("msg.sender: ", user[3]);
        console.log("address this: ", user[4]);
        assertEq(id, 5);
    }

    // ============= Part 1 =================
    
    function testIsValidEditor() public { // would pass
        factory.isValidEditor(0);
        assertEq(factory.isValidEditor(0), true);
    }

    function testIsValidEditorNext() public { // would pass
        for(uint i = 0; i > pointer; ++i) {
            factory.isValidEditor(i);
        }
        for(uint i = 0; i > pointer; ++i) {
            assertEq(factory.isValidEditor(i), true);
        }
    }
    
    // ============= Part 2 =================

    function testFuzzy() public { // would pass
        // vm.assume(id > 0);
        for(uint i = 0; i < pointer; ++i) {
            factory.isValidEditor(i);
        }
        for(uint i = 0; i < pointer; ++i) {
            assertEq(factory.isValidEditor(i), true);
        }
    }


    // ============= Part 3 =================

    function testAddressOwner1() public {  // would pass
        for(uint i = 0; i < pointer; ++i) {
            factory.addressOwnerFactory(i);
        }
        for(uint i = 0; i < pointer; ++i) {
            for(uint j = 0; j < id; ++j) {
                assertEq(factory.addressOwnerFactory(i), user[j]); // alice, bob, owner, msg.sender, address(this), contract address
            }
        }
    }

    // target contract items
    // function CreateNewPhoneBook(string memory _phoneNumber) public {}                            // create new phonebook
    // function setValid(uint256 _phoneBookIndex) private {}                                        // validating user as owner of phonebook
    // function addressOwnerFactory(uint256 _phoneBookIndex) public view returns (address) {}       // return owner of phonebook address
    // function isValidEditor(uint256 _phoneBookIndex, address _user) public view returns (bool) {} // return is-if validated address
    // function isValidEditor(uint256 _phoneBookIndex) public view returns (bool) {}                // return is-if validated address
}
