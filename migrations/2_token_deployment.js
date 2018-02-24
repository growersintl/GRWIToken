var DividendBalancer = artifacts.require("./DividendBalancer.sol");
var GRWIToken = artifacts.require("./GRWIToken.sol");

module.exports = function(deployer) {
  deployer.deploy(GRWIToken).then(function(){
    GRWIToken.deployed().then(function(token){
      
      console.log('deployed GRWIToken '+token.address);
      deployer.deploy(DividendBalancer,token.address).then(function(){
        DividendBalancer.deployed().then(function(balancer){
          console.log('initialising tokens');
          token.init(balancer.address);
        });
      });
    })
  });/*
  deployer.deploy(GRWIToken);
  DividendBalancer.deployed().then(function(divB){
      console.log("balancer deployed "+divB.address);
      GRWIToken.new(divB.address).then(function(token){
        console.log("balancer deployed "+token.address);
      })
  });*/
};
