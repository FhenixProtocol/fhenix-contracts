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
    mapping(address => euint128) internal _encBalances;
    mapping(address => mapping(address => euint128)) internal _allowed;
    euint128 internal totalEncryptedSupply = FHE.asEuint128(0);
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}
    function _allowanceEncrypted(address owner, address spender) internal view returns (euint128) { return _allowed[owner][spender]; }
    function allowanceEncrypted(address owner, address spender, Permission calldata permission) public view virtual onlyBetweenPermitted(permission, owner, spender) returns (string memory) { return FHE.sealoutput(_allowanceEncrypted(owner, spender), permission.publicKey); }
    function approveEncrypted(address spender, inEuint128 calldata value) public virtual returns (bool) { _approve(msg.sender, spender, FHE.asEuint128(value)); return true; }
    function _approve(address owner, address spender, euint128 value) internal { if (owner == address(0)) revert ERC20InvalidApprover(address(0)); if (spender == address(0)) revert ERC20InvalidSpender(address(0)); _allowed[owner][spender] = value; emit ApprovalEncrypted(owner, spender); }
    function _spendAllowance(address owner, address spender, euint128 value) internal virtual returns (euint128) { euint128 cur = _allowanceEncrypted(owner, spender); euint128 spent = FHE.min(cur, value); _approve(owner, spender, cur - spent); return spent; }
    function transferFromEncrypted(address from, address to, inEuint128 calldata value) public virtual returns (euint128) { return _transferImpl(from, to, _spendAllowance(from, msg.sender, FHE.asEuint128(value))); }
    function wrap(uint32 amount) public { if (balanceOf(msg.sender) < amount) revert ErrorInsufficientFunds(); _burn(msg.sender, amount); euint128 e = FHE.asEuint128(amount); _encBalances[msg.sender] = _encBalances[msg.sender] + e; totalEncryptedSupply = totalEncryptedSupply + e; }
    function unwrap(uint32 amount) public { euint128 enc = FHE.asEuint128(amount); euint128 toUnwrap = FHE.select(_encBalances[msg.sender].gte(enc), enc, FHE.asEuint128(0)); _encBalances[msg.sender] = _encBalances[msg.sender] - toUnwrap; totalEncryptedSupply = totalEncryptedSupply - toUnwrap; _mint(msg.sender, FHE.decrypt(toUnwrap)); }
    function _mintEncrypted(address to, inEuint128 memory encryptedAmount) internal { euint128 amount = FHE.asEuint128(encryptedAmount); _encBalances[to] = _encBalances[to] + amount; totalEncryptedSupply = totalEncryptedSupply + amount; }
    function transferEncrypted(address to, inEuint128 calldata encryptedAmount) public returns (euint128) { return _transferImpl(msg.sender, to, FHE.asEuint128(encryptedAmount)); }
    function _transferImpl(address from, address to, euint128 amount) internal returns (euint128) { euint128 send = FHE.select(amount.lte(_encBalances[from]), amount, FHE.asEuint128(0)); _encBalances[to] = _encBalances[to] + send; _encBalances[from] = _encBalances[from] - send; emit TransferEncrypted(from, to); return send; }
    function balanceOfEncrypted(address account, Permission memory auth) virtual public view onlyPermitted(auth, account) returns (string memory) { return _encBalances[account].seal(auth.publicKey); }
}
