# Blackjack information:
- The `Blackjack` contract has a number of private constants that define the rules of the game, such as the maximum cardvalue, the maximum hand value, the dealer stand value, the maximum deck size, the value of an ace, the maximum number of players, the maximum bet amount, and the house edge percentage.
- The contract has several private variables that store the state of the game, such as the owner address, the total bet amount, the house edge amount, the number of players, the dealer hand value, the player hand values, the player bet amounts, and the player status (stand/bust) flags.
- The `resetGame()` function initializes all the game variables, including the deck, which is generated and shuffled using the `initializeDeck()` and `shuffleDeck()` functions.
- The `joinGame()` function allows players to join the game by sending a bet amount, which must be within the specified range and must not exceed the maximum bet amount. The function also updates the total bet amount and the player bet amount array.
- The `dealCards()` function deals two cards to each player and one card to the dealer. It also checks that there are enough cards left in the deck to complete the deal.
- The `playerHit()` function allows a player to draw another card. If the player's hand value exceeds the maximum hand value, the function sets the player's bust flag.
- The `playerStand()` function allows a player to stand and end their turn.
- The `dealerPlay()` function implements the dealer's strategy to draw cards until the dealer's hand value exceeds thedealer stand value.
- The `resolveGame()` function resolves the game by comparing the player hand values to the dealer hand value. If a player has not bust and has a higher hand value than the dealer, they are paid out according to the payout formula in `calculatePayout()`. The function also resets the game variables and state.
- The `calculatePayout()` function calculates the payout amount for a player based on their bet amount and hand value. If the player has a blackjack (an ace and a 10-value card), they are paid out at 3:2 odds. The function also deducts the house edge percentage from the payout amount.
- The `withdrawFunds()` function allows the owner of the contract to withdraw any excess funds in the contract.

#

  - 🛑 Implementation is not fully secure and may be vulnerable to various attacks, such as frontrunning and reentrancy attacks. 
  - 🛑 Proper security measures should be taken before deploying this contract to a production environment.
  - 🛑 I played, but i'm not proffessional players. So run this by your own risk.

Enjoy it, have fun.

---

## factory contract that can be used to create instances of the `Blackjack` contract:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8;

import "./Blackjack.sol";

contract BlackjackFactory {
    address[] public deployedGames;
    
    function createGame() public {
        address newGame = address(new Blackjack());
        deployedGames.push(newGame);
    }
    
    function getDeployedGames() public view returns (address[] memory) {
        return deployedGames;
    }
}
```

This `BlackjackFactory` contract has two main functions:

- The `createGame()` function creates a new instance of the `Blackjack` contract and adds its address to the `deployedGames` array.
- The `getDeployedGames()` function returns an array of all the addresses of the `Blackjack` contracts that have been created through the factory.

You can deploy the `BlackjackFactory` contract to the blockchain and then call its `createGame()` function to create new instances of the `Blackjack` contract.\
For example to best imagination and marketing results, you can use the following code snippet in Remix to deploy the `BlackjackFactory` contract and create a new game:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8;

import "./BlackjackFactory.sol";

contract InstanceBlackjack {
    BlackjackFactory public factory;
    
    constructor() {
        factory = new BlackjackFactory();
    }
    
    function createGame() public {
        factory.createGame();
    }
    
    function getDeployedGames() public view returns (address[] memory) {
        return factory.getDeployedGames();
    }
}
```

After deploying the `InstanceBlackjack` contract in Remix, you can call its `createGame()` function to create a new `Blackjack` game instance through the `BlackjackFactory`, and then call its `getDeployedGames()` function to get an array of all the game addresses that have been created.
