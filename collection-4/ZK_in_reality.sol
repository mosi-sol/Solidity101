// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8;

// zk-Sign proof
// we are no need the mapping by "address", this is just example.
// for ZK product need just "bytes32", anonymously tx. (not anonymous address, anonymous who can do it)

contract SignMain {
    bytes4 immutable private TrustSign; // read constructor comment

    mapping(address => bytes32) private txSeries;
    mapping(bytes32 => address) private txSeriesTrue;

    // ---------------------------
    // event Claim(address claimer, bytes32 signWithNoMessage, address notClaim);

    // ---------------------------
    constructor() {
        TrustSign = bytes4(keccak256("txSign()")); // scifi ! just for fun...
    }

    // ---------------------------
    function txSign() private returns (bytes32) {
        require(txSeries[msg.sender] == bytes32(0), "you`re signed||claimed");
        bytes32 tmp = bytes32(keccak256(abi.encode(TrustSign, msg.sender, txNonce())));
        txSeries[msg.sender] = tmp;
        txSeriesTrue[tmp] = msg.sender;
        return tmp;
    }

    function txNonce() private view returns (bytes32) {
        uint8 nonce = salt();
        return bytes32(keccak256(abi.encode(msg.sender, nonce)));
    }

    function salt() private view returns(uint8) {
        // type(uint8).max === 255
        uint8 _salt = 255;
    	return uint8(uint256(
    		keccak256(abi.encodePacked(block.prevrandao, msg.sender))
    		)) % _salt; // salt must to be = 0 to 255 
    }

    // ---------------------------
    function claim() public {
        txSign();
        require(txSeries[msg.sender] != bytes32(0), "you`re signed/claimed");
        require(txSeriesTrue[txSeries[msg.sender]] == msg.sender, "you're claimed");
        txSeriesTrue[txSeries[msg.sender]] = address(0);
        // do somthing, like minting, or "build anonymously recognition address"
        // emit Claim(msg.sender, txSeries[msg.sender], txSeriesTrue[txSeries[msg.sender]]);
    }

    // this is use for development, like the test contract below
    function export(address candidate) public view returns (bool) {
        require(txSeries[candidate] != bytes32(0), "not candidate");
        return true;
    }
}


// ================= test ==============
contract Test {
    SignMain t;
    
    constructor(address _SignMain) {
        t = SignMain(_SignMain);
    }

    // example usecase: claim, mint, proof of identity, security reason or security solution
    function test() public view returns (bool) {        
        return t.export(msg.sender);
    }
}
