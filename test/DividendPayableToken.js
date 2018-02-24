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
  
  contract('DividendPayableTokenMock', function ([_, recipient1, recipient2]) {
       var data = {};
 
          const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000';
          beforeEach(async function () {
              data.startTime = latestTime() + duration.days(1);
              data.token = await DividendPayableTokenMock.new(_,recipient1,recipient2,10000);
          });
                      
          describe('token total supply', function () {
            it('returns the total amount of tokens', async function () {
                var totalSupply = await data.token.totalSupply();
                 assert.equal(totalSupply.toNumber(), 1000000);
            });
          });    
          
          describe('token totalSupply', function () {
            it('user1 has 97%', async function () {
                var supply = await data.token.balanceOf(_);
                 assert.equal(supply.toNumber(), 97*10000);
            });
            it('user2 has 2%', async function () {
                var supply = await data.token.balanceOf(recipient1);
                 assert.equal(supply.toNumber(), 2*10000);
            });
            it('user3 has 1%', async function () {
                var supply = await data.token.balanceOf(recipient2);
                 assert.equal(supply.toNumber(), 1*10000);
            });
            it('do not change on transfer if no dividend',async function(){
                var totalSupply = await data.token.totalSupply();
                data.token.transfer(recipient1,900);
                var totalSupply2 = await data.token.totalSupply();
                 assert.equal(totalSupply.toNumber(), totalSupply2.toNumber());
                
            });
          });
          
          describe('token transfer when no dividend to pay',function() {
              it('fails if user try to send more funds that he owns',async function(){
                var userOwns = (await data.token.balanceOf(_)).toNumber();
                
                var promise = data.token.transfer(recipient1,userOwns+1,{from:_,data:"0x"});
                assertRevert(promise);
              });
              it('do not fail if user try to send all funds that he owns',async function(){
                var userOwns = (await data.token.balanceOf(_)).toNumber();
                
                await data.token.transfer(recipient1,userOwns,{from:_,data:"0x"});
              });
              it('do not fail if user try to send some funds that he owns',async function(){
                var userOwns = (await data.token.balanceOf(_)).toNumber();
                
                await data.token.transfer(recipient1,userOwns/2,{from:_,data:"0x"});
              });
              
              it('cause sender balance to decrease by send amount',async function(){
                var userOwns = (await data.token.balanceOf(_)).toNumber();
                var amount = userOwns/2;
                await data.token.transfer(recipient1,amount,{from:_,data:"0x"});
                var userOwnsAfter = (await data.token.balanceOf(_)).toNumber();
                assert.equal(userOwns, userOwnsAfter+amount);
              });
              
              it('cause recipient balance to increase by send amount',async function(){
                var userOwns = (await data.token.balanceOf(recipient1)).toNumber();
                var amount = userOwns/2;
                await data.token.transfer(recipient1,amount,{from:_,data:"0x"});
                var userOwnsAfter = (await data.token.balanceOf(recipient1)).toNumber();
                 assert.equal(userOwns, userOwnsAfter-amount);
              });
          });
        
        
         describe('fallback function', function(){
            it('it reverts',async function(){
               var promise = data.token.sendTransaction({from:recipient1,data:"0x"});
               assertRevert(promise);
            }); 
         });
  });