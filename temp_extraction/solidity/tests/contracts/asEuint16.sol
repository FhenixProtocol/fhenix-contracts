// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../FHE.sol";
import "./utils/Utils.sol";

contract AsEuint16Test {
    using Utils for *;

    function castFromEboolToEuint16(uint256 val) public pure returns (uint16) {
    	return TFHE.decrypt(TFHE.asEuint16(TFHE.asEbool(val)));
	}

	function castFromEuint8ToEuint16(uint256 val) public pure returns (uint16) {
    	return TFHE.decrypt(TFHE.asEuint16(TFHE.asEuint8(val)));
	}

	function castFromEuint32ToEuint16(uint256 val) public pure returns (uint16) {
    	return TFHE.decrypt(TFHE.asEuint16(TFHE.asEuint32(val)));
	}

	function castFromPlaintextToEuint16(uint256 val) public pure returns (uint16) {
    	return TFHE.decrypt(TFHE.asEuint16(val));
	}

	function castFromPreEncryptedToEuint16(bytes memory val) public pure returns (uint16) {
    	return TFHE.decrypt(TFHE.asEuint16(val));
	}



}