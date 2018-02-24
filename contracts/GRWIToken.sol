
contract GRWIToken is DividendPayableToken {


	string public constant name = "Test Groweers International";
	string public constant symbol = "TGRWI";
	uint256 public constant DECIMALS = 8;
	uint256 public constant decimals = 8;
	
	function GRWI() DividendPayableToken(){
	}
	
	function init(address balancer) public{
	    
	    if(totalSupply==0){
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