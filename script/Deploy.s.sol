// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import {Script} from 'forge-std/Script.sol';
import {SongLedgerTest} from './../test/foundry/SongLedger.tests.sol';


/// @notice A very simple deployment script
contract Deploy is Script {

  /// @notice The main script entrypoint
  function run() external returns (SongLedgerTest test) {
    vm.startBroadcast();
    test = new SongLedgerTest();
    vm.stopBroadcast();
  }
}