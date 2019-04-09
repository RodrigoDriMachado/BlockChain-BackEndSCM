var  NotaFiscal = artifacts.require("./NotaFiscal.sol");

module.exports = function(deployer) {
  deployer.deploy(NotaFiscal);
};

module.exports = function(deployer){
	deployer.deploy(Pedido);
};
