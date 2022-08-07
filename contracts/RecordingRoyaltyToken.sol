// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

import "./BaseMusicRoyaltyToken.sol";

contract RecordingRoyaltyToken is BaseMusicRoyaltyToken {
    constructor (address _parentSong, address _admin,string memory _name,string memory _symbol)
    BaseMusicRoyaltyToken(_parentSong,_admin, 'recording',_name,_symbol){
    }
}


