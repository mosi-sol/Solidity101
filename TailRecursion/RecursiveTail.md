## How to use "tail recursion" to perform multiple NFT transfers in Solidity

The **tail recursion** ensures that the function operates as a loop, avoiding potential *stack overflow issues* that could occur with traditional recursion.

- example 1
```solidity
pragma solidity 0.8;

import "./IERC721.sol";

contract NFTBatchTransfer {
    function batchTransfer(address _tokenContract, address[] memory _to, uint256[] memory _tokenId) external {
        require(_to.length == _tokenId.length, "Input arrays must have the same length");

        uint256 index = 0;
        _batchTransferRecursive(_tokenContract, _to, _tokenId, index);
    }

    function _batchTransferRecursive(address _tokenContract, address[] memory _to, uint256[] memory _tokenId, uint256 index) private {
        if (index == _to.length) {
            return;
        }

        IERC721(_tokenContract).transferFrom(msg.sender, _to[index], _tokenId[index]);
        index++;

        _batchTransferRecursive(_tokenContract, _to, _tokenId, index);
    }
}
```

#

- example 2
```solidity
pragma solidity 0.8;

contract MyContract {
    // Tail-recursive function to calculate the factorial of a number
    function factorial(uint n) public pure returns (uint) {
        return factorialHelper(n, 1);
    }

    function factorialHelper(uint n, uint acc) private pure returns (uint) {
        if (n == 0) {
            return acc;
        }
        return factorialHelper(n - 1, acc * n);
    }
}
```
