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
    
  function internalTransfer(address to,uint256 value) internal returns(bool){
      require(balanceOf(address(this))>=value);
      balances[address(this)] = balances[address(this)] - value;
      balances[to] = balances[to] + value;
      Transfer(address(this),to,value);
      return true;
  }
    
  function getNow() public constant returns(uint256){
      return now;
  }
  
  
  function getMinimumAmountOfDividend() public constant returns(uint256){
    return 1;
  }
  
  function DividendPayableTokenV2() MintableToken() public{
      timeStart = getNow();
      userSums = new DividendInfoContract();
  }
  
  function clearDividends() public onlyOwner{
      userSums.kill();
      userSums = new DividendInfoContract();
      totalDividendSum = 0;
      totalDividendPayed = 0;
      addToDividendSum(uint128(this.balance));
  }
  
  function addToDividendSum(uint128 _value) internal{
      totalDividendSum = totalDividendSum+_value;
      AdditionalDividend(_value,totalDividendSum);
  }
  
  
  function totalSupplyForDiv() public returns(uint256){
    return totalSupply()-totalDividendPayed-balanceOf(this)  ;
  }
  
  function processDividend(address to) isNotSelf(to) isSupplyNotZero() internal{
      uint256 sumFromWhichUserWasAlreadyPaid = userSums.userDividendPaidSum(to);
      uint128 tokensHolded = uint128(balanceOf(to));
      uint256 amountToPay = (totalDividendSum - sumFromWhichUserWasAlreadyPaid)*tokensHolded/totalSupplyForDiv();
//      Debug(tokensHolded,amountToPay,totalDividendSum,totalSupply());
      if(amountToPay>getMinimumAmountOfDividend()){
        if(internalTransfer(to,amountToPay)){
            DividendPayed(to,amountToPay);
            userSums.setUserDividendPaidSum(to,totalDividendSum);
            totalDividendPayed = totalDividendPayed+amountToPay ;
        }
      }
  }
  
  
  function getAmountToPay(address adr) constant public returns(uint256) {
    uint256 sumFromWhichUserWasAlreadyPaid = userSums.userDividendPaidSum(adr);
      uint128 tokensHolded = uint128(balanceOf(adr));
      uint256 amountToPay = (totalDividendSum - sumFromWhichUserWasAlreadyPaid)*tokensHolded/totalSupplyForDiv();
        
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