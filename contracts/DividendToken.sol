import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';

contract DividendToken is ERC20Basic {
    function getDividendSum(uint32 period) public constant returns(uint128);
    uint32 public dividendRound ;
    
}