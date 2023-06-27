How to write testing library for Solidity without using any external libraries:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8;

contract TestLibrary {
    function assert(bool condition) internal pure {
        if (!condition) {
            revert("Assertion failed");
        }
    }
    
    function assertEqual(uint256 a, uint256 b) internal pure {
        assert(a == b);
    }
    
    function assertNotEqual(uint256 a, uint256 b) internal pure {
        assert(a != b);
    }
    
    function assertTrue(bool condition) internal pure {
        assert(condition);
    }
    
    function assertFalse(bool condition) internal pure {
        assert(!condition);
    }
    
    function assertGreater(uint256 a, uint256 b) internal pure {
        assert(a > b);
    }
    
    function assertGreaterEqual(uint256 a, uint256 b) internal pure {
        assert(a >= b);
    }
    
    function assertLess(uint256 a, uint256 b) internal pure {
        assert(a < b);
    }
    
    function assertLessEqual(uint256 a, uint256 b) internal pure {
        assert(a <= b);
    }
}
```

In this library defines some several 'assertion functions' that can be used to test Solidity contracts.\
The `assert` function checks if a given condition is true, and if it is not true, it reverts the transaction with an error message. The other assertion functions are shortcuts for common comparisons.

- Example of use:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8;

import "./TestLibrary.sol";

contract MyTest is TestLibrary {
    function testAddition() public {
        uint256 a = 2;
        uint256 b = 3;
        uint256 result = a + b;
        assertEqual(result, 5);
    }
    
    function testSubtraction() public {
        uint256 a = 5;
        uint256 b = 3;
        uint256 result = a - b;
        assertGreater(result, b);
        assertLessEqual(result, a);
    }
}
```
