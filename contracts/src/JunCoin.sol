// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


contract JunCoin is ERC20, Ownable {

    // 声明 Mint 事件：在代币铸造时记录铸造的数量。
    event Mint(address indexed to, uint256 indexed amount);

    // 声明 Burn 事件：在代币销毁时记录销毁的数量。
    event Burn(address indexed to, uint256 indexed amount);
    // 代币名称，供外部调用查询。
    string public _name = "JunCoin";
    // 代币符号，供外部调用查询。
    string public _symbol = "JUN";

    constructor(address initialOwner) ERC20(_name, _symbol) Ownable(initialOwner) {}

    function mint(uint256 _amount) external onlyOwner {
        _mint(msg.sender, _amount);
        emit Mint(msg.sender, _amount);
    }

    function burn(uint256 _amount) external onlyOwner {
        _burn(msg.sender, _amount);
        emit Burn(msg.sender, _amount);
    }
}
