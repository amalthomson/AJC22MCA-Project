const UserDetailsContract = artifacts.require("UserDetailsContract");

module.exports = function(deployer) {
  deployer.deploy(UserDetailsContract);
};
