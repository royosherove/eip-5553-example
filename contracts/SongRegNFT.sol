// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Structs.sol";
import "./BaseMusicRoyaltyToken.sol";
import "./Structs.sol";


contract SongRegNFT is ERC721 {
    event Minted(
        string  title,
        string indexed iscc,
        address indexed songAddress,
        address indexed creator,
        address owner);
    event RightsDistributed(address creator, address owner, uint amount, string kind);

    using Counters for Counters.Counter;
    Counters.Counter tokenId;
    SongMintingParams public mintParams;
    string public title;
    address public creator;
    address public owner;
    bool private activated =false;
    constructor (
        address _owner,
        address _creator,
        SongMintingParams memory _params
        )
    ERC721(_params.shortName, _params.symbol){
        tokenId.increment();
        creator = _creator;
        owner = _owner;
        _safeMint(_owner, tokenId.current());
        //TODO: handle ISCC
        emit Minted(title,"", address(this),_creator,_owner);
    }
    function isActive() public view returns (bool){
        return activated;
    }

    function Deactivate() public {
        //TODO - require owner?
        activated=false;
    }
    function activate() public {
        //TODO - require owner?
        activated=true;
    }

}



