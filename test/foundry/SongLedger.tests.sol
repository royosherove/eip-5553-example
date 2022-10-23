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
    address LEDGER;
    address THIS_CONTRACT = address(this);
    event NewSong(
        address songAddress, string shortName, string symbol, address compToken, address recToken, address ledger
    );

    SongLedger internal ledgerContract;

    function setUp() external {
        ledgerContract = new SongLedger(THIS_CONTRACT);
        LEDGER = address(ledgerContract);


        vm.label(LEDGER,'ledger');
        vm.label(BOB,'bob');
        vm.label(MARY,'mary');
        vm.label(SAM,'sam');
        vm.label(DAVID,'david');
        vm.label(THIS_CONTRACT,'test contract');
    }

    function test_holders() external{
        BaseMusicPortionToken token1 = new BaseMusicPortionToken(address(this),'kind','name','symbol');

        token1.transfer(BOB,10 ether);
        token1.transfer(MARY,20 ether);
        token1.transfer(SAM,30 ether);

        assertEq(token1.balanceOf(BOB), 10 ether );
        assertEq(token1.balanceOf(MARY), 20 ether );
        assertEq(token1.balanceOf(SAM), 30 ether);
        assertEq(token1.balanceOf(DAVID), 0);
        assertEq(token1.balanceOf(THIS_CONTRACT), 40 ether);

        Balance[] memory holdersA = token1.getHolders();
        assertEq(holdersA.length,4);
        assertEq(holdersA[0].holder,THIS_CONTRACT);
        assertEq(holdersA[0].amount,40 ether);

        assertEq(holdersA[1].holder,BOB);
        assertEq(holdersA[1].amount,10 ether);

        assertEq(holdersA[2].holder,MARY);
        assertEq(holdersA[2].amount,20 ether);

        assertEq(holdersA[3].holder,SAM);
        assertEq(holdersA[3].amount,30 ether);

        token1.transfer(DAVID,30 ether);
        assertEq(token1.balanceOf(BOB), 10 ether );
        assertEq(token1.balanceOf(MARY), 20 ether );
        assertEq(token1.balanceOf(SAM), 30 ether);
        assertEq(token1.balanceOf(DAVID), 30 ether);
        assertEq(token1.balanceOf(THIS_CONTRACT), 10 ether);

        Balance[] memory holdersb = token1.getHolders();
        assertEq(holdersb.length,5);
        assertEq(holdersb[0].holder,THIS_CONTRACT);
        assertEq(holdersb[0].amount,10 ether);

        assertEq(holdersb[1].holder,BOB);
        assertEq(holdersb[1].amount,10 ether);

        assertEq(holdersb[2].holder,MARY);
        assertEq(holdersb[2].amount,20 ether);

        assertEq(holdersb[3].holder,SAM);
        assertEq(holdersb[3].amount,30 ether);

        assertEq(holdersb[4].holder,DAVID);
        assertEq(holdersb[4].amount,30 ether);
            
    }

    function test_mintSong() external {
        SongMintingParams memory smp = SongMintingParams({
            shortName: "abc",
            fileHash: "",
            symbol: "SONG",
            metadataUri: "meta",
            splits: SplitInfo({compSplits: new SplitTarget[](2), recSplits: new SplitTarget[](2)})
        });
        smp.splits.compSplits[0] = SplitTarget({holderAddress: BOB,amount: 25, memo: ""});
        smp.splits.compSplits[1] = SplitTarget({holderAddress: MARY, amount: 75, memo: ""});
        smp.splits.recSplits[0] = SplitTarget({holderAddress: BOB, amount: 30, memo: ""});
        smp.splits.recSplits[1] = SplitTarget({holderAddress: MARY, amount: 70, memo: ""});

        address newSongAddress = ledgerContract.mintSong(smp);
        vm.label(newSongAddress,'newSongAddress');
        IIPRepresentation song = IIPRepresentation(newSongAddress);
        assertEq(song.kind(),"song");

        BaseMusicPortionToken token1 = BaseMusicPortionToken(song.royaltyPortionTokens()[0]);
        assertEq(token1.balanceOf(BOB), 25 ether);
        assertEq(token1.balanceOf(MARY), 75 ether);
        assertEq(token1.balanceOf(LEDGER), 0);
        assertEq(token1.balanceOf(SAM), 0);

        BaseMusicPortionToken token2 = BaseMusicPortionToken(song.royaltyPortionTokens()[1]);
        assertEq(token2.balanceOf(BOB), 30 ether);
        assertEq(token2.balanceOf(MARY), 70 ether);
        assertEq(token2.balanceOf(LEDGER), 0);
        assertEq(token2.balanceOf(SAM), 0);

    }
}
