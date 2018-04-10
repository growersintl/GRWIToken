
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import './DividendToken.sol';

contract DividendBalancer is Ownable {
    
    event DividendSumIncreased(uint256 _from,uint256 _to);
    event DividendBalancerEmpty();
    event DividendBalancerTooSoon();
    event Debug(uint256 _balance,uint256 _divSum, uint256 _desiredSum);
    DividendToken public token ;
    uint256 public desiredDividendLvl;
    uint256 public constant DIV_PERIOD = 3600*24*365;
    uint256 public constant DESIRED_PERCENTAGE = 4;
    
    function DividendBalancer(address _token) public{
        token = DividendToken(_token);    
        desiredDividendLvl = token.totalSupply()*DESIRED_PERCENTAGE/100;
    }
    
    function init() onlyOwner public{
        desiredDividendLvl = token.totalSupply()*DESIRED_PERCENTAGE/100;
    }
    
    function changeLimit(uint256 _d) onlyOwner public{
        desiredDividendLvl = _d;
    }
    
    function getTokenAddress() constant public returns(address){
        return address(token);
    }
    
    function processRequest() public{
    
            if(now>token.timeStart()){
            
                uint256 contractOperationDuration = now - token.timeStart();
                uint256 _balance = uint128(token.balanceOf(address(this)));
                uint256 _divSum = token.totalDividendSum();
                uint256 desiredSum = (desiredDividendLvl*contractOperationDuration)/DIV_PERIOD;
                Debug(_balance,_divSum,desiredSum);
                if(_balance>0){
                    if(_divSum<desiredSum){
                        if(_balance>desiredSum - _divSum){
                            token.transfer(address(token),desiredSum - _divSum);
                            DividendSumIncreased(_divSum,desiredSum);
                        }
                        else{
                            token.transfer(address(token),_balance);
                            DividendSumIncreased(_divSum,_divSum+_balance);
                            DividendBalancerEmpty();
                            
                        }
                    }
                }
                else
                {
                    DividendBalancerEmpty();
                }
                    
            }
            else
                {
                        DividendBalancerTooSoon();
                    }
    }
    
    function () public{
        this.processRequest();
        
    }
}