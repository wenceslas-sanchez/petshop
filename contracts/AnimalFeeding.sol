pragma solidity ^0.8.0;

import {AnimalOwnership} from "./AnimalOwnership.sol";

contract AnimalFeeding is AnimalOwnership {
    uint coolDown= 7 days;
    uint foodCost= 0.00000001 ether;

    event AnimalFeed(uint _petId, address _owner);
    event AnimalDead(uint _petId);

    modifier petAlive(uint _petId) {
        require(isPetAlive(_petId), "Your pet is dead...");
        _;
    }

    function isPetAlive(uint _petId) returns (bool){
        if (!animals[_petId].alive) {
            return false;
        } else if (animals[_petId].lastFeed <= coolDown) {
            animals[_petId].alive= false;
            emit AnimalDead(_petId);
            return false;
        }
        return true;
    }

    function setFoodCost(uint _foodCost) external onlyOwner {
        foodCost= _foodCost;
    }

    function setCoolDown(uint _coolDown) external onlyOwner {
        coolDown= _coolDown;
    }

    function feedAnimal(uint _petId, address _owner) public payable onlyOwnerOf(_petId) petAlive(_petId) {
        require(msg.value == foodCost);
        Animal animal= animals[_petId];
        animal.lastFeed= uint32(now); // update lastFeed value
        emit AnimalFeed(_petId, msg.sender);
    }
}
