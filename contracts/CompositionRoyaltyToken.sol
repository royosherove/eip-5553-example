// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

import "./BaseMusicRoyaltyToken.sol";

contract CompositionRoyaltyToken is BaseMusicRoyaltyToken {
    constructor (address _parentSong, address _admin,string memory _name,string memory _symbol)
    BaseMusicRoyaltyToken(_parentSong,_admin, 'composition',_name,_symbol){
    }
}


