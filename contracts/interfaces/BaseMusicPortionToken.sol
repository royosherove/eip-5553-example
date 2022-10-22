// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import './IRoyaltyPortionToken.sol';

contract BaseMusicPortionToken is ERC20, IRoyaltyPortionToken {
    event SongBinding(address ledger, address token, address song, uint amount, string kind);

    string public kind;
    address public parentWork ;
    address public ledger ;
    
    address public firstHolder ;
    Balance[]  private holders;
    mapping (address => uint256) addressIndexes;

    function updateBalances(address forHolder)  private{
        if (addressIndexes[forHolder] == 0 && forHolder != firstHolder) {
            Balance memory b;
            b.holder = forHolder;
            b.amount = balanceOf(forHolder);
            holders.push(b);
            addressIndexes[forHolder] = holders.length-1;
            firstHolder = holders[0].holder; // prevents an if at the start of the function and in this line.
        }else{
            holders[addressIndexes[forHolder]].amount = balanceOf(forHolder);
        }
    }
    function transfer(address to, uint256 amount) override public returns (bool) {
        bool result = super.transfer(to,amount);
        require(result, "transfer failed");
        updateBalances(to);
        return true;
    }
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        bool result = super.transferFrom(from,to,amount);
        require(result,"transferFrom failed");
        updateBalances(from);
        updateBalances(to);
        return true;
    }

    constructor (
        address _ledger,
        string memory _kind,
        string memory _name,
        string memory _symbol) ERC20(_name, _symbol){
            ledger = _ledger;
            kind = _kind;
            _mint(_ledger,100 * 10 **18);

    }

    function max() public pure returns (uint256){
        return 100;
    }
    function getHolders() public view returns (Balance[] memory){
        return holders;
    }
    function bindToSong(address _song) public {
        require(_msgSender() == ledger, "only ledger allowed to bind");
        require(parentWork == address(0),"already bound to song" );
        require(_song != address(0),"invalid song" );
        parentWork = _song;
            emit SongBinding(
                    ledger,
                    address(this), 
                    parentWork,
                    balanceOf(ledger),
                    kind);
    }
}


