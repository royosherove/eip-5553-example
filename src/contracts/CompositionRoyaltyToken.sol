// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

import "./BaseMusicRoyaltyToken.sol";

contract CompositionRoyaltyToken is BaseMusicRoyaltyToken {
    constructor (address _ledger,string memory _name,string memory _symbol)
    BaseMusicRoyaltyToken(_ledger, 'composition',_name,_symbol){
    }
}


