// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface InterfaceERC20 {

    // There are total of 6 important method and 2 events that should be implemented while creating 
    // tokens using ERC20 standard
    // totalsupply(), balanceOf(), transfer(), transferFrom(), approve(), allowance() - methods
    // transfer and approve - events

    // It returns the total supply of tokens in the contract
    function totalSupply() external view returns(uint);

    // As the name says, balanceOf returns the balance of an account
    function balanceOf(address account) external view returns(uint);

    // The transfer function transfers a tokens from the caller to a different address. 
    // This involves a change of state, so it isn't a view. When a user calls this function it creates a transaction and costs gas. 
    // It also emits an event, Transfer, to inform everybody on the blockchain of the event
    function transfer(address recipient, uint amount) external returns(bool);

    // Finally, transferFrom is used by the spender to actually spend the allowance.
    function transferFrom(address sender, address recipient, uint amount) external  returns(bool);

    // The approve function creates an allowance
    // Sets `amount` as the allowance of `spender`
    function approve(address spender, uint _amount) external  returns(bool);

    // On the behalf of _owner, _spender will spend the amount.
    // The allowance function lets anybody query to see what is the allowance 
    // that one address (owner) lets another address (spender) spend.
    function allowance(address owner, address spender) external view returns(uint);

    event TransferEvt(address indexed from, address indexed to, uint amount);
    event ApproveEvt(address owner, address spender, uint amount);

}

contract ERC20 is InterfaceERC20 {

    uint public totalSupply;
    mapping(address=>uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowances;
    string public tokenName;
    string public symbol;
    uint public decimal;

    constructor(){
        tokenName = "BASANT KARKI";
        symbol = "BNT";
        decimal = 18;
    }

    function transfer(address recipient, uint amount) external  returns(bool){
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit TransferEvt(msg.sender,recipient,amount);
        return true;
    }

    // Finally, transferFrom is used by the spender to actually spend the allowance.
    function transferFrom(address sender, address recipient, uint amount) external  returns(bool){
        allowances[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit TransferEvt(sender, recipient,amount);
        return true;
    }

    // The approve function creates an allowance
    // Sets `amount` as the allowance of `spender`
    function approve(address spender, uint _amount) external returns(bool){
        allowances[msg.sender][spender] = _amount;
        emit ApproveEvt(msg.sender,spender,_amount);
        return true;
    }

    // On the behalf of _owner, _spender will spend the amount.
    // The allowance function lets anybody query to see what is the allowance
    // that one address (owner) lets another address (spender) spend.
    // It simply checks the total allowance.
    function allowance(address owner, address spender) external view returns(uint){
        return allowances[owner][spender];
    }

    // createing a new token and adding to the totalSupply.
    function mint(uint _amount) external {
        totalSupply += _amount;
        balanceOf[msg.sender] += _amount;
        emit TransferEvt(address(0),msg.sender,_amount);
    }

    // distroy tokens from the total circulations
    function burn(uint _amount) external {
        totalSupply -= _amount;
        balanceOf[msg.sender] -= _amount;
        emit TransferEvt(msg.sender,address(0),_amount);
    }

}