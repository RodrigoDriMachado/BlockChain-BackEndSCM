pragma solidity ^0.5.0; 
pragma experimental ABIEncoderV2;

import "./Parse.sol";

contract StandardInterface {
	function getAge(string _firebaseId) public view returns(uint age) {}
   	function lookUpId(string _firebaseId) public view returns(bytes serialized) {}
   	function createStandardregistry() public {}
}

contract NotificationsInterface {
	    function sendMessage(string _recipientId, string _senderId, string _text) public {}
}

contract Pedido is Parse {

	address pedidoAddress;
	address fornecedorAddress;
	address itemAddress;
	address notaFiscaladdress;

	struct Fornecedor{
		uint idFornecedor;
		string nomeFornecedor;
		string creationDate;
	}

	struct Item{
		uint idItem;
		string nomeItem;
		string descricao;
		uint valUnitario;
		string creationDate;
	}

	struct NotaFiscal {
		uint idNota;
		uint quantidadeItem;
		uint valorTotal;
		string descricao;
		string creationDate;
		Item[] listaItem;
		Fornecedor[] listaFornecedor;
	}

	struct Pedido {
		uint idPedido;
		string descricaoPedido;
		string tecido;	
		Fornecedor[] listaFornecedor;
		NotaFiscal[] listaNF;
	}

	struct Lista {
		Fornecedor[] listaFornecedores;
		Item[] listaItens;
	}

	mapping(string => Pedido) pedidoRegistries;
    string[] public pedidoRegistriesAccts;

	mapping(string => Fornecedor) fornecedorRegistries;
	string[] public fornecedoRegistriesAccts;

	mapping(string => Item) itemRegistries;
	string[] public itemRegistriesAccts;

	mapping(string => NotaFiscal) notaFsicalRegistries;
	string[] public notaFiscalRegistriesAccts;

	mapping(string => Lista) listaRegistries;
    string[] public listaRegistriesAccts;


	//Varejista
	// metodo para creação de um pedido para fabricação de roupa
	function createPedido (
		string memory _firebaseId,
		string memory _creationDate,
		string memory _descricaoPedido) public returns (bool) {
			
			
			StandardInterface standard = StandardInterface(pedidoAddress);

			if(standard.lookUpId(_firebaseId).length != 0) {
				uint256 creationDate;
				if(bytes(_creationDate).lenght !=0){
					creationDate = getDateAsUnix(_creationDate);
				}
				else creationDate = now;

				Pedido storage registryPedido = pedidoRegistries[_firebaseId];
				registryPedido.descricaoPedido = _descricaoPedido;
				pedidoRegistriesAccts.push(_firebaseId);
				return true;
			}else return false;
	}
	
	//varejista
	// metodo para criação de item que será usado para fabricação no pedido
	function createItem (
		string memory _firebaseId,
		uint _idItem,
		string memory _nomeItem,
		string memory _creationDate,
		string memory _descricao,
		uint _valUnitario) public returns (bool) {

			Item storage registryItem = itemRegistries[_firebaseId];
			Lista storage registryLista = listaRegistries[_firebaseId];

			StandardInterface standard = StandardInterface(itemAddress);

			if(standard.lookUpId(_firebaseId).length != 0) {
				uint256 creationDate;
				if(bytes(_creationDate).lenght != 0){
					creationDate = getDateAsUnix(_creationDate);
				}else creationDate = now;
				registryItem.idItem = _idItem;
				registryItem.nomeItem = _nomeItem;
				registryItem.descricao = _descricao;
				registryItem.valUnitario = _valUnitario;
				itemRegistriesAccts.push(_firebaseId);
				registryLista.listaItens.push(registryItem);
				return true;
			}
			else return false;
	}

	//varejista
	//metodo para cadastrar fornecedores que podem trabalhar em algum pedido
	function createFornecedor (
		string memory _firebaseID,
		uint _idFornecedor,
		string memory _creationDate,
		string memory _nomeFornecedor) public returns (bool){

			Fornecedor storage registryFornecedor = fornecedorRegistries[_firebaseID];
			Lista storage registryLista = listaRegistries[_firebaseID];

			StandardInterface standard = StandardInterface(fornecedorAddress);

			if(standard.lookUpId(_firebaseID).length != 0) {
				uint256 creationDate;
				if(bytes(_creationDate).lenght != 0){
					creationDate = getDateAsUnix(_creationDate);
				}else creationDate = now;
				registryFornecedor.idFornecedor = _idFornecedor;
				registryFornecedor.nomeFornecedor = _nomeFornecedor;
				fornecedoRegistriesAccts.push(_firebaseID);
				registryLista.listaFornecedores.push(registryFornecedor);
				return true;
			}else return false;
	}

	//Fornecedor
	//metodo onde o fornecedor pode criar a nota fiscal do pedido
	function createNotaFiscal (
		string memory _firebaseID,
		uint _idNota,
		string memory _nomeItem,
		string memory _nomeFornecedor,
		string memory _creationDate
		) public returns (bool){

		//	Item _itemNota;
			Fornecedor _fornecedorNota;
			NotaFiscal storage registryNotafiscal = notaFsicalRegistries[_firebaseID];
			registryNotafiscal.idNota = _idNota;
			StandardInterface standard = StandardInterface(notaFiscaladdress);
			if(standard.lookUpId(_firebaseID).length != 0) {
			//	uint256 creationDate;
			//	if(bytes(_creationDate).lenght != 0){
			//		creationDate = getDateAsUnix(_creationDate);
			//	}else creationDate = now;
			registryNotafiscal.descricao = buscaItem(_nomeItem).descricao;
			registryNotafiscal.valorTotal = atualizaValTotal(_idNota);
			bool _itemadd;
			_itemadd = addItemToNF(_firebaseID, _nomeItem);
			notaFiscalRegistriesAccts.push(_fireBaseID);
			return true;
			}
	}

	// Fornecedor
	// Metodo para atualizar informações da nota fiscal do pedido
	function updateNotaFiscal (
		string memory _firebaseID,
		uint _idFornecedor,
		string memory _creationDate,
		string memory _nomeFornecedor) public returns (bool){

            if(notaFsicalRegistries[_firebaseID].creationDate != 0) {
                uint256 creationDate;
				if(bytes(_creationDate).length != 0) {
					creationDate = getDateAsUnix(_creationDate);
				}else creationDate = now;
				uint  valUnit =0 ;
				Fornecedor _fornecedor;
				_fornecedor = buscaFornecedor(_nomeFornecedor);
				notaFsicalRegistries[_firebaseID].valorTotal = atualizaValTotal(notaFsicalRegistries[_firebaseID].idNota);
			}
			return true;
	}

		function addItemToNF (
			string _firebaseID,
			string _nomeItem) public returns (bool){
				notaFsicalRegistries[_firebaseID].listaItem.push(buscaItem(_nomeItem));
				uint _valorTotal;
				_valorTotal = atualizaValTotal(notaFsicalRegistries[_firebaseID].idNota);
				notaFsicalRegistries[_firebaseID].valorTotal = _valorTotal;
		}
	
	function addFornecedorToNF (
		string memory _firebaseID,
		string memory _nomeFornecedor) public{
			notaFsicalRegistries[_firebaseID].listaFornecedor.push(buscaFornecedor(_nomeFornecedor));
		}

		

	function buscaItem(
		string memory _nomeItem) public returns (Item){
		for(uint i=0; I < listaRegistriesAccts.lenght;i++){
			string memory id = listaRegistriesAccts[i];
            Item memory registry = itemRegistries[id];
			if(compareStrings(itemRegistries.nomeItem, _nome)){
					return registry;
				}
			}
			return itemRegistries[1];
		}

	function buscaFornecedor(
		string _nomeFornec) public returns (Fornecedor){
			Fornecedor _fornecedor;
			for(uint i =0; i < listaRegistries.listaFornecedores.lenght(); i++){
				if(compareStrings(listaRegistries.listaFornecedores[i].nomeFornecedor, _nomeFornec)){
					_fornecedor = listaRegistries.listaFornecedores[i];
				}					
			}
				return _fornecedor;
	}

	function atualizaValTotal(uint _idNota) public returns (uint){
		uint _valTotal=0;
		for (int i=0; notaFsicalRegistries.listaItem.lenght();i++){
			if(notaFsicalRegistries.listaItem[i].idNota == _idNota){
				_valTotal += notaFsicalRegistries.listaItem[i].valUnit;
			}
		}
		return _valTotal;
	}

	function addNotaToPedido(string memory _fireBaseID) public {
		NotaFiscal memory _nf;
		_nf = notaFsicalRegistries[_fireBaseID];
		pedidoRegistries.listaNF.push(_nf);
	} 

	 function lookUpId (string _firebaseId) public view returns (bytes serialized) {
        return getBytes(pedidoRegistries[_firebaseId]);
    }

    function lookUpSonsId (uint256 _sonId) public view returns (bytes serialized) {
        return getBytes(pedidoRegistries[_sonId]);
    }

	function getBytes(Fornecedor registry) internal view returns (bytes serialized){
        uint offset = 64*(13);
        bytes memory buffer = new  bytes(offset);

        stringToBytes(offset, bytes(registry.nomeFornecedor), buffer);
        offset -= sizeOfString(registry.nomeFornecedor);

		string memory creationDate = uint2str(registry.creationDate);
        stringToBytes(offset, bytes(creationDate), buffer);
        offset -= sizeOfString(creationDate);

        return (buffer);
    }

	function getBytes(Item registry) internal view returns (bytes serialized){
        uint offset = 64*(13);
        bytes memory buffer = new  bytes(offset);

        stringToBytes(offset, bytes(registry.nomeItem), buffer);
        offset -= sizeOfString(registry.nomeItem);
        
        stringToBytes(offset, bytes(registry.descricao), buffer);
        offset -= sizeOfString(registry.descricao);

        string memory creationDate = uint2str(registry.creationDate);
        stringToBytes(offset, bytes(creationDate), buffer);
        offset -= sizeOfString(creationDate);

        return (buffer);
    }
    
    function getBytes(NotaFiscal registry) internal view returns (bytes serialized){
    	uint offset = 64*(11 + registry.listaItem.length);
        bytes memory buffer = new  bytes(offset);

        for(uint i = 0; i < registry.listaItem.length; i++) {
            string memory sonId = uint2str(registry.listaItem[i]);
            stringToBytes(offset, bytes(sonId), buffer);
            offset -= sizeOfString(sonId);
		}

		offset = 64*(11 + registry.listaFornecedor.lenght);
		buffer = new bytes(offset);

		for(uint b = 0; i < registry.listaFornecedor.length; b++) {
            string memory sonId2 = uint2str(registry.listaFornecedor[b]);
            stringToBytes(offset, bytes(sonId2), buffer);
            offset -= sizeOfString(sonId2);
        }

		string memory creationDate = uint2str(registry.creationDate);
        stringToBytes(offset, bytes(creationDate), buffer);
        offset -= sizeOfString(creationDate);

        return (buffer);
    }

	function getBytes(Pedido registry) internal view returns (bytes serialized){
    	uint offset = 64*(11 + registry.listaItem.length);
        bytes memory buffer = new  bytes(offset);

        for(uint i = 0; i < registry.listaFornecedor.length; i++) {
            string memory sonId = uint2str(registry.listaFornecedor[i]);
            stringToBytes(offset, bytes(sonId), buffer);
            offset -= sizeOfString(sonId);
        }

		offset = 64*(11 + registry.listaNF.lenght);
		buffer = new bytes(offset);
 		
		for(uint b = 0; b < registry.listaNF.length; b++) {
            string memory sonId2 = uint2str(registry.listaNF[b]);
            stringToBytes(offset, bytes(sonId2), buffer);
            offset -= sizeOfString(sonId2);
        }

		stringToBytes(offset, bytes(registry.descricaoPedido), buffer);
        offset -= sizeOfString(registry.descricaoPedido);

        return (buffer);
    }
	
			
}