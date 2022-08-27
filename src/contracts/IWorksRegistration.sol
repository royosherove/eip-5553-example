// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Structs.sol";
import "./BaseMusicRoyaltyToken.sol";
import "./Structs.sol";


interface IWorksRegistration {
    function changeMetadataURI(string memory _newUri, string memory _newFileHash) external ;
    function royaltyTokens() external view returns (address[] memory) ;
    function ledger() external view returns (address) ;

    event MetadaDataChanged(address byAddress,string oldURI, string oldFileHash, string newURI, string newFileHash);
}



