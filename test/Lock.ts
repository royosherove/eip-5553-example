import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { SongMintingParamsStruct, SongRegNFT } from "../typechain-types/contracts/SongRegNFT";
import chai from "chai";

describe("Composition", () => {

    // We define a fixture to reuse the same setup in every test.
    // We use loadFixture to run this setup once, snapshot that state,
    // and reset Hardhat Network to that snapshopt in every test.
    async function deploySong(): Promise<SongRegNFT> {
      const [owner, otherAccount] = await ethers.getSigners();

      const CompositionRoyaltyToken = await ethers.getContractFactory("CompositionRoyaltyToken");
      const compToken = await CompositionRoyaltyToken.deploy(owner.address, "compToken", "Comp1");

      const RecordingRoyaltyToken = await ethers.getContractFactory("RecordingRoyaltyToken");
      const recToken = await RecordingRoyaltyToken.deploy(owner.address, "recToken", "Rec1");

      const SongRegNFT = await ethers.getContractFactory("SongRegNFT");
      const songMintingParams: SongMintingParamsStruct = {
        shortName: "shortName",
        metadataUri: "",
        symbol: "",
        compToken: {
          name: compToken.name(),
          symbol: compToken.symbol(),
          tokenAddress: compToken.address,
          memo: "memo composition",
        },
        recToken: {
          name: recToken.name(),
          symbol: recToken.symbol(),
          tokenAddress: recToken.address,
          memo: "memo recording",
        },
        royaltyInfo: {
          compositionSplits: [
            { holderAddress: owner.address, amount: 50, memo: "" },
            { holderAddress: otherAccount.address, amount: 50, memo: "" },
          ],
          recordingSplits: [
            { holderAddress: owner.address, amount: 80, memo: "" },
            { holderAddress: otherAccount.address, amount: 20, memo: "" },
          ],
        },
      };

      const song = await SongRegNFT.deploy(
        owner.address,
        owner.address,
        songMintingParams
      );

      return song;

    }

    it("deploy song with composition and recording tokens", async function () {
      const song:SongRegNFT = await deploySong();
      const params = await song.mintParams()

      const CompositionRoyaltyToken = await ethers.getContractFactory("CompositionRoyaltyToken");
      const RecordingRoyaltyToken = await ethers.getContractFactory("RecordingRoyaltyToken");

      const compToken =  CompositionRoyaltyToken.attach(params.compToken.tokenAddress);
      const recToken = RecordingRoyaltyToken.attach(params.recToken.tokenAddress);

      expect(await compToken.parentSong()).to.eq(song.address)
    });
  });
