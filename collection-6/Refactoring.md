Refactoring design patterns in Solidity:

> Disclaimer: these codes not tested, just for example. so don't use in product, just learn the concept.

1. Extracting Functions:

Consider the following contract that contains a function for transferring tokens:

```solidity
contract MyToken {
    mapping(address => uint256) public balanceOf;

    function transfer(address to, uint256 amount) public {
        require(amount <= balanceOf[msg.sender], "Not enough balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
    }
}
```

This code can be refactored by extracting the transfer logic into a separate function:

```solidity
contract MyToken {
    mapping(address => uint256) public balanceOf;

    function transfer(address to, uint256 amount) public {
        require(amount <= balanceOf[msg.sender], "Not enough balance");
        _transfer(msg.sender, to, amount);
    }

    function _transfer(address from, address to, uint256 amount) internal {
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
    }
}
```

By doing this, we have made the code more modular and easier to understand.

#

2. Extracting Contracts:

Consider the following contract that contains logic for buying and selling tokens:

```solidity
contract MyToken {
    mapping(address => uint256) public balanceOf;
    uint256 public price;

    function buy() public payable {
        uint256 amount = msg.value / price;
        balanceOf[msg.sender] += amount;
    }

    function sell(uint256 amount) public {
        require(balanceOf[msg.sender] >= amount, "Not enough balance");
        uint256 value = amount * price;
        balanceOf[msg.sender] -= amount;
        payable(msg.sender).transfer(value);
    }
}
```

This code can be refactored by extracting the buying and selling logic into separate contracts:

```solidity
contract MyToken {
    mapping(address => uint256) public balanceOf;
    uint256 public price;

    function buy() public payable {
        uint256 amount = msg.value / price;
        balanceOf[msg.sender] += amount;
        TokenBought(msg.sender, amount);
    }

    function sell(uint256 amount) public {
        require(balanceOf[msg.sender] >= amount, "Not enough balance");
        uint256 value = amount * price;
        balanceOf[msg.sender] -= amount;
        payable(msg.sender).transfer(value);
        TokenSold(msg.sender, amount);
    }
}

contract TokenBoughtHandler {
    function handleTokenBought(address buyer, uint256 amount) external {
        // Handle token bought event
    }
}

contract TokenSoldHandler {
    function handleTokenSold(address seller, uint256 amount) external {
        // Handle token sold event
    }
}
```

By doing this, we have separated the concerns of buying and selling tokens into separate contracts, making the code easier to maintain.

#

3. Template Method:

Consider the following contract that contains a function for transferring tokens, which can be overridden by subclasses:

```solidity
contract MyToken {
    mapping(address => uint256) public balanceOf;

    function transfer(address to, uint256 amount) public virtual {
        require(amount <= balanceOf[msg.sender], "Not enough balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
    }
}

contract MyTokenWithFee is MyToken {
    uint256 public fee;

    function transfer(address to, uint256 amount) public override {
        super.transfer(to, amount);
        uint256 feeAmount = amount * fee / 100;
        balanceOf[msg.sender] -= feeAmount;
        balanceOf[address(this)] += feeAmount;
    }
}
```

This code can be refactored using the Template Method pattern:

```solidity
contract MyToken {
    mapping(address => uint256) public balanceOf;

    function transfer(address to, uint256 amount) public {
        require(amount <= balanceOf[msg.sender], "Not enough balance");
        _transfer(msg.sender, to, amount);
    }

    function _transfer(address from, address to, uint256 amount) internal {
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
    }
}

contract MyTokenWithFee is MyToken {
    uint256 public fee;

    function _transfer(address from, address to, uint256 amount) internal override {
        super._transfer(from, to, amount);
        uint256 feeAmount = amount * fee / 100;
        balanceOf[from] -= feeAmount;
        balanceOf[address(this)] += feeAmount;
    }
}
```

By doing this, we have defined a skeleton of the transfer algorithm in the base contract (MyToken), 
while allowing subclasses to override certain steps of the algorithm (_transfer function).

#

4. State Pattern:

Consider the following contract that contains logic for a voting system:

```solidity
contract Voting {
    enum State { Open, Closed }
    State public state;
    mapping(address => bool) public voters;
    uint256 public votesFor;
    uint256 public votesAgainst;

    constructor() {
        state = State.Open;
    }

    function vote(bool inFavor) public {
        require(state == State.Open, "Voting is closed");
        require(!voters[msg.sender], "You have already voted");
        voters[msg.sender] = true;
        if (inFavor) {
            votesFor++;
        } else {
            votesAgainst++;
        }
    }

    function closeVoting() public {
        require(state == State.Open, "Voting is already closed");
        state = State.Closed;
        // Calculate result and perform action
    }
}
```

This code can be refactored using the State Pattern:

```solidity
contract Voting {
    State public state;
    VotingState public votingState;

    constructor() {
        state = State.Open;
        votingState = new OpenState();
    }

    function vote(bool inFavor) public {
        votingState.vote(inFavor);
    }

    function closeVoting() public {
        votingState.close();
    }
}

abstract contract VotingState {
    function vote(bool inFavor) public virtual;
    function close() public virtual;
}

contract OpenState is VotingState {
    Voting public voting;

    constructor(Voting _voting) {
        voting = _voting;
    }

    function vote(bool inFavor) public override {
        require(!voting.voters(msg.sender), "You have already voted");
        voting.voters(msg.sender) = true;
        if (inFavor) {
            voting.votesFor()++;
        } else {
            voting.votesAgainst()++;
        }
    }

    function close() public override {
        voting.state() = State.Closed;
        voting.votingState() = new ClosedState(voting);
        // Calculate result and perform action
    }
}

contract ClosedState is VotingState {
    Voting public voting;

    constructor(Voting _voting) {
        voting = _voting;
    }

    function vote(bool inFavor) public override {
        revert("Voting is closed");
    }

    function close() public override {
        revert("Voting is already closed");
    }
}
```

By doing this, we have encapsulated the state of the voting system into separate state objects (OpenState and ClosedState), 
which can be swapped out at runtime. This can help to simplify complex logic and make the code easier to maintain.

#

5. Strategy Pattern:

Consider the following contract that contains logic for calculating the interest rate on a loan:

```solidity
contract Loan {
    uint256 public amount;
    uint256 public duration;
    uint256 public interestRate;

    function calculateInterest() public view returns (uint256) {
        uint256 interest = amount * interestRate / 100;
        return interest * duration;
    }
}
```

This code can be refactored using the Strategy Pattern:

```solidity
contract Loan {
    uint256 public amount;
    uint256 public duration;
    InterestCalculator public interestCalculator;

    constructor(InterestCalculator _interestCalculator) {
        interestCalculator = _interestCalculator;
    }

    function calculateInterest() public view returns (uint256) {
        return interestCalculator.calculateInterest(amount, duration);
    }
}

abstract contract InterestCalculator {
    function calculateInterest(uint256 amount, uint256 duration) public virtual view returns (uint256);
}

contract SimpleInterestCalculator is InterestCalculator {
    uint256 public interestRate;

    constructor(uint256 _interestRate) {
        interestRate = _interestRate;
    }

    function calculateInterest(uint256 amount, uint256 duration) public override view returns (uint256) {
        uint256 interest = amount * interestRate / 100;
        return interest * duration;
    }
}

contract CompoundInterestCalculator is InterestCalculator {
    uint256 public interestRate;
    uint256 public compoundingPeriod;

    constructor(uint256 _interestRate, uint256 _compoundingPeriod) {
        interestRate = _interestRate;
        compoundingPeriod = _compoundingPeriod;
    }

    function calculateInterest(uint256 amount, uint256 duration) public override view returns (uint256) {
        uint256 compoundInterest = amount;
        for (uint i = 0; i < duration / compoundingPeriod; i++) {
            compoundInterest += compoundInterest * interestRate / 100;
        }
        return compoundInterest - amount;
    }
}
```

By doing this, we have defined a family of algorithms for calculating interest (SimpleInterestCalculator and CompoundInterestCalculator), 
encapsulated each one into a separate contract, and made them interchangeable at runtime. 
This can help to reduce code duplication and make it easier to update the algorithms in the future.
