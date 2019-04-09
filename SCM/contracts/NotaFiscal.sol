pragma solidity ^0.5.0; 

contract notaFiscal {
	// Model Candidate	
	struct notaFiscal {
		uint idPedido;
		uint item1;
		uint item2;
		uint item3;
		uint qntdItem1;
		uint qntdItem2;
		uint qntdItem3;
		uint volItem1;
		uint volItem2;
		uint volItem3;
		string descItem1;
		string descItem2;
		string descItem3;
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