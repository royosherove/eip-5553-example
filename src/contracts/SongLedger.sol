// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Structs.sol";
import "./BaseMusicRoyaltyToken.sol";
import "./SongRegistration.sol";
import "./CompositionRoyaltyToken.sol";
import "./RecordingRoyaltyToken.sol";
import "./Structs.sol";


contract SongLedger is IERC721Receiver {
    using Counters for Counters.Counter;
    Counters.Counter private songIds;
    mapping(uint => address) private minterBySongId;
    mapping(uint => address) private songAddressBySongId;
    address public owner;
    string public ledgerName;


      function onERC721Received(address, address, uint256, bytes calldata) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    modifier onlyOwner {
        require( msg.sender == owner, "OW1");
        _;
    }

    constructor(address _owner){
       owner = _owner;
    }


    function mintSong(SongMintingParams memory _params) public onlyOwner {
        string memory compName = string(abi.encode("Composition Royalties for ",_params.shortName));
        string memory compSymbol = string(abi.encode("comp-",_params.symbol));
        
        string memory recName = string(abi.encode("Recording Royalties for ",_params.shortName));
        string memory recSymbol = string(abi.encode("rec-",_params.symbol));


        CompositionRoyaltyToken comp = new CompositionRoyaltyToken(address(this),compName,compSymbol);
        RecordingRoyaltyToken rec = new RecordingRoyaltyToken(address(this),recName,recSymbol);
        songIds.increment();
        uint256 newId = songIds.current();

        SongRegistration newSong = new SongRegistration(
                                        newId,
                                        address(this),
                                        _params,
                                        address(comp),
                                        address(rec)
                                    );

        comp.bindToSong(address(newSong));
        distribute(address(comp),_params.splits.compSplits,address(newSong));
        
        rec.bindToSong(address(newSong));
        distribute(address(rec),_params.splits.recSplits,address(newSong));

        emit NewSong(address(newSong), _params.shortName,_params.symbol,address(comp), address(rec), address(this));

        // songInitialRoyalties[address(newSong)] = _params.royaltyInfo;
    }
    function distribute(
            address _tokenAddress,
            SplitTarget[] memory _targets,
            address _songAddress
        ) private  {

        BaseMusicRoyaltyToken token = BaseMusicRoyaltyToken(_tokenAddress);
        for(uint i=0; i< _targets.length;i++){
            SplitTarget memory targetInfo = _targets[i];
            token.increaseAllowance(address(this),targetInfo.amount * 10**18);
            token.transferFrom(address(this),targetInfo.holderAddress, targetInfo.amount * 10**18);
            emit RoyaltyTokenDistributed(
                _songAddress,
                token.getKind(),
                _tokenAddress,
                targetInfo.amount * 10**18,
                targetInfo.holderAddress
            );
        }
    }
    event RoyaltyTokenDistributed(
        address songAddress,
        string tokenType,
        address tokenAddress,
        uint amount,
        address receiver
    );
    event NewSong(
        address songAddress,
        string shortName,
        string symbol,
        address compToken,
        address recToken,
        address ledger
    );
    
}


