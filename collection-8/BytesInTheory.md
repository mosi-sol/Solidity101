## Bytes in Theory
in **Solidity** by using "low-level" coding (**assembly**) can convert data types.

> i don't test these codes, just following the theory. so if want to use, first test then use. i am not responsible for using these example in any product.

- Helper function to convert the bytes32 to Bytes16
```solidity
function bytes32toBytes16(bytes32 input) internal pure returns (bytes16) {
    bytes16 output;
    assembly {
        output := input
    }
    return output;
}
```

- Helper function to convert the bytes32 to Bytes
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

- Helper function to convert the bytes16 to Bytes
```solidity
function bytes16toBytes(bytes16 input) internal pure returns (bytes memory) {
    bytes memory output = new bytes(16);
    assembly {
        mstore(add(output, 32), input)
    }
    return output;
}
```

- Helper function to convert the bytes To Bytes16
```solidity
function bytesToBytes16(bytes memory input) internal pure returns (bytes16 output) {
    require(input.length >= 16, "Input must be at least 16 bytes long");
    assembly {
        output := mload(add(input, 16))
    }
}
```

- Helper function to convert the bytes To Bytes32
```solidity
function bytesToBytes32(bytes memory input) internal pure returns (bytes32 output) {
    require(input.length >= 32, "Input must be at least 32 bytes long");
    assembly {
        output := mload(add(input, 32))
    }
}
```

### Part 2:

- Helper function to convert the IPFS hash from bytes to string format
```solidity
function getIpfsHash(uint256 ipfsHashSize) private view returns (string memory) {
    bytes memory ipfsHashBytes = new bytes(ipfsHashSize + 2);
    ipfsHashBytes[0] = "Q";
    ipfsHashBytes[1] = "m";
    for (uint i = 0; i < ipfsHashSize; i++) {
        ipfsHashBytes[i + 2] = bytes32ToHexString(ipfsHash.bytes32[i]);
    }
    return string(ipfsHashBytes);
}
```

- Helper function to convert bytes32 to a hexadecimal string
```solidity
function bytes32ToHexString(bytes32 bytes32Data) private pure returns (bytes memory) {
    bytes memory hexString = new bytes(64);
    for (uint i = 0; i < 32; i++) {
        uint8 byteValue = uint8(bytes32Data[i]);
        hexString[i * 2] = toHexDigit(byteValue / 16);
        hexString[i * 2 + 1] = toHexDigit(byteValue % 16);
    }
    return hexString;
}
```

- Helper function to convert a uint8 value to a hexadecimal digit
```solidity
function toHexDigit(uint8 value) private pure returns (bytes1) { // bytesN type
    if (value < 10) {
        return bytes1(uint8(bytes1("0")) + value);
    } else {
        return bytes1(uint8(bytes1("a")) + (value - 10));
    }
}
```
