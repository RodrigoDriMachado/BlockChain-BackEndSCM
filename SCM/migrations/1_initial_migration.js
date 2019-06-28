var Migration = artifacts.require("./Migrations.sol")
var Pedido = artifacts.require("./Pedido.sol");
var Standard = artifacts.require("./StandardInterface.sol")


module.exports = function(deployer) {
  deployer.deploy(Migration),
  deployer.deploy(Pedido)
};
