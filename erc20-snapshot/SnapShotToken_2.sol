// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


/* =============================
|  Erc20 - snapshot - ver 0.0.2 |
============================== */

// use snapshot in library version to use in code
library Snapshot {
    struct Data {
        mapping(uint256 => mapping(address => uint256)) snapshotData;
        uint256 currentSnapshotId;
    }

    function snapshot(Data storage data, address account) internal returns (uint256) {
        data.currentSnapshotId += 1;
        uint256 snapshotId = data.currentSnapshotId;
        data.snapshotData[snapshotId][account] = IERC20(account).balanceOf(address(this));
        return snapshotId;
    }

    function getSnapshotData(Data storage data, uint256 snapshotId, address account) internal view returns (uint256) {
        return data.snapshotData[snapshotId][account];
    }
}

contract TrackableToken is IERC20 {
    using Snapshot for Snapshot.Data;

    string public name = "Snapshot Token";
    string public symbol = "SST";
    uint8 public decimals = 18;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    Snapshot.Data private _snapshotData;

    constructor(uint256 initialSupply) {
        _totalSupply = initialSupply;
        _balances[msg.sender] = initialSupply;
        emit Transfer(address(0), msg.sender, initialSupply);
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        _snapshotData.snapshot(msg.sender);
        _snapshotData.snapshot(recipient);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        _snapshotData.snapshot(msg.sender);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
        _snapshotData.snapshot(sender);
        _snapshotData.snapshot(recipient);
        return true;
    }

    function snapshot() public returns (uint256) {
        return _snapshotData.snapshot(msg.sender);
    }

    function getSnapshotData(uint256 snapshotId, address account) public view returns (uint256) {
        return _snapshotData.getSnapshotData(snapshotId, account);
    }

    function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "SST: transfer from the zero address");
        require(recipient != address(0), "SST: transfer to the zero address");
        require(_balances[sender] >= amount, "SST: transfer amount exceeds balance");
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "SST: approve from the zero address");
        require(spender != address(0), "SST: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}
