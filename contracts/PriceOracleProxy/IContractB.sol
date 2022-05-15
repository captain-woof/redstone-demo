// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

interface IContractB {
    function isSignerAuthorized(address _receviedSigner)
        external
        view
        returns (bool);

    function writeValue() external;

    function getValue() external view returns (uint256);
}
