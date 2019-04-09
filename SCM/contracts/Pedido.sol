pragma solidity ^0.5.0; 

contract SCM {
	// Model Candidate	
	struct Pedido {
		uint idItem;
		uint itemQuant;
		string nameItem;
		string tecido
		string fornecedor;
		string descricao;
	}

	// Store Candidade
	// Fetch Candidate
	mapping(uint => Pedido) public pedidos;
	
	// Store Candidates Count
	uint public candidateCount;

	//constructor
	constructor () public {
		addCandidate("Item 1");
		addCandidate("Item 2");
	}

	function addPedido (string _name) private {
		candidatesCount ++;
		candidates[candidatesCount] = new Candidate(candidatesCount, _name, 0);
	}
}