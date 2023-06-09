// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract TicketSale {
    uint16 public numTickets;
    uint256 public basePrice;
    address public owner;
	address payable ownerAcc;
	uint16 public sold;
	bool onOffer;

    struct Offer {
        address offerer;
        uint256 price;
        uint16 id;
    }
    
	Offer public offer;
    
	struct Buyer {
		bool hasTicket;
		uint16 ticketId;
		uint256 price;
	}

	mapping(address => Buyer) buyers;

	constructor(uint16 _numTickets, uint256 _basePrice){
        numTickets = _numTickets;
		basePrice = _basePrice;
		owner = msg.sender;
		ownerAcc = payable(msg.sender);
		sold = 0;
		onOffer = false;
    }

    function validate(address person) public view returns (bool) {
        return buyers[person].hasTicket;
    }

    function buyTicket() public payable {
        address potentialBuyer = msg.sender;
		uint256 price = msg.value;

		require(!buyers[potentialBuyer].hasTicket, "You already have a ticket!");
		require(price == basePrice, "Pay equal to the base price!");
		require(sold < numTickets, "No Tickets left!");

		sold += 1;
		buyers[potentialBuyer] = Buyer({hasTicket: true, ticketId: sold, price: basePrice});
    }

    function getTicketOf(address person) public view returns (uint16) {
		require(buyers[person].hasTicket, "The person does not have any ticket");
        return buyers[person].ticketId;
    }

    function submitOffer(uint16 ticketId, uint256 price) public {
        uint256 floor = (4 * basePrice) / 5;
		uint256 ceil = (6* basePrice) / 5;
		
		require(!onOffer, "There is already an offer running!");
		require(buyers[msg.sender].hasTicket, "You do not own any ticket!");
		require(ticketId <= sold, "Wrong ticket Id!");
		require(price <= ceil, "Offer too High!");
		require(price >= floor, "Offer too Low!");

		offer = Offer({offerer: msg.sender, price: price, id: ticketId});
		onOffer = true;
    }

    function acceptOffer(uint16 ticketId) public payable {
		require(!buyers[msg.sender].hasTicket, "You already have a ticket!");
		require(onOffer, "No offers available!");
        require(msg.value == offer.price, "Pay the valid price offered!");
		require(ticketId == offer.id, "The ticket is not under offer!");

		onOffer = false;
		buyers[offer.offerer] = Buyer({hasTicket: false, ticketId: 0, price: 0});
		buyers[msg.sender] = Buyer({hasTicket: true, ticketId: ticketId, price: offer.price});
    }
    
    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw!");
		ownerAcc.transfer(address(this).balance);
    }
}