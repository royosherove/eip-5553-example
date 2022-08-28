// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import "./interfaces/IWorksRegistration.sol";
import "./interfaces/Structs.sol";


contract SongRegistration is ERC721, IWorksRegistration {
    address public songLedger;
    address public compToken;
    address public recToken;
    string public metadataUri;
    uint256 public tokenId;
    bool public activated =false;

    function supportsInterface(bytes4 interfaceId) public view virtual override( ERC721, IERC165) returns (bool) {
        return
            interfaceId == type(IWorksRegistration).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function getInterfaceId() public pure returns (bytes4){
        return type(IWorksRegistration).interfaceId;
    }

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

    function changeMetadataURI(string memory _newUri,string memory _newFileHash) public 
     {
        metadataUri = _newUri; 
        
        emit MetadataChanged("","",_newUri,"");
    }
    
    function metadataURI() public view returns (string memory){
       return metadataUri;
    }
    function royaltyInterestTokens() external view returns (address[] memory) {
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



