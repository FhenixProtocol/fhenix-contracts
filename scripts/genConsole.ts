import { writeFileSync } from "fs";

// Define the parameter types to iterate over
const types = ["int256", "uint256", "string memory", "bool", "address"];

// Function to return the conversion function based on the type
const toStringFunc = (type: string): string => {
  switch (type) {
    case "int256":
      return "_intToString(";
    case "uint256":
      return "_uintToString(";
    case "string memory":
      return "";
    case "bool":
      return "_boolToString(";
    case "address":
      return "_addressToString(";
    default:
      throw new Error("Unknown type");
  }
};

const toStringFuncEnding = (type: string): string => {
  switch (type) {
    case "int256":
      return ")";
    case "uint256":
      return ")";
    case "string memory":
      return "";
    case "bool":
      return ")";
    case "address":
      return ")";
    default:
      throw new Error("Unknown type");
  }
};

// Function to generate log functions for a given number of parameters (n)
const generateLogFunctions = (n: number): string => {
  let output = "";

  // Generate all combinations of parameter types for n parameters
  const combinations = generateCombinations(types, n);
  combinations.forEach((combo) => {
    const params = combo.map((type, i) => `${type} p${i}`).join(", ");
    const conversion = combo
      .map((type, i) => `${toStringFunc(type)}p${i}${toStringFuncEnding(type)}`)
      .join(", ");
    const methodName = `log(${params})`;

    // Generating external pure function strings
    output +=
      `\tfunction ${methodName} external pure {\n` +
      `    \t_logImpl${n}Params(${conversion});\n` +
      `\t}\n\n`;
  });

  return output;
};

// Helper function to generate combinations recursively
function generateCombinations(types: string[], n: number): string[][] {
  if (n === 1) return types.map((type) => [type]);

  const combos: string[][] = [];
  const smallerCombos = generateCombinations(types, n - 1);

  types.forEach((type) => {
    smallerCombos.forEach((combo) => {
      combos.push([type].concat(combo));
    });
  });

  return combos;
}

let output = `// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

import {FheOps, Precompiles} from "./FheOS.sol";
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

    function logBytes(bytes memory p0) external pure {
        _logImpl(string(p0));
    }

    function log(int256 p0) external pure {
        _logInt(p0);
    }

    function log(uint256 p0) external pure {
        _logUint(p0);
    }

    function log(string memory p0) external pure {
       _logImpl(p0);
    }

    function log(bool p0) external pure {
        _logBool(p0);
    }

    function log(address p0) external pure {
        _logAddress(p0);
    }
`;
// Generate and print the log functions for 2 to 4 parameters
for (let i = 2; i <= 3; i++) {
  output += generateLogFunctions(i);
}
output += "}";

writeFileSync("./contracts/Console.sol", output);
