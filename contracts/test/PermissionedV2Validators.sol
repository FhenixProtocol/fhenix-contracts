// solhint-disable func-name-mixedcase
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

import {IPermissionValidator, PermissionV2} from "../access/PermissionedV2.sol";

contract PermissionedV2RevokableValidator is IPermissionValidator {
    uint256 public rid = 1;
    mapping(uint256 => bool) public revoked;
    mapping(uint256 => address) public owner;

    function createRevokableId() public returns (uint256) {
        uint256 id = rid;
        rid += 1;

        revoked[id] = false;
        owner[id] = msg.sender;

        return id;
    }

    function revokeId(uint256 id) public {
        require(owner[id] == msg.sender, "Not owner of id");
        revoked[id] = true;
    }

    function disabled(address, uint256 id) external view returns (bool) {
        return revoked[id];
    }
}

contract PermissionedV2TimestampValidator is IPermissionValidator {
    mapping(address => uint256) public userLastRevokedTimestamp;

    function revokeExisting() public {
        userLastRevokedTimestamp[msg.sender] = block.timestamp;
    }

    function disabled(address issuer, uint256 id) external view returns (bool) {
        return id < userLastRevokedTimestamp[issuer];
    }
}
