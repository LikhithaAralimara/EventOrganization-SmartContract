//SPDX-License-Identifier: Unlicense
pragma solidity >=0.5.0 <0.9.0;

struct RateAndReview{
    uint id;
    uint rating;
    string review;
    //address reviewer;
}

contract EventContract {
    struct Event{
        address organizer;
        string name;
        uint date; //0 1 2
        uint price;
        uint ticketCount;  //1 sec  0.5 sec
        uint ticketRemain;
        string status;
        uint averageRating;
        uint refundPolicy;
        uint minAge;
    }

    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId;
 
    RateAndReview[] public reviews;

    uint private gasUsed;
    uint private timestamp;

    function createEvent(string memory name,uint date,uint price,uint ticketCount, string memory status, uint refundPolicy, uint minAge) public{
        require(date>block.timestamp,"You can organize event for future date");
        require(ticketCount>0,"You can organize event only if you create more than 0 tickets");

        events[nextId] = Event(msg.sender,name,date,price,ticketCount,ticketCount,status, 0, refundPolicy, minAge);
        nextId++;
    }

    function buyTicket(uint id,uint quantity, uint age) public payable{
        require(events[id].date!=0,"Event does not exist");
        require(events[id].date>block.timestamp,"Event has already occurred");
        Event storage _event = events[id];
        require(msg.value>=(_event.price*quantity),"Ethere is not enough");
        require(_event.ticketRemain>=quantity,"Not enough tickets");
        require(age>=_event.minAge, "You must be at least 21 years old to purchase a ticket for this event");
        _event.ticketRemain-=quantity;
        tickets[msg.sender][id]+=quantity;
    }

    function cancelTicket(uint id, uint quantity) external {
        require(events[id].date!=0,"Event does not exist");
        require(events[id].date>block.timestamp,"Event has already occurred");
        require(tickets[msg.sender][id]>=quantity,"You do not have enough tickets");

        tickets[msg.sender][id] -= quantity;
        events[id].ticketRemain += quantity;
    }

    function transferTicket(uint id,uint quantity,address to) external{
        require(events[id].date!=0,"Event does not exist");
        require(events[id].date>block.timestamp,"Event has already occurred");
        require(tickets[msg.sender][id]>=quantity,"You do not have enough tickets");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }

    function updateEvent(uint id, string memory name, uint date, uint price, uint ticketCount) external {
        require(events[id].date != 0, "Event does not exist");
        require(events[id].organizer == msg.sender, "Only event organizer can update the event");
        require(date > block.timestamp, "You can only update the event for future date");
        require(ticketCount > 0, "You can only update the event for more than 0 tickets");

        events[id].name = name;
        events[id].date = date;
        events[id].price = price;
        events[id].ticketCount = ticketCount;
            events[id].ticketRemain = ticketCount;
}

function showEventStatus(uint id) external {
    require(events[id].date != 0, "Event does not exist");

    Event storage _event = events[id];
    if (_event.date > block.timestamp) {
        _event.status = "upcoming";
    } else if (_event.ticketRemain > 0) {
        _event.status = "ongoing";
    } else {
        _event.status = "completed";
    }
}

function writeReview(uint eventId, uint rating, string memory review) public {
    require(eventId < nextId, "Event does not exist");
    require(rating > 0 && rating <= 5, "Rating must be between 1 and 5");
    require(bytes(review).length > 0, "Review cannot be empty");
    require(tickets[msg.sender][eventId] > 0, "You must have attended the event to leave a review");

    RateAndReview memory newReview = RateAndReview({
        id: eventId,
        rating: rating,
        review: review 
    });

    reviews.push(newReview);

    uint totalRating = 0;
    uint reviewCount = 0;
    for (uint i = 0; i < reviews.length; i++) {
        if (reviews[i].id == eventId) {
            totalRating += reviews[i].rating;
            reviewCount++;
        }
    }
    uint averageRating = totalRating / reviewCount;

    events[eventId].averageRating = averageRating;
}

function getReviewCount(uint eventId) internal view returns (uint) {
    uint count = 0;
    for (uint i = 0; i < reviews.length; i++) {
        if (reviews[i].id == eventId) {
            count++;
        }
    }
    return count;
}

function benchmark() public  {
    // Save the current gas used and timestamp
    gasUsed = gasleft();
    timestamp = block.timestamp;

    // Run some example function calls
    createEvent("Test Event", block.timestamp + 86400, 1 ether, 100, "upcoming", 0, 21);
    buyTicket(0, 1, 21);
    writeReview(0, 5, "Great event!");

    // Calculate the gas used and execution time
    uint gasSpent = gasUsed - gasleft();
    uint executionTime = block.timestamp - timestamp;

    // Emit an event with the benchmark results
    emit BenchmarkResult(gasSpent, executionTime);
}

event BenchmarkResult(uint gasSpent, uint executionTime);

}