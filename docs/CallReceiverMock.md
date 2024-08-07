# Solidity API

## CallReceiverMock

### MockFunctionCalled

```solidity
event MockFunctionCalled()
```

### MockFunctionCalledWithArgs

```solidity
event MockFunctionCalledWithArgs(uint256 a, uint256 b)
```

### mockFunction

```solidity
function mockFunction() public payable returns (string)
```

### mockFunctionEmptyReturn

```solidity
function mockFunctionEmptyReturn() public payable
```

### mockFunctionWithArgs

```solidity
function mockFunctionWithArgs(uint256 a, uint256 b) public payable returns (string)
```

### mockFunctionNonPayable

```solidity
function mockFunctionNonPayable() public returns (string)
```

### mockStaticFunction

```solidity
function mockStaticFunction() public pure returns (string)
```

### mockFunctionRevertsNoReason

```solidity
function mockFunctionRevertsNoReason() public payable
```

### mockFunctionRevertsReason

```solidity
function mockFunctionRevertsReason() public payable
```

### mockFunctionThrows

```solidity
function mockFunctionThrows() public payable
```

### mockFunctionOutOfGas

```solidity
function mockFunctionOutOfGas() public payable
```

### mockFunctionWritesStorage

```solidity
function mockFunctionWritesStorage(bytes32 slot, bytes32 value) public returns (string)
```

