// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

import "./RoyaltyToken.sol";

contract RecordingToken is RoyaltyToken {
    constructor (address _parentSong, address _admin, uint _count,string memory _name,string memory _symbol)
    RoyaltyToken(_parentSong,_admin,_count, 'recording',_name,_symbol){
    }
}


