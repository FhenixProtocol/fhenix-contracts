# Solidity API

## IFHERC20

_Interface of the ERC-20 standard as defined in the ERC._

### TransferEncrypted

```solidity
event TransferEncrypted(address from, address to)
```

_Emitted when `value` tokens are moved from one account (`from`) to
another (`to`).

Note that `value` may be zero._

### ApprovalEncrypted

```solidity
event ApprovalEncrypted(address owner, address spender)
```

_Emitted when the allowance of a `spender` for an `owner` is set by
a call to {approveEncrypted}. `value` is the new allowance._

### balanceOfEncrypted

```solidity
function balanceOfEncrypted(address account, struct Permission auth) external view returns (string)
```

_Returns the value of tokens owned by `account`, sealed and encrypted for the caller._

### transferEncrypted

```solidity
function transferEncrypted(address to, struct inEuint32 value) external returns (euint32)
```

_Moves a `value` amount of tokens from the caller's account to `to`.

Returns a boolean value indicating whether the operation succeeded.

Emits a {TransferEncrypted} event._

### transferEncrypted

```solidity
function transferEncrypted(address to, euint32 value) external returns (euint32)
```

### allowanceEncrypted

```solidity
function allowanceEncrypted(address spender, struct Permission permission) external view returns (string)
```

_Returns the remaining number of tokens that `spender` will be
allowed to spend on behalf of `owner` through {transferFrom}. This is
zero by default.

This value changes when {approve} or {transferFrom} are called._

### approveEncrypted

```solidity
function approveEncrypted(address spender, struct inEuint32 value) external returns (bool)
```

_Sets a `value` amount of tokens as the allowance of `spender` over the
caller's tokens.

Returns a boolean value indicating whether the operation succeeded.

IMPORTANT: Beware that changing an allowance with this method brings the risk
that someone may use both the old and the new allowance by unfortunate
transaction ordering. One possible solution to mitigate this race
condition is to first reduce the spender's allowance to 0 and set the
desired value afterwards:
https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

Emits an {ApprovalEncrypted} event._

### transferFromEncrypted

```solidity
function transferFromEncrypted(address from, address to, struct inEuint32 value) external returns (euint32)
```

_Moves a `value` amount of tokens from `from` to `to` using the
allowance mechanism. `value` is then deducted from the caller's
allowance.

Returns a boolean value indicating whether the operation succeeded.

Emits a {TransferEncrypted} event._

### transferFromEncrypted

```solidity
function transferFromEncrypted(address from, address to, euint32 value) external returns (euint32)
```

