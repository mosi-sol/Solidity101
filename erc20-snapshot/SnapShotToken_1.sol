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
|  Erc20 - snapshot - ver 0.0.1 |
============================== */

contract TrackingToken is IERC20 {
    string public name = "Tracking Token";
    string public symbol = "TK";
    uint8 public decimals = 18;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(uint256 => mapping(address => uint256)) private _snapshotData;
    uint256 private _currentSnapshotId;

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
        _updateSnapshotData(msg.sender);
        _updateSnapshotData(recipient);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        _updateSnapshotData(msg.sender);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
        _updateSnapshotData(sender);
        _updateSnapshotData(recipient);
        return true;
    }

    function snapshot() public returns (uint256) {
        _currentSnapshotId += 1;
        uint256 snapshotId = _currentSnapshotId;
        for (uint256 i = 0; i < _currentSnapshotId; i++) {
            for (uint256 j = 0; j < _currentSnapshotId; j++) {
                _snapshotData[snapshotId][msg.sender] = _balances[msg.sender];
            }
        }
        return snapshotId;
    }

    function getSnapshotData(uint256 snapshotId, address account) public view returns (uint256) {
        return _snapshotData[snapshotId][account];
    }

    function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "TK: transfer from the zero address");
        require(recipient != address(0), "TK: transfer to the zero address");
        require(_balances[sender] >= amount, "TK: transfer amount exceeds balance");
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "TK: approve from the zero address");
        require(spender != address(0), "TK: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _updateSnapshotData(address account) private {
        _snapshotData[_currentSnapshotId][account] = _balances[account];
    }
}
