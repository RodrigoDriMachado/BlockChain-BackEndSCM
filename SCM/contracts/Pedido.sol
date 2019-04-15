pragma solidity ^0.5.0; 

import "./Parse.sol";

contract SCM {

	struct Fornecedor{
		uint idFornecedor;
		string nomeFornecedor;
	}

	struct Item{
		uint idItem;
		string descricao;
		uint valUnitario;
	}

	struct NotaFiscal {
		uint idNota;
		uint valorTotal;
		string creationDate;
		Item[] listaItem;
		Fornecedor[] listaFornecedor;
	}

	struct Pedido {
		uint idItem;
		uint quantidadeItem;
		Item[] listaItemPedido;
		string tecido;
		Fornecedor[] listaFornecedorPedido;
		Notafisca[] listaNF;
		string descricao;
	}

	mapping(string => Pedido) pedidoRegistries;
    string[] public pedidoRegistriesAccts;

	mapping(string => Fornecedor) fornecedorRegistries;
	string[] public fornecedoRegistriesAccts;

	mapping(string => Item) itemRegistries;
	string[] public itemRegistriesAccts;

	mapping(string => NotaFiscal) notaFsicalRegistries;
	string[] public notaFiscalRegistriesAccts;

	function createPedido (
		string memory _firebaseId,
		uint32 _idItem,
		string memory _creationDate,
		uint16 _quantidadeItem,
		Item[] memory _listaItem,
		string memory _tecido,
		Fornecedor[] memory _listaFornecedor,
		string memory _descricao) public returns (bool) {
			
			Pedido storage registryPedido = pedidoRegistries[_firebaseId];
			if(registryPedido.lookUpId(_firebasId).lenght !=0){
				uint256 creationDate;
				if(bytes(_creationDate).lenght != 0){
					creationDate = getDateAsUnix(_creationDate);
				}else creationDate now;

				registryPedido.idItem = _idItem;
				registryPedido.quantidadeItem = _quantidadeItem;
				registryPedido.listaItemPedido = _listaItem;
				registryPedido.tecido = _tecido;
				registryPedido.listaFornecedorPedido = _listaFornecedor;
				registryPedido.descricao = _descricao;
				pedidoRegistriesAccts.push(_firebaseId);

				return true;
			}else return false;
	}
	
	function createItem (
		string memory _firebaseId,
		uint _idItem,
		string memory _creationDate,
		string memory _descricao,
		uint _valUnitario) public returns (bool) {

			Item storage registryItem = itemRegistries[_firebaseId];
			if(registryItem.lookUpId(_firebasId).lenght !=0){
				uint256 creationDate;
				if(bytes(_creationDate).lenght != 0){
					creationDate = getDateAsUnix(_creationDate);
				}
				else creationDate = now;
				registryItem.idItem = _idItem;
				registryItem.descricao = _descricao;
				registryItem.valUnitario = _valUnitario;

				itemRegistriesAccts.push(_firebaseId);
				return true;
			}
			else return false;
	}

	function createFornecedor (
		string memory _firebaseID,
		uint _idFornecedor,
		string memory _creationDate,
		string memory _nomeFornecedor) public returns (bool){

			Fornecedor storage registryFornecedor = fornecedorRegistries[_firebaseID];
			if(registryFornecedor.lookUpId(_firebaseId).length != 0) {
				uint256 creationDate;
				if(bytes(_creationDate).length != 0) {
					creationDate = getDateAsUnix(_creationDate);
				}else creationDate = now;
				registryFornecedor.idFornecedor = _idFornecedor;
				registryFornecedor.nomeFornecedor = _nomeFornecedor;

				fornecedorRegistries.push(_firebasId);
				return true;
			}else return false;
	}

	function createNotaFiscal (
		string memory _firebaseID,
		uint _idNota,
		string memory _nomeItem,
		string memory _nomeFornecedor,
		string memory descricaoItem,
		string memory _creationDate
		) public returns (bool){
			Item _itemNota;
			Fornecedor _fornecedorNota;
			NotaFiscal storage registryNotafiscal = notaFsicalRegistries[_firebaseID];
			registryNotafiscal.idNota = _idNota;
			if(registryNotafiscal.lookUpId(_firebasId).lenght != 0){
				uint256 creationDate;
				if(bytes(_creationDate).length != 0) {
					creationDate = getDateAsUnix(_creationDate);
				}else creationDate = now;
			addItemToNF(_nomeItem);
			_itemNota = buscaItem(_nomeItem);
			registryNotaFiscal.descricaoItem = _nomeItem.descricao;
			atualizaValTotal();
			return true;
			}
	}

	function updateNotaFiscal (
		string memory _firebaseID,
		uint _idFornecedor,
		string memory _nomeFornecedor) public returns (bool){

            uint256 creationDate;
            if(bytes(_creationDate).length != 0) {
                creationDate = getDateAsUnix(_creationDate);
            }else creationDate = now;
			registryNotafiscal.idNota = _idNota;
			registryNotaFiscal.creationDate = now;
			
			for(uint i =0; i < _item.lenght(); i ++){
				uint memory valUnit;
				valUnit = item[i].valUnitario;
				this.valorTotal += valUnit; 
			}
			return true;
	}

	function addItemToNF (
		string memory _item) public returns (bool){
			Item itemTmp;
			itemTmp = buscaItem(item);
			notaFsicalRegistries.listaItem.push(itemTmp);
			atualizaValTotal();
	}
	
	function addFornecedorToNF (
		string memory _firebaseID,
		string memory _nomeFornecedor) public{
			string memory _fornecedorNome = buscaFornecedor(_nomeFornecedor);
			registryNotaFiscal[_firebaseID]._listaFornecedor.push();
			
		}

	function buscaItem(
		uint _firebaseID,
		string memory _nomeItem) public returns (Item){
		Item _itemtmp;
		_temtmp = registryItem[_firebaseID];
		return _itemtmp;
	}

	function buscaFornecedor(
		uint _firebasId,
		string _nomeFornec) public returns (Fornecedor){
		Fornecedor fornec;
		fornec = registryFornecedor[_firebaseID];
	}

	function atualizaValTotal() public {
		uint _valTotal=0;
		for (int i=0; notaFsicalRegistries.listaItem.lenght();i++){
			_valTotal += notaFsicalRegistries.listaItem[i].valUnit;
		}
		notaFiscalRegistries.valorTotal = _valTotal;
	}

	function addnotaToPedido(_fireBaseID) public {
		NotaFiscal _nf;
		nf = registryNotaFiscal[_firebaseID];
		pedidoRegistries.listaNF.push(listaNF);
	} 
	
			
}