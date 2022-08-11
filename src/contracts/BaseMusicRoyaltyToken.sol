// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract BaseMusicRoyaltyToken is ERC20 {
    event SongBinding(address ledger, address token, address song, uint amount, string kind);

    string public kind;
    address public parentSong ;
    address public ledger ;
    constructor (
        address _ledger,
        string memory _kind,
        string memory _name,
        string memory _symbol) ERC20(_name, _symbol){
            ledger = _ledger;
            kind = _kind;
            _mint(_ledger,100 * 10 **18);

    }
    function bindToSong(address _song) public {
        require(_msgSender() == ledger, "only ledger allowed to bind");
        require(parentSong == address(0),"already bound to song" );
        require(_song != address(0),"invalid song" );
        parentSong = _song;
            emit SongBinding(
                    ledger,
                    address(this), 
                    parentSong,
                    balanceOf(ledger),
                    kind);
    }
    function getKind() public view returns (string memory){
        return kind;
    }
}


