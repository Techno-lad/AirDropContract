// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0 ;

contract AirDropContract {

   mapping(address => bool) public confirmedForDrop;

    address admin;
    address[] reciever;
    uint256 deadline;

    constructor()  {
        admin = msg.sender;
        deadline = block.timestamp + 2 minutes ; // 2 minutes is for testing purposes. now keyword is depreciated, block.timestamp is standard as of 0.7.0
    }

    function fundAirDrop() public payable onlyAdmin{
      require(msg.value >= 1000000000000000000, "A minimum of 10 eth needed");
    }

    function AddAddress() public {
        require(msg.sender!=admin,"Admin cannot be added to droplist");

        reciever.push(msg.sender);
        confirmedForDrop[msg.sender] = true; // addresses that signs up for airdrop are "marked" true;
    }

    function changeAirDropDate(uint256 numberOfMins) public onlyAdmin {
         deadline = block.timestamp + (numberOfMins * 1 minutes);
    }

    function getTimeUntilAirDrop() public view returns (uint256){
      if (deadline <= block.timestamp){ 
        return 0;
      } else {
        return deadline - block.timestamp; // Returns amount of seconds remaining until next check in. 
      } 
    }
    

    modifier onlyAdmin() { 
        require(msg.sender == admin);
        _;
    }

    function airdropTokens() public onlyAdmin {
        require(block.timestamp >= deadline);
        
        for(uint i = 0; i< reciever.length; i++)
        {
          address payable recipient = payable(reciever[i]); //address payable: Same as address, but with the additional members transfer and send. Hence the need for typecasting.
          recipient.transfer(1000000);   
        }
    }

    function check(address r) public view returns (bool) {
      return confirmedForDrop[r];
    }
}
