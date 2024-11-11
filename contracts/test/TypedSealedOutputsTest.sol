// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13 <0.9.0;

import {FHE, BindingsEbool, BindingsEuint8, SealedBool, SealedUint, SealedAddress, ebool, euint8, euint16, euint32, euint64, euint128, euint256, eaddress} from "../FHE.sol";
import {PermissionedV2, PermissionV2} from "../access/PermissionedV2.sol";

contract TypedSealedOutputsTest is PermissionedV2 {
    using BindingsEuint8 for euint8;

    constructor() PermissionedV2("TEST") {}

    function getSealedEBool(PermissionV2 memory permission, bool value) public view withPermission(permission) returns (SealedBool memory, SealedBool memory) {
        return (
            FHE.sealoutputTyped(FHE.asEbool(value), permission.sealingKey),
            FHE.asEbool(value).sealTyped(permission.sealingKey)
        );
    }

    function getSealedEUint8(PermissionV2 memory permission, uint8 value) public view withPermission(permission) returns (SealedUint memory, SealedUint memory) {
        return (
            FHE.sealoutputTyped(FHE.asEuint8(value), permission.sealingKey),
            FHE.asEuint8(value).sealTyped(permission.sealingKey)
        );
    }

    function getSealedEUint16(PermissionV2 memory permission, uint16 value) public view withPermission(permission) returns (SealedUint memory, SealedUint memory) {
        return (
            FHE.sealoutputTyped(FHE.asEuint16(value), permission.sealingKey),
            FHE.asEuint16(value).sealTyped(permission.sealingKey)
        );
    }

    function getSealedEUint32(PermissionV2 memory permission, uint32 value) public view withPermission(permission) returns (SealedUint memory, SealedUint memory) {
        return (
            FHE.sealoutputTyped(FHE.asEuint32(value), permission.sealingKey),
            FHE.asEuint32(value).sealTyped(permission.sealingKey)
        );
    }

    function getSealedEUint64(PermissionV2 memory permission, uint64 value) public view withPermission(permission) returns (SealedUint memory, SealedUint memory) {
        return (
            FHE.sealoutputTyped(FHE.asEuint64(value), permission.sealingKey),
            FHE.asEuint64(value).sealTyped(permission.sealingKey)
        );
    }



    function getSealedEUint128(PermissionV2 memory permission, uint128 value) public view withPermission(permission) returns (SealedUint memory, SealedUint memory) {
        return (
            FHE.sealoutputTyped(FHE.asEuint128(value), permission.sealingKey),
            FHE.asEuint128(value).sealTyped(permission.sealingKey)
        );
    }



    function getSealedEUint256(PermissionV2 memory permission, uint256 value) public view withPermission(permission) returns (SealedUint memory, SealedUint memory) {
        return (
            FHE.sealoutputTyped(FHE.asEuint256(value), permission.sealingKey),
            FHE.asEuint256(value).sealTyped(permission.sealingKey)
        );
    }

    function getSealedEAddress(PermissionV2 memory permission, address value) public view withPermission(permission) returns (SealedAddress memory, SealedAddress memory) {
        return (
            FHE.sealoutputTyped(FHE.asEaddress(value), permission.sealingKey),
            FHE.asEaddress(value).sealTyped(permission.sealingKey)
        );
    }
}
