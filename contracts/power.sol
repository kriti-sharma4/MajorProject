pragma solidity ^0.5.0;

contract power {


  struct Node
  {
    uint id;
    uint sid;
    int balance;
    int excess;
  }
  struct Snode
  {
     uint sid;
     int balance;
     int excess;
     uint arrSize;
     uint8 [5] nArr;
  }
  mapping (uint => Node) public nodes;
  mapping(uint => Snode) public sNodes;
  uint [] public sArr;
  uint public sLen;
  constructor() public {
    Node memory N1= Node(1,1,100,0);
    nodes[1]=N1;
    Node memory N2= Node(2,1,100,0);
    nodes[2]=N2;
    Node memory N3= Node(3,1,100,0);
    nodes[3]=N3;
    Node memory N4= Node(4,2,100,0);
    nodes[4]=N4;
    Node memory N5= Node(5,2,100,0);
    nodes[5]=N5;
    Snode memory SN1= Snode(1,300,0,3,[1,2,3,0,0]);
    sNodes[1]=SN1;
    Snode memory SN2= Snode(1,200,0,2,[4,5,0,0,0]);
    sNodes[2]=SN2;
    sLen=2;
     
  }
  function borrow(int _amount,uint _rec) public payable {
      uint borrower=nodes[_rec].id;
      uint superN= nodes[_rec].sid;
      uint len=sNodes[superN].arrSize;
      //address [] memory tempArr=sNodes[superN].nArr;
      bool flag=true;
      bool done=false;
      for(uint index=0;index<len;index++)
      {
        uint temp=sNodes[superN].nArr[index];
         if(temp!=borrower && nodes[temp].balance>_amount)
         {
           flag=false;
           nodes[temp].balance-=_amount;
           nodes[borrower].balance += _amount;
           nodes[borrower].excess += _amount;
           nodes[temp].excess-=_amount;
           done=true;
         }
         if(done==true)
           break;

      }
      if(flag==true)
      {
        askSNode(superN,_amount);
      }
  }
  function askSNode (uint _superN,int _amount) public payable
  {
    
      for(uint index=0;index<sLen;index++)
      {
          uint temp=index+1;
          if(temp!=_superN && sNodes[temp].balance>_amount)
          {
           sNodes[temp].balance-=_amount;
           sNodes[_superN].balance += _amount;
           sNodes[_superN].excess += _amount;
           sNodes[temp].excess-=_amount;
        
          }  
      }
  }
  
  function consume(int _amount,uint _caller) public
  {
    nodes[_caller].balance-=_amount;
  }
}
