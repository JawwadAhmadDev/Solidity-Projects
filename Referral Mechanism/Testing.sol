//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Testing {
    struct Account {
        uint256 nonWorkingReward;
        uint256 investedAmount;
        uint256 withdrawlAmount;
        uint256 lastInvestedTime;
    }

    struct MetaInfo {
        address referrer;
        uint256 referredCount;
        uint256 workingOneTimeReward;
        uint256 workingDailyReward;
        uint256 dailyRewardPercent;
        uint256 totalInvestedAmount;
        uint256 biggesetInvestment;
        uint256 lastDirectTime;
        uint256 lastWithDrawNonWorkingRewardTime;
    }

    mapping(address => Account[]) public accounts;
    mapping(address => MetaInfo) public metaInfoOf;

    function updateData() external {
        accounts[msg.sender].push(Account({
             nonWorkingReward: 0,
             investedAmount: 100000,
             withdrawlAmount: 0,
             lastInvestedTime: block.timestamp
        }));
        accounts[msg.sender].push(Account({
             nonWorkingReward: 0,
             investedAmount: 500000,
             withdrawlAmount: 0,
             lastInvestedTime: block.timestamp
        }));

        metaInfoOf[msg.sender].dailyRewardPercent = 50;
    }
    function calculateNonWorkingRewardOf(address _addr, uint256 _index)
        public
        view
        returns (uint256, uint256, uint256)
    {
        Account memory userAccount = accounts[_addr][_index];
        MetaInfo memory userMetaInfo = metaInfoOf[_addr];
        uint256 timeDifference = block.timestamp - userAccount.lastInvestedTime;
        uint256 rewardableDays = timeDifference / 10;
        uint256 rewardableAmount = rewardableDays*((userAccount.investedAmount*userMetaInfo.dailyRewardPercent)/10000);

        return (timeDifference, rewardableDays, rewardableAmount);
    }

    function checking (uint amount) external pure returns (uint) {
        return amount / 10;
    }
}
