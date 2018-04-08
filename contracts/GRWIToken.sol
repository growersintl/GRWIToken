pragma solidity ^0.4.19;

import './DividendPayableTokenV2.sol';
contract GRWIToken is DividendPayableTokenV2 {


	string public constant name = "Growers International";
	string public constant symbol = "GRWI";
	uint256 public constant DECIMALS = 8;
	uint256 public constant decimals = 8;
	
	function GRWIToken() DividendPayableTokenV2() public{
	}
	
	function init(address balancer,address swapper) public{
	    
	    if(totalSupply()==0){
    	    mintingFinished = false;
    	    mint(address(swapper),(10**8)*(12*10**5));
    	    mint(address(balancer),(10**8)*(5*10**4));
    	    mintingFinished = true;
	    }
	    else{
	        revert();
	    }
	}
    
}