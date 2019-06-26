pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./seriality/Seriality.sol";

// import "github.com/pouladzade/Seriality/src/Seriality.sol";
// import "github.com/pipermerriam/ethereum-datetime/contracts/DateTime.sol";

contract Parse is Seriality {

  /*This method is only used for string comparsion.
  Since == for string is not yet implemented we convert the parameters to
  Ethereum-SHA-3 and compare it.*/
    function compareStrings (string memory a, string memory b) internal pure returns (bool) {
        bytes32 firstString = keccak256(bytes(a));
        bytes32 secondString = keccak256(bytes(b));
        return firstString == secondString;
    }


    function getSlice(uint256 begin, uint256 end, string memory text) internal pure returns (string memory) {
        bytes memory a = new bytes(end-begin+1);
        for(uint i=0;i<=end-begin;i++){
            a[i] = bytes(text)[i+begin-1];
        }
        return string(a);
    }

   
}