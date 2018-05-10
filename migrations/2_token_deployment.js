var DividendBalancer = artifacts.require("./DividendBalancer.sol");
var GRWIToken = artifacts.require("./GRWIToken.sol");

module.exports = function(deployer,network,accounts) {
  deployer.deploy(GRWIToken).then(function(){
    GRWIToken.deployed().then(function(token){
      
      console.log('deployed GRWIToken '+token.address);
      Promise.all([deployer.deploy(DividendBalancer,token.address),token.init()]).then(function(){
        DividendBalancer.deployed().then(function(balancer){
          console.log('initialising tokens');
          return balancer.init().then(function(){
            console.log('supplying tokens to balancer from '+accounts[0]);
            return token.transfer(balancer.address,"5000000000000").then(function(){
              console.log('supplying tokens done');
            });
          });
        });
      });
    })
  });
};
