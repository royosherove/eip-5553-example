// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.6;

    struct Dist{
        address holderAddress;
        uint amount;
        string memo;
    }

    struct DistroList{
        uint writerHoldersCount;
        uint recordingHoldersCount;
        //            Dist[] pubRoyalties;
        Dist[] writerRoyalties;
        Dist[] recordingRoyalties;
    }
    struct SingleTokenData{
        string name;
        string symbol;
        string memo;
    }
    struct AssetData {
        string name;
        string location;
        string memo;
    }
    struct SongMintingParams{
        string  title;
        string  iscc;
        AssetData audioFull;
        AssetData audioShort;
        AssetData image;
        DistroList royaltyInfo;
        SingleTokenData stoken;//song token
        SingleTokenData wtoken; //writer
        SingleTokenData rtoken; //recording
    }
    struct RoyaltyTokenMetadata {
        address writerTokenAddress;
        address recordingTokenAddress;
    }

