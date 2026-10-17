// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

import "forge-std/Test.sol";
import "../contracts/utils/debug/MockFheOps.sol";

/// @title MockFheOps Security Findings - Forge Tests
/// @notice Reproduces C-1, C-2, C-3 from the Fhenix security report and
///         verifies the fixes applied to MockFheOps.sol.
contract MockFheOpsFindingsTest is Test {
    MockFheOps mock;

    uint8 constant UINT8_TYPE   = 0;
    uint8 constant UINT32_TYPE  = 2;
    uint8 constant UINT256_TYPE = 5;

    function setUp() public {
        mock = new MockFheOps();
    }

    // -----------------------------------------------------------------------
    // [C-1] random() - seed was ignored, only block.timestamp used
    // -----------------------------------------------------------------------

    /// @notice Before fix: different seeds produced identical output.
    ///         After fix: different seeds with all else equal produce different output.
    function test_C1_Fix_SeedAffectsOutput() public {
        vm.warp(1_700_000_000);

        // Same timestamp, different seeds, same caller => different outputs
        bytes memory result1 = mock.random(UINT8_TYPE, 1, 0);
        bytes memory result2 = mock.random(UINT8_TYPE, 2, 0);

        // With the fix (seed included in keccak), these must differ
        assertNotEq(
            keccak256(result1),
            keccak256(result2),
            "[C-1 fix] Different seeds now produce different output"
        );
    }

    /// @notice After fix: output is deterministic given the same inputs (reproducible).
    function test_C1_Fix_DeterministicForSameInputs() public {
        vm.warp(1_700_000_000);
        bytes memory r1 = mock.random(UINT8_TYPE, 42, 0);
        bytes memory r2 = mock.random(UINT8_TYPE, 42, 0);
        assertEq(keccak256(r1), keccak256(r2), "Same inputs must yield same output");
    }

    /// @notice After fix: random still returns a value within the type range.
    function test_C1_Fix_OutputInRange() public {
        vm.warp(1_700_000_000);
        bytes memory result = mock.random(UINT8_TYPE, 99, 0);
        uint256 val = abi.decode(result, (uint256));
        assertLt(val, 256, "[C-1 fix] euint8 random must be < 256");
    }

    // -----------------------------------------------------------------------
    // [C-2] sub() - underflow caused panic revert instead of wrapping
    // -----------------------------------------------------------------------

    /// @notice After fix: lhs < rhs no longer panics; result wraps modularly.
    function test_C2_Fix_UnderflowWraps() public {
        uint8 utype = UINT8_TYPE; // range 0-255, maxValue = 256

        uint256 lhs = 10;
        uint256 rhs = 20; // rhs > lhs

        bytes memory lhsBytes = mock.uint256ToBytes(lhs);
        bytes memory rhsBytes = mock.uint256ToBytes(rhs);

        // Must NOT revert after fix
        bytes memory result = mock.sub(utype, lhsBytes, rhsBytes);
        uint256 val = abi.decode(result, (uint256));

        // Expected: (256 - (20 - 10) % 256) % 256 = (256 - 10) % 256 = 246
        assertEq(val, 246, "[C-2 fix] 10 - 20 (mod 256) should wrap to 246");
    }

    /// @notice Normal subtraction still works correctly after fix.
    function test_C2_Fix_NormalSubtraction() public {
        bytes memory lhsBytes = mock.uint256ToBytes(50);
        bytes memory rhsBytes = mock.uint256ToBytes(30);

        bytes memory result = mock.sub(UINT8_TYPE, lhsBytes, rhsBytes);
        uint256 val = abi.decode(result, (uint256));

        assertEq(val, 20, "Normal subtraction 50 - 30 = 20");
    }

    /// @notice Equal operands return 0.
    function test_C2_Fix_EqualOperandsReturnZero() public {
        bytes memory v = mock.uint256ToBytes(77);
        bytes memory result = mock.sub(UINT8_TYPE, v, v);
        uint256 val = abi.decode(result, (uint256));
        assertEq(val, 0, "x - x must be 0");
    }

    // -----------------------------------------------------------------------
    // [C-3] maxValue(5) returned 1 - euint256 arithmetic always yielded 0
    // -----------------------------------------------------------------------

    /// @notice After fix: maxValue(5) returns 0 (sentinel for "no modulo").
    function test_C3_Fix_MaxValueEuint256IsSentinel() public view {
        uint256 mv = mock.maxValue(UINT256_TYPE);
        assertEq(mv, 0, "[C-3 fix] maxValue(5) must be 0 (sentinel for full uint256)");
    }

    /// @notice After fix: add() for euint256 returns the actual sum.
    function test_C3_Fix_AddEuint256ReturnsRealSum() public {
        bytes memory a = mock.uint256ToBytes(123_456_789);
        bytes memory b = mock.uint256ToBytes(987_654_321);

        bytes memory result = mock.add(UINT256_TYPE, a, b);
        uint256 val = abi.decode(result, (uint256));

        assertEq(val, 1_111_111_110, "[C-3 fix] add(euint256) must return real sum");
    }

    /// @notice After fix: mul() for euint256 returns the actual product.
    function test_C3_Fix_MulEuint256ReturnsRealProduct() public {
        bytes memory a = mock.uint256ToBytes(7);
        bytes memory b = mock.uint256ToBytes(13);

        bytes memory result = mock.mul(UINT256_TYPE, a, b);
        uint256 val = abi.decode(result, (uint256));

        assertEq(val, 91, "[C-3 fix] mul(euint256) must return real product");
    }

    /// @notice After fix: sub() for euint256 returns the real difference.
    function test_C3_Fix_SubEuint256ReturnsRealDiff() public {
        bytes memory a = mock.uint256ToBytes(100);
        bytes memory b = mock.uint256ToBytes(40);

        bytes memory result = mock.sub(UINT256_TYPE, a, b);
        uint256 val = abi.decode(result, (uint256));

        assertEq(val, 60, "[C-3 fix] sub(euint256) must return 60");
    }

    /// @notice After fix: random() for euint256 returns full-range value (no % 1 truncation).
    function test_C3_Fix_RandomEuint256InFullRange() public {
        vm.warp(1_700_000_000);
        bytes memory result = mock.random(UINT256_TYPE, 42, 0);
        uint256 val = abi.decode(result, (uint256));

        // With the old code this was always 0 (% 1). With the fix it is a real hash value.
        // A keccak256 of real inputs is astronomically unlikely to be 0.
        assertTrue(val != 0, "[C-3 fix] random(euint256) must return non-zero value");
    }
}
