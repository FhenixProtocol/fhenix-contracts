// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

import {FheOps, Precompiles} from "../../FheOS.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

library Console {
    function _logImpl(string memory payload) internal pure {
        FheOps(Precompiles.Fheos).log(payload);
    }

    function _logImpl2Params(string memory p0, string memory p1) internal pure {
        string memory payload = string(abi.encodePacked(string("p0: "), p0, string(" p1: "), p1));
        _logImpl(payload);
    }

    function _logImpl3Params(string memory p0, string memory p1, string memory p2) internal pure {
        string memory payload = string(abi.encodePacked(string("p0: "), p0, string(" p1: "), 
        p1, string(" p2: "), p2));
        _logImpl(payload);
    }

    function _intToString(int _value) internal pure returns (string memory) {
        return Strings.toStringSigned(_value);
    }

    function _uintToString(uint _value) internal pure returns (string memory) {
        return Strings.toString(_value);
    }

    function _addressToString(address _addr) internal pure returns (string memory) {
        bytes memory alphabet = "0123456789abcdef";
        bytes20 value = bytes20(_addr);
        bytes memory buffer = new bytes(42); // 2 characters for '0x' and 40 characters for the address
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 0; i < 20; i++) {
            buffer[2+i*2] = alphabet[uint8(value[i] >> 4)];
            buffer[3+i*2] = alphabet[uint8(value[i] & 0x0f)];
        }
        return string(buffer);
    }

    function _boolToString(bool val) internal pure returns (string memory) {
        return val ? "true" : "false";
    }

    function _logInt(int256 p0) internal pure {
        _logImpl(_intToString(p0));
    }

    function _logUint(uint256 p0) internal pure {
        _logImpl(_uintToString(p0));
    }

    function _logBool(bool p0) internal pure {
        _logImpl(_boolToString(p0));
    }

    function _logAddress(address p0) internal pure {
        _logImpl(_addressToString(p0));
    }

    function logBytes(bytes memory p0) internal pure {
        _logImpl(string(p0));
    }

    function log(int256 p0) internal pure {
        _logInt(p0);
    }

    function log(uint256 p0) internal pure {
        _logUint(p0);
    }

    function log(string memory p0) internal pure {
       _logImpl(p0);
    }

    function log(bool p0) internal pure {
        _logBool(p0);
    }

    function log(address p0) internal pure {
        _logAddress(p0);
    }
	function log(int256 p0, int256 p1) internal pure {
    	_logImpl2Params(_intToString(p0), _intToString(p1));
	}

	function log(int256 p0, uint256 p1) internal pure {
    	_logImpl2Params(_intToString(p0), _uintToString(p1));
	}

	function log(int256 p0, string memory p1) internal pure {
    	_logImpl2Params(_intToString(p0), p1);
	}

	function log(int256 p0, bool p1) internal pure {
    	_logImpl2Params(_intToString(p0), _boolToString(p1));
	}

	function log(int256 p0, address p1) internal pure {
    	_logImpl2Params(_intToString(p0), _addressToString(p1));
	}

	function log(uint256 p0, int256 p1) internal pure {
    	_logImpl2Params(_uintToString(p0), _intToString(p1));
	}

	function log(uint256 p0, uint256 p1) internal pure {
    	_logImpl2Params(_uintToString(p0), _uintToString(p1));
	}

	function log(uint256 p0, string memory p1) internal pure {
    	_logImpl2Params(_uintToString(p0), p1);
	}

	function log(uint256 p0, bool p1) internal pure {
    	_logImpl2Params(_uintToString(p0), _boolToString(p1));
	}

	function log(uint256 p0, address p1) internal pure {
    	_logImpl2Params(_uintToString(p0), _addressToString(p1));
	}

	function log(string memory p0, int256 p1) internal pure {
    	_logImpl2Params(p0, _intToString(p1));
	}

	function log(string memory p0, uint256 p1) internal pure {
    	_logImpl2Params(p0, _uintToString(p1));
	}

	function log(string memory p0, string memory p1) internal pure {
    	_logImpl2Params(p0, p1);
	}

	function log(string memory p0, bool p1) internal pure {
    	_logImpl2Params(p0, _boolToString(p1));
	}

	function log(string memory p0, address p1) internal pure {
    	_logImpl2Params(p0, _addressToString(p1));
	}

	function log(bool p0, int256 p1) internal pure {
    	_logImpl2Params(_boolToString(p0), _intToString(p1));
	}

	function log(bool p0, uint256 p1) internal pure {
    	_logImpl2Params(_boolToString(p0), _uintToString(p1));
	}

	function log(bool p0, string memory p1) internal pure {
    	_logImpl2Params(_boolToString(p0), p1);
	}

	function log(bool p0, bool p1) internal pure {
    	_logImpl2Params(_boolToString(p0), _boolToString(p1));
	}

	function log(bool p0, address p1) internal pure {
    	_logImpl2Params(_boolToString(p0), _addressToString(p1));
	}

	function log(address p0, int256 p1) internal pure {
    	_logImpl2Params(_addressToString(p0), _intToString(p1));
	}

	function log(address p0, uint256 p1) internal pure {
    	_logImpl2Params(_addressToString(p0), _uintToString(p1));
	}

	function log(address p0, string memory p1) internal pure {
    	_logImpl2Params(_addressToString(p0), p1);
	}

	function log(address p0, bool p1) internal pure {
    	_logImpl2Params(_addressToString(p0), _boolToString(p1));
	}

	function log(address p0, address p1) internal pure {
    	_logImpl2Params(_addressToString(p0), _addressToString(p1));
	}

	function log(int256 p0, int256 p1, int256 p2) internal pure {
    	_logImpl3Params(_intToString(p0), _intToString(p1), _intToString(p2));
	}

	function log(int256 p0, int256 p1, uint256 p2) internal pure {
    	_logImpl3Params(_intToString(p0), _intToString(p1), _uintToString(p2));
	}

	function log(int256 p0, int256 p1, string memory p2) internal pure {
    	_logImpl3Params(_intToString(p0), _intToString(p1), p2);
	}

	function log(int256 p0, int256 p1, bool p2) internal pure {
    	_logImpl3Params(_intToString(p0), _intToString(p1), _boolToString(p2));
	}

	function log(int256 p0, int256 p1, address p2) internal pure {
    	_logImpl3Params(_intToString(p0), _intToString(p1), _addressToString(p2));
	}

	function log(int256 p0, uint256 p1, int256 p2) internal pure {
    	_logImpl3Params(_intToString(p0), _uintToString(p1), _intToString(p2));
	}

	function log(int256 p0, uint256 p1, uint256 p2) internal pure {
    	_logImpl3Params(_intToString(p0), _uintToString(p1), _uintToString(p2));
	}

	function log(int256 p0, uint256 p1, string memory p2) internal pure {
    	_logImpl3Params(_intToString(p0), _uintToString(p1), p2);
	}

	function log(int256 p0, uint256 p1, bool p2) internal pure {
    	_logImpl3Params(_intToString(p0), _uintToString(p1), _boolToString(p2));
	}

	function log(int256 p0, uint256 p1, address p2) internal pure {
    	_logImpl3Params(_intToString(p0), _uintToString(p1), _addressToString(p2));
	}

	function log(int256 p0, string memory p1, int256 p2) internal pure {
    	_logImpl3Params(_intToString(p0), p1, _intToString(p2));
	}

	function log(int256 p0, string memory p1, uint256 p2) internal pure {
    	_logImpl3Params(_intToString(p0), p1, _uintToString(p2));
	}

	function log(int256 p0, string memory p1, string memory p2) internal pure {
    	_logImpl3Params(_intToString(p0), p1, p2);
	}

	function log(int256 p0, string memory p1, bool p2) internal pure {
    	_logImpl3Params(_intToString(p0), p1, _boolToString(p2));
	}

	function log(int256 p0, string memory p1, address p2) internal pure {
    	_logImpl3Params(_intToString(p0), p1, _addressToString(p2));
	}

	function log(int256 p0, bool p1, int256 p2) internal pure {
    	_logImpl3Params(_intToString(p0), _boolToString(p1), _intToString(p2));
	}

	function log(int256 p0, bool p1, uint256 p2) internal pure {
    	_logImpl3Params(_intToString(p0), _boolToString(p1), _uintToString(p2));
	}

	function log(int256 p0, bool p1, string memory p2) internal pure {
    	_logImpl3Params(_intToString(p0), _boolToString(p1), p2);
	}

	function log(int256 p0, bool p1, bool p2) internal pure {
    	_logImpl3Params(_intToString(p0), _boolToString(p1), _boolToString(p2));
	}

	function log(int256 p0, bool p1, address p2) internal pure {
    	_logImpl3Params(_intToString(p0), _boolToString(p1), _addressToString(p2));
	}

	function log(int256 p0, address p1, int256 p2) internal pure {
    	_logImpl3Params(_intToString(p0), _addressToString(p1), _intToString(p2));
	}

	function log(int256 p0, address p1, uint256 p2) internal pure {
    	_logImpl3Params(_intToString(p0), _addressToString(p1), _uintToString(p2));
	}

	function log(int256 p0, address p1, string memory p2) internal pure {
    	_logImpl3Params(_intToString(p0), _addressToString(p1), p2);
	}

	function log(int256 p0, address p1, bool p2) internal pure {
    	_logImpl3Params(_intToString(p0), _addressToString(p1), _boolToString(p2));
	}

	function log(int256 p0, address p1, address p2) internal pure {
    	_logImpl3Params(_intToString(p0), _addressToString(p1), _addressToString(p2));
	}

	function log(uint256 p0, int256 p1, int256 p2) internal pure {
    	_logImpl3Params(_uintToString(p0), _intToString(p1), _intToString(p2));
	}

	function log(uint256 p0, int256 p1, uint256 p2) internal pure {
    	_logImpl3Params(_uintToString(p0), _intToString(p1), _uintToString(p2));
	}

	function log(uint256 p0, int256 p1, string memory p2) internal pure {
    	_logImpl3Params(_uintToString(p0), _intToString(p1), p2);
	}

	function log(uint256 p0, int256 p1, bool p2) internal pure {
    	_logImpl3Params(_uintToString(p0), _intToString(p1), _boolToString(p2));
	}

	function log(uint256 p0, int256 p1, address p2) internal pure {
    	_logImpl3Params(_uintToString(p0), _intToString(p1), _addressToString(p2));
	}

	function log(uint256 p0, uint256 p1, int256 p2) internal pure {
    	_logImpl3Params(_uintToString(p0), _uintToString(p1), _intToString(p2));
	}

	function log(uint256 p0, uint256 p1, uint256 p2) internal pure {
    	_logImpl3Params(_uintToString(p0), _uintToString(p1), _uintToString(p2));
	}

	function log(uint256 p0, uint256 p1, string memory p2) internal pure {
    	_logImpl3Params(_uintToString(p0), _uintToString(p1), p2);
	}

	function log(uint256 p0, uint256 p1, bool p2) internal pure {
    	_logImpl3Params(_uintToString(p0), _uintToString(p1), _boolToString(p2));
	}

	function log(uint256 p0, uint256 p1, address p2) internal pure {
    	_logImpl3Params(_uintToString(p0), _uintToString(p1), _addressToString(p2));
	}

	function log(uint256 p0, string memory p1, int256 p2) internal pure {
    	_logImpl3Params(_uintToString(p0), p1, _intToString(p2));
	}

	function log(uint256 p0, string memory p1, uint256 p2) internal pure {
    	_logImpl3Params(_uintToString(p0), p1, _uintToString(p2));
	}

	function log(uint256 p0, string memory p1, string memory p2) internal pure {
    	_logImpl3Params(_uintToString(p0), p1, p2);
	}

	function log(uint256 p0, string memory p1, bool p2) internal pure {
    	_logImpl3Params(_uintToString(p0), p1, _boolToString(p2));
	}

	function log(uint256 p0, string memory p1, address p2) internal pure {
    	_logImpl3Params(_uintToString(p0), p1, _addressToString(p2));
	}

	function log(uint256 p0, bool p1, int256 p2) internal pure {
    	_logImpl3Params(_uintToString(p0), _boolToString(p1), _intToString(p2));
	}

	function log(uint256 p0, bool p1, uint256 p2) internal pure {
    	_logImpl3Params(_uintToString(p0), _boolToString(p1), _uintToString(p2));
	}

	function log(uint256 p0, bool p1, string memory p2) internal pure {
    	_logImpl3Params(_uintToString(p0), _boolToString(p1), p2);
	}

	function log(uint256 p0, bool p1, bool p2) internal pure {
    	_logImpl3Params(_uintToString(p0), _boolToString(p1), _boolToString(p2));
	}

	function log(uint256 p0, bool p1, address p2) internal pure {
    	_logImpl3Params(_uintToString(p0), _boolToString(p1), _addressToString(p2));
	}

	function log(uint256 p0, address p1, int256 p2) internal pure {
    	_logImpl3Params(_uintToString(p0), _addressToString(p1), _intToString(p2));
	}

	function log(uint256 p0, address p1, uint256 p2) internal pure {
    	_logImpl3Params(_uintToString(p0), _addressToString(p1), _uintToString(p2));
	}

	function log(uint256 p0, address p1, string memory p2) internal pure {
    	_logImpl3Params(_uintToString(p0), _addressToString(p1), p2);
	}

	function log(uint256 p0, address p1, bool p2) internal pure {
    	_logImpl3Params(_uintToString(p0), _addressToString(p1), _boolToString(p2));
	}

	function log(uint256 p0, address p1, address p2) internal pure {
    	_logImpl3Params(_uintToString(p0), _addressToString(p1), _addressToString(p2));
	}

	function log(string memory p0, int256 p1, int256 p2) internal pure {
    	_logImpl3Params(p0, _intToString(p1), _intToString(p2));
	}

	function log(string memory p0, int256 p1, uint256 p2) internal pure {
    	_logImpl3Params(p0, _intToString(p1), _uintToString(p2));
	}

	function log(string memory p0, int256 p1, string memory p2) internal pure {
    	_logImpl3Params(p0, _intToString(p1), p2);
	}

	function log(string memory p0, int256 p1, bool p2) internal pure {
    	_logImpl3Params(p0, _intToString(p1), _boolToString(p2));
	}

	function log(string memory p0, int256 p1, address p2) internal pure {
    	_logImpl3Params(p0, _intToString(p1), _addressToString(p2));
	}

	function log(string memory p0, uint256 p1, int256 p2) internal pure {
    	_logImpl3Params(p0, _uintToString(p1), _intToString(p2));
	}

	function log(string memory p0, uint256 p1, uint256 p2) internal pure {
    	_logImpl3Params(p0, _uintToString(p1), _uintToString(p2));
	}

	function log(string memory p0, uint256 p1, string memory p2) internal pure {
    	_logImpl3Params(p0, _uintToString(p1), p2);
	}

	function log(string memory p0, uint256 p1, bool p2) internal pure {
    	_logImpl3Params(p0, _uintToString(p1), _boolToString(p2));
	}

	function log(string memory p0, uint256 p1, address p2) internal pure {
    	_logImpl3Params(p0, _uintToString(p1), _addressToString(p2));
	}

	function log(string memory p0, string memory p1, int256 p2) internal pure {
    	_logImpl3Params(p0, p1, _intToString(p2));
	}

	function log(string memory p0, string memory p1, uint256 p2) internal pure {
    	_logImpl3Params(p0, p1, _uintToString(p2));
	}

	function log(string memory p0, string memory p1, string memory p2) internal pure {
    	_logImpl3Params(p0, p1, p2);
	}

	function log(string memory p0, string memory p1, bool p2) internal pure {
    	_logImpl3Params(p0, p1, _boolToString(p2));
	}

	function log(string memory p0, string memory p1, address p2) internal pure {
    	_logImpl3Params(p0, p1, _addressToString(p2));
	}

	function log(string memory p0, bool p1, int256 p2) internal pure {
    	_logImpl3Params(p0, _boolToString(p1), _intToString(p2));
	}

	function log(string memory p0, bool p1, uint256 p2) internal pure {
    	_logImpl3Params(p0, _boolToString(p1), _uintToString(p2));
	}

	function log(string memory p0, bool p1, string memory p2) internal pure {
    	_logImpl3Params(p0, _boolToString(p1), p2);
	}

	function log(string memory p0, bool p1, bool p2) internal pure {
    	_logImpl3Params(p0, _boolToString(p1), _boolToString(p2));
	}

	function log(string memory p0, bool p1, address p2) internal pure {
    	_logImpl3Params(p0, _boolToString(p1), _addressToString(p2));
	}

	function log(string memory p0, address p1, int256 p2) internal pure {
    	_logImpl3Params(p0, _addressToString(p1), _intToString(p2));
	}

	function log(string memory p0, address p1, uint256 p2) internal pure {
    	_logImpl3Params(p0, _addressToString(p1), _uintToString(p2));
	}

	function log(string memory p0, address p1, string memory p2) internal pure {
    	_logImpl3Params(p0, _addressToString(p1), p2);
	}

	function log(string memory p0, address p1, bool p2) internal pure {
    	_logImpl3Params(p0, _addressToString(p1), _boolToString(p2));
	}

	function log(string memory p0, address p1, address p2) internal pure {
    	_logImpl3Params(p0, _addressToString(p1), _addressToString(p2));
	}

	function log(bool p0, int256 p1, int256 p2) internal pure {
    	_logImpl3Params(_boolToString(p0), _intToString(p1), _intToString(p2));
	}

	function log(bool p0, int256 p1, uint256 p2) internal pure {
    	_logImpl3Params(_boolToString(p0), _intToString(p1), _uintToString(p2));
	}

	function log(bool p0, int256 p1, string memory p2) internal pure {
    	_logImpl3Params(_boolToString(p0), _intToString(p1), p2);
	}

	function log(bool p0, int256 p1, bool p2) internal pure {
    	_logImpl3Params(_boolToString(p0), _intToString(p1), _boolToString(p2));
	}

	function log(bool p0, int256 p1, address p2) internal pure {
    	_logImpl3Params(_boolToString(p0), _intToString(p1), _addressToString(p2));
	}

	function log(bool p0, uint256 p1, int256 p2) internal pure {
    	_logImpl3Params(_boolToString(p0), _uintToString(p1), _intToString(p2));
	}

	function log(bool p0, uint256 p1, uint256 p2) internal pure {
    	_logImpl3Params(_boolToString(p0), _uintToString(p1), _uintToString(p2));
	}

	function log(bool p0, uint256 p1, string memory p2) internal pure {
    	_logImpl3Params(_boolToString(p0), _uintToString(p1), p2);
	}

	function log(bool p0, uint256 p1, bool p2) internal pure {
    	_logImpl3Params(_boolToString(p0), _uintToString(p1), _boolToString(p2));
	}

	function log(bool p0, uint256 p1, address p2) internal pure {
    	_logImpl3Params(_boolToString(p0), _uintToString(p1), _addressToString(p2));
	}

	function log(bool p0, string memory p1, int256 p2) internal pure {
    	_logImpl3Params(_boolToString(p0), p1, _intToString(p2));
	}

	function log(bool p0, string memory p1, uint256 p2) internal pure {
    	_logImpl3Params(_boolToString(p0), p1, _uintToString(p2));
	}

	function log(bool p0, string memory p1, string memory p2) internal pure {
    	_logImpl3Params(_boolToString(p0), p1, p2);
	}

	function log(bool p0, string memory p1, bool p2) internal pure {
    	_logImpl3Params(_boolToString(p0), p1, _boolToString(p2));
	}

	function log(bool p0, string memory p1, address p2) internal pure {
    	_logImpl3Params(_boolToString(p0), p1, _addressToString(p2));
	}

	function log(bool p0, bool p1, int256 p2) internal pure {
    	_logImpl3Params(_boolToString(p0), _boolToString(p1), _intToString(p2));
	}

	function log(bool p0, bool p1, uint256 p2) internal pure {
    	_logImpl3Params(_boolToString(p0), _boolToString(p1), _uintToString(p2));
	}

	function log(bool p0, bool p1, string memory p2) internal pure {
    	_logImpl3Params(_boolToString(p0), _boolToString(p1), p2);
	}

	function log(bool p0, bool p1, bool p2) internal pure {
    	_logImpl3Params(_boolToString(p0), _boolToString(p1), _boolToString(p2));
	}

	function log(bool p0, bool p1, address p2) internal pure {
    	_logImpl3Params(_boolToString(p0), _boolToString(p1), _addressToString(p2));
	}

	function log(bool p0, address p1, int256 p2) internal pure {
    	_logImpl3Params(_boolToString(p0), _addressToString(p1), _intToString(p2));
	}

	function log(bool p0, address p1, uint256 p2) internal pure {
    	_logImpl3Params(_boolToString(p0), _addressToString(p1), _uintToString(p2));
	}

	function log(bool p0, address p1, string memory p2) internal pure {
    	_logImpl3Params(_boolToString(p0), _addressToString(p1), p2);
	}

	function log(bool p0, address p1, bool p2) internal pure {
    	_logImpl3Params(_boolToString(p0), _addressToString(p1), _boolToString(p2));
	}

	function log(bool p0, address p1, address p2) internal pure {
    	_logImpl3Params(_boolToString(p0), _addressToString(p1), _addressToString(p2));
	}

	function log(address p0, int256 p1, int256 p2) internal pure {
    	_logImpl3Params(_addressToString(p0), _intToString(p1), _intToString(p2));
	}

	function log(address p0, int256 p1, uint256 p2) internal pure {
    	_logImpl3Params(_addressToString(p0), _intToString(p1), _uintToString(p2));
	}

	function log(address p0, int256 p1, string memory p2) internal pure {
    	_logImpl3Params(_addressToString(p0), _intToString(p1), p2);
	}

	function log(address p0, int256 p1, bool p2) internal pure {
    	_logImpl3Params(_addressToString(p0), _intToString(p1), _boolToString(p2));
	}

	function log(address p0, int256 p1, address p2) internal pure {
    	_logImpl3Params(_addressToString(p0), _intToString(p1), _addressToString(p2));
	}

	function log(address p0, uint256 p1, int256 p2) internal pure {
    	_logImpl3Params(_addressToString(p0), _uintToString(p1), _intToString(p2));
	}

	function log(address p0, uint256 p1, uint256 p2) internal pure {
    	_logImpl3Params(_addressToString(p0), _uintToString(p1), _uintToString(p2));
	}

	function log(address p0, uint256 p1, string memory p2) internal pure {
    	_logImpl3Params(_addressToString(p0), _uintToString(p1), p2);
	}

	function log(address p0, uint256 p1, bool p2) internal pure {
    	_logImpl3Params(_addressToString(p0), _uintToString(p1), _boolToString(p2));
	}

	function log(address p0, uint256 p1, address p2) internal pure {
    	_logImpl3Params(_addressToString(p0), _uintToString(p1), _addressToString(p2));
	}

	function log(address p0, string memory p1, int256 p2) internal pure {
    	_logImpl3Params(_addressToString(p0), p1, _intToString(p2));
	}

	function log(address p0, string memory p1, uint256 p2) internal pure {
    	_logImpl3Params(_addressToString(p0), p1, _uintToString(p2));
	}

	function log(address p0, string memory p1, string memory p2) internal pure {
    	_logImpl3Params(_addressToString(p0), p1, p2);
	}

	function log(address p0, string memory p1, bool p2) internal pure {
    	_logImpl3Params(_addressToString(p0), p1, _boolToString(p2));
	}

	function log(address p0, string memory p1, address p2) internal pure {
    	_logImpl3Params(_addressToString(p0), p1, _addressToString(p2));
	}

	function log(address p0, bool p1, int256 p2) internal pure {
    	_logImpl3Params(_addressToString(p0), _boolToString(p1), _intToString(p2));
	}

	function log(address p0, bool p1, uint256 p2) internal pure {
    	_logImpl3Params(_addressToString(p0), _boolToString(p1), _uintToString(p2));
	}

	function log(address p0, bool p1, string memory p2) internal pure {
    	_logImpl3Params(_addressToString(p0), _boolToString(p1), p2);
	}

	function log(address p0, bool p1, bool p2) internal pure {
    	_logImpl3Params(_addressToString(p0), _boolToString(p1), _boolToString(p2));
	}

	function log(address p0, bool p1, address p2) internal pure {
    	_logImpl3Params(_addressToString(p0), _boolToString(p1), _addressToString(p2));
	}

	function log(address p0, address p1, int256 p2) internal pure {
    	_logImpl3Params(_addressToString(p0), _addressToString(p1), _intToString(p2));
	}

	function log(address p0, address p1, uint256 p2) internal pure {
    	_logImpl3Params(_addressToString(p0), _addressToString(p1), _uintToString(p2));
	}

	function log(address p0, address p1, string memory p2) internal pure {
    	_logImpl3Params(_addressToString(p0), _addressToString(p1), p2);
	}

	function log(address p0, address p1, bool p2) internal pure {
    	_logImpl3Params(_addressToString(p0), _addressToString(p1), _boolToString(p2));
	}

	function log(address p0, address p1, address p2) internal pure {
    	_logImpl3Params(_addressToString(p0), _addressToString(p1), _addressToString(p2));
	}

}
