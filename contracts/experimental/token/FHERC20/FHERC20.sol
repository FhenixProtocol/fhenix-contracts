// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { FHE, euint128, inEuint128 } from "../../../FHE.sol";
import { Permissioned, Permission } from "../../../access/Permissioned.sol";

import { IFHERC20 } from "./IFHERC20.sol";

error ErrorInsufficientFunds();
error ERC20InvalidApprover(address);
error ERC20InvalidSpender(address);

contract FHERC20 is IFHERC20, ERC20, Permissioned {

    // A mapping from address to an encrypted balance.
    mapping(address => euint128) internal _encBalances;
    // A mapping from address (owner) to a mapping of address (spender) to an encrypted amount.
    mapping(address => mapping(address => euint128)) internal _allowed;
    euint128 internal totalEncryptedSupply = FHE.asEuint128(0);

    constructor(
        string memory name,
        string memory symbol
    ) ERC20(name, symbol) {}

    function _allowanceEncrypted(address owner, address spender) internal view returns (euint128) {
        return _allowed[owner][spender];
    }

    function allowanceEncrypted(
        address owner,
        address spender,
        Permission calldata permission
    ) public view virtual onlyBetweenPermitted(permission, owner, spender) returns (string memory) {
        return FHE.sealoutput(_allowanceEncrypted(owner, spender), permission.publicKey);
    }

    function approveEncrypted(address spender, inEuint128 calldata value) public virtual returns (bool) {
        _approve(msg.sender, spender, FHE.asEuint128(value));
        return true;
    }

    function _approve(address owner, address spender, euint128 value) internal {
        if (owner == address(0)) {
            revert ERC20InvalidApprover(address(0));
        }
        if (spender == address(0)) {
            revert ERC20InvalidSpender(address(0));
        }
        _allowed[owner][spender] = value;
    }

    function _spendAllowance(address owner, address spender, euint128 value) internal virtual returns (euint128) {
        euint128 currentAllowance = _allowanceEncrypted(owner, spender);
        euint128 spent = FHE.min(currentAllowance, value);
        _approve(owner, spender, (currentAllowance - spent));

        return spent;
    }

    function transferFromEncrypted(address from, address to, inEuint128 calldata value) public virtual returns (euint128) {
        return _transferFromEncrypted(from, to, FHE.asEuint128(value));
    }

    function _transferFromEncrypted(address from, address to, euint128 value) public virtual returns (euint128) {
        euint128 val = value;
        euint128 spent = _spendAllowance(from, msg.sender, val);
        return _transferImpl(from, to, spent);
    }

    function wrap(uint32 amount) public {
        if (balanceOf(msg.sender) < amount) {
            revert ErrorInsufficientFunds();
        }

        _burn(msg.sender, amount);
        euint128 eAmount = FHE.asEuint128(amount);
        _encBalances[msg.sender] = _encBalances[msg.sender] + eAmount;
        totalEncryptedSupply = totalEncryptedSupply + eAmount;
    }

    function unwrap(uint32 amount) public {
        euint128 encAmount = FHE.asEuint128(amount);

        euint128 amountToUnwrap = FHE.select(_encBalances[msg.sender].gte(encAmount), encAmount, FHE.asEuint128(0));

        _encBalances[msg.sender] = _encBalances[msg.sender] - amountToUnwrap;
        totalEncryptedSupply = totalEncryptedSupply - amountToUnwrap;

        _mint(msg.sender, FHE.decrypt(amountToUnwrap));
    }

//    function mint(uint256 amount) public {
//        _mint(msg.sender, amount);
//    }

    function _mintEncrypted(address to, inEuint128 memory encryptedAmount) internal {
        euint128 amount = FHE.asEuint128(encryptedAmount);
        _encBalances[to] = _encBalances[to] + amount;
        totalEncryptedSupply = totalEncryptedSupply + amount;
    }

    function transferEncrypted(address to, inEuint128 calldata encryptedAmount) public returns (euint128) {
        return _transferEncrypted(to, FHE.asEuint128(encryptedAmount));
    }

    // Transfers an amount from the message sender address to the `to` address.
    function _transferEncrypted(address to, euint128 amount) public returns (euint128) {
        return _transferImpl(msg.sender, to, amount);
    }

    // Transfers an encrypted amount.
    function _transferImpl(address from, address to, euint128 amount) internal returns (euint128) {
        // Make sure the sender has enough tokens.
        euint128 amountToSend = FHE.select(amount.lte(_encBalances[from]), amount, FHE.asEuint128(0));

        // Add to the balance of `to` and subract from the balance of `from`.
        _encBalances[to] = _encBalances[to] + amountToSend;
        _encBalances[from] = _encBalances[from] - amountToSend;

        return amountToSend;
    }

    function balanceOfEncrypted(
        address account, Permission memory auth
    ) virtual public view onlyPermitted(auth, account) returns (string memory) {
        return _encBalances[account].seal(auth.publicKey);
    }

    //    // Returns the total supply of tokens, sealed and encrypted for the caller.
    //    // todo: add a permission check for total supply readers
    //    function getEncryptedTotalSupply(
    //        Permission calldata permission
    //    ) public view onlySender(permission) returns (bytes memory) {
    //        return totalEncryptedSupply.seal(permission.publicKey);
    //    }
}
