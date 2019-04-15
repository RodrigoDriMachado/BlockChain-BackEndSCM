pragma solidity ^0.5.0;

import "./Parse.sol";

contract StandardInterface {
    function getAge(string _firebaseId) public view returns(uint age) {}
    function lookUpId(string _firebaseId) public view returns(bytes serialized) {}
}

contract NotificationsInterface {
    function sendMessage(string _recipientId, string _senderId, string _text) public {}
}

contract GeneralRegistry is Parse {

    address standardAddress;
    address notificationAddress;

    struct General {
        string fatherName;
        string motherName;
        uint256 creationDate;
        bool approved;
        string cpf;
        string pis;
        string photo;
        string nationality;
        string marriedLicense;
        string[] sharedRegistry;
    }

    mapping(string => General) registries;
    string[] public registriesAccts;

    function createGeneralRegistry (
        string _firebaseId,
        string _fatherName,
        string _motherName,
        string _creationDate,
        string _cpf,
        string _pis,
        string _photo,
        string _nationality,
        string _marriedLicense ) public returns (bool) {

        General storage registry = registries[_firebaseId];

        registry.fatherName = _fatherName;
        registry.motherName = _motherName;
        if(bytes(_creationDate).length != 0) registry.creationDate = getDateAsUnix(_creationDate);
        else registry.creationDate = now;
        registry.cpf = _cpf;
        registry.pis = _pis;
        registry.photo = _photo;
        registry.nationality = _nationality;
        registry.marriedLicense = _marriedLicense;
        registry.approved = false;

        registriesAccts.push(_firebaseId) - 1;
        return true;
    }

    function createSingleGeneralRegistry (
        string _firebaseId,
        string _fatherName,
        string _motherName,
        string _creationDate,
        string _cpf,
        string _pis,
        string _photo,
        string _nationality ) public returns (bool status) {

        StandardInterface standard = StandardInterface(standardAddress);
        if(standard.getAge(_firebaseId) >= 16 && standard.lookUpId(_firebaseId).length > 0) {
            createGeneralRegistry(_firebaseId, _fatherName, _motherName, _creationDate, _cpf, _pis, _photo, _nationality, "N/A");
            return true;
        } else {
            return false;
        }
    }

    function createYoungGeneralRegistry (
        string _firebaseId,
        string _firebaseId_father,
        string _fatherName,
        string _motherName,
        string _creationDate,
        string _cpf,
        string _pis,
        string _photo,
        string _nationality ) public returns (bool status) {

        StandardInterface standard = StandardInterface(standardAddress);
        if(standard.getAge(_firebaseId) < 16 &&
            standard.lookUpId(_firebaseId).length > 0 &&
            standard.lookUpId(_firebaseId_father).length > 0) {
            createGeneralRegistry(_firebaseId, _fatherName, _motherName, _creationDate, _cpf, _pis, _photo, _nationality, "N/A");
            negate(_firebaseId);
            return true;
        } else {
            return false;
        }
    }

    function createMarriedGeneralRegistry (
        string _firebaseId,
        string _fatherName,
        string _motherName,
        string _creationDate,
        string _cpf,
        string _pis,
        string _photo,
        string _nationality,
        string _marriedLicense ) public returns (bool status) {

        StandardInterface standard = StandardInterface(standardAddress);
        if(standard.getAge(_firebaseId) >= 16 &&
            standard.lookUpId(_firebaseId).length > 0) {
            createGeneralRegistry(_firebaseId, _fatherName, _motherName, _creationDate, _cpf, _pis, _photo, _nationality, _marriedLicense);
            return true;
        } else {
            return false;
        }
    }

    function setStandardAddress(address _standardAddress) public {
        standardAddress = _standardAddress;
    }

    function setNotificationAddress(address _notificationAddress) public {
        notificationAddress = _notificationAddress;
    }

    /*Look up for an user with the Firebase ID.
    This should be used for getting all pertinent information of a certain user. */
    function lookUpId (string _firebaseId) public view returns (bytes serialized) {
        return getBytes(registries[_firebaseId]);
    }

    function isApproved (string _firebaseId) public view returns (bool) {
        return registries[_firebaseId].approved;
    }

    function negate (string _firebaseId) public {
        registries[_firebaseId].approved = false;
    }

    function approve (string _firebaseId) public {
        registries[_firebaseId].approved = true;
    }

    function shareDocument (string _recipientId, string _senderId) public returns (bool){
        if (registries[_senderId].creationDate == 0) { return false;
        } else if (registries[_recipientId].creationDate == 0)  { return false;
        } else if (compareStrings(_recipientId, _senderId)) { return false;
        } else {
            registries[_recipientId].sharedRegistry.push(_senderId) - 1;
            return true;
        }
    }
    
    function getSharedDocument (string _firebaseId) public view returns (bytes serialized) {
        uint offset = 64*(registries[_firebaseId].sharedRegistry.length);
        bytes memory buffer = new  bytes(offset);
        
        for(uint i = 0; i < registries[_firebaseId].sharedRegistry.length; i++) {
            string memory sharedDoc = registries[_firebaseId].sharedRegistry[i];
            stringToBytes(offset, bytes(sharedDoc), buffer);
            offset -= sizeOfString(sharedDoc);
        }
        return (buffer);
    }

    /* */
    function update (
        string _firebaseId,
        string _fatherName,
        string _motherName,
        string _creationDate,
        string _cpf,
        string _pis,
        string _photo,
        string _nationality,
        string _marriedLicense ) public {

        registries[_firebaseId].fatherName = _fatherName;
        registries[_firebaseId].motherName = _motherName;
        registries[_firebaseId].creationDate = getDateAsUnix(_creationDate);
        registries[_firebaseId].cpf = _cpf;
        registries[_firebaseId].pis = _pis;
        registries[_firebaseId].photo = _photo;
        registries[_firebaseId].nationality = _nationality;
        registries[_firebaseId].marriedLicense = _marriedLicense;
        registries[_firebaseId].approved = false;
    }

    /* */
    function getBytes(General registry) internal view returns (bytes serialized){
        uint offset = 64*(8);
        bytes memory buffer = new  bytes(offset);

        stringToBytes(offset, bytes(registry.marriedLicense), buffer);
        offset -= sizeOfString(registry.marriedLicense);

        stringToBytes(offset, bytes(registry.nationality), buffer);
        offset -= sizeOfString(registry.nationality);

        stringToBytes(offset, bytes(registry.photo), buffer);
        offset -= sizeOfString(registry.photo);

        stringToBytes(offset, bytes(registry.pis), buffer);
        offset -= sizeOfString(registry.pis);

        stringToBytes(offset, bytes(registry.cpf), buffer);
        offset -= sizeOfString(registry.cpf);

        string memory creationDate = uint2str(registry.creationDate);
        stringToBytes(offset, bytes(creationDate), buffer);
        offset -= sizeOfString(creationDate);

        stringToBytes(offset, bytes(registry.motherName), buffer);
        offset -= sizeOfString(registry.motherName);

        stringToBytes(offset, bytes(registry.fatherName), buffer);
        offset -= sizeOfString(registry.fatherName);

        return (buffer);
    }

    function sendNotification(string _responsibleFirebaseId, string _text) public view {
        NotificationsInterface notification = NotificationsInterface(notificationAddress);
        notification.sendMessage(_responsibleFirebaseId, "system", _text);
    }
}