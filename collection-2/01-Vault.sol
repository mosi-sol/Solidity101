// SPDX-License-Identifier: MIT
pragma solidity 0.8; // work in/on/at >=0.7.0 <0.9.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";     // isolate include {ERC20}
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";   // isolate include {IERC20}

// _____ Vault Smartcontract _____ \\
contract Vault is ERC20 {
    // ===== local variable =====
    IERC20 public immutable token; // setup when deploy

    // ===== events =====
    event Save(address indexed spender, uint indexed amount, uint indexed date);
    event Recipient(address indexed spender, uint indexed amount, uint indexed date);

    // ===== validation =====
    modifier insufficientAmount(uint256 amount) {
        require(amount > 0, "not enough insufficient fund");
        _;
    }

    // ===== init =====
    constructor(IERC20 mockToken_, string memory _name, string memory _symbol) 
    ERC20(_name, _symbol) {         // Liquidity Provider Token "LP-TOKEN"
        token = mockToken_;
    }

    // ===== program =====
    function deposit(uint256 amount) external insufficientAmount(amount) {
        _deposit(amount);
        emit Save(msg.sender, amount, block.timestamp);
    }

    function withdraw(uint256 amount) external insufficientAmount(amount) {
        _withdraw(amount);
        emit Recipient(msg.sender, amount, block.timestamp);
    }

    // ===== logic =====
    function _deposit(uint256 amount) internal insufficientAmount(amount) {
        uint256 amountToken = amount;
        uint256 supplyLPToken = totalSupply();
        uint256 balanceToken = token.balanceOf(address(this));
        uint256 amountLPToken;

        supplyLPToken == 0 ? 
        amountLPToken = amountToken : 
        amountLPToken = (amountToken * supplyLPToken) / balanceToken;

        _mint(msg.sender, amountLPToken);
        token.transferFrom(msg.sender, address(this), amountToken);
        // this is by the owner, not by contract. so this line just for example & not work...
        token.approve(address(this), amount); 
    }

    function _withdraw(uint256 amount) internal insufficientAmount(amount) {
        uint256 amountLPToken = amount;
        uint256 supplyLPToken = totalSupply();
        uint256 balanceToken = token.balanceOf(address(this));
        uint256 amountToken = (amountLPToken * balanceToken) / supplyLPToken;
        // if vault paye then: " amountToken * paye / x " ===> " a * 9700 / 10000 " 
        // this equetion mean 3%, then token.transfer(vault owner, paye amount)
        
        _burn(msg.sender, amountLPToken);
        /*
        paye = 9700; // = 3%
        amountToken = (amountLPToken * balanceToken) / supplyLPToken;
        amountPaye = (amountToken * paye) / 10000;
        result = amountToken - amountPaye;
        token.transfer(owner, amountPaye);
        token.transfer(msg.sender, result);
        */
        token.transfer(msg.sender, amountToken); 
    }
}

// _____ Mock token _____ \\
contract MockToken is ERC20 {
    constructor() ERC20("Mock Token", "MOK") {
        mint(msg.sender, 100 * 10**18);
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
