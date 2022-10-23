// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.15;

import "forge-std/Test.sol";

import "../../contracts/SongLedger.sol";
import "../../contracts/interfaces/IRoyaltyPortionToken.sol";
import "../../contracts/musical-ip-5553/IIPRepresentation.sol";
import "../../contracts/interfaces/Structs.sol";
import "forge-std/console.sol";


contract SongLedgerTest is Test{
    address BOB = vm.addr(1); 
    address MARY = vm.addr(2);
    address SAM = vm.addr(3);
    address DAVID = vm.addr(4);
    event NewSong(
        address songAddress, string shortName, string symbol, address compToken, address recToken, address ledger
    );

    SongLedger internal LEDGER;

    function setUp() external {
        LEDGER = new SongLedger(address(this));

        vm.label(address(LEDGER),'ledger');
        vm.label(BOB,'bob');
        vm.label(MARY,'mary');
        vm.label(SAM,'sam');
        vm.label(DAVID,'david');
        vm.label(address(this),'test contract');
    }

    function test_holders() external{
        BaseMusicPortionToken token1 = new BaseMusicPortionToken(address(this),'kind','name','symbol');

        token1.transfer(BOB,10e18);
        token1.transfer(MARY,20e18);
        token1.transfer(SAM,30e18);

        assertEq(token1.balanceOf(BOB), 10e18 );
        assertEq(token1.balanceOf(MARY), 20e18 );
        assertEq(token1.balanceOf(SAM), 30e18);
        assertEq(token1.balanceOf(DAVID), 0);
        assertEq(token1.balanceOf(address(this)), 40e18);

        Balance[] memory holdersA = token1.getHolders();
        assertEq(holdersA.length,4);
        assertEq(holdersA[0].holder,address(this));
        assertEq(holdersA[0].amount,40e18);

        assertEq(holdersA[1].holder,BOB);
        assertEq(holdersA[1].amount,10e18);

        assertEq(holdersA[2].holder,MARY);
        assertEq(holdersA[2].amount,20e18);

        assertEq(holdersA[3].holder,SAM);
        assertEq(holdersA[3].amount,30e18);

        token1.transfer(DAVID,30e18);
        assertEq(token1.balanceOf(BOB), 10e18 );
        assertEq(token1.balanceOf(MARY), 20e18 );
        assertEq(token1.balanceOf(SAM), 30e18);
        assertEq(token1.balanceOf(DAVID), 30e18);
        assertEq(token1.balanceOf(address(this)), 10e18);

        Balance[] memory holdersb = token1.getHolders();
        assertEq(holdersb.length,5);
        assertEq(holdersb[0].holder,address(this));
        assertEq(holdersb[0].amount,10e18);

        assertEq(holdersb[1].holder,BOB);
        assertEq(holdersb[1].amount,10e18);

        assertEq(holdersb[2].holder,MARY);
        assertEq(holdersb[2].amount,20e18);

        assertEq(holdersb[3].holder,SAM);
        assertEq(holdersb[3].amount,30e18);

        assertEq(holdersb[4].holder,DAVID);
        assertEq(holdersb[4].amount,30e18);
            
    }

    function test_mintSong() external {
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

    }
}
