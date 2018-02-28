pragma solidity ^0.4.19;

import './DividendPayableToken.sol';
contract GRWIToken is DividendPayableToken {


	string public constant name = "Growers International";
	string public constant symbol = "GRWI";
	uint256 public constant DECIMALS = 8;
	uint256 public constant decimals = 8;
	
	function GRWIToken() DividendPayableToken() public{
	}
	
	function init(address balancer) public{
	    
	    if(totalSupply()==0){
    	    mintingFinished = false;
    	    mint(address(owner),(10**8)*(12*10**5));
    	    mint(address(balancer),(10**8)*(5*10**5));
    	    mintingFinished = true;
	    }
	    else{
	        revert();
	    }
	}
    
}