# Fhenix Contracts [![Github Actions][gha-badge]][gha] [![License: MIT][license-badge]][license]

[gha]: https://github.com/fhenixprotocol/fhenix-contracts/actions
[gha-badge]: https://github.com/fhenixprotocol/fhenix-contracts/actions/workflows/ci.yml/badge.svg
[license]: https://opensource.org/licenses/MIT
[license-badge]: https://img.shields.io/badge/License-MIT-blue.svg

Solidity contracts for working with FHE smart contract on Fhenix.

Need help getting started? Check out the [fhenix documentation](https://docs.fhenix.io)!

These contracts are still under heavy constructions and will be changing frequently. Consider binding your contracts to a specific version, and keep an eye on the [changelog](https://github.com/FhenixProtocol/fhenix-contracts/CHANGELOG.md)

## Install

```
npm install @fhenixprotocol/contracts
```

## Usage

Import `FHE.sol` or any of the helper contracts

```
import "@fhenixprotocol/contracts/FHE.sol";
```

## Example

```
pragma solidity ^0.8.20;
import {FHE, euint8, inEuint8} from "@fhenixprotocol/contracts/FHE.sol";
contract Test {
    
    euint8 _output2;
    uint8 _output;
    function setOutput(inEuint8 calldata _encryptedNumber) public  {
        uint8 action = FHE.decrypt(FHE.asEuint8(_encryptedNumber));
        _output = action;
    }
    function setOutputBytes(bytes calldata _encryptedNumber) public  {
        uint8 action = FHE.decrypt(FHE.asEuint8(_encryptedNumber));
        _output = action;
    }
    function getOutput() public view returns (uint8) {
        return _output;
    }
     function getOutput2() public view returns (uint8) {
        return FHE.decrypt(_output2);
    }
    function setOutput2(bytes calldata e) public {
        _output2 = FHE.asEuint8(e);
    }
    function getOutputEncrypted(bytes32 publicKey) public view  returns (bytes memory) {
        return FHE.sealoutput(FHE.asEuint8(_output), publicKey);
    }
}
```

## License

This project is licensed under MIT.
