// SPDX-License-Identifier: MIT
pragma solidity 0.8;

contract Blackjack {
    uint private constant MAX_CARD_VALUE = 10;
    uint private constant MAX_HAND_VALUE = 21;
    uint private constant DEALER_STAND_VALUE = 17;
    uint private constant MAX_DECK_SIZE = 52;
    uint private constant ACE_VALUE = 11;
    uint private constant MAX_PLAYERS = 2;
    uint private constant MAX_BET_AMOUNT = 100 ether;
    uint private constant HOUSE_EDGE_PERCENTAGE = 1;
    
    address private owner;
    uint private totalBetAmount;
    uint private houseEdgeAmount;
    uint private numPlayers;
    uint private dealerHandValue;
    uint[MAX_PLAYERS] private playerHandValue;
    uint[MAX_PLAYERS] private playerBetAmount;
    bool[MAX_PLAYERS] private playerHasStood;
    bool[MAX_PLAYERS] private playerHasBusted;
    uint[MAX_DECK_SIZE] private deck;
    uint private deckIndex;
    
    constructor() {
        owner = msg.sender;
        resetGame();
    }
    
    function resetGame() private {
        totalBetAmount = 0;
        houseEdgeAmount = 0;
        numPlayers = 0;
        dealerHandValue = 0;
        playerHandValue = [0, 0];
        playerBetAmount =[0, 0];
        playerHasStood = [false, false];
        playerHasBusted = [false, false];
        deckIndex = 0;
        initializeDeck();
    }
    
    function initializeDeck() private {
        for (uint i = 0; i < MAX_DECK_SIZE; i++) {
            deck[i] = (i % MAX_CARD_VALUE) + 1;
            if (deck[i] > MAX_CARD_VALUE) {
                deck[i] = MAX_CARD_VALUE;
            }
        }
        shuffleDeck();
    }
    
    function shuffleDeck() private {
        for (uint i = 0; i < MAX_DECK_SIZE; i++) {
            uint j = i + uint(keccak256(abi.encodePacked(block.prevrandao))) % (MAX_DECK_SIZE - i);
            uint temp = deck[j];
            deck[j] = deck[i];
            deck[i] = temp;
        }
    }
    
    function joinGame() public payable {
        require(numPlayers < MAX_PLAYERS, "Max players reached");
        require(msg.value > 0 && msg.value <= MAX_BET_AMOUNT, "Invalid bet amount");
        playerBetAmount[numPlayers] = msg.value;
        numPlayers++;
        totalBetAmount += msg.value;
    }
    
    function dealCards() public {
        require(numPlayers > 0, "No players in game");
        require(deckIndex + (numPlayers +1) * 2 <= MAX_DECK_SIZE, "Not enough cards in deck");
        for (uint i = 0; i < numPlayers; i++) {
            playerHandValue[i] += drawCard();
            playerHandValue[i] += drawCard();
        }
        dealerHandValue = drawCard();
    }
    
    function drawCard() private returns (uint) {
        require(deckIndex < MAX_DECK_SIZE, "No cards left in deck");
        uint card = deck[deckIndex];
        deckIndex++;
        return card;
    }
    
    function playerHit(uint playerIndex) public {
        require(playerIndex < numPlayers, "Invalid player index");
        require(!playerHasBusted[playerIndex], "Player has already busted");
        require(!playerHasStood[playerIndex], "Player has already stood");
        playerHandValue[playerIndex] += drawCard();
        if (playerHandValue[playerIndex] > MAX_HAND_VALUE) {
            playerHasBusted[playerIndex] = true;
        }
    }
    
    function playerStand(uint playerIndex) public {
        require(playerIndex < numPlayers, "Invalid player index");
        require(!playerHasBusted[playerIndex], "Player has already busted");
        require(!playerHasStood[playerIndex], "Player has already stood");
        playerHasStood[playerIndex] = true;
    }
    
    function dealerPlay() private {
        while (dealerHandValue < DEALER_STAND_VALUE) {
            dealerHandValue += drawCard();
        }
    }
    
    function resolveGame() public {
        require(numPlayers > 0, "No players in game");
        dealerPlay();
        for (uint i = 0; i < numPlayers; i++) {
            if (!playerHasBusted[i]) {
                if (dealerHandValue > MAX_HAND_VALUE || playerHandValue[i] > dealerHandValue) {
                    uint payoutAmount = calculatePayout(i);
                    payable(msg.sender).transfer(payoutAmount);
                }
            }
        }
        resetGame();
    }
    
    function calculatePayout(uint playerIndex) private view returns (uint) {
        uint payoutAmount = playerBetAmount[playerIndex] * 2;
        if (playerHandValue[playerIndex] == MAX_HAND_VALUE && dealerHandValue != MAX_HAND_VALUE) {
            payoutAmount += payoutAmount / 2;
        }
        payoutAmount -= (payoutAmount * HOUSE_EDGE_PERCENTAGE) / 100;
        return payoutAmount;
    }
    
    function withdrawFunds() public {
        require(msg.sender == owner, "Only owner can withdraw funds");
        uint amount = address(this).balance - totalBetAmount;
        payable(msg.sender).transfer(amount);
    }
}
