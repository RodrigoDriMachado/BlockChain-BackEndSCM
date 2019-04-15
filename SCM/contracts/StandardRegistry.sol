pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

import "./Parse.sol";

contract NotificationsInterface {
    function sendMessage(string _recipientId, string _senderId, string _text) public {}
}

contract StandardRegistry is Parse {

    address notificationAddress;
    
    /*Struct for the standard access registry
    Consider adding parents name*/
    struct Standard {
        string given_name;
        string family_name;
        string telephone;
        uint256 birthday;
        string add;
        string add_complement;
        string city;
        string state;
        string zipcode;
        string mail;
    }

    /*Map for regestries
    the mapping type on solidity does not support iteration, does forcing us to create
    a list of string to iterate over*/
    mapping(string => Standard) regestries;
    string[] public regestriesAccts;

    /*Add a user to the contract.
    This method should never be called first, since it changes the information
    of the user.
    Please use lookUp() before creating another user.*/
    function createStandardregistry (
        string _firebaseId,
        string _given_name,
        string _family_name,
        string _telephone,
        string _birthday,
        string _add,
        string _add_complement,
        string _city,
        string _state,
        string _zipcode,
        string _mail) public {

        Standard storage registry = regestries[_firebaseId];

        registry.given_name = _given_name;
        registry.family_name = _family_name;
        registry.telephone = _telephone;
        if(bytes(_birthday).length != 0) registry.birthday = getDateAsUnix(_birthday);
        else registry.birthday = now;
        registry.add = _add;
        registry.add_complement = _add_complement;
        registry.city = _city;
        registry.state = _state;
        registry.zipcode = _zipcode;
        registry.mail = _mail;

        regestriesAccts.push(_firebaseId) - 1;
    }

    /*Those parameters are the "Composite Private Key"
    This contract does not have a strong key for lookup since it's only use is for
    standard information for other contracts.*/
    function lookUpregistry (
        string _given_name,
        string _family_name,
        string _birthday,
        string _city,
        string _state ) public view returns (bool) {

        if(regestriesAccts.length == 0) return false;
        for(uint i = 0; i < regestriesAccts.length; i ++) {
            string memory id = regestriesAccts[i];
            Standard memory registry = regestries[id];
            if(compareStrings(registry.given_name, _given_name) &&
            compareStrings(registry.family_name,_family_name) &&
            compareStrings(registry.city, _city) &&
            compareStrings(registry.state, _state)){
                return true;
            }
        }
        return false;
    }

    function setNotificationAddress(address _notificationAddress) public {
        notificationAddress = _notificationAddress;
    }

    /*Look up for an user with the Firebase ID.
    This should be used for getting all pertinent information of a certain user. */
    function lookUpId (string _firebaseId) public view returns (bytes serialized) {
        Standard memory registry = regestries[_firebaseId];
        return getBytes(registry);
    }

    function lookUpId_Standard (string _firebaseId) public view returns (Standard standard) {
        return regestries[_firebaseId];
    }

    /*Delete a certain regestry with the Firebase ID.
    This should be use carefully and only with an user Firebase should be deleted.*/
    function deleteRegistry (string _firebaseId) public {
        delete(regestries[_firebaseId]);
    }

    /*This method is used for updating already existing registries.
    This should not be used for adding new regestries. */
    function update(
        string _firebaseId,
        string _given_name,
        string _family_name,
        string _telephone,
        string _birthday,
        string _add,
        string _add_complement,
        string _city,
        string _state,
        string _zipcode,
        string _mail) public {

        regestries[_firebaseId].given_name = _given_name;
        regestries[_firebaseId].family_name = _family_name;
        regestries[_firebaseId].telephone = _telephone;
        regestries[_firebaseId].birthday = getDateAsUnix(_birthday);
        regestries[_firebaseId].add = _add;
        regestries[_firebaseId].add_complement = _add_complement;
        regestries[_firebaseId].city = _city;
        regestries[_firebaseId].state = _state;
        regestries[_firebaseId].zipcode = _zipcode;
        regestries[_firebaseId].mail = _mail;
    }

    function getAge(string _firebaseId) public view returns (uint) {
        uint256 birthday = regestries[_firebaseId].birthday;
        uint today = now;

        uint age = today - birthday;

        return age/31536000;
    }

    /*Since solidity still doesn't support tuple/list return on functions this method
    is used to serialize a standard registry structure. This method should recieve a
    Stanadrd structure and will return a hex number.*/
    function getBytes(Standard registry) internal view returns (bytes serialized){
        uint offset = 64*(10);
        bytes memory buffer = new  bytes(offset);

        stringToBytes(offset, bytes(registry.mail), buffer);
        offset -= sizeOfString(registry.mail);

        stringToBytes(offset, bytes(registry.zipcode), buffer);
        offset -= sizeOfString(registry.zipcode);

        stringToBytes(offset, bytes(registry.state), buffer);
        offset -= sizeOfString(registry.state);

        stringToBytes(offset, bytes(registry.city), buffer);
        offset -= sizeOfString(registry.city);

        stringToBytes(offset, bytes(registry.add_complement), buffer);
        offset -= sizeOfString(registry.add_complement);

        stringToBytes(offset, bytes(registry.add), buffer);
        offset -= sizeOfString(registry.add);

        string memory birthday = uint2str(registry.birthday);
        stringToBytes(offset, bytes(birthday), buffer);
        offset -= sizeOfString(birthday);

        stringToBytes(offset, bytes(registry.telephone), buffer);
        offset -= sizeOfString(registry.telephone);

        stringToBytes(offset, bytes(registry.family_name), buffer);
        offset -= sizeOfString(registry.family_name);

        stringToBytes(offset, bytes(registry.given_name), buffer);
        offset -= sizeOfString(registry.given_name);

        return (buffer);
    }
}