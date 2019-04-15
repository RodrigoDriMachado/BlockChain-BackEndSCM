pragma solidity ^0.4.24;

import "./Parse.sol";

contract Notifications is Parse {

    struct User {
        string firebase_id;
        uint256[] notification_list;
        mapping(uint256 => Message) messages_list;
    }

    struct Message {
        string id_sender;
        string text;
        uint256 time;
        bool read;
        bool deleted;
    }
    

    mapping(string => User) registries;
    string[] public registriesUsers;
    
    function sendMessage(string _recipientId, string _senderId, string _text) public {
        if(compareStrings(registries[_recipientId].firebase_id,"")) {
            createUser(_recipientId);
        }
        createMessage(_recipientId, _senderId, _text);
    }
    
    function createUser(string _firebaseId) public {
        User storage registry = registries[_firebaseId];
        registry.firebase_id = _firebaseId;
        registriesUsers.push(_firebaseId) - 1;
    }
    
    function createMessage(string _recipientId, string _senderId, string _text) public {
        uint256 id = registries[_recipientId].notification_list.length + 1;
        
        Message storage message = registries[_recipientId].messages_list[id];
        message.id_sender = _senderId;
        message.text = _text;
        message.time = now;
        message.read = false;
        
        registries[_recipientId].notification_list.push(id) -1;
    }
    
    function getMessagesIds(string _firebaseId) public view returns (bytes serialized) {
        uint offset = 64*(registries[_firebaseId].notification_list.length);
        bytes memory buffer = new  bytes(offset);
        
        for(uint i = 0; i < registries[_firebaseId].notification_list.length; i++) {
            uint256 id = registries[_firebaseId].notification_list[i];
            if(registries[_firebaseId].messages_list[id].deleted == false) {
                string memory messageId = uint2str(registries[_firebaseId].notification_list[i]);
                stringToBytes(offset, bytes(messageId), buffer);
                offset -= sizeOfString(messageId);
            }
        }
        return (buffer);
    }
    
    function markRead(string _firebaseId, uint256 _id) public {
        registries[_firebaseId].messages_list[_id].read = true;
    }
    
    function isRead(string _firebaseId, uint256 _id) public view returns (bool status) {
        return registries[_firebaseId].messages_list[_id].read;
    }
    
    function markDeleted(string _firebaseId, uint256 _id) public {
        registries[_firebaseId].messages_list[_id].deleted = true;
    }
    
    function isDeleted(string _firebaseId, uint256 _id) public view returns (bool status) {
        return registries[_firebaseId].messages_list[_id].deleted;
    }
    
    function getMessages(string _firebaseId, uint256 _id) public view returns (bytes serialized) {
        uint offset = 64*(3);
        bytes memory buffer = new bytes(offset);
        
        Message memory message = registries[_firebaseId].messages_list[_id];
        
        string memory sender_id = message.id_sender;
        stringToBytes(offset, bytes(sender_id), buffer);
        offset -= sizeOfString(sender_id);
        
        string memory text = message.text;
        stringToBytes(offset, bytes(text), buffer);
        offset -= sizeOfString(text);
        
        string memory time = uint2str(message.time);
        stringToBytes(offset, bytes(time), buffer);
        offset -= sizeOfString(time);
        
        return (buffer);
    } 

}