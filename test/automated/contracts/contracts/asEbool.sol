// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../FHE.sol";
import "./utils/Utils.sol";

contract AsEboolTest {
    using Utils for *;

    function castFromEuint8ToEbool(uint256 val) public pure returns (bool) {
    	return TFHE.decrypt(TFHE.asEbool(TFHE.asEuint8(val)));
	}

	function castFromEuint16ToEbool(uint256 val) public pure returns (bool) {
    	return TFHE.decrypt(TFHE.asEbool(TFHE.asEuint16(val)));
	}

	function castFromEuint32ToEbool(uint256 val) public pure returns (bool) {
    	return TFHE.decrypt(TFHE.asEbool(TFHE.asEuint32(val)));
	}

	function castFromPlaintextToEbool(uint256 val) public pure returns (bool) {
    	return TFHE.decrypt(TFHE.asEbool(val));
	}

	function castFromPreEncryptedToEbool(bytes memory val) public pure returns (bool) {
    	return TFHE.decrypt(TFHE.asEbool(val));
	}



}