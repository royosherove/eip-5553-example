// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IRoyaltyPortionToken.sol";

contract BaseMusicPortionToken is ERC20, IRoyaltyPortionToken {
    event SongBinding(address ledger, address token, address song, uint256 amount, string kind);
    event HolderAdded(address holder, uint256 amount);

    string public kind;
    address public parentWork;
    address public ledger;

    Balance[] public holders;
    mapping(address => uint256) addressLocation;

    function updateBalances(address _address) private {
        if (_address==address(0) ){
            return;
        }
        uint256 foundIndex = addressLocation[address(_address)];
        if ((foundIndex== 0 && holders.length==0) || (foundIndex==0 && holders[0].holder!=_address)){
            uint256 balance = balanceOf(_address);
            
            holders.push(Balance({holder:_address,amount:balance}));
            
            addressLocation[_address] = holders.length-1;//// we do NOT UPDATE ADDRESS INDEXES LATER FOR OTHERS
            emit HolderAdded(_address,balance);
        } else {
            holders[addressLocation[_address]].amount = balanceOf(_address);
        }
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        bool result = super.transfer(to, amount);
        require(result, "transfer failed");
        updateBalances(_msgSender());
        updateBalances(to);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        bool result = super.transferFrom(from, to, amount);
        require(result, "transferFrom failed");
        updateBalances(from);
        updateBalances(to);
        return true;
    }

    constructor(address _ledger, string memory _kind, string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {
        ledger = _ledger;
        kind = _kind;
        _mint(_ledger, 100 * 10 ** 18);
    }

    function max() public pure returns (uint256) {
        return 100;
    }

    function getHolders() public view returns (Balance[] memory) {
        return holders;
    }

    function bindToSong(address _song) public {
        require(_msgSender() == ledger, "only ledger allowed to bind");
        require(parentWork == address(0), "already bound to song");
        require(_song != address(0), "invalid song");
        parentWork = _song;
        emit SongBinding(ledger, address(this), parentWork, balanceOf(ledger), kind);
    }
}
