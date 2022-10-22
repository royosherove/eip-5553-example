// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/utils/Counters.sol";
import "./musical-ip-5553/MusicalIP.sol";
import "./CompositionRoyaltyToken.sol";
import "./RecordingRoyaltyToken.sol";


contract SimpleSongLedger is IERC721Receiver {
    using Counters for Counters.Counter;
    Counters.Counter private songIds;
      function onERC721Received(address, address, uint256, bytes calldata) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    function mintSong(SongMintingParams memory _params) public {
        CompositionRoyaltyToken comp = new CompositionRoyaltyToken(address(this),"SONGCOMP","COMP");
        RecordingRoyaltyToken rec = new RecordingRoyaltyToken(address(this),"SONGREC","REC");
        songIds.increment();

        MusicalIP newSong = new MusicalIP(
                                        songIds.current(),
                                        address(this),
                                        _params,
                                        address(comp),
                                        address(rec),
                                        "song"
                                    );
    }
}


