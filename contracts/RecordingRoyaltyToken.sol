// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

import "./interfaces/BaseMusicPortionToken.sol";

contract RecordingRoyaltyToken is BaseMusicPortionToken {
    constructor(address _ledger, string memory _name, string memory _symbol)
        BaseMusicPortionToken(_ledger, "recording", _name, _symbol)
    {}
}
