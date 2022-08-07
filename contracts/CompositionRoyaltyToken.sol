// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

import "./BaseMusicRoyaltyToken.sol";

contract CompositionRoyaltyToken is BaseMusicRoyaltyToken {
    constructor (address _admin,string memory _name,string memory _symbol)
    BaseMusicRoyaltyToken(_admin, 'composition',_name,_symbol){
    }
}


