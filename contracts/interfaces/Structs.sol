// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.6;

struct Balance {
    address holder;
    uint256 amount;
}

struct SplitTarget {
    address holderAddress;
    uint256 amount;
    string memo;
}

struct SplitInfo {
    SplitTarget[] compSplits;
    SplitTarget[] recSplits;
}

struct RoyaltyTokenData {
    string name;
    string symbol;
    address tokenAddress;
    string memo;
}

struct SongMintingParams {
    string shortName;
    string fileHash;
    string symbol;
    string metadataUri;
    SplitInfo splits;
}
