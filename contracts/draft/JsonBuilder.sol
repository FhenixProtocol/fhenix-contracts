// solhint-disable quotes
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

/**
 * @dev Library to help build structured JSON strings.
 * Optionally the JSON can be converted into base64 as the final step.
 * - Architect
 *
 * Usage:
 *
 * JsonBuilder
 *   .obj()
 *   .kv("name", symbol())
 *   .kv("description", name())
 *   .kv("attributes", attributes, false)
 *   .end()
 *   .toBase64();
 *
 */
library JsonBuilder {
    function obj() internal pure returns (string memory) {
        return "";
    }

    function end(string memory o) internal pure returns (string memory) {
        return inBraces(o);
    }

    function addressToString(
        address _address
    ) internal pure returns (string memory) {
        bytes32 _bytes = bytes32(uint256(uint160(_address)));
        bytes memory _hex = "0123456789abcdef";
        bytes memory _string = new bytes(42);
        _string[0] = "0";
        _string[1] = "x";
        for (uint256 i = 0; i < 20; i++) {
            _string[2 + i * 2] = _hex[uint8(_bytes[i + 12] >> 4)];
            _string[3 + i * 2] = _hex[uint8(_bytes[i + 12] & 0x0f)];
        }
        return string(_string);
    }

    function inQuotes(string memory val) internal pure returns (string memory) {
        return string.concat('"', val, '"');
    }
    function inBraces(string memory val) internal pure returns (string memory) {
        return string.concat("{", val, "}");
    }
    function inBrackets(
        string memory val
    ) internal pure returns (string memory) {
        return string.concat("[", val, "]");
    }
    function toCommaSeparatedList(
        string[] memory vals
    ) internal pure returns (string memory result) {
        result = "";
        for (uint256 i = 0; i < vals.length; i++) {
            result = string.concat(
                result,
                vals[i],
                i < vals.length - 1 ? "," : ""
            );
        }
    }

    function bytes32ToString(
        bytes32 _bytes32
    ) internal pure returns (string memory) {
        uint8 i = 0;
        while (i < 32 && _bytes32[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 32 && _bytes32[i] != 0; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return string(bytesArray);
    }

    function bytes32ArrToStringArr(
        bytes32[] memory values
    ) internal pure returns (string[] memory bytes32Strings) {
        bytes32Strings = new string[](values.length);
        for (uint256 i = 0; i < values.length; i++) {
            bytes32Strings[i] = bytes32ToString(values[i]);
        }
    }

    function kv(
        string memory o,
        string memory key,
        string memory value
    ) internal pure returns (string memory) {
        return kv(o, key, value, true);
    }
    function kv(
        string memory o,
        string memory key,
        address value
    ) internal pure returns (string memory) {
        return kv(o, key, addressToString(value), true);
    }
    function kv(
        string memory o,
        string memory key,
        bool value
    ) internal pure returns (string memory) {
        return kv(o, key, value ? "true" : "false", true);
    }
    function kv(
        string memory o,
        string memory key,
        uint256 value
    ) internal pure returns (string memory) {
        return kv(o, key, Strings.toString(value), true);
    }

    function kv(
        string memory o,
        string memory key,
        string[] memory values
    ) internal pure returns (string memory) {
        return kv(o, key, inBrackets(toCommaSeparatedList(values)), false);
    }
    function kv(
        string memory o,
        string memory key,
        bytes32[] memory values
    ) internal pure returns (string memory) {
        string[] memory bytes32Strings = new string[](values.length);
        for (uint256 i = 0; i < values.length; i++) {
            bytes32Strings[i] = inQuotes(bytes32ToString(values[i]));
        }
        return
            kv(o, key, inBrackets(toCommaSeparatedList(bytes32Strings)), false);
    }
    function kv(
        string memory o,
        string memory key,
        address[] memory values
    ) internal pure returns (string memory) {
        string[] memory addStrings = new string[](values.length);
        for (uint256 i = 0; i < values.length; i++) {
            addStrings[i] = inQuotes(addressToString(values[i]));
        }
        return kv(o, key, inBrackets(toCommaSeparatedList(addStrings)), false);
    }
    function kv(
        string memory o,
        string memory key,
        uint256[] memory values
    ) internal pure returns (string memory) {
        string[] memory uintStrings = new string[](values.length);
        for (uint256 i = 0; i < values.length; i++) {
            uintStrings[i] = inQuotes(Strings.toString(values[i]));
        }
        return kv(o, key, inBrackets(toCommaSeparatedList(uintStrings)), false);
    }

    function kv(
        string memory o,
        string memory key,
        string memory value,
        bool quoteValue
    ) internal pure returns (string memory) {
        return
            string.concat(
                o,
                bytes(o).length > 0 ? "," : "",
                '"',
                key,
                '":',
                quoteValue ? '"' : "",
                value,
                quoteValue ? '"' : ""
            );
    }

    function toBase64(
        string memory value
    ) internal pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(bytes(abi.encodePacked(value)))
                )
            );
    }

    function toBase64(
        string[] memory values
    ) internal pure returns (string memory) {
        return toBase64(inBraces(toCommaSeparatedList(values)));
    }
}
