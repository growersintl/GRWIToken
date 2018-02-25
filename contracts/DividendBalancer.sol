
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import './DividendToken.sol';

contract DividendBalancer is Ownable {
    
    event DividendSumIncreased(uint256 sum);
    event DividendBalancerEmpty();
    DividendToken public token ;
    uint256 public desiredDividendLvl;
    
    function DividendBalancer(address _token) public{
        token = DividendToken(_token);    
    }
    
    function changeLimit(uint256 _d) onlyOwner{
        desiredDividendLvl = _d;
    }
    
    function () public{
        uint32 _p = token.dividendRound();
        uint128 _divSum = token.getDividendSum(_p);
        uint128 _balance = uint128(token.balanceOf(address(this)));
        if(_balance>0){
            if(_divSum<desiredDividendLvl){
                if(_balance>desiredDividendLvl - _divSum){
                    token.transfer(address(token),desiredDividendLvl - _divSum);
                    DividendSumIncreased(desiredDividendLvl - _divSum);
                }
                else{
                    token.transfer(address(token),_balance);
                    DividendSumIncreased(_balance);
                    DividendBalancerEmpty();
                    
                }
            }
        }
        else
        {
            DividendBalancerEmpty();
        }
    }
}