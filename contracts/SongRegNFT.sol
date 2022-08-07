// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Structs.sol";
import "./BaseMusicRoyaltyToken.sol";
import "./Structs.sol";


contract SongRegNFT is ERC721 {
    using Counters for Counters.Counter;
    event Minted(
        string  title,
        string indexed iscc,
        address indexed songAddress,
        address indexed creator,
        address owner);
    event RightsDistributed(address creator, address owner, uint amount, string kind);

    string public title;
    string public shortName;
    address public creator;
    address public owner;

    bool private activated =false;
    constructor (
        address _owner,
        address _creator,
        uint256  _tokenId,
        SongMintingParams memory _params
        )
    ERC721(_params.shortName, _params.symbol){
        creator = _creator;
        owner = _owner;
        _safeMint(_owner, _tokenId);
        shortName = _params.shortName;
        //TODO: handle ISCC
        emit Minted(title,"", address(this),_creator,_owner);
    }
    function isActive() public view returns (bool){
        return activated;
    }

    function Deactivate(BaseMusicRoyaltyToken  _royaltyTokenInfo) public {
        _royaltyTokenInfo = _royaltyTokenInfo;
        activated=false;
    }
    function activate(BaseMusicRoyaltyToken  _royaltyTokenInfo) public {
        _royaltyTokenInfo = _royaltyTokenInfo;
        activated=true;
    }

}



