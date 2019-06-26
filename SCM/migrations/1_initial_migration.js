var Migration = artifacts.require("./Migrations.sol")
var Standard = artifacts.require("./Pedido.sol");

module.exports = function(deployer) {
  deployer.deploy(Migration)
};
