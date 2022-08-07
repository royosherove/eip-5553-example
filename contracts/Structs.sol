// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.6;

    struct InitialSplitTarget{
        address holderAddress;
        uint amount;
        string memo;
    }

    struct InitialSplit{
        InitialSplitTarget[] compositionSplits;
        InitialSplitTarget[] recordingSplits;
    }
    struct RoyaltyTokenData{
        string name;
        string symbol;
        address tokenAddress;
        string memo;
    }
    struct SongMintingParams{
        string  shortName;
        string  symbol;
        string  metadataUri;
        InitialSplit royaltyInfo;
        RoyaltyTokenData compToken; 
        RoyaltyTokenData recToken; 
    }

