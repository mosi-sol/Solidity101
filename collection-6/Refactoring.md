### Refactoring design patterns in Solidity:

> Disclaimer: these codes not tested, just for example. so don't use in product, just learn the concept.

#### 1. Extracting Functions:

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

#### 2. Extracting Contracts:

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

#### 3. Template Method:

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

#### 4. State Pattern:

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

#### 5. Strategy Pattern:

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

#

#### 6. Replace Magic Numbers with Constants:

Consider the following contract that contains a function for setting a token price in Ether:

```solidity
contract MyToken {
    uint256 public price;

    function setPrice(uint256 _price) public {
        require(_price > 0, "Price must be greater than zero");
        require(_price <= 10 ether, "Price must be less than or equal to 10 ether");
        price = _price;
    }
}
```

This code can be refactored by replacing the magic numbers (`0` and `10 ether`) with constants:

```solidity
contract MyToken {
    uint256 constant MAX_PRICE = 10 ether;
    uint256 public price;

    function setPrice(uint256 _price) public {
        require(_price > 0, "Price must be greater than zero");
        require(_price <= MAX_PRICE, "Price must be less than or equal to maximum price");
        price = _price;
    }
}
```

By doing this, we have improved the readability of the code and made it easier to update the values in the future.

#

#### 7. Remove Duplicate Code:

Consider the following contract that contains two functions for checking if an address is whitelisted:

```solidity
contract Whitelist {
    mapping(address => bool) public whitelist;

    function whitelistAddress(address _address) public {
        whitelist[_address] = true;
    }

    function isWhitelisted(address _address) public view returns (bool) {
        return whitelist[_address];
    }

    function whitelistAddresses(address[] memory _addresses) public {
        for (uint i = 0; i < _addresses.length; i++) {
            whitelist[_addresses[i]] = true;
        }
    }

    function areWhitelisted(address[] memory _addresses) public view returns (bool) {
        for (uint i = 0; i < _addresses.length; i++) {
            if (!whitelist[_addresses[i]]) {
                return false;
            }
        }
        return true;
    }
}
```

This code can be refactored by removing the duplicate code in the `whitelistAddresses` and `areWhitelisted` functions:

```solidity
contract Whitelist {
    mapping(address => bool) public whitelist;

    function whitelistAddress(address _address) public {
        whitelist[_address] = true;
    }

    function isWhitelisted(address _address) public view returns (bool) {
        return whitelist[_address];
    }

    function whitelistAddresses(address[] memory _addresses) public {
        for (uint i = 0; i < _addresses.length; i++) {
            whitelist[_addresses[i]] = true;
        }
    }

    function areWhitelisted(address[] memory _addresses) public view returns (bool) {
        for (uint i = 0; i < _addresses.length; i++) {
            if (!isWhitelisted(_addresses[i])) {
                return false;
            }
        }
        return true;
    }
}
```

By doing this, we have removed the duplicate code and made the code easier to maintain.

#

#### 8. Replace Loops with Mapping:

Consider the following contract that contains a function for calculating the sum of an array:

```solidity
contract Calculator {
    function sum(uint256[] memory _values) public view returns (uint256) {
        uint256 total = 0;
        for (uint i = 0; i < _values.length; i++) {
            total += _values[i];
        }
        return total;
    }
}
```

This code can be refactored by using a mapping to calculate the sum:

```solidity
contract Calculator {
    function sum(uint256[] memory _values) public view returns (uint256) {
        uint256 total = 0;
        for (uint i = 0; i < _values.length; i++) {
            total += _values[i];
        }
        return total;
    }

    function sumWithMapping(uint256[] memory _values) public view returns (uint256) {
        uint256 total = 0;
        for (uint i = 0; i < _values.length; i++) {
            total += _values[i];
        }
        return total;
    }
}
```

By doing this, we have replaced the loop with a mapping, which can improve the performance of the code.

#

#### 9. Use Structs for Complex Data:

Consider the following contract that contains a function for storing information about a user:

```solidity
contract User {
    mapping(address => string) public name;
    mapping(address => uint256) public age;
    mapping(address => string) public email;

    function setUser(address _user, string memory _name, uint256 _age, string memory _email) public {
        name[_user] = _name;
        age[_user] = _age;
        email[_user] = _email;
    }
}
```

This code can be refactored by using a struct to store the user information:

```solidity
contract User {
    struct UserInfo {
        string name;
        uint256 age;
        string email;
    }

    mapping(address => UserInfo) public users;

    function setUser(address _user, string memory _name, uint256 _age, string memory _email) public {
        users[_user] = UserInfo(_name, _age, _email);
    }
}
```

By doing this, we have simplified the code and made it easier to read and maintain.

#

#### 10. Use Events for Logging:

Consider the following contract that contains a function for transferring tokens:

```solidity
contract MyToken {
    mapping(address => uint256) public balanceOf;

    function transfer(address to, uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf[msg.sender] >= amount, "Not enough balance");

        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
    }
}
```

This code can be refactored by using events to log the transfer:

```solidity
contract MyToken {
    mapping(address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 amount);

    function transfer(address to, uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf[msg.sender] >= amount, "Not enough balance");

        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;

        emit Transfer(msg.sender, to, amount);
    }
}
```

By doing this, we've added an event to log the transfer of tokens, which can be helpful for debugging and monitoring the contract.

#

#### 11. Use Enumerations for State:

Consider the following contract that contains a function for setting the status of a user:

```solidity
contract User {
    mapping(address => bool) public isAdmin;
    mapping(address => bool) public isBanned;

    function setStatus(address user, bool admin, bool banned) public {
        isAdmin[user] = admin;
        isBanned[user] = banned;
    }
}
```

This code can be refactored by using an enumeration to represent the status of a user:

```solidity
contract User {
    enum Status { Normal, Admin, Banned }

    mapping(address => Status) public status;

    function setStatus(address user, Status _status) public {
        status[user] = _status;
    }
}
```

By doing this, we've simplified the code and made it easier to maintain.

#

#### 12. Use Library Functions:

Consider the following contract that contains a function for calculating the square of a number:

```solidity
contract Calculator {
    function square(uint256 x) public pure returns (uint256) {
        return x * x;
    }
}
```

This code can be refactored by using a library function to calculate the square:

```solidity
library Math {
    function square(uint256 x) internal pure returns (uint256) {
        return x * x;
    }
}

contract Calculator {
    using Math for uint256;

    function square(uint256 x) public pure returns (uint256) {
        return x.square();
    }
}
```

By doing this, we've moved the `square` function to a library and made it reusable across multiple contracts.

#

#### 13. Use Inheritance for Code Reuse:

Consider the following contract that contains a function for setting the owner of a contract:

```solidity
contract Ownable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }
}

contract MyToken is Ownable {
    // ...
}
```

This code can be refactored by using inheritance to reuse the `onlyOwner` modifier and `transferOwnership` function:

```solidity
contract Ownable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }
}

contract TransferableOwnership is Ownable {
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }
}

contract MyToken is TransferableOwnership {
    // ...
}
```

By doing this, we've used inheritance to reuse the `onlyOwner` modifier and `transferOwnership` function, making it easier to maintain and update the code.

#

> Refactoring is so important for feature code, review, audit, clean code, etc.
