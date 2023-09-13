// SPDX-License-Identifier: MIT
pragma solidity 0.8;
import "hardhat/console.sol";

library TestPass {

    // ========== check pass
    function asPass(uint8 a, uint8 pair) public pure returns(bool ans) {
        a == pair ? ans = true : ans = false;
    }

    function asPass(uint256 a, uint256 pair) public pure returns(bool ans) {
        a == pair ? ans = true : ans = false;
    }

    function asPass(string memory a, string memory pair) public pure returns(bool ans) {
        bytes32(keccak256(abi.encode(a))) == bytes32(keccak256(abi.encode(pair))) ? ans = true : ans = false;
    }

    function asPass(bytes memory a, bytes memory pair) public pure returns(bool ans) {
        bytes32(a) == bytes32(pair) ? ans = true : ans = false;
    }

    function asPass(bytes32 a, bytes32 pair) public pure returns(bool ans) {
        a == pair ? ans = true : ans = false;
    }

    function asPass(bool a, bool pair) public pure returns(bool ans) {
        a == pair ? ans = true : ans = false;
    }

    // ========== math
    function asLarge(uint8 a, uint8 pair) public pure returns(bool ans) {
        a > pair ? ans = true : ans = false;
    }

    function asLarge(uint256 a, uint256 pair) public pure returns(bool ans) {
        a > pair ? ans = true : ans = false;
    }

    // ========== fuzzy
    function asFuzzy(uint256 a) public view returns(bool ans, uint256 pair) {
        (ans, pair) = _asFuzzy(a);
    }

    function _asFuzzy(uint256 a) private view returns(bool ans, uint256 pair) {
        require(a > 1, "divided by zero injection");
        pair = uint256(keccak256(abi.encodePacked(a, block.prevrandao))) % (a - 1);
        a != pair ? ans = true : ans = false;
    }

    // ========== fail (short hand code for when need fail)
    function asFail(uint8 a, uint8 pair) public pure returns(bool ans) {
        a != pair ? ans = true : ans = false; // "fail condition, a would equal answer-> (a+b=a)"
    }
    
    function asFail(uint256 a, uint256 pair) public pure returns(bool ans) {
        a != pair ? ans = true : ans = false; // "fail condition, a would equal answer-> (a+b=a)"
    }

}

contract Example {
    // example: 1+0=1 => true
    // 1+1=2 & 2>1 => false

    // not good example
    function test_bad(uint256 a, uint256 b) public view {
        uint tmp = a + b;
        require(TestPass.asFail(a, tmp));
        console.log("test pass");
    }

    // good example
    function test_good(uint256 a, uint256 b) public view {
        uint tmp = a + b;
        bool x = TestPass.asFail(a, tmp);
        x == true ? console.log("test pass") : console.log("test fail");
    }
}

// for more information, read this article at ethereum website:
// https://ethereum.org/en/developers/docs/smart-contracts/testing/
