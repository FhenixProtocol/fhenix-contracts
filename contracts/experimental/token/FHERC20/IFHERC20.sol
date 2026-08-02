pragma solidity >=0.8.19 <0.9.0;
// SPDX-License-Identifier: MIT
import { Permission, Permissioned } from "../../../access/Permissioned.sol";
import { euint128, inEuint128 } from "../../../FHE.sol";
interface IFHERC20 {
    event TransferEncrypted(address indexed from, address indexed to);
    event ApprovalEncrypted(address indexed owner, address indexed spender);
    function balanceOfEncrypted(address account, Permission memory auth) external view returns (string memory);
    function allowanceEncrypted(address owner, address spender, Permission memory permission) external view returns (string memory);
    function transferEncrypted(address to, inEuint128 calldata value) external returns (euint128);
    function approveEncrypted(address spender, inEuint128 calldata value) external returns (bool);
    function transferFromEncrypted(address from, address to, inEuint128 calldata value) external returns (euint128);
}
