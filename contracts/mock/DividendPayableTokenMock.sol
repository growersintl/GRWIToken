pragma solidity ^0.4.19;

import './../GRWIToken.sol';

contract DividendPayableTokenMock is GRWIToken {

    event NewTime(uint32 time);
    event ProcessDividend(address adr,uint32 time,uint32 round);

    function DividendPayableTokenMock(address adr1,address adr2, address adr3, uint256 baseAmount) GRWIToken() public {
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
  
}
