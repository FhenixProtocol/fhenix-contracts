// solhint-disable var-name-mixedcase
// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity >=0.8.19 <0.9.0;

import { IFhenixPermitV2, PermissionV2, IFhenixPermissionedV2 } from "./PermitV2.sol";

abstract contract PermissionedV2 is IFhenixPermissionedV2 {
	bytes32 private projectId;

	IFhenixPermitV2 public PERMIT_V2;
	string public PROJECT_ID;

	error ProjectNameTooLong();

	constructor(address _permitV2, string memory _projectId) {
		if (bytes(_projectId).length > 32) revert ProjectNameTooLong();

		PERMIT_V2 = IFhenixPermitV2(_permitV2);
		projectId = bytes32(abi.encodePacked(_projectId));
		PROJECT_ID = _projectId;

		PERMIT_V2.validateProjectId(projectId);
	}

	function checkPermitSatisfies(
		uint256 _permitId
	) public view returns (bool) {
		return
			PERMIT_V2.checkPermitSatisfies(_permitId, address(this), projectId);
	}

	/**
	 * @dev Validates that sender has the permit and permission to view `issuers` data
	 * Validates that the PermitNFT is in the senders wallet and has access
	 * to read this contract (via address, project, or category).
	 */
	modifier withPermission(PermissionV2 memory permission) {
		PERMIT_V2.validatePermission(
			permission,
			msg.sender,
			address(this),
			projectId
		);
		_;
	}
}