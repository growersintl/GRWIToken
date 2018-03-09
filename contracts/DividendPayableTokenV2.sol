pragma solidity ^0.4.19;
import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';

contract DividendInfoContract is Ownable {
    mapping(address=>uint256) public userDividendPaidSum;
    
    function setUserDividendPaidSum(address user,uint256 val)public onlyOwner{
      userDividendPaidSum[user]=val;
    }
    function  kill() public onlyOwner{
      selfdestruct(owner);
    } 
}

contract DividendPayableTokenV2 is MintableToken {

    event ProcessingDiv(uint32 period,uint256 gas);
    event AdditionalDividend(uint256 valueAdded,uint256 totalSum);
    event Debug(uint256 holded,uint256 toBePaid,uint256 totalDivAmount, uint256 totalAmount);
    event DividendPayed(address to,uint256 amount);
    
    DividendInfoContract internal userSums;
    uint256 public totalDividendSum ;
    uint256 public totalDividendPayed ;
    uint256 public timeStart ;
    
  modifier isNotSelf(address _u){
    if(address(this)!=_u){
      _;
    }
  }
  
  modifier isSupplyNotZero(){
      if(totalSupplyForDiv()>0){
        _;
      }
  }
  
  function resetDividends() public onlyOwner{
      userSums.kill();
      userSums = new DividendInfoContract();
      totalDividendSum = this.balanceOf(this);
      totalDividendPayed = 0;
  }
    
  function getNow() public constant returns(uint32){
      return uint32(now);
  }
  
  function getMinimumAmountOfDividend() public constant returns(uint256){
    return 1;
  }
  
  function DividendPayableTokenV2() MintableToken() public{
      timeStart = getNow();
      userSums = new DividendInfoContract();
  }
  
  function addToDividendSum(uint128 _value) internal{
      totalDividendSum = totalDividendSum+_value;
      AdditionalDividend(_value,totalDividendSum);
  }
  
  
  function totalSupplyForDiv() public returns(uint256){
    return totalSupply()-totalDividendPayed  ;
  }
  
  function processDividend(address to) isNotSelf(to) isSupplyNotZero() internal{
      uint256 sumFromWhichUserWasAlreadyPaid = userSums.userDividendPaidSum(to);
      uint128 tokensHolded = uint128(balanceOf(to));
      uint256 amountToPay = (totalDividendSum - sumFromWhichUserWasAlreadyPaid)*tokensHolded/totalSupplyForDiv();
      if(amountToPay>getMinimumAmountOfDividend()){
        if(this.transfer(to,amountToPay)){
            DividendPayed(to,amountToPay);
            userSums.setUserDividendPaidSum(to,userSums.userDividendPaidSum(to)+amountToPay);
            totalDividendPayed = totalDividendPayed+amountToPay ;
        }
      }
  }
    
  function transfer(address to,uint256 _value) public returns(bool){
      processDividend(msg.sender);
      processDividend(to);
      if(to==address(this)){
          // add dividendSum 
          addToDividendSum(uint128(_value));
      }
      return super.transfer(to,_value);
  }
  
  
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
  
    processDividend(msg.sender);
    processDividend(_from);
    processDividend(_to);
    if(_to==address(this)){
          // add dividendSum 
          addToDividendSum(uint128(_value));
      }
      else{
          processDividend(_to);
      }
    return super.transferFrom( _from, _to, _value);
  }
}