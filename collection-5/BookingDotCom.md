## Booking web3

### explain
Booking[dot]com is an online travel agency that allows users to search for and book accommodations, flights, rental cars, and other travel-related services. Here's how it works:

Search for accommodations: Users can search for accommodations by entering their destination, travel dates, and the number of guests. They can also specify preferences such as the type of accommodation, price range, and amenities.

Browse results: Booking[dot]com will then display a list of available accommodations that match the user's search criteria. Users can browse through the results and view photos, read descriptions, and check availability.

Book accommodations: Once the user has found an accommodation they like, they can book it by entering their personal and payment details. Booking[dot]com will then confirm the reservation and send a confirmation email to the user.

Manage reservations: Users can manage their reservations through their Booking[dot]com account. They can view their bookings, make changes to their reservation, and cancel their booking if necessary.

Customer service: If users have any questions or need assistance with their booking, Booking[dot]com provides customer service through their website, mobile app, or phone.

Payment: Booking[dot]com acts as an intermediary between the user and the accommodation provider, and collects payment from the user on behalf of the provider. The provider then receives payment from Booking[dot]com after the stay is completed.

Overall, Booking[dot]com provides a convenient and user-friendly platform for travelers to search for and book accommodations and other travel-related services, while also providing customer support and managing payments.

### blockchain/web3
There are several parts of the Booking[dot]com process that could potentially be implemented on a blockchain as a smart contract. Here are a few examples:

Booking: The booking process could be implemented as a smart contract on a blockchain. This would allow users to book accommodations directly on the blockchain, with the terms of the booking (e.g. dates, price, cancellation policy) enforced by the smart contract.

Payment: The payment process could also be implemented as a smart contract on a blockchain. This would allow users to make payments directly on the blockchain, with the smart contract automatically releasing payment to the accommodation provider once the stay is completed.

Reviews: The review system could be implemented on a blockchain as a smart contract. This would ensure that reviews are genuine, as they would be recorded on the blockchain and could not be manipulated or deleted.

Loyalty program: Booking[dot]com's loyalty program could also be implemented on a blockchain as a smart contract. This would allow users to earn and redeem loyalty points directly on the blockchain, with the smart contract automatically managing the points and rewards.

Overall, implementing parts of the Booking[dot]com process on a blockchain as smart contracts could increase transparency, security, and efficiency by removing intermediaries and automating processes. However, it's important to note that implementing such a system would require significant technical expertise and resources.

---

### smartcontract

1. **Booking**: Here's an example of how a booking smart contract could be implemented in Solidity:

```solidity
contract Booking {
  address public owner;
  uint public price;
  uint public startDate;
  uint public endDate;
  string public description;

  function book(uint _price, uint _startDate, uint _endDate, string memory _description) public {
    require(msg.sender == owner, "Only the owner can book this accommodation");
    price = _price;
    startDate = _startDate;
    endDate = _endDate;
    description = _description;
  }
}
```

This contract stores the owner of the accommodation, the price, start and end dates of the booking, and a description of the accommodation. When a user wants to book the accommodation, they would call the `book()` function and provide the necessary parameters. The function checks that the user calling it is the owner of the accommodation, and then sets the values of price, start date, end date, and description.

2. **Payment**: Here's an example of how a payment smart contract could be implemented in Solidity:

```solidity
contract Payment {
  address public buyer;
  address public seller;
  uint public amount;
  bool public paid;

  function pay() public payable {
    require(msg.sender == buyer, "Only the buyer can make a payment");
    require(msg.value == amount, "Payment amount must match the agreed amount");
    seller.transfer(amount);
    paid = true;
  }
}
```

This contract stores the buyer, seller, amount, and payment status. When the buyer wants to make a payment, they would call the `pay()` function and provide the necessary parameters. The function checks that the user calling it is the buyer, and that the payment amount matches the agreed amount. It then sends the payment to the seller and sets the payment status to `true`.

3. **Reviews**: Here's an example of how a review smart contract could be implemented in Solidity:

```solidity
contract Review {
  address public reviewer;
  string public comment;
  uint public rating;
  bool public approved;

  function writeReview(string memory _comment, uint _rating) public {
    require(rating >= 1 && rating <= 5, "Rating must be between 1 and 5");
    reviewer = msg.sender;
    comment = _comment;
    rating = _rating;
    approved = false;
  }

  function approveReview() public {
    require(msg.sender == owner, "Only the owner can approve a review");
    approved = true;
  }
}
```

This contract stores the reviewer, comment, rating, and approval status. When a user wants to write a review, they would call the `writeReview()` function and provide the necessary parameters. The function checks that the rating is between 1 and 5, and then sets the values of reviewer, comment, rating, and approval status. Only the owner of the accommodation can approve a review, which they would do by calling the `approveReview()` function.

4. **Loyalty program**: Here's an example of how a loyalty program smart contract could be implemented in Solidity:

```solidity
contract LoyaltyProgram {
  address public user;
  uint public points;

  function addPoints(uint _points) public {
    user = msg.sender;
    points += _points;
  }

  function redeemPoints(uint _points) public {
    require(points >= _points, "Insufficient points");
    points -= _points;
    // implement redemption logic here
  }
}
```

This contract stores the user and their loyalty points. When a user wants to add points to their account, they would call the `addPoints()` function and provide the necessary parameters. The function sets the value of user and adds the given number of points to their account. When a user wants to redeem points, they would call the `redeemPoints()` function and provide the necessary parameters. The function checks that the user has enough points, subtracts the redeemed points from their account, and then implements the redemption logic (e.g. issuing a reward).

---

### final barebone version
***prototype release***

```solidity
contract Booking {
  address public owner;
  address public buyer;
  address public reviewer;
  uint public price;
  uint public startDate;
  uint public endDate;
  uint public rating;
  uint public loyaltyPoints;
  bool public paid;
  bool public approved;
  string public comment;
  string public description;

  modifier onlyOwner() {
    require(msg.sender == owner, "Only the owner can perform this action");
    _;
  }
  
  modifier onlyBuyer() {
    require(msg.sender == buyer, "Only the buyer can perform this action");
    _;
  }
  
  modifier onlyReviewer() {
    require(msg.sender == reviewer, "Only the reviewer can perform this action");
    _;
  }

  function book(uint _price, uint _startDate, uint _endDate, string memory _description) public onlyOwner {
    price = _price;
    startDate = _startDate;
    endDate = _endDate;
    description = _description;
  }

  function pay() public payable onlyBuyer {
    require(msg.value == price, "Payment amount must match the agreed amount");
    owner.transfer(price);
    paid = true;
  }

  function writeReview(string memory _comment, uint _rating) public {
    require(_rating >= 1 && _rating <= 5, "Rating must be between 1 and 5");
    reviewer = msg.sender;
    comment = _comment;
    rating = _rating;
    approved = false;
  }

  function approveReview() public onlyOwner {
    approved = true;
  }

  function addLoyaltyPoints(uint _points) public onlyOwner {
    loyaltyPoints += _points;
  }

  function redeemLoyaltyPoints(uint _points) public onlyOwner {
    require(loyaltyPoints >= _points, "Insufficient points");
    loyaltyPoints -= _points;
    // implement redemption logic here
  }
}
```

#

> Attention: this is for teaching purposes, don't use in product.

---

### web3 ui
using `bootstrap` for ui and `ethersjs` for web3 operations

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Booking</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
  <style>
    body {
      background-color: #222;
      color: #fff;
    }
    .card {
      background-color: #333;
      color: #fff;
      margin-bottom: 20px;
    }
    .btn-primary {
      background-color: #007bff;
      border-color: #007bff;
    }
    .btn-primary:hover {
      background-color: #0069d9;
      border-color: #0062cc;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="row">
      <div class="col-md-8 offset-md-2">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">Booking</h5>
            <form id="bookingForm">
              <div class="form-group">
                <label for="price">Price</label>
                <input type="number" class="form-control" id="price" name="price">
              </div>
              <div class="form-group">
                <label for="startDate">Start Date</label>
                <input type="date" class="form-control" id="startDate" name="startDate">
              </div>
              <div class="form-group">
                <label for="endDate">End Date</label>
                <input type="date" class="form-control" id="endDate" name="endDate">
              </div>
              <div class="form-group">
                <label for="description">Description</label>
                <textarea class="form-control" id="description" name="description"></textarea>
              </div>
              <button type="submit" class="btn btn-primary">Book</button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script src="https://cdn.ethers.io/lib/ethers-5.4.umd.min.js" crossorigin="anonymous"></script>
  <script>
    const provider = new ethers.providers.JsonRpcProvider('http://localhost:8545');
    const contractAddress = 'CONTRACT_ADDRESS';     // replace with contract address
    const contractABI = [];                         // replace with contract ABI

    const contract = new ethers.Contract(contractAddress, contractABI, provider);

    const bookingForm = document.getElementById('bookingForm');
    bookingForm.addEventListener('submit', async (event) => {
      event.preventDefault();
      const formData = new FormData(event.target);
      const price = formData.get('price');
      const startDate = formData.get('startDate');
      const endDate = formData.get('endDate');
      const description = formData.get('description');
      const signer = provider.getSigner();
      const transaction = await contract.connect(signer).book(price, startDate, endDate, description);
      await transaction.wait();
      alert('Booking successful!');
    });
  </script>
</body>
</html>
```

### mobile app
react native 0.64.2

```js
import React, { useState } from 'react';
import { StyleSheet, Text, View, TextInput, TouchableOpacity } from 'react-native';
import { ethers } from 'ethers';

const contractAddress = 'CONTRACT_ADDRESS';     // replace with contract address
const contractABI = [];                         // replace with contract ABI
const provider = new ethers.providers.JsonRpcProvider('http://localhost:8545');
const signer = provider.getSigner();
const contract = new ethers.Contract(contractAddress, contractABI, provider);

export default function App() {
  const [price, setPrice] = useState('');
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');
  const [description, setDescription] = useState('');
  const [status, setStatus] = useState('');

  const handleBook = async () => {
    try {
      const transaction = await contract.connect(signer).book(price, startDate, endDate, description);
      await transaction.wait();
      setStatus('Booking successful!');
    } catch (error) {
      console.error(error);
      setStatus('Booking failed. Please try again.');
    }
  }

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Booking</Text>
      <TextInput
        style={styles.input}
        placeholder="Price"
        value={price}
        onChangeText={setPrice}
        keyboardType="numeric"
      />
      <TextInput
        style={styles.input}
        placeholder="Start Date"
        value={startDate}
        onChangeText={setStartDate}
        keyboardType="numeric"
      />
      <TextInput
        style={styles.input}
        placeholder="End Date"
        value={endDate}
        onChangeText={setEndDate}
        keyboardType="numeric"
      />
      <TextInput
        style={styles.input}
        placeholder="Description"
        value={description}
        onChangeText={setDescription}
      />
      <TouchableOpacity style={styles.button} onPress={handleBook}>
        <Text style={styles.buttonText}>Book</Text>
      </TouchableOpacity>
      <Text style={styles.status}>{status}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#222',
    alignItems: 'center',
    justifyContent: 'center',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#fff',
    marginBottom: 20,
  },
  input: {
    width: '80%',
    height: 40,
    backgroundColor: '#333',
    borderRadius: 5,
    color: '#fff',
    paddingHorizontal: 10,
    marginBottom: 10,
  },
  button: {
    width: '80%',
    height: 40,
    backgroundColor: '#007bff',
    borderRadius: 5,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 10,
  },
  buttonText: {
    color: '#fff',
    fontWeight: 'bold',
  },
  status: {
    color: '#fff',
    marginTop: 20,
  },
});
```

> mobile app made by @creature , he is my student. this is just for teaching purposes, don't use in your product.
