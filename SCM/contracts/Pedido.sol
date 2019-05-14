pragma solidity ^0.5.1;

pragma experimental ABIEncoderV2;

//import "./Parse.sol";

contract Pedido {

	address pedidoAddress;
	address notaFiscaladdress;
    NotaFiscal[] public listaNFPedido;
    Pedido[] public listaPedido;
	Fornecedor[] public listaFornecedor;
    Item[] public listaItem;

    struct Fornecedor{
		uint idFornecedor;
		string nomeFornecedor;
		string emailFornecedor;
		string creationDate;
	}

	struct NotaFiscal {
		uint idNota;
		Item[] listaItem;
		string descricaoItem;
		uint quantidadeItem;
		uint valorUnitario;
		uint valorTotal;
		uint idPedido;
		uint256 creationDate;
		string origem;
		string destino;
	}

	struct Pedido{
		uint idPedido;
		string  descricaoPedido;
		Fornecedor[] fornecedoresPedido;
		NotaFiscal[] nfPeido;
		string tecido;
		uint256 creationDate;
	}

	struct Item{
		uint idItem;
		string nomeItem;
		string descricaoItem;
	}

	mapping(string => Pedido) pedidoRegistries;
    string[] public pedidoRegistriesAccts;

	mapping(string => Item) itemRegistries;
    string[] public itemRegistriesAccts;

	mapping(string => Fornecedor) fornecedorRegistries;
    string[] public fornecedorRegistriesAccts;

	mapping(string => NotaFiscal) notaFsicalRegistries;
	string[] public notaFiscalRegistriesAccts;


	//Varejista
	// metodo para criação de um pedido para fabricação de roupa
	function createPedido (
		string memory _firebaseId,
		string memory _firebaseIdFornecedor,
		uint _idPedido,
		string memory _tecido,
		string memory _descricaoPedido,
		string memory _nomeFornecedor
		) public returns (bool) {
			
				Pedido storage registryPedido = pedidoRegistries[_firebaseId];
				registryPedido.descricaoPedido = _descricaoPedido;
				registryPedido.idPedido = _idPedido;
				registryPedido.tecido = _tecido;
				pedidoRegistriesAccts.push(_firebaseId);
				listaPedido.push(pedidoRegistries[_firebaseId]);
				registryPedido.fornecedoresPedido.push(fornecedorRegistries[_firebaseIdFornecedor]);
				return true;
	}

	//Varejista
	//metodo para cadastro de Fonrnecedor
	function createFornecedor (
		string memory _firebaseID,
		uint _idFornecedor,
		string memory _nomeFornecedor,
		string memory _emailFornecedor) public returns (bool){

			Fornecedor storage registryFornecedor = fornecedorRegistries[_firebaseID];
			registryFornecedor.idFornecedor = _idFornecedor;
		    registryFornecedor.nomeFornecedor = _nomeFornecedor;
			registryFornecedor.emailFornecedor = _emailFornecedor;
			fornecedorRegistriesAccts.push(_firebaseID);
			listaFornecedor.push(fornecedorRegistries[_firebaseID]);
		}
	
	//Varejista
	//Metodo para criação do item
	function createItem (
		string memory _firebaseID,
		uint _idItem,
		string memory _nomeItem,
		string memory _descricaoItem) public returns (bool){

			Item storage registryItem = itemRegistries[_firebaseID];
			registryItem.idItem = _idItem;
		    registryItem.nomeItem = _nomeItem;
			registryItem.descricaoItem = _descricaoItem;
			itemRegistriesAccts.push(_firebaseID);
			listaItem.push(itemRegistries[_firebaseID]);
		}

	function createNotaFiscal (
		string memory _firebaseID,
		uint _idNota,
		uint _idItem,
		string memory _descricaoItem,
		uint _quantidadeItem,
		uint _valorUnitario,
		uint _idPedido,
		string memory _origem,
		string memory _destino
		) public returns (bool){
			
			NotaFiscal storage registryNotafiscal = notaFsicalRegistries[_firebaseID];
			registryNotafiscal.idNota = _idNota;
			for(uint iNota=0; iNota < listaItem.length; iNota ++){
				if(listaItem[iNota].idItem == _idItem){
					registryNotafiscal.descricaoItem = listaItem[iNota].descricaoItem;		
				}
			}
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
	    string memory _fireBaseIDNota, uint _idPedido) public {
	    listaNFPedido.push(notaFsicalRegistries[_fireBaseIDNota]);
	    for(uint i=0; i < listaPedido.length; i++){
	        if(listaPedido[i].idPedido == _idPedido){
	            listaPedido[i].nfPeido.push(notaFsicalRegistries[_fireBaseIDNota]);
	        }
	    }
	}
	

}
