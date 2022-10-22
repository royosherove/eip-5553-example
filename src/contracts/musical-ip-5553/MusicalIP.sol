// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import "./IIPRepresentation.sol";
import "../interfaces/Structs.sol";


contract MusicalIP is ERC721, IIPRepresentation {
    string public kind;
    address public songLedger;
    address public compToken;
    address public recToken;
    string public metadataURI;
    string public fileHash;
    uint256 public tokenId;
    bool public activated =false;

    function supportsInterface(bytes4 interfaceId) public view virtual override( ERC721, IERC165) returns (bool) {
        return
            interfaceId == type(IIPRepresentation).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function getInterfaceId() public pure returns (bytes4){
        return type(IIPRepresentation).interfaceId;
    }

    constructor (
        uint256 _tokenId,
        address _songLedger,
        SongMintingParams memory _params,
        address _compAddress,
        address _recAddress,
        string memory _kind
        )
    ERC721(_params.shortName, _params.symbol){

        songLedger = _songLedger;
        compToken = _compAddress;
        recToken = _recAddress;
        metadataURI = _params.metadataUri;
        fileHash = _params.fileHash;
        tokenId = _tokenId;
        kind= _kind;
        
        _safeMint(_songLedger, _tokenId);
        emit Minted(_params.shortName,_songLedger,_compAddress,_recAddress,_msgSender(),tokenId,_params.metadataUri);
    }

    function changeMetadataURI(string memory _newURI,string memory _newFileHash) public 
     {
        string memory oldURI = metadataURI;
        string memory oldHash = fileHash;
        metadataURI = _newURI; 
        fileHash = _newFileHash;
        
        emit MetadataChanged(oldURI, oldHash,_newURI,_newFileHash);
    }
    
    function royaltyPortionTokens() external view returns (address[] memory) {
        address[] memory items = new address[](2); 
        items[0] = compToken;
        items[1] = recToken;
        return items;
    }
    function ledger() external view returns (address) {
         return songLedger;
    }

    event MetadataChanged(
        string  oldUri, string oldFileHash,
        string  newUri, string newFileHash
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
}



