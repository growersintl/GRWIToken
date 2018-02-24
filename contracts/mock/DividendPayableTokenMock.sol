pragma solidity ^0.4.19;

import './../DividendPayableToken.sol';

contract DividendPayableTokenMock is DividendPayableToken {

    event NewTime(uint32 time);
    event ProcessDividend(address adr,uint32 time,uint32 round);

    function DividendPayableTokenMock(address adr1,address adr2, address adr3, uint256 baseAmount) DividendPayableToken() public {
        mint(adr1,baseAmount*97);
        mint(adr2,baseAmount*2);
        mint(adr3,baseAmount);
        finishMinting();
    }
    
    
  uint32 public _now ;
  
  function getNow() public constant returns(uint32){
      return uint32(_now);
  }
    
  function setNow(uint32 _n) public{
      _now = _n;
      NewTime(_now);
  }
    
  function addToNow(uint32 _n) public{
      _now = _now+_n;
      NewTime(_now);
  }
  
  function processDividend(address to) internal{
    ProcessDividend(to,_now,dividendRound);
    super.processDividend(to);
  }
  
  function updatePeriod(address to) public{
    userDividendRound[to] = dividendRound;
  }
  function getUserDivRound(address u) public constant returns(uint32){
    return userDividendRound[u];
  }
  function runComputeDividendRound() public{
    super.computeDividendRound();
  }
}
