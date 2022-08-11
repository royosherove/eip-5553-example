import { expect } from "chai";
import { ethers } from "hardhat";
import { SongMintingParamsStruct  } from "../typechain-types/contracts/SongRegNFT";
import { CompositionRoyaltyToken,RecordingRoyaltyToken,RecordingRoyaltyToken__factory,SongRegNFT, SongRegNFT__factory } from "../typechain-types";
import { NewSongEvent, SongLedger } from "../typechain-types/contracts/SongLedger";
import chai from "chai";
import { CompositionRoyaltyToken__factory } from "../typechain-types";
const check = require("./check.js");

describe("Composition", () => {

    it("can deploy song with composition and recording tokens", async function () {
      const [acc0,acc1,acc2,acc3,acc4] = await ethers.getSigners();
      const songLedger = await ethers.getContractFactory("SongLedger");
      const deployedLedger = await songLedger.deploy(acc0.address);
      const mintParams:SongMintingParamsStruct = {
          shortName: "shortName",
          symbol: "SHORT",
          metadataUri: "uri",
          splits:{
            compSplits:[
              { holderAddress: acc2.address, amount: 30, memo:"writer1" },
              { holderAddress: acc3.address, amount: 70, memo:"writer2" },
          ],
            recSplits:[
              { holderAddress: acc2.address, amount: 10, memo:"mastering" },
              { holderAddress: acc3.address, amount: 40, memo:"producer" },
              { holderAddress: acc4.address, amount: 50, memo:"singer" },
            ]
          } ,
      }
      await expect(deployedLedger.mintSong(mintParams))
      .to.emit(deployedLedger,"NewSong");

      const filter = deployedLedger.filters.NewSong();

      const evs = await deployedLedger.queryFilter(filter,0,"latest") as NewSongEvent[];
      const songAddress = evs[0].args.songAddress;
      const compAddress = evs[0].args.compToken;
      const recAddress = evs[0].args.recToken;

      const songContract = SongRegNFT__factory.connect(songAddress,acc0);
      const compContract = CompositionRoyaltyToken__factory.connect(compAddress,acc0);
      const recContract = RecordingRoyaltyToken__factory.connect(recAddress,acc0);

      //song initial data
      expect(await songContract.songLedger()).to.eq(deployedLedger.address);
      expect(await songContract.metadataUri()).to.eq("uri");
      expect(await songContract.name()).to.eq("shortName");
      expect(await songContract.symbol()).to.eq("SHORT");
      expect(await songContract.tokenId()).to.eq(1);
      
      //song points to rec and comp tokens
      expect(await songContract.compToken()).to.eq(compAddress);
      expect(await songContract.recToken()).to.eq(recAddress);
      
      //tokens point to song
      expect(await compContract.parentSong()).to.eq(songAddress);
      expect(await recContract.parentSong()).to.eq(songAddress);

      //token composition splits initial balances
      expect(await compContract.balanceOf(acc2.address)).to.eq(toWei(30));
      expect(await compContract.balanceOf(acc3.address)).to.eq(toWei(70));

      //token recording splits initial balances
      expect(await recContract.balanceOf(acc2.address)).to.eq(toWei(10));
      expect(await recContract.balanceOf(acc3.address)).to.eq(toWei(40));
      expect(await recContract.balanceOf(acc4.address)).to.eq(toWei(50));

      

    });
  });

const toWei = (num:number): any => ethers.BigNumber.from((num * 10 ** 18).toString());


