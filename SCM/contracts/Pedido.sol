pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./Parse.sol";

contract StandardInterface {
    function lookUpId(string memory _firebaseId) public view returns(bytes memory serialized) {}
}

contract Pedido is Parse {

	address pedidoAddress;
	address notaFiscaladdress;
	address itemAddress;
	address fornecedorAddress;
    NotaFiscal[] public listaNF;
    Pedido[] public listaPedido;
	Fornecedor[] public listaFornecedor;
    Item[] public listaItem;

    struct Fornecedor{
	//	uint256 idFornecedor;
		string nomeFornecedor;
		string emailFornecedor;
		string tipoFornecedor;
	}

	struct NotaFiscal {
		uint idNota;
		string nomeItem;
		string descricaoItem;
		uint quantidadeItem;
		uint valorUnitario;
		uint valorTotal;
		uint idPedido;
		string origem;
		string destino;
		string tipoNotafiscal;
	}

	struct Pedido{
		uint idPedido;
		string  descricaoPedido;
		Fornecedor fornecedor;
		NotaFiscal[] listaNFPedido;
		string nomeFornecedor;
		string nomeSubfornecedor;
		uint idNotaFiscal;
		string nomeItem;
		string tipoPedido;
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
		uint _idPedido,
		string memory _item,
		string memory _descricaoPedido,
		string memory _tipoPedido,
		string memory _nomeFornecedor
		) public returns (bool) {

			Pedido storage registryPedido = pedidoRegistries[_firebaseId];
			//VALIDA SE O TIPO DE PEDIDO E MATERIA PRIMA
			if(compareStrings("materia prima",_tipoPedido)){
				//SE FOR, VERIFICAR SE O FORNECEDOR É O FABRICANTE
				for(uint ip1=0; ip1 < listaFornecedor.length; ip1++){
					if(compareStrings(listaFornecedor[ip1].nomeFornecedor, _nomeFornecedor)){
						if(compareStrings(listaFornecedor[ip1].tipoFornecedor, "fabricante")){
							registryPedido.nomeFornecedor = listaFornecedor[ip1].nomeFornecedor;
						}
						else return false;
					}
				}
				//VALIDA SE O ITEM JA ESTA CADASTRADO
				for(uint ip2=0;ip2<listaItem.length;ip2++){
					if(compareStrings(listaItem[ip2].nomeItem, _item)){
						registryPedido.nomeItem = _item;
					}
				}
			}

			//VALIDA SE O TIPO DE PEDIDO E PRODUCAO
			else if(compareStrings("producao",_tipoPedido)){
				//SE FOR, VERIFICAR SE O FORNECEDOR É O SUBFORNECEDOR
				for(uint ip3; ip3 < listaFornecedor.length; ip3++){
					if(compareStrings(listaFornecedor[ip3].nomeFornecedor, _nomeFornecedor)){
						if(compareStrings(listaFornecedor[ip3].tipoFornecedor, "subfornecedor")){
							registryPedido.nomeFornecedor = listaFornecedor[ip3].nomeFornecedor;
						}
						else return false;
					}
				}
				//VALIDA SE O ITEM JA ESTA CADASTRADO
				for(uint ip4=0;ip4<listaItem.length;ip4++){
					if(compareStrings(listaItem[ip4].nomeItem, _item)){
						registryPedido.nomeItem = _item;
					}
				}
			}

			//VALIDA SE O TIPO DE PEDIDO E DE CONFECCAO
			else if(compareStrings("confecao",_tipoPedido)){
				//SE FOR, VERIFICAR SE O FORNECEDOR É O FORNECEDOR
				for(uint ip5; ip5 < listaFornecedor.length; ip5++){
					if(compareStrings(listaFornecedor[ip5].nomeFornecedor, _nomeFornecedor)){
						if(compareStrings(listaFornecedor[ip5].tipoFornecedor, "fornecedor")){
							registryPedido.fornecedor = listaFornecedor[ip5];
						}
						else return false;
					}
				}
				//VALIDA SE O ITEM JA ESTA CADASTRADO
				for(uint ip6=0;ip6<listaItem.length;ip6++){
					if(compareStrings(listaItem[ip6].nomeItem, _item)){
						registryPedido.nomeItem = _item;
					}
				}
				//CADASTRA O RESTANTE DOS DADOS DE PEDIDO
				registryPedido.descricaoPedido = _descricaoPedido;
				registryPedido.idPedido = _idPedido;
				pedidoRegistriesAccts.push(_firebaseId);
				listaPedido.push(pedidoRegistries[_firebaseId]);
			}

			//CADASTRA O RESTANTE DOS DADOS DE PEDIDO
				registryPedido.descricaoPedido = _descricaoPedido;
				registryPedido.idPedido = _idPedido;
				registryPedido.tipoPedido = _tipoPedido;
				pedidoRegistriesAccts.push(_firebaseId);
				listaPedido.push(pedidoRegistries[_firebaseId]);

		return true;
	}

	//Varejista
	//metodo para cadastro de Fonrnecedor
	function createFornecedor (
		string memory _firebaseID,
		//uint _idFornecedor,
		string memory _nomeFornecedor,
		string memory _tipoFornecedor,
		string memory _emailFornecedor) public returns (bool){

			Fornecedor storage registryFornecedor = fornecedorRegistries[_firebaseID];
			//registryFornecedor.idFornecedor = _idFornecedor;
		    registryFornecedor.nomeFornecedor = _nomeFornecedor;
			registryFornecedor.emailFornecedor = _emailFornecedor;
			registryFornecedor.tipoFornecedor = _tipoFornecedor;
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

	//Qualquerum
	//Metodo para criar uma NotaFiscal
	function createNotaFiscal (
		string memory _firebaseID,
		uint _idNota,
		uint _idItem,
		uint _idPedido,
		string memory _nomeItem,
		string memory _tipoNota,
		uint _quantidadeItem,
		uint _valorUnitario
		//uint  _IDFornecedorOrigem,
		//uint  _IDFornecedorDestino
		) public returns (bool){

			NotaFiscal storage registryNotafiscal = notaFsicalRegistries[_firebaseID];
			registryNotafiscal.idNota = _idNota;
			if(compareStrings(listaPedido[_idPedido-1].nomeItem,_nomeItem)){
					registryNotafiscal.tipoNotafiscal = _tipoNota;
					registryNotafiscal.valorUnitario = _valorUnitario;
					registryNotafiscal.quantidadeItem = _quantidadeItem;
					registryNotafiscal.valorTotal = (_quantidadeItem * _valorUnitario);
					registryNotafiscal.idPedido = _idPedido;
					registryNotafiscal.descricaoItem = listaItem[_idItem].descricaoItem;
					registryNotafiscal.nomeItem = _nomeItem;
					notaFiscalRegistriesAccts.push(_firebaseID);
					//registryNotafiscal.origem = listaFornecedor[_IDFornecedorOrigem-1].nomeFornecedor;
					//registryNotafiscal.destino = listaFornecedor[_IDFornecedorDestino-1].nomeFornecedor;
					listaNF.push(notaFsicalRegistries[_firebaseID]);
					return true;
			}
			else
				return true;
	}

	/* Vinculo da Nota Fiscal com o Pedido */
    function addNotaToPedido(
	    uint _idNota, uint _idPedido) public returns (bool) {

		//VALIDA SE O PEDIDO É DE MATERIA PRIMA
		if(testaPedidoMateriaPrima(_idPedido)){
			//SE FOR A NF PODE SER MATERIA PRIMA
			if(testaNFMateriaPrima(_idNota)){
				listaPedido[_idPedido-1].listaNFPedido.push(listaNF[_idNota-1]);
			}
			return true;
		}
		//VALIDA SE O PEDIDO É DE PRODUCAO ( FORECENDOR CONTRATA UMA PRODUCAO DE UM SUBFORNECEDOR)
		else if(testaPedidoProducao(_idPedido)){
			//SE FOR, A NOTA FISCAL PODE SER DE PRODUCAO
			if(testaNFProducao(_idNota)){
				//VINCULA O PEDIDO COM A NOTA
				listaPedido[_idPedido-1].listaNFPedido.push(listaNF[_idNota-1]);
			}
			return true;
		}

		//VALIDA SE O PEDIDO É DE CONFECAO ( VAREJISTA CONTRATATA A CONFECACAO DE FORNECEDOR)
		else if(testaPedidoConfeccao(_idPedido)){
			//SE FOR, A NOTA FISCAL PODE SER DE COMPRA
			if(testaNFCompra(_idNota)){
				//VINCULA O PEDIDO COM A NOTA
				listaPedido[_idPedido-1].listaNFPedido.push(listaNF[_idNota-1]);
			}
			return true;
		}

		else return false;
	}

	function testaPedidoMateriaPrima(uint _idPedido) private returns (bool){
		bool testePedido;
		if(compareStrings(listaPedido[_idPedido-1].tipoPedido, "materia prima")){
			testePedido=true;
		}
		else testePedido=false;
		return testePedido;
	}

	function testaPedidoProducao(uint _idPedido) private returns (bool){
		bool testePedido;
		if(compareStrings(listaPedido[_idPedido-1].tipoPedido, "producao")){
			testePedido=true;
		}
		else testePedido=false;
		return testePedido;
	}

	function testaPedidoConfeccao(uint _idPedido) private returns (bool){
		bool testePedido;
		if(compareStrings(listaPedido[_idPedido-1].tipoPedido, "confecao")){
			testePedido=true;
		}
		else testePedido=false;
		return testePedido;
	}

	function testaNFProducao(uint _idNF) private returns (bool){
		bool testeNF;
		if(compareStrings(listaNF[_idNF-1].tipoNotafiscal, "producao")){
			testeNF=true;
		}
		else testeNF=false;
		return testeNF;
	}

	function testaNFCompra(uint _idNF) private returns (bool){
		bool testeNF;
		if(compareStrings(listaNF[_idNF-1].tipoNotafiscal, "compra")){
			testeNF=true;
		}
		else testeNF=false;
		return testeNF;
	}

	function testaNFMateriaPrima(uint _idNF) private returns (bool){
		bool testeNF;
		if(compareStrings(listaNF[_idNF-1].tipoNotafiscal, "materia prima")){
			testeNF=true;
		}
		else testeNF=false;
		return testeNF;
	}

/*
	// CONSULTA O FORENCEDOR DE ORIGEM DE UMA NOTA FISCAL
	function consultaFornecedorOrigemNF(uint _idNota) public returns (string memory){
         return listaNF[_idNota-1].origem;
	}

	// CONSULTA O FORNECEDOR DE DESTINO DE UMA NOTA FISCAL
	function consultaFornecedorDestinoNF(uint _idNota) public returns (string memory){
		return listaNF[_idNota-1].destino;
	}*/

	// CONSULTA O VALOR TOTAL DA NOTA
	function consultaValorNF(uint _idNota) public returns (uint){
		return listaNF[_idNota-1].valorTotal;
	}


	function lookUpIdFornecedor (string memory _firebaseId) public view returns (bytes memory serialized) {
        return getBytesFornecedor(fornecedorRegistries[_firebaseId]);
    }
/*
	function lookUpIdPedido (string memory _firebaseId) public view returns (bytes memory serialized) {
        return getBytesPedido(pedidoRegistries[_firebaseId]);
    }

	function lookUpIdItem (string memory _firebaseId) public view returns (bytes memory serialized) {
        return getBytesItem(itemRegistries[_firebaseId]);
    }

	function lookUpIdNF (string memory _firebaseId) public view returns (bytes memory serialized) {
        return getBytesNF(notaFsicalRegistries[_firebaseId]);
    }*/

	// TODO: Trocar para fornecedor
	function getBytesFornecedor(Fornecedor memory registryFornec) internal view returns (bytes memory serialized){
        uint offset = 64*(8);
        bytes memory buffer = new  bytes(offset);

        stringToBytes(offset, bytes(registryFornec.nomeFornecedor), buffer);
        offset -= sizeOfString(registryFornec.nomeFornecedor);

        stringToBytes(offset, bytes(registryFornec.emailFornecedor), buffer);
        offset -= sizeOfString(registryFornec.emailFornecedor);

        stringToBytes(offset, bytes(registryFornec.tipoFornecedor), buffer);
        offset -= sizeOfString(registryFornec.tipoFornecedor);

        return (buffer);
    }
/*
	function getBytesPedido(Pedido memory registry) internal view returns (bytes memory serialized){
        uint offset = 64*(8);
        bytes memory buffer = new  bytes(offset);

        stringToBytes(offset, bytes(registry.tipoPedido), buffer);
        offset -= sizeOfString(registry.tipoPedido);

        stringToBytes(offset, bytes(registry.descricaoPedido), buffer);
        offset -= sizeOfString(registry.descricaoPedido);

        stringToBytes(offset, bytes(registry.nomeFornecedor), buffer);
        offset -= sizeOfString(registry.nomeFornecedor);

        stringToBytes(offset, bytes(registry.nomeSubfornecedor), buffer);
        offset -= sizeOfString(registry.nomeSubfornecedor);

        stringToBytes(offset, bytes(registry.nomeItem), buffer);
        offset -= sizeOfString(registry.nomeItem);

        return (buffer);
    }

	function getBytesItem(Item memory registry) internal view returns (bytes memory serialized){
        uint offset = 64*(8);
        bytes memory buffer = new  bytes(offset);

        stringToBytes(offset, bytes(registry.tipoPedido), buffer);
        offset -= sizeOfString(registry.tipoPedido);

        stringToBytes(offset, bytes(registry.descricaoPedido), buffer);
        offset -= sizeOfString(registry.descricaoPedido);

        stringToBytes(offset, bytes(registry.nomeFornecedor), buffer);
        offset -= sizeOfString(registry.nomeFornecedor);

        stringToBytes(offset, bytes(registry.nomeSubfornecedor), buffer);
        offset -= sizeOfString(registry.nomeSubfornecedor);

        stringToBytes(offset, bytes(registry.nomeItem), buffer);
        offset -= sizeOfString(registry.nomeItem);

        return (buffer);
    }

	function getBytesNF(NotaFiscal memory registry) internal view returns (bytes memory serialized){
        uint offset = 64*(8);
        bytes memory buffer = new  bytes(offset);

        stringToBytes(offset, bytes(registry.tipoPedido), buffer);
        offset -= sizeOfString(registry.tipoPedido);

        stringToBytes(offset, bytes(registry.descricaoPedido), buffer);
        offset -= sizeOfString(registry.descricaoPedido);

        stringToBytes(offset, bytes(registry.nomeFornecedor), buffer);
        offset -= sizeOfString(registry.nomeFornecedor);

        stringToBytes(offset, bytes(registry.nomeSubfornecedor), buffer);
        offset -= sizeOfString(registry.nomeSubfornecedor);

        stringToBytes(offset, bytes(registry.nomeItem), buffer);
        offset -= sizeOfString(registry.nomeItem);

        return (buffer);
    }*/
}