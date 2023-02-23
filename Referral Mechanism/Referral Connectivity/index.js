let network;
let contract_address;
let connection;
let mainAccount;
let accounts;
let Accounttype = "0";
let windows = {};
let contractAddress = "0xbC4BF2D43a855672CF4Ec8ae70f909825cD93602";
let abi = [
  {
    inputs: [
      { internalType: "address", name: "_token", type: "address" },
      {
        internalType: "address",
        name: "_defaultReferrerAddress",
        type: "address",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      { indexed: false, internalType: "uint256", name: "id", type: "uint256" },
      {
        indexed: false,
        internalType: "uint256",
        name: "time",
        type: "uint256",
      },
    ],
    name: "InActiveTimeOfID",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "previousOwner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "newOwner",
        type: "address",
      },
    ],
    name: "OwnershipTransferred",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "from",
        type: "address",
      },
      { indexed: false, internalType: "address", name: "to", type: "address" },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "level",
        type: "uint256",
      },
    ],
    name: "PaidDailyReferral",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "from",
        type: "address",
      },
      { indexed: false, internalType: "address", name: "to", type: "address" },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "level",
        type: "uint256",
      },
    ],
    name: "PaidOnetimeReferral",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "referee",
        type: "address",
      },
      {
        indexed: false,
        internalType: "address",
        name: "referrer",
        type: "address",
      },
    ],
    name: "RegisteredReferer",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "referee",
        type: "address",
      },
      {
        indexed: false,
        internalType: "address",
        name: "referrer",
        type: "address",
      },
      {
        indexed: false,
        internalType: "string",
        name: "reason",
        type: "string",
      },
    ],
    name: "RegisteredRefererFailed",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "invester",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "userAccountNo",
        type: "uint256",
      },
    ],
    name: "TotalPaidLevelBonus",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "time",
        type: "uint256",
      },
    ],
    name: "TotalPaidReferenceBonus",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "_addr",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "from",
        type: "uint256",
      },
      { indexed: false, internalType: "uint256", name: "to", type: "uint256" },
      {
        indexed: false,
        internalType: "uint256",
        name: "time",
        type: "uint256",
      },
    ],
    name: "UpdatedDailyRewardPercent",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "user",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "timestamp",
        type: "uint256",
      },
    ],
    name: "UpdatedUserLastActiveTime",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "caller",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "time",
        type: "uint256",
      },
    ],
    name: "WithDraw",
    type: "event",
  },
  {
    inputs: [],
    name: "Token",
    outputs: [{ internalType: "contract IERC20", name: "", type: "address" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      { internalType: "address", name: "", type: "address" },
      { internalType: "uint256", name: "", type: "uint256" },
    ],
    name: "accounts",
    outputs: [
      { internalType: "bool", name: "isActive", type: "bool" },
      { internalType: "uint256", name: "id", type: "uint256" },
      { internalType: "uint256", name: "investedTime", type: "uint256" },
      { internalType: "uint256", name: "investedAmount", type: "uint256" },
      {
        internalType: "uint256",
        name: "nonWorkingRewardPending",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "workingAndNonWorkingRewardPending",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "lastNonWorkingWithdrawTime",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "address", name: "_addr", type: "address" }],
    name: "calculateActualReward",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "address", name: "_addr", type: "address" }],
    name: "calculateNonWorkingRewardOf",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      { internalType: "address", name: "_addr", type: "address" },
      { internalType: "uint256", name: "_index", type: "uint256" },
    ],
    name: "calculateNonWorkingRewardOfAt",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "address", name: "_addr", type: "address" }],
    name: "calculateWorkingRewardOf",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "_percent", type: "uint256" }],
    name: "changeMarketingPercent",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "defaultReferrerAddress",
    outputs: [{ internalType: "address", name: "", type: "address" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "_amount", type: "uint256" }],
    name: "invest",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "address", name: "_addr", type: "address" }],
    name: "investment_of",
    outputs: [
      { internalType: "uint256", name: "_investmentCount", type: "uint256" },
      {
        internalType: "uint256",
        name: "_activeInvestmentCount",
        type: "uint256",
      },
      { internalType: "uint256", name: "_totalInvestment", type: "uint256" },
      { internalType: "uint256", name: "_activeInvestment", type: "uint256" },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "address", name: "", type: "address" }],
    name: "isOldComer",
    outputs: [{ internalType: "bool", name: "", type: "bool" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    name: "levelRate_DailyReward",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    name: "levelRate_OneTimeWorkingReward",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "address", name: "", type: "address" }],
    name: "maxActiveInvestmentOf",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "maxInvestAmount",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "address", name: "", type: "address" }],
    name: "metaInfoOf",
    outputs: [
      { internalType: "address", name: "referrer", type: "address" },
      { internalType: "uint256", name: "totalReferredCount", type: "uint256" },
      {
        internalType: "uint256",
        name: "referredCount_sinceLastWithdrawl",
        type: "uint256",
      },
      { internalType: "uint256", name: "dailyRewardPercent", type: "uint256" },
      { internalType: "uint256", name: "biggesetInvestment", type: "uint256" },
      { internalType: "uint256", name: "totalInvestedAmount", type: "uint256" },
      {
        internalType: "uint256",
        name: "workingDailyReward_Pending",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "workingOneTimeReward_Pending",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "lastRewardWithdrawTime",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "totalWorkingReward_Pending",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "minInvestAmount",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "owner",
    outputs: [{ internalType: "address", name: "", type: "address" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      { internalType: "address", name: "_referrer", type: "address" },
      { internalType: "uint256", name: "_amount", type: "uint256" },
    ],
    name: "register",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "renounceOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "timeDurationToBoostReward",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "timeDurationToDowngradeReward",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "total_active_ids",
    outputs: [
      { internalType: "uint256[]", name: "_activeIds", type: "uint256[]" },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "total_ids_count",
    outputs: [
      { internalType: "uint256", name: "_totalIdsCount", type: "uint256" },
      { internalType: "uint256", name: "_activeIdsCount", type: "uint256" },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "total_users",
    outputs: [
      { internalType: "address[]", name: "_totalUsers", type: "address[]" },
      { internalType: "address[]", name: "_activeUsers", type: "address[]" },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "total_users_count",
    outputs: [
      { internalType: "uint256", name: "_totalUsersCount", type: "uint256" },
      { internalType: "uint256", name: "_activeUsersCount", type: "uint256" },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "address", name: "newOwner", type: "address" }],
    name: "transferOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint8", name: "_percent", type: "uint8" }],
    name: "updateDefaultRewardPercent",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      { internalType: "address", name: "_addr", type: "address" },
      { internalType: "uint256", name: "_amount", type: "uint256" },
    ],
    name: "updateMaxActiveInvestmentOf",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "_amount", type: "uint256" }],
    name: "updateMaxInvestAmount",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "_amount", type: "uint256" }],
    name: "updateMinInvestAmount",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "address", name: "_token", type: "address" }],
    name: "updateToken",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "withDrawReward",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "_amount", type: "uint256" }],
    name: "withdrawBNB",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      { internalType: "address", name: "_Token", type: "address" },
      { internalType: "uint256", name: "_amount", type: "uint256" },
    ],
    name: "withdrawToken",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

let tokencontractAddress = "0x208F521710620d417E9f35a37f107e360f4A7c3d";
let tokenabi = [
  { inputs: [], stateMutability: "nonpayable", type: "constructor" },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "value",
        type: "uint256",
      },
    ],
    name: "Approval",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      { indexed: true, internalType: "address", name: "from", type: "address" },
      { indexed: true, internalType: "address", name: "to", type: "address" },
      {
        indexed: false,
        internalType: "uint256",
        name: "value",
        type: "uint256",
      },
    ],
    name: "Transfer",
    type: "event",
  },
  {
    inputs: [{ internalType: "uint256", name: "amount", type: "uint256" }],
    name: "Mint",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      { internalType: "address", name: "owner", type: "address" },
      { internalType: "address", name: "spender", type: "address" },
    ],
    name: "allowance",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      { internalType: "address", name: "spender", type: "address" },
      { internalType: "uint256", name: "value", type: "uint256" },
    ],
    name: "approve",
    outputs: [{ internalType: "bool", name: "", type: "bool" }],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "address", name: "account", type: "address" }],
    name: "balanceOf",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "_value", type: "uint256" }],
    name: "burn",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "decimals",
    outputs: [{ internalType: "uint8", name: "", type: "uint8" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      { internalType: "address", name: "spender", type: "address" },
      { internalType: "uint256", name: "subtractedValue", type: "uint256" },
    ],
    name: "decreaseAllowance",
    outputs: [{ internalType: "bool", name: "", type: "bool" }],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      { internalType: "address", name: "spender", type: "address" },
      { internalType: "uint256", name: "addedValue", type: "uint256" },
    ],
    name: "increaseAllowance",
    outputs: [{ internalType: "bool", name: "", type: "bool" }],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "name",
    outputs: [{ internalType: "string", name: "", type: "string" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "symbol",
    outputs: [{ internalType: "string", name: "", type: "string" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "totalSupply",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      { internalType: "address", name: "recipient", type: "address" },
      { internalType: "uint256", name: "amount", type: "uint256" },
    ],
    name: "transfer",
    outputs: [{ internalType: "bool", name: "", type: "bool" }],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      { internalType: "address", name: "sender", type: "address" },
      { internalType: "address", name: "recipient", type: "address" },
      { internalType: "uint256", name: "amount", type: "uint256" },
    ],
    name: "transferFrom",
    outputs: [{ internalType: "bool", name: "", type: "bool" }],
    stateMutability: "nonpayable",
    type: "function",
  },
];

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
    let investmentAmount = web3.utils.toWei(amount).toString();

    let contract = new web3.eth.Contract(abi, contractAddress);
    let tokenContract = new web3.eth.Contract(tokenabi, tokencontractAddress);

    let approveHash = await tokenContract.methods.approve(
      contractAddress,
      investmentAmount
    );
    console.log("transaction approved hash", approveHash);
    jQuery('#')

    contract.methods
      .register(referrerAddress, web3.utils.toWei(investmentAmount))
      .send({
        from: accounts[0],
      })
      .on("transactionHash", async (hash) => {
        console.log("transactionHash: ", hash);
        jQuery("#registerHash").text("Hash:" + hash);
      });
  } catch (error) {
    alert(error);
  }
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
