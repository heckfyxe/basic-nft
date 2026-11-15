// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {ERC165} from "./ERC165.sol";
import {ERC721TokenReceiver} from "./ERC721TokenReceiver.sol";
import {ERC721} from "./ERC721.sol";

contract NFT is ERC721 {
    mapping(address => uint256) private s_balanceOf;
    mapping(uint256 => address) private s_ownerOf;
    mapping(uint256 => address) private s_approved;
    mapping(address => mapping(address => bool)) private s_isApprovedForAll;
    uint256 private tokenCounter;

    function mint() public {
        s_balanceOf[msg.sender]++;
        s_ownerOf[tokenCounter] = msg.sender;
        emit Transfer(address(0), msg.sender, tokenCounter);
        _callERC721Receiver(msg.sender, address(0), tokenCounter++, "");
    }

    function balanceOf(address _owner) external view override returns (uint256) {
        require(_owner != address(0));
        return s_balanceOf[_owner];
    }

    function ownerOf(uint256 _tokenId) external view override returns (address) {
        address owner = s_ownerOf[_tokenId];
        require(owner != address(0));
        return owner;
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) public override {
        transferFrom(_from, _to, _tokenId);
        _callERC721Receiver(_to, _from, _tokenId, data);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external override {
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public override {
        require(_to != address(0));
        require(_tokenId < tokenCounter);
        require(_from == s_ownerOf[_tokenId]);
        require(_from == msg.sender || s_approved[_tokenId] == msg.sender || s_isApprovedForAll[_from][msg.sender]);
        s_balanceOf[_from]--;
        s_balanceOf[_to]++;
        s_ownerOf[_tokenId] = _to;
        s_approved[_tokenId] = address(0);
        emit Transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external override {
        address _owner = s_ownerOf[_tokenId];
        require(_owner == msg.sender || s_isApprovedForAll[_owner][msg.sender]);
        s_approved[_tokenId] = _approved;
        emit Approval(_owner, _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) external override {
        s_isApprovedForAll[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) external view override returns (address) {
        require(_tokenId < tokenCounter);
        return s_approved[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) external view override returns (bool) {
        return s_isApprovedForAll[_owner][_operator];
    }

    function supportsInterface(bytes4 interfaceID) external pure override returns (bool) {
        return interfaceID == type(ERC165).interfaceId || interfaceID == type(ERC721).interfaceId;
    }

    function _callERC721Receiver(address _receiver, address _from, uint256 _tokenId, bytes memory data) private {
        if (_receiver.code.length == 0) return;
        bytes4 response = ERC721TokenReceiver(_receiver).onERC721Received(msg.sender, _from, _tokenId, data);
        require(response == ERC721TokenReceiver.onERC721Received.selector);
    }
}
