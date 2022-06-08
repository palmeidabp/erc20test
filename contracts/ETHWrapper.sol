// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

contract WETH is ERC20PresetMinterPauser {

	constructor() ERC20PresetMinterPauser("Wrapped ETH", "WETH") {

	}
}

contract ETHWrapper {

	WETH public WETHToken;

    event LogEthWrapped(address sender, uint256 amount);
    event LogETHUnwrapped(address sender, uint256 amount);

	constructor() public {
		WETHToken = new WETH();
	}

    

    function wrap() public payable{
        require(msg.value > 1000000, "We need to wrap at least 1 WETH");
        WETHToken.mint(msg.sender,msg.value);
        emit LogEthWrapped(msg.sender, msg.value);
    }

    function unwrap(uint value) public {
        require(value > 0, "We need to unwrap at least 1 WETH");
        uint allowancevalue = WETHToken.allowance(address(this),msg.sender );
        require(value < allowancevalue, "We need to more allowance ");
        WETHToken.transferFrom(msg.sender,address(this),value);
        WETHToken.burn(value);
        payable(msg.sender).transfer(value);
        emit LogETHUnwrapped(msg.sender, value);

    }

    function aproove(uint value) public {
        require(value > 0, "We need to unwrap at least 1 WETH");
        WETHToken.approve(msg.sender, value); // Allows the contract to transfer %value% of WETH from the msg.sender wallet to this contract
    }

    function totalSupply() public view returns (uint256) {
        return  WETHToken.totalSupply();
    }

    function mintedBalance() public view returns (uint256) {
        return WETHToken.balanceOf(msg.sender);
    }

    function allowance() public view returns (uint) {
        return WETHToken.allowance(address(this),msg.sender );
    }

    function contractBalance() public view returns (uint){
        return address(this).balance;
    }

}