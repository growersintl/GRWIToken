var DividendBalancer = artifacts.require("./DividendBalancer.sol");
var GRWIToken = artifacts.require("./GRWIToken.sol");

module.exports = function(deployer) {
  deployer.deploy(DividendBalancer);
  deployer.deploy(GRWIToken);
  DividendBalancer.deployed().then(function(divB){
      console.log("balancer deployed "+divB.address);
      GRWIToken.new(divB.address).then(function(token){
        console.log("balancer deployed "+token.address);
      })
  })
};
