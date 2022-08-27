// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
import '@openzeppelin/contracts/interfaces/IERC165.sol';


///
/// @dev Interface for Simple Works Registration Standard
///
interface IWorksRegistration is IERC165 {
    function changeMetadataURI(string memory _newUri, string memory _newFileHash) external ;
    function royaltyInterestTokens() external view returns (address[] memory) ;
    function ledger() external view returns (address) ;
    function metadataURI() external view returns (string memory) ;

    event MetadaDataChanged(address byAddress,string oldURI, string oldFileHash, string newURI, string newFileHash);
}



