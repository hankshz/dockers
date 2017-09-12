var Betting = artifacts.require("./Betting.sol");

module.exports = function(deployer) {
	deployer.deploy(Betting, 0, 5);
};
