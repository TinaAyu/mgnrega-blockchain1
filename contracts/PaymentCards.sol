pragma solidity ^0.4.2;

contract PaymentCards {
  card[] public PaymentCards;
  uint public totalNumberOfPaymentCards;
  address public government;
  mapping (address => card) PaymentCardOf;
  uint public cardNumber;

  struct card {
    address customerAddress;
    uint PaymentCardNumber;
    string customerName;
    string residentialAddress;
    string place;
    address gpcOwner;
    bool cardCreated;
  }

  modifier onlyGovernment{
    if (msg.sender != government) throw;
    _;
  }

  /*event WagerExists(address  indexed _custAddr);
  event GPCExists(address indexed _gpcAddr);*/
  event PaymentCardCreated(address indexed _customerAddress);

  function PaymentCard() {
    government = tx.origin;
    totalNumberOfPaymentCards = 0;
    cardNumber = 1001;
  }

  function addPaymentCard(address _customerAddress, string _customerName,
    string _residentialAddress, string _place, address _gpcAddress) onlyGovernment returns (uint) {
    uint cardnum;
    bool exists = PaymentCardOf[_customerAddress].cardCreated;
    if (_customerAddress == _gpcAddress) {throw;}
    if (!exists) {
      
      /*WagerExists(_customerAddress);*/
      
      /*FPSExists(_fpsAddress);*/

      card memory newCard;
      newCard.customerAddress = _customerAddress;
      newCard.PaymentCardNumber = cardNumber;
      newCard.customerName = _customerName;
      newCard.residentialAddress = _residentialAddress;
      newCard.place = _place;
      newCard.gpcOwner = _gpcAddress;
      newCard.cardCreated = true;

      PaymentCards.push(newCard);
      PaymentCardOf[_customerAddress] = newCard;
      totalNumberOfPaymentCards += 1;
      cardnum = cardNumber;
      cardNumber += 1;
      //PaymentCardCreated(_customerAddress);
      //return true;
    }
    return cardnum;
  }

  function getPaymentCardDetails(address _customerAddress) constant returns (bool, uint, string, string, string, address) {
    uint cardNum;
    string memory cusName;
    string memory cusAddress;
    string memory place;
    address gpcAddr;

    bool exists = PaymentCardOf[_customerAddress].cardCreated;
    if (exists) {
      card c = PaymentCardOf[_customerAddress];
      cardNum = c.PaymentCardNumber;
      cusName = c.customerName;
      cusAddress = c.residentialAddress;
      place = c.place;
      gpcAddr = c.gpcOwner;
    }
    return (exists, cardNum, cusName, cusAddress, place, gpcAddr);
  }

}
