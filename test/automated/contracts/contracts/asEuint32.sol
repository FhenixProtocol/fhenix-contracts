// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../FHE.sol";
import "./utils/Utils.sol";

contract AsEuint32Test {
    using Utils for *;

    function castFromEboolToEuint32(uint256 val) public pure returns (uint32) {
    	return TFHE.decrypt(TFHE.asEuint32(TFHE.asEbool(val)));
	}

	function castFromEuint8ToEuint32(uint256 val) public pure returns (uint32) {
    	return TFHE.decrypt(TFHE.asEuint32(TFHE.asEuint8(val)));
	}

	function castFromEuint16ToEuint32(uint256 val) public pure returns (uint32) {
    	return TFHE.decrypt(TFHE.asEuint32(TFHE.asEuint16(val)));
	}

	function castFromPlaintextToEuint32(uint256 val) public pure returns (uint32) {
    	return TFHE.decrypt(TFHE.asEuint32(val));
	}

	function castFromPreEncryptedToEuint32(bytes memory val) public pure returns (uint32) {
    	return TFHE.decrypt(TFHE.asEuint32(val));
	}



}