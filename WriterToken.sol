// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.6;

import "../base/RoyaltyToken.sol";

contract WriterToken is RoyaltyToken {
    constructor (address _parentSong, address _admin, uint _count,string memory _name,string memory _symbol)
    RoyaltyToken(_parentSong,_admin,_count, 'writer',_name,_symbol){
    }
}


