// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 
contract xyz_com{
    address customer;//customer is the buyer 
    address public owner;//owner is owner of the xyz.com(the virtual middleman contract between the seller and buyer) 
    address public seller;//the seller uses xyz.com to sell their products to customers
    uint public amount_sent_by_customer;
    uint public price_of_product;
    bool public product_delivered;
    bool public product_sent;
 
    constructor(uint price, address _seller)
    {
        //the constructor initializes all the variables : owner,customer(seller),product price, delivery and dispatch status
        owner=msg.sender;//the deployer of the smart contract is the owner of the website xyz.com
        seller=_seller;//seller of the product who uses xyz.com
        product_delivered=false;//delivery status
        product_sent=false;//dispatch or off-loading status
        price_of_product=price;//the product price is set by the owner
    }


 //we use modifiers are used to implement constraints that make sure only those entities call particular functions that they are authorized to call
 //for example we cannot give the seller the authority to verify if the product is delivered only the customer can do that
    modifier notOwner()
    {
        require(owner!=msg.sender);
        _;
    }
 
     modifier onlyOwner()
    {
        require(owner==msg.sender);
        _;
    }
 
    modifier notSeller()
    {
        require(seller!=msg.sender);
        _;
    }
 
     modifier onlySeller()
    {
        require(seller==msg.sender);
        _;
    }
 
    function payMoney() public payable notOwner notSeller{
        //the payMoney() function basically is called by the customer who wants to buy the product and the value they send to the contract
        //is the amount they are paying for the product
        amount_sent_by_customer+=msg.value;
        customer=msg.sender;
    }
 
    function deliverProduct() public onlySeller returns(bool){
        //only the seller can start delivery
        //the seller starts delivery only when they recieve the correct amount for the product
        require(amount_sent_by_customer>=price_of_product,"Insufficient amount transferred");
        //if product is offloaded/dispatched the product_sent flag becomes true and the customer waits to receive the product
        product_sent=true;
        return product_sent;
    }
 
    function isProductDelivered(bool p) public notOwner notSeller{
        //only customer has authority to call this function, since only customer can tell if they received the product or not
        product_delivered=p;
    }
 
    function refund() public onlyOwner{
        //the owner will refund the money to the customer if they haven't received the product
        require(product_delivered==false,"Product is delivered successfully");
        payable(customer).transfer(price_of_product);
    }
 
    function transferFunds() public onlyOwner{
        //the owner will send money to the seller only if the product is delivered
        require(product_delivered==true);
        payable(seller).transfer(price_of_product);
    }
 
    function getBalance() public view returns(uint){
        //this function can be used to check the balance of the address
        return address(this).balance;
    }
    // function sendtip(uint _tip) public payable notOwner notSeller{
    //       payable(seller).transfer(_tip);
          
    
    // }
}
