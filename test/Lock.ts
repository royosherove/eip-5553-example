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
      const accounts = await ethers.getSigners();
      const songLedger = await ethers.getContractFactory("SongLedger");
      const deployedLedger = await songLedger.deploy(accounts[0].address);
      const mintParams:SongMintingParamsStruct = {
          shortName: "shortName",
          symbol: "SHORT",
          metadataUri: "uri",
          splits:{
            compSplits:[
              { holderAddress: accounts[2].address, amount: 30, memo:"writer1" },
              { holderAddress: accounts[3].address, amount: 70, memo:"writer2" },
          ],
            recSplits:[
              { holderAddress: accounts[2].address, amount: 10, memo:"mastering" },
              { holderAddress: accounts[3].address, amount: 40, memo:"producer" },
              { holderAddress: accounts[4].address, amount: 50, memo:"singer" },
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

      const songContract = SongRegNFT__factory.connect(songAddress,accounts[0]);
      const compContract = CompositionRoyaltyToken__factory.connect(compAddress,accounts[0]);
      const recContract = RecordingRoyaltyToken__factory.connect(recAddress,accounts[0]);

      //song points to rec and comp tokens
      await expect(await songContract.compToken()).to.eq(compAddress);
      await expect(await songContract.recToken()).to.eq(recAddress);
      
      //tokens point to song
      await expect(await compContract.parentSong()).to.eq(songAddress);
      await expect(await recContract.parentSong()).to.eq(songAddress);

      await expect(await recContract.balanceOf(accounts[2].address)).to.eq(ethers.BigNumber.from((30*10**18).toString()));

      

    });
  });

async function getInstanceOf(contractName:string, deployedAddress: string) {
  const compContract = await ethers.getContractFactory(contractName);
  const compInstance = await compContract.attach(deployedAddress);
}

