# Solidity API

## PermissionedV2Counter

### owner

```solidity
address owner
```

### constructor

```solidity
constructor() public
```

### add

```solidity
function add(struct inEuint32 encryptedValue) public
```

### getCounter

```solidity
function getCounter(address user) public view returns (uint256)
```

### getCounterPermit

```solidity
function getCounterPermit(struct PermissionV2 permission) public view returns (uint256)
```

### getCounterPermitSealed

```solidity
function getCounterPermitSealed(struct PermissionV2 permission) public view returns (string)
```

