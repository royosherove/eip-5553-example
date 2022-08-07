// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Structs.sol";
import "./RoyaltyToken.sol";
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
    string public iscc;
    address public creator;
    address public owner;

    Counters.Counter private positiveVotes;
    Counters.Counter private negativeVotes;
    RoyaltyTokenMetadata public royaltyTokenInfo;
    AssetData public audioFull;
    AssetData public audioShort;
    AssetData public image;
    bool private activated =false;
    constructor (
        address _owner,
        address _creator,
        uint256  _tokenId,
        SongMintingParams memory _params
        )
    ERC721(_params.stoken.name, _params.stoken.symbol){
        creator = _creator;
        owner = _owner;
        _safeMint(_owner, _tokenId);
        title = _params.title;
        iscc = _params.iscc;
        audioFull = _params.audioFull;
        audioShort = _params.audioShort;
        image = _params.image;
        //                initialRoyalties = _initialDistro;
        emit Minted(_params.title,_params.iscc, address(this),_creator,_owner);
    }
    function isActive() public view returns (bool){
        return activated;
    }

    function activate(RoyaltyTokenMetadata calldata _royaltyTokenInfo) public {
        //TODO: require owner
        royaltyTokenInfo = _royaltyTokenInfo;
        activated=true;
    }
    //    Counters.Counter private voteIds;

    function getPositiveVotes() public view returns (uint256) {
        return positiveVotes.current();
    }
    function getNegativeVotes() public view returns (uint256){
        return negativeVotes.current();
    }


    //    function addVote(bool value, address voter)  public{
    //        //TODO: check ownership
    //        if(value){
    //            positiveVotes.increment();
    //        }
    //        else{
    //            negativeVotes.increment();
    //        }
    //    }

}


//function setTokens(address _writerToken, address _publisherToken, address _recordingToken){
////require(_msgSender())
//}


