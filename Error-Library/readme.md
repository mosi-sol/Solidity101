Error library for Solidity:

```solidity
// SPDX-License-Identifier: MIT

pragma solidity 0.8;

library Errors {
    error InvalidInput(string message);
    error InsufficientFunds(string message);
    error UnauthorizedAccess(string message);
}
```

In this error library, define three custom error types: `InvalidInput`, `InsufficientFunds`, and `UnauthorizedAccess`. Each error type has a string message parameter that can be used to provide more detail about the error.

To use this error library in the Solidity code, can import the library and then use the `revert()` function to throw an error. 

- Example of use:

```solidity
// SPDX-License-Identifier: MIT

pragma solidity 0.8;

import "./Errors.sol";

contract MyContract {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function withdraw(uint amount) external {
        if (msg.sender != owner) {
            revert Errors.UnauthorizedAccess("Only the owner can withdraw funds");
        }
        if (amount > address(this).balance) {
            revert Errors.InsufficientFunds("Insufficient funds to withdraw");
        }
        (bool success, ) = msg.sender.call{value: amount}("");
        if (!success) {
            revert Errors.InvalidInput("Failed to send funds");
        }
    }
}
```

Use the `Errors` library to throw custom errors if the input is invalid, there are insufficient funds, or if an unauthorized user attempts to withdraw funds. By using custom errors, we can provide more detailed information about what went wrong, which can be helpful for debugging and troubleshooting.
