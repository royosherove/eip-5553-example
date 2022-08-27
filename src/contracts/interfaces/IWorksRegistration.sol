// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
import '@openzeppelin/contracts/interfaces/IERC165.sol';


///
/// @dev Interface for Simple Works Registration Standard
///
interface IWorksRegistration is IERC165 {
    
    /// @notice Called with the new uri to an updated metadata file
    /// @param _newUri - the uri pointing to a metadata file (file standard is up to the implementer)
    /// @param _newFileHash - The hash of the new metadata file, for future reference and verification
    function changeMetadataURI(string memory _newUri, string memory _newFileHash) external ;

    /// @return array of addresess of ERC20 tokens representing royalty interest in the work
    /// @dev i.e implementing ERC5501 (IRoyaltyInterestToken interface)
    function royaltyInterestTokens() external view returns (address[] memory) ;

    /// @return the address of the contract or EOA that initialized the work registration
    /// @dev i.e a registery or registrar, to be implemented in the future
    function ledger() external view returns (address) ;

    /// @return the uri of the current metadata file for the work
    function metadataURI() external view returns (string memory) ;

    /// @dev event to be triggered whenever metadata URI is changed
    /// @param byAddress the addresses that triggered this operation
    /// @param oldURI the uri to the old metadata file prior to the change
    /// @param oldFileHash the hash of the old metadata file prior to the change
    /// @param newURI the uri to the new metadata file 
    /// @param newFileHash the hash of the new metadata file 
    event MetadaDataChanged(address byAddress,string oldURI, string oldFileHash, string newURI, string newFileHash);
}



