// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.15;

import "forge-std/Test.sol";

import "../../contracts/SongLedger.sol";
import "../../contracts/interfaces/IRoyaltyPortionToken.sol";
import "../../contracts/musical-ip-5553/IIPRepresentation.sol";
import "../../contracts/interfaces/Structs.sol";
import "forge-std/console.sol";


contract SongLedgerTest is Test{
    event NewSong(
        address songAddress, string shortName, string symbol, address compToken, address recToken, address ledger
    );

    SongLedger internal LEDGER;

    function setUp() external {
        LEDGER = new SongLedger(address(this));
    }

    function test_mintSong() external {
        address BOB = vm.addr(1); vm.label(BOB,'bob');
        address MARY = vm.addr(2);vm.label(MARY,'mary');
        address SAM = vm.addr(3);vm.label(SAM,'sam');
        vm.label(address(this),'test contract');
        vm.label(address(LEDGER),'ledger');

        SongMintingParams memory smp = SongMintingParams({
            shortName: "abc",
            fileHash: "",
            symbol: "SONG",
            metadataUri: "meta",
            splits: SplitInfo({compSplits: new SplitTarget[](2), recSplits: new SplitTarget[](2)})
        });
        smp.splits.compSplits[0] = SplitTarget({holderAddress: BOB,amount: 50, memo: ""});
        smp.splits.compSplits[1] = SplitTarget({holderAddress: MARY, amount: 50, memo: ""});
        smp.splits.recSplits[0] = SplitTarget({holderAddress: BOB, amount: 50, memo: ""});
        smp.splits.recSplits[1] = SplitTarget({holderAddress: MARY, amount: 50, memo: ""});

        address newSongAddress = LEDGER.mintSong(smp);
        vm.label(newSongAddress,'newSongAddress');
        IIPRepresentation song = IIPRepresentation(newSongAddress);
        assertEq(song.kind(),"song");

        BaseMusicPortionToken token1 = BaseMusicPortionToken(song.royaltyPortionTokens()[0]);
        assertEq(token1.balanceOf(MARY), 50e18 );
        assertEq(token1.balanceOf(BOB), 50e18 );
        assertEq(token1.balanceOf(address(LEDGER)), 0);
        assertEq(token1.balanceOf(SAM), 0);

        Balance[] memory holdersA = token1.getHolders();
        assertEq(holdersA.length,3);
        assertEq(holdersA[0].holder,address(LEDGER));
        assertEq(holdersA[0].amount,0);

        assertEq(holdersA[1].holder,BOB);
        assertEq(holdersA[1].amount,50e18);

        assertEq(holdersA[2].holder,MARY);
        assertEq(holdersA[2].amount,50e18);

        
        


        vm.prank(BOB);
        token1.transfer(SAM,10e18);

        assertEq(token1.balanceOf(MARY), 50e18 );
        assertEq(token1.balanceOf(BOB), 40e18 );
        assertEq(token1.balanceOf(address(LEDGER)), 0);
        assertEq(token1.balanceOf(SAM), 10e18);
        
        Balance[] memory holdersround2 = token1.getHolders();

        assertEq(holdersround2.length,4);
        assertEq(holdersround2[0].holder,address(LEDGER));
        assertEq(holdersround2[0].amount,0);
        
        assertEq(holdersround2[1].holder,BOB);
        assertEq(holdersround2[1].amount,40e18);
        
        assertEq(holdersround2[2].holder,MARY);
        assertEq(holdersround2[2].amount,50e18);

        assertEq(holdersround2[3].holder,SAM);
        assertEq(holdersround2[3].amount,10e18);


        IRoyaltyPortionToken b = IRoyaltyPortionToken(song.royaltyPortionTokens()[1]);
    }
}
