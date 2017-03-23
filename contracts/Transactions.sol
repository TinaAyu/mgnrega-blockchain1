pragma solidity ^0.4.0;


contract Transactions{
	uint public noOfTransactions;
    
	address public government;
    uint fixedWagerPaymentperhr;
    uint fixedPaymentToGPC;

    mapping (address => paymentMade) balances;
    mapping (address => wagers1) hourWorked;
    
   
    struct paymentMade{
        uint _type;
        uint balance;
		//address sender;
        address receiver;
    }
    struct wagers1{
        uint hours1;
        uint days1;
        bool flag;
        address user;
    }
    
    
    modifier onlyGovernment{
    if (msg.sender != government) throw;
    _;
  }
  
    function Transactions(){
        government = tx.origin;
        noOfTransactions = 0;
        fixedWagerPaymentperhr = 100;
        fixedPaymentToGPC = 50000;
        //balances[government].balance = 1000000;
        
    }
    function initializeGov(address _user) returns (uint){
    	paymentMade memory govbal;
		uint bal=0;
        if(_user==government){
        	govbal.balance = 10000000;
            govbal._type = 0;
            govbal.receiver = government;
            balances[government] = govbal;
			noOfTransactions +=1;
			bal = balances[government].balance;
            return bal;
        }
       
        	return bal;
        
            
        
    }
    function getNoOfTransactions() constant returns (uint){
    	return noOfTransactions;
    }
    function supplyToGPC(address _gpc) onlyGovernment returns (bool) {
        if(balances[government].balance >= fixedPaymentToGPC){
			paymentMade memory newUser;
            if(balances[_gpc].receiver==address(0)){
                newUser._type = 1;
                newUser.balance = fixedPaymentToGPC;
				newUser.receiver = _gpc;
				balances[_gpc] = newUser;
                balances[government].balance -= fixedPaymentToGPC;
                
            }
            else{
                 balances[_gpc]._type = 1;
                balances[_gpc].balance += fixedPaymentToGPC;
                balances[government]._type = 0;
                balances[government].balance -= fixedPaymentToGPC;
            }
            return true;
        }
        else {
            return false;
        }
    }
    
    function payToWager(address _wager, address _gpc) returns (bool) {
    bool flag;   
	if(balances[_gpc].receiver == address(0)){throw;}
	uint paymentToWager = fixedWagerPaymentperhr*hourWorked[_wager].days1*8 + fixedWagerPaymentperhr*hourWorked[_wager].hours1;
	if(balances[_gpc].balance >= paymentToWager){
            paymentMade memory newUser;

			if(balances[_wager].receiver==address(0)){
                newUser._type = 2;
                newUser.balance = paymentToWager;
                newUser.receiver = _wager;
				balances[_wager] = newUser;
				//balances[_gpc]._type = 1;
                balances[_gpc].balance -= paymentToWager;
                
                
            }
            else{
                //balances[_wager]._type = 2;
                balances[_wager].balance += paymentToWager;
                //balances[_gpc]._type = 1;
                balances[_gpc].balance -= paymentToWager;
            }
       
        return flag;
        }
        return flag;
    }
    
    function hoursWorked(address _wager){

        	wagers1 memory newUser;
            if(hourWorked[_wager].user == address(0)){
				
                newUser.hours1 = 1;
                newUser.flag = true;
                newUser.days1 = 0;
                newUser.user = _wager;
                hourWorked[_wager] = newUser;
            }
            else{
            	if(hourWorked[_wager].flag == false){throw;}
            	if(hourWorked[_wager].hours1 < 8 && hourWorked[_wager].days1<120){
            		hourWorked[_wager].hours1 += 1;
            	}
                if(hourWorked[_wager].hours1 == 8){
                	hourWorked[_wager].hours1 = 0;
                	hourWorked[_wager].days1 += 1;
                }
                
                if(hourWorked[_wager].days1==120){
                    hourWorked[_wager].flag = false;
                }
            }
        
    }
    function timeWorked(address _wager, uint _days, uint _hours){
    	wagers1 memory newUser;
    	if(_days>120){ throw; }
    	if(_hours>=8){
    		_days += (_hours/8);
    		_hours = _hours%8;
    	}
    	if(hourWorked[_wager].user == address(0)){
				
                newUser.hours1 = _hours;
                newUser.flag = true;
                newUser.days1 = _days;
                newUser.user = _wager;
                hourWorked[_wager] = newUser;
            }
           else{
           	if((hourWorked[_wager].hours1+_hours) < 8 && hourWorked[_wager].days1<120){
            		hourWorked[_wager].hours1 += _hours;
            		hourWorked[_wager].days1 += _days;
            	}
            if((hourWorked[_wager].hours1+_hours) == 8){
                	hourWorked[_wager].hours1 = 0;
                	hourWorked[_wager].days1 += 1;
                }
            if(hourWorked[_wager].days1==120){
                    hourWorked[_wager].flag = false;
                }	
           }
    }
    function validWager(address _wager) constant returns (bool){
        
            return hourWorked[_wager].flag;
        
    }
    
   function getHoursWorked(address _wager) constant returns (uint){
        uint hours2 = hourWorked[_wager].days1*8 + hourWorked[_wager].hours1;
        return hours2;
    }
    
    function getBalance(address _cus) constant returns(uint){
        uint balance1;
        
        if(balances[_cus].receiver != address(0)){
         balance1 = balances[_cus].balance;
         return balance1;
        }
        
        return balance1;
    }
    function getDaysWorked(address _cus) constant returns(uint){
        return hourWorked[_cus].days1;
        
    }
    function getRemainingGovBalance() constant returns (uint){
        return balances[government].balance;
    }
    function getRemainingGpcBalance(address _gpc) constant returns(uint){
        return balances[_gpc].balance;
    } 
    
}