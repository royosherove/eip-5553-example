import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { SongMintingParamsStruct, SongRegNFT } from "../typechain-types/contracts/SongRegNFT";
import chai from "chai";
import { CompositionRoyaltyToken, RecordingRoyaltyToken, SongRegNFT__factory } from "../typechain-types";

describe("Composition", () => {

    // We define a fixture to reuse the same setup in every test.
    // We use loadFixture to run this setup once, snapshot that state,
    // and reset Hardhat Network to that snapshopt in every test.
    // async function deploySong(){
    //   const [owner, otherAccount] = await ethers.getSigners();

    //   const CompositionRoyaltyToken = await ethers.getContractFactory("CompositionRoyaltyToken");
    //   const compToken = await CompositionRoyaltyToken.deploy(owner.address, "compToken", "Comp1");
    //   const compTokenDeployed = await compToken.deployed()

    //   const RecordingRoyaltyToken = await ethers.getContractFactory("RecordingRoyaltyToken");
    //   const recToken = await RecordingRoyaltyToken.deploy(owner.address, "recToken", "Rec1");
    //   const recTokenDeployed = await recToken.deployed();

    //   const SongRegNFT = await ethers.getContractFactory("SongRegNFT");
    //   const songMintingParams: SongMintingParamsStruct = {
    //     shortName: "shortName",
    //     metadataUri: "",
    //     symbol: "",
    //     compToken: {
    //       name: compTokenDeployed.name(),
    //       symbol: compTokenDeployed.symbol(),
    //       tokenAddress: compTokenDeployed.address,
    //       memo: "memo composition",
    //     },
    //     recToken: {
    //       name: recTokenDeployed.name(),
    //       symbol: recTokenDeployed.symbol(),
    //       tokenAddress: recTokenDeployed.address,
    //       memo: "memo recording",
    //     },
    //     royaltyInfo: {
    //       compositionSplits: [
    //         { holderAddress: owner.address, amount: 50, memo: "" },
    //         { holderAddress: otherAccount.address, amount: 50, memo: "" },
    //       ],
    //       recordingSplits: [
    //         { holderAddress: owner.address, amount: 80, memo: "" },
    //         { holderAddress: otherAccount.address, amount: 20, memo: "" },
    //       ],
    //     },
    //   };

    //   const song = await SongRegNFT.deploy(
    //     owner.address,
    //     owner.address,
    //     songMintingParams
    //   );

    //   return {song,compToken,recToken};

    // }

    it("deploy song with composition and recording tokens", async function () {
      const accounts = await ethers.getSigners();
      const songLedger = await ethers.getContractFactory("SongLedger");
      const deployedLedger = await songLedger.deploy(accounts[0].address);
      const mintParams:SongMintingParamsStruct = {
          shortName: "shortName",
          symbol: "SHORT",
          metadataUri: "uri",
          splits:{
            compSplits:[],
            recSplits:[]
          } ,
      }
      const songRegNftType = await ethers.getContractFactory("SongRegNFT");
      await deployedLedger.mintSong(mintParams);
      // const params = await song.mintParams()

      // expect(await song.title()).to.eq("shortName")
      // expect( compToken.address).to.eq(params.compToken.tokenAddress)
      // expect(await compToken.parentSong()).to.eq(song.address)
    });
  });
