// solhint-disable func-name-mixedcase
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import {SignatureChecker} from "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import {JsonBuilder} from "./JsonBuilder.sol";

struct PermissionV2 {
    address issuer;
    uint256 permitId;
    bytes32 sealingKey;
    uint64 deadline;
    bytes signature;
}

struct PermitV2Info {
    uint256 id;
    address issuer;
    string name;
    uint64 createdAt;
    uint64 validityDur;
    uint64 expiresAt;
    bool revoked;
    bool universal;
}

struct PermitV2FullInfo {
    uint256 id;
    address issuer;
    string name;
    address holder;
    uint64 createdAt;
    uint64 validityDur;
    uint64 expiresAt;
    bool revoked;
    bool universal;
    address[] contracts;
    string[] projectIds;
    address[] routers;
}

interface IFhenixPermitV2 {
    function validateProjectId(bytes32 _projectId) external view;
    function checkPermitSatisfies(
        uint256 _permitId,
        address _contract,
        bytes32 _projectId
    ) external view returns (bool);
    function validatePermission(
        PermissionV2 calldata _permission,
        address _sender,
        address _contract,
        bytes32 _projectId
    ) external view;
    function validatePermitRouter(
        uint256 _permitId,
        address _router
    ) external view returns (address issuer);
    function approve(
        uint256 _permitId,
        address _contract,
        bytes32 _projectId,
        address _router
    ) external;
    function revokeApproval(
        uint256 _permitId,
        address _contract,
        bytes32 _projectId,
        address _router
    ) external;
}

interface IFhenixPermissionedV2 {
    function PROJECT_ID() external view returns (string memory);
}

contract PermitV2 is ERC721Enumerable, EIP712, IFhenixPermitV2 {
    using JsonBuilder for string;

    using EnumerableSet for EnumerableSet.Bytes32Set;
    using EnumerableSet for EnumerableSet.AddressSet;

    string public version = "v2.0.0";

    uint256 private _pid = 0;
    mapping(uint256 => PermitV2Info) private permitInfo;
    mapping(uint256 => EnumerableSet.AddressSet) private permitContracts;
    mapping(uint256 => EnumerableSet.Bytes32Set) private permitProjectIds;
    mapping(uint256 => EnumerableSet.AddressSet) private permitRouters;

    EnumerableSet.Bytes32Set private projectIds;

    constructor()
        ERC721(
            string.concat("Fhenix Permit ", version),
            string.concat("fhenix-permit-", version)
        )
        EIP712(string.concat("Fhenix Permission ", version), version)
    {
        projectIds.add(bytes32(abi.encodePacked("FHERC20")));
    }

    event PermitV2Created(address indexed user, uint256 indexed permitId);

    error Permit_NotIssuer();

    error InvalidProjectId();
    error InvalidContractAddress();
    error InvalidApprovalTarget();

    error PermitInvalid_Revoked();
    error PermitInvalid_Expired();
    error PermitInvalid_Signature();

    error PermitUnauthorized_NotHolder();
    error PermitUnauthorized_IssuerMismatch();
    error PermitUnauthorized_ContractNotSatisfied();
    error PermitUnauthorized_InvalidRouter();

    error PermissionInvalid_DeadlinePassed();


    modifier permitIssuedBySender(uint256 _permitId) {
        if (permitInfo[_permitId].issuer != msg.sender) revert Permit_NotIssuer();
        _;
    }
    modifier permitIsActive(uint256 _permitId) {
        if (permitInfo[_permitId].revoked) revert PermitInvalid_Revoked();
        if (permitInfo[_permitId].expiresAt < block.timestamp)
            revert PermitInvalid_Expired();
        _;
    }

    function createNewProject(string calldata _projectName) external {
        if (bytes(_projectName).length > 32) revert InvalidProjectId();
        bytes32 _projectId = bytes32(abi.encodePacked(_projectName));
        if (projectIds.contains(_projectId)) revert InvalidProjectId();
        projectIds.add(_projectId);
    }

    function createNewPermit(
        string calldata _name,
        bool _universal,
        uint64 _validityDur,
        address[] calldata _contracts,
        string[] calldata _projects
    ) external {
        _pid += 1;

        permitInfo[_pid] = PermitV2Info({
            id: _pid,
            issuer: msg.sender,
            name: _name,
            createdAt: uint64(block.timestamp),
            validityDur: _validityDur,
            expiresAt: uint64(block.timestamp) + _validityDur,
            revoked: false,
            universal: _universal
        });

        // Add specific contracts
            for (uint256 i = 0; i < _contracts.length; i++) {
                permitContracts[_pid].add(_contracts[i]);
            }

        // Add projects
            for (uint256 i = 0; i < _projects.length; i++) {
                permitProjectIds[_pid].add(
                    bytes32(abi.encodePacked(_projects[i]))
                );
            }

        _safeMint(msg.sender, _pid);

        emit PermitV2Created(msg.sender, _pid);
    }

    function renewPermit(
        uint256 _permitId
    ) external permitIssuedBySender(_permitId) {
        permitInfo[_permitId].expiresAt =
            uint64(block.timestamp) +
            permitInfo[_permitId].validityDur;
    }

    function revokePermit(
        uint256 _permitId
    ) external permitIssuedBySender(_permitId) {
        permitInfo[_permitId].revoked = true;
    }

    function approve(
        uint256 _permitId,
        address _contract,
        bytes32 _projectId,
        address _router
    ) external permitIssuedBySender(_permitId) {
        // Check that only one of _contract _projectId _router is non-null
        if (((_contract == address(0) ? 0 : 1) + (_projectId == bytes32(0) ? 0 : 1) + (_router == address(0) ? 0 : 1)) != 0) revert InvalidApprovalTarget();

        if (_contract != address(0)) permitContracts[_permitId].add(_contract);
        if (_projectId != bytes32(0)) permitProjectIds[_permitId].add(_projectId);
        if (_router != address(0)) permitRouters[_permitId].add(_router);
    }

    function revokeApproval(
        uint256 _permitId,
        address _contract,
        bytes32 _projectId,
        address _router
    ) external permitIssuedBySender(_permitId) {
        // Check that only one of _contract _projectId _router is non-null
        if (((_contract == address(0) ? 0 : 1) + (_projectId == bytes32(0) ? 0 : 1) + (_router == address(0) ? 0 : 1)) != 0) revert InvalidApprovalTarget();

        if (_contract != address(0)) permitContracts[_permitId].remove(_contract);
        if (_projectId != bytes32(0)) permitProjectIds[_permitId].remove(_projectId);
        if (_router != address(0)) permitRouters[_permitId].remove(_router);
    }

    function updateProjectIds(
        uint256 _permitId,
        bytes32[] calldata _projectsToAdd,
        bytes32[] calldata _projectsToRemove
    )
        external
        permitIssuedBySender(_permitId)
    {
        for (uint256 i = 0; i < _projectsToAdd.length; i++) {
            permitProjectIds[_permitId].add(
                bytes32(abi.encodePacked(_projectsToAdd[i]))
            );
        }

        for (uint256 i = 0; i < _projectsToRemove.length; i++) {
            permitProjectIds[_permitId].remove(
                bytes32(abi.encodePacked(_projectsToRemove[i]))
            );
        }
    }

    function updateContracts(
        uint256 _permitId,
        address[] calldata _contractsToAdd,
        address[] calldata _contractsToRemove
    ) external permitIssuedBySender(_permitId) {
        for (uint256 i = 0; i < _contractsToAdd.length; i++) {
            if (_contractsToAdd[i] == address(0))
                revert InvalidContractAddress();
            permitContracts[_permitId].add(_contractsToAdd[i]);
        }

        for (uint256 i = 0; i < _contractsToRemove.length; i++) {
            if (_contractsToRemove[i] == address(0))
                revert InvalidContractAddress();
            permitContracts[_permitId].remove(_contractsToRemove[i]);
        }
    }

    function validateProjectId(bytes32 _projectId) external view {
        if (!projectIds.contains(_projectId)) revert InvalidProjectId();
    }

    function _checkPermitSatisfies(
        uint256 _permitId,
        address _contract,
        bytes32 _projectId
    ) internal view returns (bool) {
        if (permitInfo[_permitId].universal) return true;
        if (permitContracts[_permitId].contains(_contract)) return true;
        if (permitProjectIds[_permitId].contains(_projectId)) return true;
        return false;
    }

    function _getContractProjectId(
        address _contract
    ) internal view returns (bytes32) {
        (bool success, bytes memory result) = _contract.staticcall(
            abi.encodeWithSelector(IFhenixPermissionedV2.PROJECT_ID.selector)
        );
        if (success && result.length > 0) return abi.decode(result, (bytes32));
        return bytes32(0);
    }

    function checkPermitSatisfies(
        uint256 _permitId,
        address _contract,
        bytes32 _projectId
    ) external view returns (bool permitted) {
        return _checkPermitSatisfies(_permitId, _contract, _projectId);
    }

    function checkPermitSatisfiesContract(
        uint256 _permitId,
        address _contract
    ) external view returns (bool permitted) {
        bytes32 _projectId = _getContractProjectId(_contract);
        return _checkPermitSatisfies(_permitId, _contract, _projectId);
    }

    function validatePermission(
        PermissionV2 calldata _permission,
        address _sender,
        address _contract,
        bytes32 _projectId
    ) external view permitIsActive(_permission.permitId) {
        bytes32 digest = _hashTypedDataV4(
            keccak256(
                abi.encode(
                    keccak256(
                        "PermissionedV2(address issuer,uint256 permitId,bytes32 sealingKey,uint64 deadline)"
                    ),
                    _permission.issuer,
                    _permission.permitId,
                    _permission.sealingKey,
                    _permission.deadline
                )
            )
        );

        bool validSignature = SignatureChecker.isValidSignatureNow(_sender, digest, _permission.signature);
        if (!validSignature) revert PermitInvalid_Signature();

        // After this point, _sender and the contents of _permission can be trusted

        uint256 permitId = _permission.permitId;

        if (ownerOf(permitId) != _sender) revert PermitUnauthorized_NotHolder();
        if (permitInfo[permitId].issuer != _permission.issuer) revert PermitUnauthorized_IssuerMismatch();
        if (!_checkPermitSatisfies(permitId, _contract, _projectId)) revert PermitUnauthorized_ContractNotSatisfied();

        if (_permission.deadline < block.timestamp) revert PermissionInvalid_DeadlinePassed();
    }

    function validatePermitRouter(uint256 _permitId, address _router) external view returns (address issuer) {
        if (!permitRouters[_permitId].contains(_router)) revert PermitUnauthorized_InvalidRouter();

        issuer = permitInfo[_permitId].issuer;

        // Shared permits can not be used within a write tx
        if (ownerOf(_permitId) != issuer) revert PermitUnauthorized_NotHolder();
    }

    function tokenURI(
        uint256 _permitId
    ) public view override returns (string memory) {
        PermitV2Info memory _permit = permitInfo[_permitId];

        string memory attributes = JsonBuilder.obj();
        attributes = attributes.kv("id", _permit.id);
        attributes = attributes.kv("issuer", _permit.issuer);
        attributes = attributes.kv("name", _permit.name);
        attributes = attributes.kv("holder", ownerOf(_permit.id));
        attributes = attributes.kv("createdAt", _permit.createdAt);
        attributes = attributes.kv("validityDur", _permit.validityDur);
        attributes = attributes.kv("expiresAt", _permit.expiresAt);
        attributes = attributes.kv("universal", _permit.universal);
        attributes = attributes.kv("revoked", _permit.revoked);
        attributes = attributes.kv(
            "contracts",
            permitContracts[_permitId].values()
        );
        attributes = attributes.kv(
            "categories",
            permitProjectIds[_permitId].values()
        );
        attributes = attributes.kv(
            "routers",
            permitRouters[_permitId].values()
        );
        attributes = attributes.end();

        return
            JsonBuilder
                .obj()
                .kv("name", symbol())
                .kv("description", name())
                .kv("attributes", attributes, false)
                .end()
                .toBase64();
    }

    function getPermitInfo(
        uint256 _permitId
    ) external view returns (PermitV2FullInfo memory) {
        PermitV2Info memory _permit = permitInfo[_permitId];
        return
            PermitV2FullInfo({
                id: _permit.id,
                issuer: _permit.issuer,
                name: _permit.name,
                holder: ownerOf(_permitId),
                createdAt: _permit.createdAt,
                validityDur: _permit.validityDur,
                expiresAt: _permit.expiresAt,
                revoked: _permit.revoked,
                universal: _permit.universal,
                contracts: permitContracts[_permitId].values(),
                projectIds: JsonBuilder.bytes32ArrToStringArr(
                    permitProjectIds[_permitId].values()
                ),
                routers: permitRouters[_permitId].values()
            });
    }
}
