// solhint-disable no-empty-blocks
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

import {FHE, euint128, inEuint128} from "../FHE.sol";
import {PermissionedV2, PermissionV2} from "./PermissionedV2.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IFHERC20} from "./IFHERC20.sol";

contract FHERC20 is IFHERC20, ERC20, PermissionedV2 {
    // A mapping from address to an encrypted balance.
    mapping(address => euint128) internal _encBalances;
    // A mapping from address (owner) to a mapping of address (spender) to an encrypted amount.
    mapping(address => mapping(address => euint128)) internal _encAllowances;
    euint128 internal _encTotalSupply = FHE.asEuint128(0);

    constructor(
        string memory name,
        string memory symbol,
        address permitV2 // TODO: Remove when PermitV2 deployed to fixed address
    ) ERC20(name, symbol) PermissionedV2(permitV2, "FHERC20") {}

    /**
     * @dev Returns the encrypted value of tokens in existence.
     */
    function encTotalSupply() public view virtual override returns (euint128) {
        return _encTotalSupply;
    }

    /**
     * @dev Returns the encrypted value of tokens in existence, sealed for the caller.
     */
    function sealedTotalSupply(
        PermissionV2 calldata permission
    )
        public
        view
        virtual
        override
        withPermission(permission)
        returns (string memory)
    {
        return _encTotalSupply.seal(permission.publicKey);
    }

    /**
     * @dev Returns the value of the encrypted tokens owned by `account`
     */
    function encBalanceOf(
        address account
    ) public view virtual override returns (euint128) {
        return _encBalances[account];
    }

    /**
     * @dev Returns the value of the encrypted tokens owned by the issuer of the PermitNft, sealed for the caller
     */
    function sealedBalanceOf(
        PermissionV2 calldata permission
    )
        public
        view
        virtual
        override
        withPermission(permission)
        returns (string memory)
    {
        return _encBalances[permission.issuer].seal(permission.publicKey);
    }

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     * Accepts the value as inEuint128, more convenient for calls from EOAs.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     */
    function encTransfer(
        address to,
        inEuint128 calldata ieAmount
    ) public virtual override returns (bool) {
        _encTransfer(msg.sender, to, FHE.asEuint128(ieAmount));
        return true;
    }

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function encAllowance(
        address owner,
        address spender
    ) public view virtual override returns (euint128) {
        return _encAllowances[owner][spender];
    }

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default. Sealed for the caller.
     *
     * Permission issuer must be either the owner or spender.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function sealedAllowance(
        PermissionV2 calldata permission,
        address owner,
        address spender
    )
        public
        view
        virtual
        override
        withPermission(permission)
        returns (string memory)
    {
        if (permission.issuer != owner && permission.issuer != spender) {
            revert FHERC20NotOwnerOrSpender();
        }
        return _encAllowances[owner][spender].seal(permission.publicKey);
    }

    /**
     * @dev Sets `ieAmount` tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits an {EncApproved} event.
     */
    function encApprove(
        address spender,
        inEuint128 calldata ieAmount
    ) public virtual override returns (bool) {
        _encApprove(msg.sender, spender, FHE.asEuint128(ieAmount));
        return true;
    }

    /**
     * @dev Moves `ieAmount` tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance. Accepts the value as inEuint128, more convenient for calls from EOAs.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {EncTransfer} event.
     */
    function encTransferFrom(
        address from,
        address to,
        inEuint128 calldata ieAmount
    ) public virtual override returns (bool) {
        euint128 encSpent = _encSpendAllowance(
            from,
            msg.sender,
            FHE.asEuint128(ieAmount)
        );
        _encTransfer(from, to, encSpent);
        return true;
    }

    /**
     * @dev Encrypts `amount` tokens, reducing the callers public balance by `amount`,
     * and increasing their `encBalance` by `amount`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits an {Encrypted} event.
     */
    function encrypt(uint128 amount) public virtual override returns (bool) {
        _burn(msg.sender, amount);
        _encMint(msg.sender, FHE.asEuint128(amount));

        emit Encrypted(msg.sender, amount);

        return true;
    }

    /**
     * @dev Decrypts `amount` tokens, reducing the callers `encBalance` by `amount`,
     * and increasing their public balance by `amount`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Decrypted} event.
     */
    function decrypt(uint128 amount) public virtual override returns (bool) {
        euint128 eAmount = _encBurn(msg.sender, FHE.asEuint128(amount));
        amount = FHE.decrypt(eAmount);
        _mint(msg.sender, amount);

        emit Decrypted(msg.sender, amount);

        return true;
    }

    /**
     * @dev Moves `eAmount` tokens from the caller's account to `to`.
     * Accepts the value as euint128, more convenient for calls from other contracts
     *
     * Returns an `euint128` of the true amount transferred.
     *
     * Emits an {EncTransfer} event.
     */
    function _encTransfer(
        address from,
        address to,
        euint128 eAmount
    ) internal returns (euint128) {
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }

        // Make sure the sender has enough tokens.
        eAmount = FHE.select(
            eAmount.lte(_encBalances[from]),
            eAmount,
            FHE.asEuint128(0)
        );

        _encBeforeTokenTransfer(from, to, eAmount);

        // Add to the balance of `to` and subtract from the balance of `from`.
        _encBalances[to] = _encBalances[to] + eAmount;
        _encBalances[from] = _encBalances[from] - eAmount;

        emit EncTransfer(from, to);

        _encAfterTokenTransfer(from, to, eAmount);

        return eAmount;
    }

    /**
     * @dev Creates `eAmount` encrypted tokens and assigns them to `to`.
     * Increases `encTotalSupply` by `eAmount`
     * Accepts the value as euint128, more convenient for calls from other contracts
     *
     * Emits an {EncTransfer} event with `from` set to the zero address.
     */
    function _encMint(address to, euint128 eAmount) internal {
        if (account == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }

        _encBeforeTokenTransfer(address(0), to, eAmount);

        _encBalances[to] = _encBalances[to] + eAmount;
        _encTotalSupply = _encTotalSupply + eAmount;

        emit EncTransfer(address(0), to);

        _encAfterTokenTransfer(address(0), to, eAmount);
    }

    /**
     * @dev Destroys `eAmount` encrypted tokens from `to`.
     * Decreases `encTotalSupply` by `eAmount`
     * Accepts the value as euint128, more convenient for calls from other contracts
     *
     * Emits an {EncTransfer} event with `to` set to the zero address.
     */
    function _encBurn(
        address from,
        euint128 eAmount
    ) internal returns (euint128) {
        if (account == address(0)) {
            revert ERC20InvalidSender(address(0));
        }

        eAmount = FHE.select(
            _encBalances[msg.sender].gte(eAmount),
            eAmount,
            FHE.asEuint128(0)
        );

        _encBeforeTokenTransfer(from, address(0), eAmount);

        _encBalances[from] = _encBalances[from] - eAmount;
        _encTotalSupply = _encTotalSupply - eAmount;

        emit EncTransfer(from, address(0));

        _encAfterTokenTransfer(from, address(0), eAmount);

        return eAmount;
    }

    function _encApprove(
        address owner,
        address spender,
        euint128 eAmount
    ) internal {
        if (owner == address(0)) {
            revert ERC20InvalidApprover(address(0));
        }
        if (spender == address(0)) {
            revert ERC20InvalidSpender(address(0));
        }
        _encAllowances[owner][spender] = eAmount;
    }

    function _encSpendAllowance(
        address owner,
        address spender,
        euint128 eAmount
    ) internal virtual returns (euint128) {
        euint128 eCurrentAllowance = _encAllowances[owner][spender];
        euint128 eSpent = FHE.min(eCurrentAllowance, eAmount);
        _encApprove(owner, spender, (eCurrentAllowance - eSpent));

        return eSpent;
    }

    /**
     * @dev Hook that is called before any transfer of encrypted tokens. This includes
     * minting and burning.
     */
    function _encBeforeTokenTransfer(
        address from,
        address to,
        euint128 eAmount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of encrypted tokens. This includes
     * minting and burning.
     */
    function _encAfterTokenTransfer(
        address from,
        address to,
        euint128 eAmount
    ) internal virtual {}
}
