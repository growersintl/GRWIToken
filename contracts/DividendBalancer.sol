
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import './DividendToken.sol';

contract DividendBalancer is Ownable {
    
    event DividendSumIncreased(uint256 sum);
    event DividendBalancerEmpty();
    DividendToken public token ;
    uint256 public desiredDividendLvl;
    uint256 public constant DIV_PERIOD = 3600*24*30;
    
    function DividendBalancer(address _token) public{
        token = DividendToken(_token);    
    }
    
    function changeLimit(uint256 _d) onlyOwner{
        desiredDividendLvl = _d;
    }
    
    function () public{
    
        uint256 contractOperationDuration = now - token.timeStart();
        uint256 _balance = uint128(token.balanceOf(address(this)));
        uint256 _divSum = token.totalDividendSum();
        uint256 desiredSum = desiredDividendLvl*((contractOperationDuration)/DIV_PERIOD+1);
        if(_balance>0){
            if(_divSum<desiredSum){
                if(_balance>desiredSum - _divSum){
                    token.transfer(address(token),desiredSum - _divSum);
                    DividendSumIncreased(desiredSum - _divSum);
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