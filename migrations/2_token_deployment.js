var DividendBalancer = artifacts.require("./DividendBalancer.sol");
var GRWIToken = artifacts.require("./GRWIToken.sol");

module.exports = function(deployer,network,accounts) {
  deployer.deploy(GRWIToken).then(function(){
    GRWIToken.deployed().then(function(token){
      
      console.log('deployed GRWIToken '+token.address);
      Promise.all([deployer.deploy(DividendBalancer,token.address)]).then(function(){
        DividendBalancer.deployed().then(function(balancer){
          console.log('initialising tokens');
          token.init(balancer.address,accounts[0]);
        });
      });
    })
  });
};
