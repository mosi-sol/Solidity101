## Bytes in Theory
in **Solidity** by using "low-level" coding (**assembly**) can convert data types.

> i don't test these codes, just following the theory. so if want to use, first test then use. i am not responsible for using these example in any product.

- bytes32 to Bytes16
```solidity
function bytes32toBytes16(bytes32 input) internal pure returns (bytes16) {
    bytes16 output;
    assembly {
        output := input
    }
    return output;
}
```
- bytes32 to Bytes
```solidity
function bytes32toBytes(bytes32 input) internal pure returns (bytes memory) {
    bytes memory output = new bytes(32);
    assembly {
        mstore(0, input)
        mstore(32, 0)
        output := mload(0)
    }
    return output;
}
```
- bytes16 to Bytes
```solidity
function bytes16toBytes(bytes16 input) internal pure returns (bytes memory) {
    bytes memory output = new bytes(16);
    assembly {
        mstore(add(output, 32), input)
    }
    return output;
}
```
- bytes To Bytes16
```solidity
function bytesToBytes16(bytes memory input) internal pure returns (bytes16 output) {
    require(input.length >= 16, "Input must be at least 16 bytes long");
    assembly {
        output := mload(add(input, 16))
    }
}
```
- bytes To Bytes32
```solidity
function bytesToBytes32(bytes memory input) internal pure returns (bytes32 output) {
    require(input.length >= 32, "Input must be at least 32 bytes long");
    assembly {
        output := mload(add(input, 32))
    }
}
```
