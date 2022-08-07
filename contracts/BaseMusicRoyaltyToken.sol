// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract BaseMusicRoyaltyToken is ERC20 {
    event RoyaltyMinted(address song, uint amount, string kind);

    address public admin;
    string public kind;
    address public parentSong ;
    constructor (
        address _admin,
        string memory _kind,
        string memory _name,
        string memory _symbol) ERC20(_name, _symbol){
            _mint(_admin,100);
            kind = _kind;
            admin = _admin;

    }
    function bindToSong(address _song) public {
        require(parentSong == address(0),"already bound to song" );
        require(_song != address(0),"invalid song" );
        parentSong = _song;
            emit RoyaltyMinted(
                        parentSong,
                        balanceOf(admin),
                        kind);
    }
    function getKind() public view returns (string memory){
        return kind;
    }
}


