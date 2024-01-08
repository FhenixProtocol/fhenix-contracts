// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.20;

import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import { EIP712 } from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

struct Signature {
	bytes32 publicKey;
	bytes sig;
}

abstract contract Permissioned is EIP712 {
    // solhint-disable-next-line func-visibility, no-empty-blocks
    constructor() EIP712("Fhenix Permission", "1.0") {}

    modifier onlySignedPublicKey(Signature memory signature) {
        bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(keccak256("Permissioned(bytes32 publicKey)"), signature.publicKey)));
        address signer = ECDSA.recover(digest, signature.sig);
        require(signer == msg.sender, "signature signer not msg.sender");
        _;
    }

    modifier onlySignedPublicKeyOwner(Signature memory signature, address owner) {
        bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(keccak256("Permissioned(bytes32 publicKey)"), signature.publicKey)));
        address signer = ECDSA.recover(digest, signature.sig);
        require(signer == owner, "signature signer not owner");
        _;
    }
}