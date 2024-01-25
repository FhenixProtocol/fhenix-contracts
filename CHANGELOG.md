## v0.1.0-beta.3

* The contract `Permission.sol` is now named `Permissioned.sol`
* The function `onlySignedPublicKey` is now named `onlySender`
* The function `onlySignedPublicKeyOwner` is now named `onlyPermitted`
* Fixed bugs when casting between types
* Added support for .seal() function for euint types
