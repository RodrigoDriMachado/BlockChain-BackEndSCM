pragma solidity ^0.4.24;

import "./Parse.sol";

contract StandardInterface {
    function getAge(string _firebaseId) public view returns(uint age) {}
    function lookUpId(string _firebaseId) public view returns(bytes serialized) {}
    function createStandardregistry() public {}
}

contract NotificationsInterface {
    function sendMessage(string _recipientId, string _senderId, string _text) public {}
}

contract BirthRegistry is Parse {

    address standardAddress;
    address notificationAddress;

    struct BirthCertificate {
        uint256 creationDate;
        string cpf;
        uint256 birthDate;
        string hospitalName;
        string cityOfBirth;
        string fathersName;
        string mothersName;
        string fathersGrandmothersName;
        string fathersGrandfathersName;
        string mothersGrandmothersName;
        string mothersGrandfathersName;
        bool approved;
        bool hasSon;
        uint256[] sonsCertificates;
        string[] sharedRegistry;
    }

    struct SonCertificate {
        uint256 creationDate;
        string cpf;
        uint256 birthDate;
        string hospitalName;
        string cityOfBirth;
        string fathersName;
        string mothersName;
        string fathersGrandmothersName;
        string fathersGrandfathersName;
        string mothersGrandmothersName;
        string mothersGrandfathersName;
        string sonsFirstName;
        string sonsFamilyName;
        bool approved;
    }

    mapping(string => BirthCertificate) registries;
    string[] public registriesAccts;

    mapping(uint256 => SonCertificate) sonsRegistries;
    uint256[] public sonsRegistriesAccts;

    function createBirthCertificate (
        string _firebaseId,
        string _creationDate,
        string _cpf,
        string _birthDate,
        string _hospitalName,
        string _cityOfBirth,
        string _fathersName,
        string _mothersName ) public returns (bool) {

        StandardInterface standard = StandardInterface(standardAddress);
        if(standard.lookUpId(_firebaseId).length != 0) {
            uint256 creationDate;
            if(bytes(_creationDate).length != 0) {
                creationDate = getDateAsUnix(_creationDate);
            }else creationDate = now;

            BirthCertificate storage registry = registries[_firebaseId];
            registry.cpf = _cpf;
            registry.creationDate = creationDate;
            registry.birthDate = getDateAsUnix(_birthDate);
            registry.hospitalName = _hospitalName;
            registry.cityOfBirth = _cityOfBirth;
            registry.fathersName = _fathersName;
            registry.mothersName = _mothersName;
            registry.hasSon = false;
            registry.approved = true;

            registriesAccts.push(_firebaseId) - 1;
            return true;

        } else return false;
    }

    function updateBirthCertificate (
        string _firebaseId,
        string _creationDate,
        string _cpf,
        string _birthDate,
        string _hospitalName,
        string _cityOfBirth,
        string _fathersName,
        string _mothersName ) public returns (bool) {

        if(registries[_firebaseId].creationDate != 0) {
            uint256 creationDate;
            if(bytes(_creationDate).length != 0) {
                creationDate = getDateAsUnix(_creationDate);
            }else creationDate = now;

            registries[_firebaseId].cpf = _cpf;
            registries[_firebaseId].creationDate = creationDate;
            registries[_firebaseId].birthDate = getDateAsUnix(_birthDate);
            registries[_firebaseId].hospitalName = _hospitalName;
            registries[_firebaseId].cityOfBirth = _cityOfBirth;
            registries[_firebaseId].fathersName = _fathersName;
            registries[_firebaseId].mothersName = _mothersName;
            registries[_firebaseId].approved = false;
            
            return true;
        } else{
            return false;
        }
    }

    function updateGrandparents (
        string _firebaseId,
        string _fathersGrandmothersName,
        string _fathersGrandfathersName,
        string _mothersGrandmothersName,
        string _mothersGrandfathersName
    ) public {
        if(registries[_firebaseId].creationDate != 0) {
            registries[_firebaseId].fathersGrandfathersName = _fathersGrandfathersName;
            registries[_firebaseId].fathersGrandmothersName = _fathersGrandmothersName;
            registries[_firebaseId].mothersGrandfathersName = _mothersGrandfathersName;
            registries[_firebaseId].mothersGrandmothersName = _mothersGrandmothersName;
        }
    }

    function createSonsBirthCertificate (
        string _responsibleFirebaseId,
        string _creationDate,
        string _cpf,
        string _birthDate,
        string _hospitalName,
        string _cityOfBirth,
        string _fathersName,
        string _mothersName ) public returns (bool) {

        StandardInterface standard = StandardInterface(standardAddress);
        if(standard.lookUpId(_responsibleFirebaseId).length != 0) {
            if(lookUpId(_responsibleFirebaseId).length != 0) {
                uint256 creationDate;
                if(bytes(_creationDate).length != 0) {
                    creationDate = getDateAsUnix(_creationDate);
                }else creationDate = now;

                uint256 birthDate;
                if(bytes(_birthDate).length != 0) {
                    birthDate = getDateAsUnix(_birthDate);
                }else birthDate = now;

                registries[_responsibleFirebaseId].hasSon = true;
                registries[_responsibleFirebaseId].sonsCertificates.push(sonsRegistriesAccts.length) - 1;

                SonCertificate storage registry = sonsRegistries[sonsRegistriesAccts.length];
                registry.cpf = _cpf;
                registry.creationDate = creationDate;
                registry.birthDate = birthDate;
                registry.hospitalName = _hospitalName;
                registry.cityOfBirth = _cityOfBirth;
                registry.fathersName = _fathersName;
                registry.mothersName = _mothersName;
                registry.approved = false;

                sonsRegistriesAccts.push(sonsRegistriesAccts.length) - 1;
                return true;
            } else {
                return false;
            } 
        } else {
            return false;
        }
    }

    function updateSonsBirthCertificate (
        uint256 _sonsId,
        string _creationDate,
        string _cpf,
        string _birthDate,
        string _hospitalName,
        string _cityOfBirth,
        string _fathersName,
        string _mothersName ) public returns (bool) {

        if(sonsRegistries[_sonsId].creationDate != 0) {
            uint256 creationDate;
            if(bytes(_creationDate).length != 0) {
                creationDate = getDateAsUnix(_creationDate);
            }else creationDate = now;

            uint256 birthDate;
            if(bytes(_birthDate).length != 0) {
                birthDate = getDateAsUnix(_birthDate);
            }else birthDate = now;

            sonsRegistries[_sonsId].cpf = _cpf;
            sonsRegistries[_sonsId].creationDate = creationDate;
            sonsRegistries[_sonsId].birthDate = birthDate;
            sonsRegistries[_sonsId].hospitalName = _hospitalName;
            sonsRegistries[_sonsId].cityOfBirth = _cityOfBirth;
            sonsRegistries[_sonsId].fathersName = _fathersName;
            sonsRegistries[_sonsId].mothersName = _mothersName;
            sonsRegistries[_sonsId].approved = false;
            return true;
        } else return false;
    }

    function updateSonsGrandparentsAndName (
        uint256 _sonsId,
        string _fathersGrandmothersName,
        string _fathersGrandfathersName,
        string _mothersGrandmothersName,
        string _mothersGrandfathersName,
        string _firstName,
        string _familyName
    ) public {
        sonsRegistries[_sonsId].sonsFirstName = _firstName;
        sonsRegistries[_sonsId].sonsFamilyName = _familyName;
        sonsRegistries[_sonsId].fathersGrandfathersName = _fathersGrandfathersName;
        sonsRegistries[_sonsId].fathersGrandmothersName = _fathersGrandmothersName;
        sonsRegistries[_sonsId].mothersGrandfathersName = _mothersGrandfathersName;
        sonsRegistries[_sonsId].mothersGrandmothersName = _mothersGrandmothersName;
    }

    function lookUpId (string _firebaseId) public view returns (bytes serialized) {
        return getBytes(registries[_firebaseId]);
    }

    function lookUpSonsId (uint256 _sonId) public view returns (bytes serialized) {
        return getBytes(sonsRegistries[_sonId]);
    }

    function negate (string _firebaseId) public {
        registries[_firebaseId].approved = false;
    }

    function approve (string _firebaseId) public {
        registries[_firebaseId].approved = true;
    }

    function negateSon (uint _sonId) public {
        sonsRegistries[_sonId].approved = false;
    }

    function approveSon (uint _sonId) public {
        sonsRegistries[_sonId].approved = true;
    }

    function isApproved (string _firebaseId) public view returns (bool) {
        return registries[_firebaseId].approved;
    }

    function isSonApproved (uint _sonId) public view returns (bool) {
        return sonsRegistries[_sonId].approved;
    }

    function hasSon (string _firebaseId) public view returns (bool) {
        return registries[_firebaseId].hasSon;
    }

    function setStandardAddress(address _standardAddress) public {
        standardAddress = _standardAddress;
    }

    function setNotificationAddress(address _notificationAddress) public {
        notificationAddress = _notificationAddress;
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

    function getBytes(BirthCertificate registry) internal view returns (bytes serialized) {
        uint offset = 64*(11 + registry.sonsCertificates.length);
        bytes memory buffer = new  bytes(offset);

        for(uint i = 0; i < registry.sonsCertificates.length; i++) {
            string memory sonId = uint2str(registry.sonsCertificates[i]);
            stringToBytes(offset, bytes(sonId), buffer);
            offset -= sizeOfString(sonId);
        }

        stringToBytes(offset, bytes(registry.mothersGrandfathersName), buffer);
        offset -= sizeOfString(registry.mothersGrandfathersName);

        stringToBytes(offset, bytes(registry.mothersGrandmothersName), buffer);
        offset -= sizeOfString(registry.mothersGrandmothersName);

        stringToBytes(offset, bytes(registry.fathersGrandfathersName), buffer);
        offset -= sizeOfString(registry.fathersGrandfathersName);

        stringToBytes(offset, bytes(registry.fathersGrandmothersName), buffer);
        offset -= sizeOfString(registry.fathersGrandmothersName);

        stringToBytes(offset, bytes(registry.mothersName), buffer);
        offset -= sizeOfString(registry.mothersName);

        stringToBytes(offset, bytes(registry.fathersName), buffer);
        offset -= sizeOfString(registry.fathersName);

        stringToBytes(offset, bytes(registry.cityOfBirth), buffer);
        offset -= sizeOfString(registry.cityOfBirth);

        stringToBytes(offset, bytes(registry.hospitalName), buffer);
        offset -= sizeOfString(registry.hospitalName);

        string memory birthDate = uint2str(registry.birthDate);
        stringToBytes(offset, bytes(birthDate), buffer);
        offset -= sizeOfString(birthDate);

        stringToBytes(offset, bytes(registry.cpf), buffer);
        offset -= sizeOfString(registry.cpf);

        string memory creationDate = uint2str(registry.creationDate);
        stringToBytes(offset, bytes(creationDate), buffer);
        offset -= sizeOfString(creationDate);

        return (buffer);
    }

    function getBytes(SonCertificate registry) internal view returns (bytes serialized){
        uint offset = 64*(13);
        bytes memory buffer = new  bytes(offset);

        stringToBytes(offset, bytes(registry.sonsFirstName), buffer);
        offset -= sizeOfString(registry.sonsFirstName);
        
        stringToBytes(offset, bytes(registry.sonsFamilyName), buffer);
        offset -= sizeOfString(registry.sonsFamilyName);

        stringToBytes(offset, bytes(registry.mothersGrandfathersName), buffer);
        offset -= sizeOfString(registry.mothersGrandfathersName);

        stringToBytes(offset, bytes(registry.mothersGrandmothersName), buffer);
        offset -= sizeOfString(registry.mothersGrandmothersName);

        stringToBytes(offset, bytes(registry.fathersGrandfathersName), buffer);
        offset -= sizeOfString(registry.fathersGrandfathersName);

        stringToBytes(offset, bytes(registry.fathersGrandmothersName), buffer);
        offset -= sizeOfString(registry.fathersGrandmothersName);

        stringToBytes(offset, bytes(registry.mothersName), buffer);
        offset -= sizeOfString(registry.mothersName);

        stringToBytes(offset, bytes(registry.fathersName), buffer);
        offset -= sizeOfString(registry.fathersName);

        stringToBytes(offset, bytes(registry.cityOfBirth), buffer);
        offset -= sizeOfString(registry.cityOfBirth);

        stringToBytes(offset, bytes(registry.hospitalName), buffer);
        offset -= sizeOfString(registry.hospitalName);

        string memory birthDate = uint2str(registry.birthDate);
        stringToBytes(offset, bytes(birthDate), buffer);
        offset -= sizeOfString(birthDate);

        stringToBytes(offset, bytes(registry.cpf), buffer);
        offset -= sizeOfString(registry.cpf);

        string memory creationDate = uint2str(registry.creationDate);
        stringToBytes(offset, bytes(creationDate), buffer);
        offset -= sizeOfString(creationDate);

        return (buffer);
    }
    
    function sendNotification(string _responsibleFirebaseId, string _text) public view {
        NotificationsInterface notification = NotificationsInterface(notificationAddress);
        notification.sendMessage(_responsibleFirebaseId, "system", _text);
    }
}