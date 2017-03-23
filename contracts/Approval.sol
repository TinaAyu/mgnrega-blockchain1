pragma solidity ^0.4.2;

contract Approval {
  uint public numberOfNotApprovedWagers;
  uint public numberOfNotApprovedGPC;
  address public government;
  userApproval[] approvals;
  mapping (address => userApproval) userApprovals;
  mapping (address => bool) userAlreadyInApprovalList;

  struct userApproval {
    address userAddress;
    bool approved;
    uint usertype;
  }

  modifier onlyGovernment() {
    if (msg.sender != government) throw;
    _;
  }

  event WagerAddedToApprovalList(address indexed _customerAddress);
  event GPCAddedToApprovalList(address indexed _gpcAddress);
  event WagerApproved(address indexed _customerAddress);
  event GPCApproved(address indexed _gpcAddress);

  function Approval() {
    government = tx.origin;
    numberOfNotApprovedWagers = 0;
    numberOfNotApprovedGPC = 0;
  }

  function addToNotApprovedList(address _userAddr, uint _type) {
    userApproval memory newAppro;
    if (_type == 2) {
      if (userApprovals[_userAddr].userAddress == address(0) && ! userAlreadyInApprovalList[_userAddr]) {
        newAppro.userAddress = _userAddr;
        newAppro.approved = false;
        newAppro.usertype = _type;
        approvals.push(newAppro);

        userApprovals[_userAddr] = newAppro;
        userAlreadyInApprovalList[_userAddr] = true;
        numberOfNotApprovedWagers += 1;
        WagerAddedToApprovalList(_userAddr);
      }
    }
    else if (_type == 1) {
      if (userApprovals[_userAddr].userAddress == address(0) && ! userAlreadyInApprovalList[_userAddr]) {
        newAppro.userAddress = _userAddr;
        newAppro.approved = false;
        newAppro.usertype = _type;
        approvals.push(newAppro);

        userApprovals[_userAddr] = newAppro;
        userAlreadyInApprovalList[_userAddr] = true;
        numberOfNotApprovedGPC += 1;
        GPCAddedToApprovalList(_userAddr);
      }
    }
  }

  function approveWager(address _customer) onlyGovernment {
    if (userApprovals[_customer].userAddress == _customer && ! userApprovals[_customer].approved && userAlreadyInApprovalList[_customer]) {
      userApprovals[_customer].approved = true;
      if (numberOfNotApprovedWagers - 1 < 0) throw;
      numberOfNotApprovedWagers -= 1;
      WagerApproved(_customer);

      // create rationCard for this customer
    }
  }

  function approveGPC(address _gpc) onlyGovernment {
    if (userApprovals[_gpc].userAddress == _gpc && ! userApprovals[_gpc].approved && userAlreadyInApprovalList[_gpc]) {
      userApprovals[_gpc].approved = true;
      if (numberOfNotApprovedGPC - 1 < 0) throw;
      numberOfNotApprovedGPC -= 1;
      GPCApproved(_gpc);
    }
  }

  function getUnApprovedCustomers() constant onlyGovernment returns (uint)  {
    return numberOfNotApprovedWagers;
  }

  function getUnApprovedFPS() constant onlyGovernment returns (uint) {
    return numberOfNotApprovedGPC;
  }

  function getUnapprovedUser(uint _index, uint _type) constant returns (address) {
    uint i;
    if (_type == 1) {
      if (_index >= numberOfNotApprovedGPC)
        return address(0);
      for (i = _index; i < numberOfNotApprovedGPC; i++) {
        if (!approvals[i].approved && approvals[i].usertype == _type)
          return approvals[i].userAddress;
      }
    } else if (_type == 2) {
      if (_index >= numberOfNotApprovedWagers)
        return address(0);
      for (i = _index; i < numberOfNotApprovedWagers; i++) {
        if (!approvals[i].approved && approvals[i].usertype == 2)
        return approvals[i].userAddress;
      }
    }
    return address(0);
  }

}
