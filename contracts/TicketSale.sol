// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract TicketSale {
    uint16 public numTickets;
    uint256 public basePrice;
    address public owner;
    struct Offer {
        address offerer;
        uint256 price;
        uint16 id;
    }
    Offer public offer;
    constructor(uint16 _numTickets, uint256 _basePrice){
        // TODO
    }

    function validate(address person) public view returns (bool) {
        // TODO
    }

    function buyTicket() public payable {
        // TODO
    }

    function getTicketOf(address person) public view returns (uint16) {
        // TODO
    }

    function submitOffer(uint16 ticketId, uint256 price) public {
        // TODO
    }

    function acceptOffer(uint16 ticketId) public payable {
        // TODO
    }
    
    function withdraw() public {
        // TODO
    }
}