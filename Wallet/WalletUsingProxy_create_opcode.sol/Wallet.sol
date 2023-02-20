//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./Address.sol";
import "./Clones.sol";
import "./Ownable.sol";
import "./Pausable.sol";
import "./EnumerableSet.sol";
contract Wallet is Ownable, Pausable {
    address public implementation;
    address payable public receiver;
    address[] private addresses;
    

    constructor (address _impl) {
        implementation = _impl;
        receiver = payable(address(this));
    }

    function createAddress() external {
        address _clone = Clones.clone(implementation);

        (Address(payable(_clone))).setReceiver(receiver);

        addresses.push(_clone);
    }

    function getAddresses() public view returns (address[] memory) {
        return addresses;
    }

    receive() external payable { }


    function pause() onlyOwner external {
        _pause();
    }
}