pragma solidity ^0.4.19;
import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';

contract DividendPayableToken is MintableToken {

    event NewPeriod(uint32 period);
    event AdditionalDividend(uint128 amount,uint32 period);
    event DividendPayed(address to,uint128 amount,uint32 period);
    
    mapping(address=>uint32) userDividendRound;
    uint32 public dividendRound ;
    uint32 public timeStart ;
    uint32 public constant DIV_PERIOD = 3600*24*30 ;
    mapping(uint32=>uint128) public divSums ;
    
    function getDividendSum(uint32 period) constant returns(uint128){
        return divSums[period];
    }
    
  function getNow() public constant returns(uint32){
      return uint32(now);
  }
  
  function computeDividendRound() internal{
      uint32 _time = getNow();
      uint32 newVal = (_time-timeStart)/DIV_PERIOD;
      if(dividendRound!=newVal){
          dividendRound = newVal;
          NewPeriod(dividendRound);
      }
  }
  
  function DividendPayableToken() MintableToken(){
      timeStart = getNow();
  }
  
  function addToDividendSum(uint128 _value) internal{
      uint128 _ds = divSums[dividendRound];
      AdditionalDividend(_value,dividendRound);
      if(_ds == 0){
           divSums[dividendRound] = _value;
      }
      else{
           divSums[dividendRound] = _ds+_value;
      }
  }
  
  function processDividend(address to) internal{
      uint32 _r = userDividendRound[to];
      uint128 amountToPay = 0;
      uint128 tokensHolded = uint128(balanceOf(to));
      if(_r!=dividendRound){
          for(uint32 i=_r;i<dividendRound;i++){      
              uint128 _ds = divSums[i];
              amountToPay = amountToPay + uint128(((uint256(_ds)*uint256(tokensHolded)))/totalSupply());
          }
          if(amountToPay>0){
              if(transfer(to,amountToPay)){
                  DividendPayed(to,amountToPay,dividendRound);
                  userDividendRound[to]=dividendRound;
              }
          }
      }
  }
    
  function transfer(address to,uint256 _value) public returns(bool){
      computeDividendRound(); 
      processDividend(msg.sender);
      if(to==address(this)){
          // add dividendSum 
          addToDividendSum(uint128(_value));
      }
      else{
          processDividend(to);
      }
      return super.transfer(to,_value);
  }
  
  
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    computeDividendRound(); 
    processDividend(msg.sender);
    processDividend(_from);
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