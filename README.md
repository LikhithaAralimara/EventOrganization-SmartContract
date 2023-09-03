# EventOrganization-SmartContract
EventContract Solidity Smart Contract
This repository contains a Solidity smart contract named EventContract for managing events, ticket sales, and reviews. This README provides an overview of the contract's functionality and usage.

Table of Contents
Overview
Contract Functions
Usage
Contributing
License
Overview
The EventContract smart contract allows users to create and manage events. It provides functions for creating events, buying tickets, canceling tickets, transferring tickets, updating event details, checking event status, and leaving reviews with ratings. The contract also includes a benchmarking function to measure gas usage and execution time for various contract operations.

 Usage
 1. You can run the smart contract on Remix and upon successful deployment you can interact in Remix for creatingevent,buy/transfer/cancel the tickets , See event status , write reviews/ratings , & more. 
      Note : Use EPOCH timestamp whereever date is mentioned 

![image](https://github.com/LikhithaAralimara/EventOrganization-SmartContract/assets/128489410/3d8a618f-1cea-49f9-8985-0138b3555291)

2. To use this smart contract, you can deploy it to an Ethereum-compatible blockchain. Interact with the contract through web3.js or ethers.js libraries in your decentralized application (DApp).

Contract Functions
1. createEvent
Allows an organizer to create a new event with details such as name, date, price, ticket count, status, refund policy, and minimum age requirement.
2. buyTicket
Allows users to purchase event tickets, checking that the event exists, is in the future, and has enough available tickets. Age verification is also enforced.
3. cancelTicket
Allows users to cancel purchased tickets, returning them to the available ticket pool.
4. transferTicket
Enables users to transfer their purchased tickets to another address.
5. updateEvent
Permits organizers to update event details, including name, date, price, and ticket count, for events they have created.
6. showEventStatus
Retrieves and updates the status of an event (upcoming, ongoing, or completed) based on its date and ticket availability.
7. writeReview
Allows attendees to leave reviews and ratings for events they have attended. Ratings must be between 1 and 5, and reviews cannot be empty. The average event rating is calculated and updated.
8. benchmark
Measures gas usage and execution time for various contract operations and emits benchmark results as an event.


