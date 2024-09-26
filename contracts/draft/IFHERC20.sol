pragma solidity >=0.8.19 <0.9.0;

// SPDX-License-Identifier: MIT
// Fhenix Protocol (last updated v0.1.0) (token/FHERC20/IFHERC20.sol)
// Inspired by OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts) (token/ERC20/IERC20.sol)

import {euint128, inEuint128} from "../FHE.sol";
import {PermissionV2} from "./PermissionedV2.sol";

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IFHERC20 {
    error FHERC20NotOwnerOrSpender();

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event EncTransfer(address indexed from, address indexed to);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approveEncrypted}. `value` is the new allowance.
     */
    event EncApproved(address indexed owner, address indexed spender);

    /**
     * @dev Emitted when `amount` tokens are transferred from `_balance[owner]` to `_encBalance[owner]`
     * by a call to {encrypt}.
     */
    event Encrypted(address indexed owner, uint256 amount);

    /**
     * @dev Emitted when `amount` tokens are transferred from `_encBalance[owner]` to `_balance[owner]`
     * by a call to {decrypt}.
     */
    event Decrypted(address indexed owner, uint256 amount);

    /**
     * @dev Returns the encrypted value of tokens in existence.
     */
    function encTotalSupply() external view returns (euint128);

    /**
     * @dev Returns the encrypted value of tokens in existence, sealed for the caller.
     */
    function sealedTotalSupply(
        PermissionV2 calldata permission
    ) external view returns (string memory);

    /**
     * @dev Returns the value of the encrypted tokens owned by `account`
     */
    function encBalanceOf(address account) external view returns (euint128);

    /**
     * @dev Returns the value of the encrypted tokens owned by the issuer of the PermitNft, sealed for the caller
     */
    function sealedBalanceOf(
        PermissionV2 memory permission
    ) external view returns (string memory);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     * Accepts the value as inEuint128, more convenient for calls from EOAs.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     */
    function encTransfer(
        address to,
        inEuint128 calldata ieAmount
    ) external returns (bool);

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
    ) external view returns (euint128);

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
        PermissionV2 memory permission,
        address owner,
        address spender
    ) external view returns (string memory);

    /**
     * @dev Sets `ieAmount` tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {ApprovalEncrypted} event.
     */
    function encApprove(
        address spender,
        inEuint128 calldata ieAmount
    ) external returns (bool);

    /**
     * @dev Moves `ieAmount` tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance. Accepts the value as inEuint128, more convenient for calls from EOAs.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {TransferEncrypted} event.
     */
    function encTransferFrom(
        address from,
        address to,
        inEuint128 calldata ieAmount
    ) external returns (bool);

    /**
     * @dev Encrypts `amount` tokens, reducing the callers public balance by `amount`,
     * and increasing their `encBalance` by `amount`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Encrypted} event.
     */
    function encrypt(uint128 amount) external returns (bool);

    /**
     * @dev Decrypts `amount` tokens, reducing the callers `encBalance` by `amount`,
     * and increasing their public balance by `amount`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Decrypted} event.
     */
    function decrypt(uint128 amount) external returns (bool);
}
