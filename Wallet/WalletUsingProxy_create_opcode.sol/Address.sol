//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Address {
    address payable public receiver;

    function setReceiver(address _addr) external {
        receiver = payable(_addr);
    }

    receive() external payable {
        receiver.transfer(msg.value);
    }
}