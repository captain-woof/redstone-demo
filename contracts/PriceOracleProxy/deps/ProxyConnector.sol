// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

abstract contract ProxyConnector {

  function prepareMessage(bytes memory encodedFunction) internal pure returns (bytes memory) {
    uint8 dataSymbolsCount;

    // calldatasize - whole calldata size
    // we get 97 last bytes, but we actually want to read only one byte
    // that stores number of redstone data symbols
    // Learn more: https://github.com/redstone-finance/redstone-evm-connector
    // calldataload - reads 32 bytes from calldata (it receives an offset)
    assembly {
      // We assign 32 bytes to dataSymbolsCount, but it has uint8 type (8 bit = 1 byte)
      // That's why only the last byte is assigned to dataSymbolsCount
      dataSymbolsCount := calldataload(sub(calldatasize(), 97))
    }

    uint16 redstonePayloadLength = uint16(dataSymbolsCount) * 64 + 32 + 1 + 65; // datapoints + timestamp + data size + signature

    uint256 encodedFunctionLength = encodedFunction.length;

    uint256 i;
    bytes memory message;

    assembly {
      message := mload(0x40) // sets message pointer to first free place in memory

      mstore(message, add(encodedFunctionLength, redstonePayloadLength)) // we save length of our message (it's a standard in EVM to store )

      // Copy function and its arguments byte by byte
      for { i := 0 } lt(i, encodedFunctionLength) { i := add(i, 1) } {
        mstore(
          add(add(0x20, message), mul(0x20, i)), // address
          mload(add(add(0x20, encodedFunction), mul(0x20, i))) // byte to copy
        )
      }

      // Copy redstone payload to the message bytes
      calldatacopy(
        add(message, add(0x20, encodedFunctionLength)), // address
        sub(calldatasize(), redstonePayloadLength), // offset
        redstonePayloadLength // bytes length to copy
      )

      // Update first free memory pointer
      mstore(
        0x40,
        add(add(message, add(redstonePayloadLength, encodedFunctionLength)), 0x20 /* 0x20 == 32 - message length size that is stored in the beginning of the message bytes */))
    }

    return message;
  }

  function proxyCalldata(address contractAddress, bytes memory encodedFunction) internal returns (bytes memory) {
    bytes memory message = prepareMessage(encodedFunction);

    (bool success, bytes memory result) = contractAddress.call(message);

    require(success, 'Proxy connector call failed');

    return result;
  }

  function proxyCalldataView(address contractAddress, bytes memory encodedFunction) internal view returns (bytes memory) {
    bytes memory message = prepareMessage(encodedFunction);

    (bool success, bytes memory result) = contractAddress.staticcall(message);

    require(success, 'Proxy connector call failed (proxyCalldataView)');

    return result;
  }
}
