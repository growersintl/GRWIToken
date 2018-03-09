import latestTime from 'zeppelin-solidity/test/helpers/latestTime';
import { advanceBlock } from 'zeppelin-solidity/test/helpers/advanceToBlock';
import { increaseTimeTo, duration } from 'zeppelin-solidity/test/helpers/increaseTime';
const DividendPayableTokenMock = artifacts.require('DividendPayableTokenMock');

  var assertRevert= async function(promise){
      
      try {
        await promise;
        assert.fail('Expected revert not received');
      } catch (error) {
        const revertFound = error.message.search('revert') >= 0;
        assert(revertFound, `Expected "revert", got ${error} instead`);
      }
  }
  
  contract('DividendPayableToken Complex Dividend', function ([_, recipient1, recipient2]) {
       var data = {};
 
          beforeEach(async function () {
              data.startTime = latestTime() + duration.days(1);
              data.tokenPromise = DividendPayableTokenMock.new(_,recipient1,recipient2,10000);
              data.token = await data.tokenPromise;
              await data.token.setNow(data.startTime);
              await data.token.transfer(_,0);
              await data.token.transfer(data.token.address,1000);
        
          });
          
          
          describe('dividend Release after DIV_PERIOD passed', function () {
            it('increases balance of transaction sender', async function () {
              
                var senderOwns = (await data.token.balanceOf(_)).toNumber();
                var recipientOwns = (await data.token.balanceOf(recipient1)).toNumber();
                
                await data.token.transfer(recipient1,0,{from:_});
                
                var senderOwnsAfter = (await data.token.balanceOf(_)).toNumber();
                var recipientOwnsAfter = (await data.token.balanceOf(recipient1)).toNumber();
                console.log(recipientOwnsAfter,recipientOwns);
                assert.isAbove(senderOwnsAfter,senderOwns);
                //checks if increase is proportional to amounts owned
                console.log(senderOwnsAfter,senderOwns);
                assert.equal(recipientOwnsAfter/recipientOwns,senderOwnsAfter/senderOwns);
            });
            
            
            it('increases balance of transaction recipient', async function () {
                var recipientOwns = (await data.token.balanceOf(recipient1)).toNumber();
                await data.token.transfer(recipient1,0,{from:_});
                var recipientOwnsAfter = (await data.token.balanceOf(recipient1)).toNumber();
                console.log(recipientOwnsAfter,recipientOwns);
                assert.isAbove(recipientOwnsAfter,recipientOwns);
            });
          });    
        
  });
  
  
  
  
  