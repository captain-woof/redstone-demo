// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

import "./deps/PriceAwareOwnable.sol";

contract ContractB is PriceAware {
    uint256 private lastValue = 0;

    function isSignerAuthorized(address _receviedSigner)
        public
        view
        virtual
        override
        returns (bool)
    {
        return _receviedSigner == 0x0C39486f770B26F5527BBBf942726537986Cd7eb; // redstone demo main
    }

    function writeValue() public {
        uint256 tslaPrice = getPriceFromMsg(bytes32("ETH"));
        lastValue = tslaPrice;
    }

    function getValue() public view returns (uint256) {
        uint256 result = getPriceFromMsg(bytes32("ETH"));
        return result;
    }
}
