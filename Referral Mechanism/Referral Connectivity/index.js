let network;
let contract_address;
let connection;
let mainAccount;
let accounts;
let Accounttype = "0";
let windows = {};
let contractAddress = "0x8A1Cbba159c3918F0F8500Fc61b9Bc73C16a69dc";
let abi = [{"inputs":[{"internalType":"address","name":"_token","type":"address"},{"internalType":"address","name":"_defaultReferrer","type":"address"},{"internalType":"address[]","name":"_marketingAddresses","type":"address[]"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"invester","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"time","type":"uint256"}],"name":"Invested","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"referree","type":"address"},{"indexed":false,"internalType":"address","name":"referrer","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"time","type":"uint256"}],"name":"Registered","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"rewardCollector","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"time","type":"uint256"}],"name":"Withdrawn","type":"event"},{"inputs":[{"internalType":"address","name":"_token","type":"address"}],"name":"Address","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address[]","name":"_addresses","type":"address[]"},{"internalType":"uint256[]","name":"_amounts","type":"uint256[]"}],"name":"Balances","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_token","type":"address"},{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"Booster1","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"Booster2","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_addr","type":"address"},{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"IndividualMax","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address[]","name":"_marketingAddresses","type":"address[]"}],"name":"MarketingAddresses","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_percentage","type":"uint256"}],"name":"MarketingPercentage","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_minAmount","type":"uint256"},{"internalType":"uint256","name":"_maxAmount","type":"uint256"}],"name":"MinAndMax","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"defaultReferrer","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_addr","type":"address"}],"name":"get_dataOf","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"},{"internalType":"uint256[]","name":"","type":"uint256[]"},{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_addr","type":"address"}],"name":"get_pendingRewardOf","outputs":[{"internalType":"uint256","name":"_totalReward","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"get_totalIDs","outputs":[{"internalType":"uint256","name":"ids","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_addr","type":"address"}],"name":"get_totalInvestmentOf","outputs":[{"internalType":"uint256","name":"_totalInvestment","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"get_totalUsers","outputs":[{"internalType":"address[]","name":"users","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"get_totalUsersCount","outputs":[{"internalType":"uint256","name":"usersCount","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_addr","type":"address"}],"name":"get_totalWithdrawnOf","outputs":[{"internalType":"uint256","name":"_totalWithdrawn","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"invest","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"marketingAddresses","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_referrer","type":"address"},{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"register","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"token","outputs":[{"internalType":"contract IERC20","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"withdrawReward","outputs":[],"stateMutability":"nonpayable","type":"function"}];

let tokencontractAddress = "0x208F521710620d417E9f35a37f107e360f4A7c3d";
let tokenabi = [{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"Mint","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"value","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_value","type":"uint256"}],"name":"burn","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"sender","type":"address"},{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"}];

window.setInterval(async function () {
  if (typeof window.ethereum !== undefined) {
    windows.ethereum = window.ethereum;
    let contract = new web3.eth.Contract(abi, contractAddress);
    console.log("aaaa", contract);
  }
}, 500);

window.addEventListener("load", () => {
  interval = setInterval(async function checkConnection() {
    try {
      let isConnected = false;
      if (windows.ethereum) {
        window.web3 = new Web3(windows.ethereum);
        await windows.ethereum.enable();

        isConnected = true;
      } else {
        isConnected = false;
        connection = "Plz install metamask!";
        jQuery("#metamaskConnection").text(connection);
      }
    } catch (error) {
      console.log("Metamask Not Found", error);
    }
    try {
      let accounts = await getAccounts();
      getBalanceOfAccount();
      console.log("length===>" + accounts.length);
      console.log("length===>" + accounts);
      console.log("length===>" + accounts[0]);
      if (accounts.length > 0) {
        connection = "Metamask is unlocked";
        jQuery("#metamaskConnection").text(connection);
        window.web3.eth.getChainId((err, netId) => {
          console.log("networkId==>", netId);
          switch (netId.toString()) {
            case "1":
              console.log("This is mainnet");
              jQuery("#network").text("This is mainnet");
              Accounttype = "1";
              network = "mainnet";
              break;
            case "2":
              console.log("This is the deprecated Morden test network.");
              jQuery("#network").text(
                "This is the deprecated Morden test network."
              );
              break;
            case "3":
              console.log("This is the ropsten test network.");
              jQuery("#network").text("This is the ropsten test network.");
              network = "ropsten";
              break;
            case "4":
              console.log("This is the Rinkeby test network.");
              jQuery("#network").text("This is the Rinkeby test network.");
              network = "Rinkeby";
              break;
            case "42":
              console.log("This is the Kovan test network.");
              jQuery("#network").text("This is the Kovan test network.");
              network = "Kovan";
              break;
            case "97":
              console.log("This is the BNB test network.");
              jQuery("#network").text("This is the BNB test network.");
              network = "BNBTestnet";
              break;
            case "57":
              console.log("This is the BNB main network.");
              jQuery("#network").text("This is the BNB main network.");
              network = "BNBMain";
              break;
            default:
              console.log("This is an unknown network.");
              jQuery("#network").text("This is the unknown test network.");
          }
        });
      } else {
        connection = "Metamask is locked";
        jQuery("#metamaskConnection").text(connection);
      }
    } catch (error) {
      console.log("Error while checking locked account");
    }
    console.log("web3333===>", await window.web3);
  }, 1000);
});

function isLocked() {
  window.web3.eth.getAccounts(function (err, accounts) {
    if (err != null) {
      console.log(err);
      jQuery("#lock").text(err);
    } else if (accounts.length === 0) {
      console.log("MetaMask is locked");
      jQuery("#lock").text("MetaMask is locked.");
    } else {
      console.log("MetaMask is unlocked");
      jQuery("#lock").text("MetaMask is unlocked.");
    }
  });
}

function getBalanceOfAccount() {
  console.log("length===>" + mainAccount);
  window.web3.eth.getBalance(accounts[0], (err, wei) => {
    myBalance = web3.utils.fromWei(wei, "ether");
    console.log("Balance===>", myBalance);
    $("#getBalance").text("Account Balance:" + myBalance + " " + "BNB");
  });
}

const getAccounts = async () => {
  try {
    const web3 = new Web3(windows.ethereum);
    accounts = await web3.eth.getAccounts();
    jQuery("#account").text("Account:" + accounts[0]);
    console.log(accounts);
    return accounts;
  } catch (error) {
    console.log("Error while fetching acounts: ", error);
    return null;
  }
};

async function register() {
  try {
    let referrerAddress = jQuery("#referrerAddress").val();
    let amount = jQuery("#registerInvestment").val();

    let contract = new web3.eth.Contract(abi, contractAddress);
    let tokenContract = new web3.eth.Contract(tokenabi, tokencontractAddress);
    console.log('tokencontract', tokenContract);
    

    // tokenContract.methods
    //   .approve(contractAddress, web3.utils.toWei(amount))
    //   .send({
    //     from: accounts[0],
    //   })
    //   .on("transactionHash", async (hash) => {
    //     console.log("transactionHash: ", hash);
    //     jQuery("#Register_approveHash").text("hash: " + hash);
    //   });
    
    // contract.methods
    //   .register(referrerAddress, web3.utils.toWei(amount))
    //   .send({
    //     from: accounts[0],
    //   })
    //   .on("transactionHash", async (hash) => {
    //     console.log("transactionHash: ", hash);
    //     jQuery("#registerHash").text("Hash:" + hash);
    //   });
  } catch (error) {
    alert(error);
  }
}

async function transactionDetail() {
    let transaction = jQuery("#transaction_hash").val();

    let detail = await web3.eth.getTransactionReceipt(transaction);
    console.log('detail',detail.logs["5"].data);
}

async function SwapBNBToToken() {
  try {
    let amountInBNB = jQuery("#getBNBToBeSwapped").val();

    let amountToBeTransferred = web3.utils.toWei(amountInBNB).toString();

    let contract = new web3.eth.Contract(abi, contractAddress);

    contract.methods
      .swapBNBTotoken()
      .send({
        from: accounts[0],
        value: amountToBeTransferred,
      })
      .on("transactionHash", async (hash) => {
        console.log("transactionHash: ", hash);
        jQuery("#SwapBNBToTokenHash").text("Hash:" + hash);
      });
  } catch (error) {
    alert(error);
  }
}

// async function BNBToDollar() {
//   try {
//     let amountInBNB = jQuery("#getBNBConvertedToDollar").val();

//     let amountToBeConverted = (web3.utils.toWei(amountInBNB)).toString();

//     let contract = new web3.eth.Contract(abi, contractAddress);

//     let convertedValue = await contract.methods.BNB_to_Doller(amountToBeConverted).call();
//     let actualConvertedValue = (web3.utils.fromWei(convertedValue)).toString();
//     let actualConvertedValue1 = (web3.utils.fromWei(actualConvertedValue)).toString();
//     console.log("convertedValue" + actualConvertedValue1);
//     jQuery("#ConvertedBNB").text("Dollars: " + (actualConvertedValue1));

//   }
//   catch (error) {
//     alert(error)
//   }
// }

// async function DollarToBNB() {
//   try {
//     let amountInDollars = jQuery("#getDollarConvertedToBNB").val();

//     // let amountToBeConverted = (web3.utils.toWei(amountInBNB)).toString();

//     let contract = new web3.eth.Contract(abi, contractAddress);

//     let convertedValue = await contract.methods.Doller_To_Bnb(amountInDollars).call();
//     let actualConvertedValue = (web3.utils.fromWei(convertedValue)).toString();
//     console.log("convertedValue" + actualConvertedValue);
//     jQuery("#ConvertedDollars").text("BNBs " + actualConvertedValue);

//   }
//   catch (error) {
//     alert(error)
//   }
// }

async function BNBToToken() {
  try {
    let amountInBNBs = jQuery("#getBNBConvertedToToken").val();

    let amountToBeConverted = web3.utils.toWei(amountInBNBs).toString();

    let contract = new web3.eth.Contract(abi, contractAddress);

    let convertedValue = await contract.methods
      .calculate(amountToBeConverted)
      .call();
    let actualConvertedValue = web3.utils.fromWei(convertedValue).toString();
    console.log("convertedValue" + actualConvertedValue);
    jQuery("#ConvertedBNBsInToken").text("Tokens " + actualConvertedValue);
  } catch (error) {
    alert(error);
  }
}