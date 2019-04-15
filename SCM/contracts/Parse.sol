pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

import "./oraclize/OraclizeAPI.sol";
import "./seriality/Seriality.sol";
import "./ethereum-datetime/contracts/DateTime.sol";

// import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
// import "github.com/pouladzade/Seriality/src/Seriality.sol";
// import "github.com/pipermerriam/ethereum-datetime/contracts/DateTime.sol";

contract Parse is Seriality, usingOraclize, DateTime {

    function getDateAsUnix(string date) public view returns (uint) {
        string memory day_s = getSlice(1, 2, date);
        uint day = parseInt(day_s);

        string memory month_s = getSlice(4, 5, date);
        uint month = parseInt(month_s);

        string memory year_s = getSlice(7, 10, date);
        uint year = parseInt(year_s);

        return toTimestamp(uint16(year), uint8(month), uint8(day));
    }

  /*This method is only used for string comparsion.
  Since == for string is not yet implemented we convert the parameters to
  Ethereum-SHA-3 and compare it.*/
    function compareStrings (string a, string b) internal pure returns (bool) {
        bytes32 firstString = keccak256(bytes(a));
        bytes32 secondString = keccak256(bytes(b));
        return firstString == secondString;
    }


    function getSlice(uint256 begin, uint256 end, string text) internal pure returns (string) {
        bytes memory a = new bytes(end-begin+1);
        for(uint i=0;i<=end-begin;i++){
            a[i] = bytes(text)[i+begin-1];
        }
        return string(a);
    }
}