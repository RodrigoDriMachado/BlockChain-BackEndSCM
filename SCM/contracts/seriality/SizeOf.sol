pragma solidity ^0.5.0;

/**
 * @title SizeOf
 * @dev The SizeOf return the size of the solidity types in byte
 * @author pouladzade@gmail.com
 */

contract  SizeOf {

    function sizeOfString(string memory _in) internal pure  returns(uint _size){
        _size = bytes(_in).length / 32;
        if(bytes(_in).length % 32 != 0){
            _size++;
        }
        _size++; // first 32 bytes is reserved for the size of the string
        _size *= 32;
    }

    function sizeOfAddress() internal pure  returns(uint8){
        return 20;
    }

    function sizeOfBool() internal pure  returns(uint8){
        return 1;
    }
}
