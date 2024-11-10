// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13 <0.9.0;

import "../FHE.sol";
import {PermissionedV2, PermissionV2} from "../access/PermissionedV2.sol";

contract PermissionedV2Counter is PermissionedV2 {
    mapping(address => euint32) private userCounter;
    address public owner;

    constructor() PermissionedV2("COUNTER") {
        owner = msg.sender;
    }

    function add(inEuint32 calldata encryptedValue) public {
        euint32 value = FHE.asEuint32(encryptedValue);
        userCounter[msg.sender] = userCounter[msg.sender] + value;
    }

    function getCounter(address user) public view returns (uint256) {
        return FHE.decrypt(userCounter[user]);
    }

    function getCounterPermit(
        PermissionV2 memory permission
    ) public view withPermission(permission) returns (uint256) {
        return FHE.decrypt(userCounter[permission.issuer]);
    }

    function getCounterPermitSealed(
        PermissionV2 memory permission
    ) public view withPermission(permission) returns (string memory) {
        return
            FHE.sealoutput(
                userCounter[permission.issuer],
                permission.sealingKey
            );
    }
}
