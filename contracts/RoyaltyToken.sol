// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract RoyaltyToken is ERC20 {
    event RoyaltyMinted(address song, uint amount, string kind);

    string public kind;
    address public parentSong ;
    constructor (
        address _parentSong,
        address _admin,
        uint _count,
        string memory _kind,
        string memory _name,
        string memory _symbol) ERC20(_name, _symbol){
            _mint(_admin,_count);
            parentSong = _parentSong;
            kind = _kind;

            emit RoyaltyMinted(
                _parentSong,
                balanceOf(_admin),
                _kind);
    }
    function getKind() public view returns (string memory){
        return kind;
    }
}


