/**
Deployed at : https://goerli.etherscan.io/address/0xE62ED56809AF5dB84dd58BE1d1Fc875ef0B57f17#code
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AyasBlock {

    struct channelData {
        bool exists;
        string uid;     
        address admin;  
        string name;
        string description;
    }

    struct messagesData {
        bool exists;
        string uid;     
        string [] messagesInfo;    
        uint256 [] timestamp;
        string [] tag;
        string [] name;
        bool [] isAdmin;
    }

    struct modsData {
        bool exists;
        string uid;   
        address [] modAddress;   
        string [] tag;
        string [] name;
    }

    struct membersData {
        bool exists;
        string [] joinedChannels;
    }

    mapping (string => channelData) private channels;
    mapping (string => messagesData) private messages;
    mapping (string => modsData) private mods;
    mapping (address => membersData) private members;


    function createChannel (string memory _uid, string memory _name, string memory _description) public  {
        
        bool  _exists= true;
        string [] memory _emptyStringArr;
        address [] memory _modAddress;
        address _creator= msg.sender;

        require (!channels[_uid].exists);
        channelData memory newChannel = channelData({
            exists: _exists,
            uid: _uid,
            admin: _creator,
            name: _name,
            description:_description
        });
        channels[_uid]= newChannel;

        uint256 [] memory _timestamp;
        bool [] memory _emptyBoolArr;
        messagesData memory newMessage= messagesData({
            exists:_exists,
            uid: _uid,
            messagesInfo: _emptyStringArr,
            timestamp:_timestamp,
            tag:_emptyStringArr,
            name:_emptyStringArr,
            isAdmin:_emptyBoolArr
        });
        messages[_uid]= newMessage;
        modsData memory newMod= modsData({
            exists: _exists,
            uid:_uid,
            modAddress:_modAddress,
            tag:_emptyStringArr,
            name:_emptyStringArr
        });
        mods[_uid]= newMod;
    }

    function addMessage (string memory _uid, string memory _mesage) public   {
        require (channels[_uid].exists);
            if (channels[_uid].admin ==  msg.sender){
            messages[_uid].messagesInfo.push(_mesage);
            messages[_uid].timestamp.push(block.timestamp);
           }
    }

    function joinChannel (string memory _uid) public {
        require(channels[_uid].exists);
        if (members[msg.sender].exists) {
             members[msg.sender].joinedChannels.push(_uid);
        } else {
            bool _exists= true;
            string [] memory _emptyStringArr;
            membersData memory newMember= membersData ({
                exists:_exists,
                joinedChannels:_emptyStringArr
            });
            members[msg.sender]= newMember;
            members[msg.sender].joinedChannels.push(_uid);
        }
    }

    function getJoinedChannels (address  _reqAddress) public view returns  (string [] memory) {
        require(members[_reqAddress].exists);
        return members[_reqAddress].joinedChannels;
    }

    function getMessageTimestamp (string memory _uid) public view returns (uint256 [] memory) {
        require (messages[_uid].exists);
        return messages[_uid].timestamp;
    }

    function getMessageInfo (string memory _uid) public view returns (string [] memory) {
        require (messages[_uid].exists);
        return messages[_uid].messagesInfo;
    }

    function getChannelName (string  memory _uid) public view returns (string memory) {
        require (channels[_uid].exists);
        return channels[_uid].name;
    }

        function getChannelDescription (string  memory _uid) public view returns (string memory) {
        require (channels[_uid].exists);
        return channels[_uid].description;
    }

}
