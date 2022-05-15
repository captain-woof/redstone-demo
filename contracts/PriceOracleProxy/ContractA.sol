// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

import "./IContractB.sol";
import "./deps/PriceAware.sol";
import "./deps/ProxyConnector.sol";

contract ContractA is ProxyConnector {
    IContractB private immutable contractB;

    uint256 private lastValueFromContractB;

    constructor(address _bContractAddr) public {
        contractB = IContractB(_bContractAddr);
    }

    function writeInContractB() public {
        // Usually we would simply call the one instruction below
        // bContract.setPrice();

        // But to proxy calldata we need to add a bit more instructions
        proxyCalldata(
            address(contractB),
            abi.encodeWithSelector(IContractB.writeValue.selector)
        );
    }

    // Implementation from: https://stackoverflow.com/a/63258666
    function toUint256(bytes memory _bytes)
        internal
        pure
        returns (uint256 value)
    {
        assembly {
            value := mload(add(_bytes, 0x20))
        }
    }

    function readFromContractBAndSave() public {
        // Usually we would simply call the one instruction below
        // lastValueFromContractB = bContract.getLastTeslaPrice();

        // But to proxy calldata we need to add a bit more instructions
        bytes memory bytesResponse = proxyCalldata(
            address(contractB),
            abi.encodeWithSelector(IContractB.getValue.selector)
        );
        lastValueFromContractB = toUint256(bytesResponse);
    }

    function getLastValueFromContractB() public view returns (uint256) {
        return lastValueFromContractB;
    }
}
