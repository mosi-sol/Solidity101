## Bytes in Theory
how to convert bytes data type to other bytes type.

- full details: [here]()
- basic example:
```solidity
function bytes16toBytes(bytes16 input, bytes memory output, uint offset) internal pure {
        assembly {
            mstore8(add(output, add(offset, 0)), byte(15, input))
            mstore8(add(output, add(offset, 1)), byte(14, input))
            mstore8(add(output, add(offset, 2)), byte(13, input))
            mstore8(add(output, add(offset, 3)), byte(12, input))
            mstore8(add(output, add(offset, 4)), byte(11, input))
            mstore8(add(output, add(offset, 5)), byte(10, input))
            mstore8(add(output, add(offset, 6)), byte(9, input))
            mstore8(add(output, add(offset, 7)), byte(8, input))
            mstore8(add(output, add(offset, 8)), byte(7, input))
            mstore8(add(output, add(offset, 9)), byte(6, input))
            mstore8(add(output, add(offset, 10)), byte(5, input))
            mstore8(add(output, add(offset, 11)), byte(4, input))
            mstore8(add(output, add(offset, 12)), byte(3, input))
            mstore8(add(output, add(offset, 13)), byte(2, input))
            mstore8(add(output, add(offset, 14)), byte(1, input))
            mstore8(add(output, add(offset, 15)), byte(0, input))
        }
    }
```
