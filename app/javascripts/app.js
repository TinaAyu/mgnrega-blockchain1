// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";

// Import libraries we need.
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

// Import our contract artifacts and turn them into usable abstractions.
import transaction_artifacts from '../../build/contracts/Transactions.json'

// MetaCoin is our usable abstraction, which we'll use through the code below.
var Transaction = contract(transaction_artifacts);

// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
var accounts;
var governmentAddress;
var transactionGlobal;
window.App = {
  start: function() {
    var self = this;

    // Bootstrap the MetaCoin abstraction for Use.
    Transaction.setProvider(web3.currentProvider);
    Transaction.deployed().then(function(instance){
        transactionGlobal = instance;
    });
    // Get the initial account balance so it can be displayed.
    web3.eth.getAccounts(function(err, accs) {
      if (err != null) {
        alert("There was an error fetching your accounts.");
        return;
      }

      if (accs.length == 0) {
        alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
        return;
      }

      accounts = accs;
      governmentAddress = accounts[0];
      //var governmentBalance = self.getGovBalance();
      var gaddressEle = document.getElementById('government-address');
      
      gaddressEle.innerHTML = governmentAddress;
      //gbalanceEle.innerHTML = governmentBalance;
      self.initializeGovBal();
     self.getBalance1();
    });
  },
  initializeGovBal: function(){
    var self = this;
    var govAddr = document.getElementById('government-address').innerHTML;
    var bal;

    Transaction.deployed().then(function(instance){
        bal = instance;
        //return bal.initializeGov(govAddr);
        return bal.initializeGov(govAddr, {from:governmentAddress, gas: 100000});
    }).then(function(res){
      console.log(res.valueOf());
      //var gbalanceEle = document.getElementById('government-balance');
      //gbalanceEle.innerHTML = res.valueOf();
     /* }).catch(function(e){
    console.log(e);*/
     //self.getBalance1();
  });

  },
  supplyToGPC: function(){
    var self = this;
    var gpc = document.getElementById('gpc_addr').value;
    
    var gpcAddr = accounts[gpc];
    alert(gpcAddr);
    //console.log(gpcAddr);
    var bal;

    Transaction.deployed().then(function(instance){
        bal = instance;
        //return bal.initializeGov(govAddr);
        return bal.supplyToGPC(gpcAddr, {from:governmentAddress, gas: 200000});
    }).then(function(res){
      console.log(res.valueOf());
      //var gbalanceEle = document.getElementById('government-balance');
      //gbalanceEle.innerHTML = res.valueOf();
      }).catch(function(e){
    console.log(e);
  });
      self.getBalance1();
     
     /* var user;
   Transaction.deployed().then(function(instance){
   user =instance; 
   return user.getRemainingGpcBalance(gpcAddr,{from: governmentAddress, gas:200000});
 }).then(function(res){
  console.log(res.valueOf());
});  */ 
  },
  getBal: function(){
      var self=this;
      var addr = prompt("Please enter address of account");
      if(addr!=null){
        var addr =accounts[addr];
        var user;
        Transaction.deployed().then(function(instance){
        user = instance;
        //return bal.initializeGov(govAddr);
        return user.getBalance.call(addr, {from:governmentAddress, gas: 200000});
    }).then(function(res){
      console.log(res.valueOf());
      alert(res.valueOf());
      }).catch(function(e){
    console.log(e);
  });
      }
  },
  setTimeworked: function(){
    var self=this;
    var user;
    var addr_no =prompt("Please enter wager account to set time");
    var days1 = prompt("Enter number of days:");
    var hours1 = prompt("Enter number of hours:");
    if(addr_no!=null && days1!=null && hours1!=null){
      var addr =accounts[addr_no];
      Transaction.deployed().then(function(instance){
        user =instance; 
        return user.timeWorked(addr,days1,hours1,{from: governmentAddress, gas:100000});
      }).then(function(res){
        alert("Success!!");
        console.log(res.valueOf());
     }).catch(function(e){
    console.log(e);
  });

    }
  },
  supplyToWager: function(){
    var self = this;
    var user;
    var gpc = document.getElementById('gpc_addr').value;
    var wager = document.getElementById('wager_addr').value;
    var gpc_addr1 = accounts[gpc];
    var wager_addr1 = accounts[wager];
    alert(gpc_addr1)
    alert(wager_addr1);
    Transaction.deployed().then(function(instance){
        user =instance; 
        return user.payToWager(wager_addr1,gpc_addr1,{from: governmentAddress, gas:200000});
      }).then(function(res){
        alert("Success!!");
        console.log(res.valueOf());
     }).catch(function(e){
    console.log(e);
  });

  },
  getBalance1: function(){

    var self=this;
    var govAddr = document.getElementById('government-address').innerHTML;
    var user;

    Transaction.deployed().then(function(instance){
        user = instance;
        //return bal.initializeGov(govAddr);
        return user.getBalance.call(governmentAddress, {from:governmentAddress, gas: 200000});
    }).then(function(res){
      console.log(res.valueOf());
      var gbalanceEle = document.getElementById('government-balance');
      gbalanceEle.innerHTML = res.valueOf();
      //console.log(res1);
    //var gbalanceEle = document.getElementById('government-balance');
    //gbalanceEle.innerHTML = res.valueOf();
  /*}).catch(function(e){
    console.log(e);*/
  });
  },

  /*setStatus: function(message) {
    var status = document.getElementById("status");
    status.innerHTML = message;
  },

  refreshBalance: function() {
    var self = this;

    var meta;
    MetaCoin.deployed().then(function(instance) {
      meta = instance;
      return meta.getBalance.call(account, {from: account});
    }).then(function(value) {
      var balance_element = document.getElementById("balance");
      balance_element.innerHTML = value.valueOf();
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error getting balance; see log.");
    });
    self.sendCoin();
  },

  sendCoin: function() {
    var self = this;

    var amount = parseInt(document.getElementById("amount").value);
    var receiver = document.getElementById("receiver").value;

    this.setStatus("Initiating transaction... (please wait)");

    var meta;
    MetaCoin.deployed().then(function(instance) {
      meta = instance;
      return meta.sendCoin(receiver, amount, {from: account});
    }).then(function() {
      self.setStatus("Transaction complete!");
      self.refreshBalance();
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error sending coin; see log.");
    });
  }
*/
};

window.addEventListener('load', function() {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 MetaCoin, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider);
  } else {
    console.warn("No web3 detected. Falling back to http://localhost:8545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
  }

  App.start();
});
