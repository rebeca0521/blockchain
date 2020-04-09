pragma solidity ^0.6.0;
contract bank {
      
  mapping (string => address) public students; //學號映射到地址
  mapping (address => uint256 ) public balances; //地址映射到存款金額
  address payable owner; //銀行的擁有者，會在constructor做設定

  //設定owner為創立合約的人
  constructor () public payable{
      owner = msg.sender;
  }
  

 // 可以讓使用者call這個函數把錢存進合約地址，並且在balances中紀錄使用者的帳戶金額 
  function deposit() public payable {
        balances[msg.sender] += msg.value;
  }
  


 // 可以讓使用者從合約提錢，這邊需要去確認合約裡的餘額 >= 想提的金額
 function withdraw (uint withdrawAmount ) public payable returns(address)  {
     require (withdrawAmount <= balances[msg.sender],"Fail" );
     
     msg.sender.transfer(withdrawAmount);
     balances[msg.sender]-=withdrawAmount;
 }

  
  //可以讓使用者從合約轉帳給某個地址，這邊需要去確認合約裡的餘額 >= 想轉的金額
  //實現的是銀行內部轉帳，也就是說如果轉帳成功balances的目標地址會增加轉帳金額
  function transfer(uint transerAmount, address payable targetAddress) public payable{
      require(balances[msg.sender]>=transerAmount,"Fail");
      targetAddress.transfer(transerAmount);
  }

  //從balances回傳使用者的銀行帳戶餘額
  function getBalance() public view returns(uint256) {
      return balances[msg.sender];
      
  }

  //回傳銀行合約的所有餘額，設定為只有owner才能呼叫成功
  function getBankBalance() public view returns(uint){
      return address(this).balance;
  }

  //透過students把學號映射到使用者的地址
  function enroll(string memory accountName) public{
      students[accountName] = msg.sender;
      
  }

  //當觸發fallback時，檢查觸發者是否為owner，是則自殺合約，把合約剩餘的錢轉給owner
  fallback() external {
      require(owner == msg.sender, "Error");
      selfdestruct(owner);
  }




  
}  
