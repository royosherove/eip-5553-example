// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Structs.sol";
import "./BaseMusicRoyaltyToken.sol";
import "./SongRegNFT.sol";
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

    event RoyaltyTokenDistributed(
        address songAddress,
        string tokenType,
        address tokenAddress,
        uint amount,
        address receiver
    );

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

    // function mintRoyaltyTokensForSong(
    //     address _songAddress,
    //     string memory _wtokenName,
    //     string memory _wtokenSymbol,
    //     string memory _rtokenName,
    //     string memory _rtokenSymbol
    // )
    // private
    // returns (RoyaltyTokenData memory){
    //     uint256 MINT_AMOUNT = 100*10**18;
    //     // CompositionRoyaltyToken newComp = new CompositionRoyal
    //     // CompositionRoyaltyToken compToken = new CompositionRoyaltyToken();
    //     // CompositionRoyaltyToken = new WriterToken(_songAddress,address(this), MINT_AMOUNT,_wtokenName,_wtokenSymbol);
    //     // RecordingToken newRecordingToken = new RecordingToken(_songAddress,address(this), MINT_AMOUNT,_rtokenName,_rtokenSymbol);

    //     RoyaltyTokenData memory tokens;
    //     // tokens.writerTokenAddress = address(newWriterToken);
    //     // tokens.recordingTokenAddress = address(newRecordingToken);

    //     return tokens;
    // }
        function distribute(
        address _tokenAddress,
        SplitTarget[] memory _targets,
        address _songAddress
    ) private {
        for(uint i=0; i< _targets.length;i++){
            //TODO: Check length, hacker could provide wrong target length in params
            SplitTarget memory targetInfo = _targets[i];
            BaseMusicRoyaltyToken token = BaseMusicRoyaltyToken(_tokenAddress);
            token.transfer(targetInfo.holderAddress, targetInfo.amount * 10**18);
            emit RoyaltyTokenDistributed(
                _songAddress,
                token.getKind(),
                _tokenAddress,
                targetInfo.amount * 10**18,
                targetInfo.holderAddress
            );
        }
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

        SongRegNFT newSong = new SongRegNFT(
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

        // songInitialRoyalties[address(newSong)] = _params.royaltyInfo;
    }
}


