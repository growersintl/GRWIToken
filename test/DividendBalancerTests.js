import latestTime from 'zeppelin-solidity/test/helpers/latestTime';
import { advanceBlock } from 'zeppelin-solidity/test/helpers/advanceToBlock';
import { increaseTimeTo, duration } from 'zeppelin-solidity/test/helpers/increaseTime';
const GRWIToken = artifacts.require('GRWIToken');
const DividendBalancer = artifacts.require('DividendBalancer');

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
              data.tokenPromise = GRWIToken.new();
              data.token = await data.tokenPromise;
              data.balancerPromise = DividendBalancer.new(data.token.address);
              data.balancer = await data.balancerPromise;
              data.token.init(data.balancer.address,recipient1);
              data.balancer.init();
              data.startTime = (await data.token.timeStart()).toNumber();
              console.log('Stert time = '+data.startTime);
              await increaseTimeTo(data.startTime+1);
              await data.token.transfer(_,0);
        
          });
          
          
          describe('dividend Release after DIV_PERIOD passed', function () {
            
            it('has correct token address set', async function () {
              
              var expected =  data.token.address;
              var actual =  await data.balancer.getTokenAddress();
              assert.equal(actual,expected);
            });
            
            it('sets desired percentage to 4 percent over 12 months', async function () {
              var level = await data.balancer.desiredDividendLvl();
              var total = await data.token.totalSupply();
              assert.equal(total,125000000000000);
              assert.equal(level,5000000000000);
            
            });
            
            
            it('has balance to support dividend for one year', async function () {
              
              var total = await data.token.balanceOf(data.balancer.address);
              assert.equal(total,5000000000000);
            });
            
            it('it will supply right amount after 73 days (1/5 of a year) if called', async function () {
              
              var time = await latestTime();
              await increaseTimeTo(time);
              var {logs} = await data.balancer.processRequest();
            //  console.log('before:   '+JSON.stringify(logs));
              var divTotalBefore = ( await data.token.totalDividendSum()).toNumber();
              
              await increaseTimeTo(time+3600*24*73);
              
             var {logs} = await data.balancer.processRequest();
              
          //    console.log('after:  '+JSON.stringify(logs));
              
              var divTotalAfter = (await data.token.totalDividendSum()).toNumber();
              console.log(divTotalAfter,divTotalBefore)
              assert.equal((divTotalAfter-divTotalBefore)/1000000000000<1.0001,true);
              assert.equal((divTotalAfter-divTotalBefore)/1000000000000>0.9999,true);
              
            });
            
            
            it('it will supply right amount after 73 days (1/5 of a year) if called by fallback', async function () {
              
              
              var {logs} = await data.balancer.sendTransaction({to:data.balancer.address,
              from:_});
              
              var divTotalBefore = ( await data.token.totalDividendSum()).toNumber();
              
              await increaseTimeTo(latestTime()+3600*24*73);
              
              var {logs} = await  data.balancer.sendTransaction({to:data.balancer.address,
              from:_});
              
              var divTotalAfter = (await data.token.totalDividendSum()).toNumber();
           
              console.log(divTotalAfter,divTotalBefore);
              assert.equal((divTotalAfter-divTotalBefore)/1000000000000<1.0001,true);
              assert.equal((divTotalAfter-divTotalBefore)/1000000000000>0.9999,true);
              
            });
          });    
        
  });
  
  
  
  
  