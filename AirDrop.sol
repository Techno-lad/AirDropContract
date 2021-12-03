// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.6 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";

contract AirdropContract {

   mapping(address => bool) public confirmedForDrop;

    address admin;
    address[] reciever;
    uint256 deadline;

    constructor() public {
        admin = msg.sender;
    }

    function AddAddress() public {
        require(!confirmedForDrop[admin]==true);
        //require()
        reciever.push(msg.sender);
    }

    function setAirDropDate(uint256 numberOfMins) public {
         deadline = now + (numberOfMins * 1 minutes);
    }

    function getTimeUntilAirDrop() public view returns (uint256){
      if (deadline <= now){ // Checks to see if its time to check in.
        return 0;
      } else {
        return deadline - now; // Returns amount of seconds remaining until next check in.
      } 
    }
    

    modifier onlyAdmin() { // This modifier authorizes only the owner of the contract to execute whichever function utilizes this modifier.
        require(msg.sender == admin);
        _;
    }

    function airdropTokens() public payable onlyAdmin {
        require(now >= deadline);
        ERC20 erc20token = ERC20(token);
        
        for(uint i = 0; i< reciever.length; i++)
        {
          
            erc20token.transferFrom(msg.sender, reciever[i], 10000000);
            
            
        }
    }
}
