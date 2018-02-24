
import './../DividendPayableToken.sol';

contract DividendPayableTokenMock is DividendPayableToken {
    function DividendPayableTokenMock(address adr1,address adr2, address adr3, uint256 baseAmount) DividendPayableToken() public {
        mint(adr1,baseAmount*97);
        mint(adr2,baseAmount*2);
        mint(adr3,baseAmount);
        finishMinting();
    }
}