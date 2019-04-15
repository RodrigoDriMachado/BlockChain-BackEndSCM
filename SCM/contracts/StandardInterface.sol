pragma solidity ^0.4.6;

contract StandardInterface {
    function getAge(string _firebaseId) public view returns(uint age) {}
    function lookUpId(string _firebaseId) public view returns(bytes serialized) {}
}