// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../FHE.sol";
import "./utils/Utils.sol";

contract AsEuint8Test {
    using Utils for *;

    function castFromEboolToEuint8(uint256 val) public pure returns (uint8) {
    	return TFHE.decrypt(TFHE.asEuint8(TFHE.asEbool(val)));
	}

	function castFromEuint16ToEuint8(uint256 val) public pure returns (uint8) {
    	return TFHE.decrypt(TFHE.asEuint8(TFHE.asEuint16(val)));
	}

	function castFromEuint32ToEuint8(uint256 val) public pure returns (uint8) {
    	return TFHE.decrypt(TFHE.asEuint8(TFHE.asEuint32(val)));
	}

	function castFromPlaintextToEuint8(uint256 val) public pure returns (uint8) {
    	return TFHE.decrypt(TFHE.asEuint8(val));
	}

	function castFromPreEncryptedToEuint8(bytes memory val) public pure returns (uint8) {
    	return TFHE.decrypt(TFHE.asEuint8(val));
	}



}