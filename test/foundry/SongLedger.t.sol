// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.15;

import "forge-std/Test.sol";

import "../../contracts/SongLedger.sol";
import "../../contracts/interfaces/Structs.sol";

contract SongLedgerTest is Test {
    event NewSong(
        address songAddress, string shortName, string symbol, address compToken, address recToken, address ledger
    );

    SongLedger internal ledger;

    function setUp() external {
        ledger = new SongLedger(address(this));
    }

    function test_mintSong() external {
        SongMintingParams memory smp = SongMintingParams({
            shortName: "abc",
            fileHash: "",
            symbol: "SONG",
            metadataUri: "meta",
            splits: SplitInfo({compSplits: new SplitTarget[](2), recSplits: new SplitTarget[](2)})
        });
        smp.splits.compSplits[0] = SplitTarget({holderAddress: address(this), amount: 50, memo: ""});
        smp.splits.compSplits[1] = SplitTarget({holderAddress: address(this), amount: 50, memo: ""});
        smp.splits.recSplits[0] = SplitTarget({holderAddress: address(this), amount: 50, memo: ""});
        smp.splits.recSplits[1] = SplitTarget({holderAddress: address(this), amount: 50, memo: ""});

        address newSongAddress = ledger.mintSong(smp);
    }
}
