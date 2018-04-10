import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';

contract DividendToken is ERC20Basic {
    uint256 public totalDividendSum ;
    uint256 public timeStart ;
     function transfer(address to,uint256 _value) public returns(bool);
}