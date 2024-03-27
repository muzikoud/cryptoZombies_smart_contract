// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./zombieattack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {
    mapping(uint => address) zombieApprovals;

    function balanceOf(
        address _owner
    ) public view override returns (uint256 _balance) {
        return ownerZombieCount[_owner];
    }

    function ownerOf(
        uint256 _tokenId
    ) public view override  returns (address _owner) {
        return zombieToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerZombieCount[_to]++;
        ownerZombieCount[_from]--;
        zombieToOwner[_tokenId] = _to;
        Transfer(_from, _to, _tokenId);
    }

    function transfer(
        address _to,
        uint256 _tokenId
    ) public override onlyOwnerOf(_tokenId) {
        _transfer(msg.sender, _to, _tokenId);
    }

    function approve(
        address _to,
        uint256 _tokenId
    ) public override onlyOwnerOf(_tokenId) {
        zombieApprovals[_tokenId] = _to;
        Approval(msg.sender, _to, _tokenId);
    }
    function takeOwnership(uint256 _tokenId) public override{
        require(zombieApprovals[_tokenId] == msg.sender);
        _transfer(ownerOf(_tokenId), msg.sender, _tokenId);
    }
}
