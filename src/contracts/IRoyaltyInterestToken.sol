// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Structs.sol";
import "./BaseMusicRoyaltyToken.sol";
import "./Structs.sol";


struct Balance {
    address holder;
    uint256 amount;
}
interface IRoyaltyInterestToken {
    function kind() external view returns (string memory) ;
    function max() external view returns (uint256) ;
    function ledger() external view returns (address) ;
    function parentWork() external view returns (address) ;
    function getHolders() external view returns (Balance[] memory) ;

    event MetadaDataChanged(address byAddress,string oldURI, string oldFileHash, string newURI, string newFileHash);
}



