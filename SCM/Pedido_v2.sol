pragma solidity ^0.4.24; 
pragma experimental ABIEncoderV2;

import "./Parse.sol";

contract Pedido {

	address pedidoAddress;
	address notaFiscaladdress;


	struct NotaFiscal {
		uint idNota;
		string item;
		string descricaoItem;
		uint quantidadeItem;
		uint valorUnitario;
		uint valorTotal;
		uint idPedido;
		uint256 creationDate;
		string origem;
		string destino;		
	}

	struct Pedido {
		uint idPedido;
		string descricaoPedido;
		string tecido;	
		string[] listaFornecedor;
		uint256 creationDate;
		string[] listaNFPedido;
	}

	mapping(string => Pedido) pedidoRegistries;
    string[] public pedidoRegistriesAccts;

	mapping(string => NotaFiscal) notaFsicalRegistries;
	string[] public notaFiscalRegistriesAccts;


	//Varejista
	// metodo para creação de um pedido para fabricação de roupa
	function createPedido (
		string memory _firebaseId,
		uint _idPedido,
		string memory _nomeFornecedor,
		string memory _descricaoPedido) public returns (bool) {
			
				Pedido storage registryPedido = pedidoRegistries[_firebaseId];
				registryPedido.descricaoPedido = _descricaoPedido;
				registryPedido.idPedido = _idPedido;
				registryPedido.listaFornecedor.push(_nomeFornecedor);
				pedidoRegistriesAccts.push(_firebaseId);
				return true;

	}
	
	//Fornecedor
	//metodo onde o fornecedor pode criar a nota fiscal do pedido
	function createNotaFiscal (
		string memory _firebaseID,
		uint _idNota,
		string _item,
		string _descricaoItem,
		uint _quantidadeItem,
		uint _valorUnitario,
		uint _idPedido,
		string memory _origem,
		string memory _destino
		) public returns (bool){
			NotaFiscal storage registryNotafiscal = notaFsicalRegistries[_firebaseID];
			registryNotafiscal.idNota = _idNota;
	
			registryNotafiscal.idNota = _idNota;
			registryNotafiscal.item = _item;
			registryNotafiscal.descricaoItem = _descricaoItem;
			registryNotafiscal.valorUnitario = _valorUnitario;
			registryNotafiscal.quantidadeItem = _quantidadeItem;
			registryNotafiscal.valorTotal = (_quantidadeItem * _valorUnitario);
			registryNotafiscal.idPedido = _idPedido;
			registryNotafiscal.origem = _origem;
			registryNotafiscal.destino = _destino;

			notaFiscalRegistriesAccts.push(_firebaseID);
			return true;
	}

	function addNotaToPedido(
	    string memory _fireBaseIDNota,
	    string memory _firebaseIDPedido) public {
		//NotaFiscal memory  _nf;
		//_nf = notaFsicalRegistries[_fireBaseIDNota] ;
		pedidoRegistries[_firebaseIDPedido].listaNFPedido.push(_fireBaseIDNota);
	} 
	
	
	function getItemNotaPedido(string _fireBaseIDNota) public returns(string){
	    return "teste";
	}
}