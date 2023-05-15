// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8;

contract RideHailingPlatform {
    
    struct Rider {
        string name;
        uint balance;
    }
    
    struct Driver {
        string name;
        uint balance;
    }
    
    struct RideRequest {
        uint riderId;
        uint driverId;
        uint fare;
        bool isAccepted;
        bool isCompleted;
    }
    
    mapping(uint => Rider) public riders;
    mapping(uint => Driver) public drivers;
    mapping(uint => RideRequest) public rideRequests;
    
    uint public riderCount;
    uint public driverCount;
    uint public rideRequestCount;
    
    constructor() {
        riderCount = 0;
        driverCount = 0;
        rideRequestCount = 0;
    }
    
    function createRider(string memory _name) public {
        riders[riderCount] = Rider(_name, 0);
        riderCount++;
    }
    
    function createDriver(string memory _name) public {
        drivers[driverCount] = Driver(_name, 0);
        driverCount++;
    }
    
    function createRideRequest(uint _riderId, uint _fare) public {
        require(_riderId < riderCount, "Invalid rider ID");
        rideRequests[rideRequestCount] = RideRequest(_riderId, 0, _fare, false, false);
        rideRequestCount++;
    }
    
    function cancelRideRequest(uint _rideRequestId) public {
        require(_rideRequestId < rideRequestCount, "Invalid ride request ID");
        require(!rideRequests[_rideRequestId].isAccepted, "Ride request already accepted");
        require(!rideRequests[_rideRequestId].isCompleted, "Ride request already completed");
        delete rideRequests[_rideRequestId];
    }
    
    function acceptRideRequest(uint _rideRequestId, uint _driverId) public {
        require(_rideRequestId < rideRequestCount, "Invalid ride request ID");
        require(_driverId < driverCount, "Invalid driver ID");
        require(!rideRequests[_rideRequestId].isAccepted, "Ride request already accepted");
        rideRequests[_rideRequestId].driverId = _driverId;
        rideRequests[_rideRequestId].isAccepted = true;
    }
    
    function completeRide(uint _rideRequestId) public {
        require(_rideRequestId < rideRequestCount, "Invalid ride request ID");
        require(rideRequests[_rideRequestId].isAccepted, "Ride request not accepted");
        require(!rideRequests[_rideRequestId].isCompleted, "Ride request already completed");
        Rider storage rider = riders[rideRequests[_rideRequestId].riderId];
        Driver storage driver = drivers[rideRequests[_rideRequestId].driverId];
        uint fare = rideRequests[_rideRequestId].fare;
        rider.balance -= fare;
        driver.balance += fare;
        rideRequests[_rideRequestId].isCompleted = true;
    }

    function disputeRide(uint _rideRequestId) public {
        require(_rideRequestId < rideRequestCount, "Invalid ride request ID");
        require(rideRequests[_rideRequestId].isAccepted, "Ride request not accepted");
        require(!rideRequests[_rideRequestId].isCompleted, "Ride request already completed");
        Rider storage rider = riders[rideRequests[_rideRequestId].riderId];
        Driver storage driver = drivers[rideRequests[_rideRequestId].driverId];
        uint fare = rideRequests[_rideRequestId].fare;
        rider.balance += fare;
        driver.balance -= fare;
        rideRequests[_rideRequestId].isCompleted = true;
    }
    
    function getRiderBalance(uint _riderId) public view returns (uint) {
        require(_riderId < riderCount, "Invalid rider ID");
        return riders[_riderId].balance;
    }
    
    function getDriverBalance(uint _driverId) public view returns (uint) {
        require(_driverId < driverCount, "Invalid driver ID");
        return drivers[_driverId].balance;
    }
    
    function rateDriver(uint _driverId, uint _rating) public view {
        require(_driverId < driverCount, "Invalid driver ID");
        require(_rating <= 5, "Invalid rating");
        // Implement rating system logic here
    }
    
    function incentivizeDriver(uint _driverId, uint _amount) public {
        require(_driverId < driverCount, "Invalid driver ID");
        drivers[_driverId].balance += _amount;
    }
    
    function authenticateUser() public pure returns (bool) {
        // Implement authentication logic here
    }
}

// remember to add transparency for rider and drivers. drivers would to kyc before accessing the app. etc...
// trade fee and app fee, etc...
