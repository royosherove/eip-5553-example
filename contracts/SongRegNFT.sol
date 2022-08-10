// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Structs.sol";
import "./BaseMusicRoyaltyToken.sol";
import "./Structs.sol";


contract SongRegNFT is ERC721 {
    address public songLedger;
    address public compToken;
    address public recToken;
    string public metadataUri;
    uint256 public tokenId;
    bool public activated =false;

    constructor (
        uint256 _tokenId,
        address _songLedger,
        SongMintingParams memory _params,
        address _compAddress,
        address _recAddress
        )
    ERC721(_params.shortName, _params.symbol){

        songLedger = _songLedger;
        compToken = _compAddress;
        recToken = _recAddress;
        metadataUri = _params.metadataUri;
        tokenId = _tokenId;
        
        _safeMint(_songLedger, _tokenId);
        emit Minted(_params.shortName,_songLedger,_compAddress,_recAddress,_msgSender(),tokenId,_params.metadataUri);
    }

    function changeUri(string memory _newUri) public 
    onlyLedger {
        metadataUri = _newUri; 
        
        emit UriChanged(_newUri);
    }
    
    function tokenUri() public view returns (string memory){
       return metadataUri;
    }

    event UriChanged(
        string  newUri
        );
    event Minted(
        string  abbvName,
        address ledger,
        address compToken,
        address recToken,
        address creator,
        uint256 tokenId,
        string metadataUri
        );

    modifier onlyLedger {
        require( _msgSender() == songLedger, "Operation requires ledger contract");
        _;
    }

    function Deactivate() public
    onlyLedger {
        activated=false;
    }
    function activate() public 
    onlyLedger {
        activated=true;
    }

}



