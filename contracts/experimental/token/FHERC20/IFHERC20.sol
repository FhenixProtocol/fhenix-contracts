pragma solidity >=0.8.19 <0.9.0;

// SPDX-License-Identifier: MIT
// Fhenix Protocol (last updated v0.1.0) (token/FHERC20/IFHERC20.sol)
// Inspired by OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts) (token/ERC20/IERC20.sol)

import { Permission, Permissioned } from "../../../access/Permissioned.sol";
import { euint128, inEuint128 } from "../../../FHE.sol";

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IFHERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event TransferEncrypted(address indexed from, address indexed to);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approveEncrypted}. `value` is the new allowance.
     */
    event ApprovalEncrypted(address indexed owner, address indexed spender);

    // /**
    //  * @dev Returns the value of tokens in existence.
    //  */
    // function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`, sealed and encrypted for the caller.
     */
    function balanceOfEncrypted(address account, Permission memory auth) external view returns (string memory);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     * Accepts the value as inEuint128, more convenient for calls from EOAs.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     */
    function transferEncrypted(address to, inEuint128 calldata value) external returns (euint128);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     * Accepts the value as euint128, more convenient for calls from other contracts
     *
     * Returns a boolean value indicating whether the operation succeeded.
     */
    function _transferEncrypted(address to, euint128 value) external returns (euint128);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowanceEncrypted(address owner, address spender, Permission memory permission) external view returns (string memory);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
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
    function approveEncrypted(address spender, inEuint128 calldata value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance. Accepts the value as inEuint128, more convenient for calls from EOAs.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {TransferEncrypted} event.
     */
    function transferFromEncrypted(address from, address to, inEuint128 calldata value) external returns (euint128);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance. Accepts the value as inEuint128, more convenient for calls
     * from other contracts.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {TransferEncrypted} event.
     */
    function _transferFromEncrypted(address from, address to, euint128 value) external returns (euint128);
}
