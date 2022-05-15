//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.2;

import "redstone-evm-connector/lib/contracts/message-based/PriceAware.sol";

contract PriceOracle is PriceAware {
    ////////////////////////////
    // FUNCTIONS
    ////////////////////////////

    // Function to get price of coin
    function getPrice(string calldata _tokenSymbol)
        public
        view
        returns (uint256)
    {
        return getPriceFromMsg(_stringToBytes32(_tokenSymbol));
    }

    ////////////////////////////
    // OVERRIDE FUNCTIONS
    ////////////////////////////

    function isSignerAuthorized(address _receivedSigner)
        public
        view
        virtual
        override
        returns (bool)
    {
        return _receivedSigner == 0x0C39486f770B26F5527BBBf942726537986Cd7eb;
    }

    ////////////////////////////
    // INTERNAL FUNCTIONS
    ////////////////////////////

    function _stringToBytes32(string memory source)
        internal
        pure
        returns (bytes32 result)
    {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }
}
