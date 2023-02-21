//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Testing {

    uint256 constant DECIMALS = 10000;
    struct Account {
        bool isActive;
        uint256 investedTime;
        uint256 investedAmount;
        uint256 nonWorkingRewardPending;
        uint256 workingAndNonWorkingRewardPending;
        uint256 lastNonWorkingWithdrawTime;
    }

    struct MetaInfo {
        address referrer;
        uint256 referredCount;
        uint256 lastDirectTime;
        uint256 dailyRewardPercent;
        uint256 biggesetInvestment;
        uint256 totalInvestedAmount;
        uint256 workingDailyReward_Pending;
        uint256 workingOneTimeReward_Pending;
        uint256 lastWithDrawNonWorkingRewardTime;
        uint256 totalWorkingReward_Pending;
    }

    mapping(address => Account[]) public accounts;
    mapping(address => MetaInfo) public metaInfoOf;

    function updateData() external {
        accounts[msg.sender].push(Account({
            isActive: true,
            investedTime: block.timestamp,
            investedAmount: 200,
            nonWorkingRewardPending: 200 * 2,
            workingAndNonWorkingRewardPending: 200 * 3,
            lastNonWorkingWithdrawTime: block.timestamp
        }));
        accounts[msg.sender].push(Account({
            isActive: true,
            investedTime: block.timestamp,
            investedAmount: 300,
            nonWorkingRewardPending: 300 * 2,
            workingAndNonWorkingRewardPending: 300 * 3,
            lastNonWorkingWithdrawTime: block.timestamp
        }));
        // accounts[msg.sender].push(Account({
        //     isActive: true,
        //     investedTime: block.timestamp,
        //     investedAmount: 400,
        //     nonWorkingRewardPending: 400 * 2,
        //     lastNonWorkingWithdrawTime: block.timestamp
        // }));

        metaInfoOf[msg.sender].dailyRewardPercent = 300;
        // metaInfoOf[msg.sender].workingDailyReward_Pending = 500;
        // metaInfoOf[msg.sender].workingOneTimeReward_Pending = 1000;
        metaInfoOf[msg.sender].totalWorkingReward_Pending = 500;
    }
    // function calculateNonWorkingRewardOf(address _addr, uint256 _index)
    //     public
    //     view
    //     returns (uint256, uint256, uint256)
    // {
    //     Account memory userAccount = accounts[_addr][_index];
    //     MetaInfo memory userMetaInfo = metaInfoOf[_addr];
    //     uint256 timeDifference = block.timestamp - userAccount.lastInvestedTime;
    //     uint256 rewardableDays = timeDifference / 10;
    //     uint256 rewardableAmount = rewardableDays*((userAccount.investedAmount*userMetaInfo.dailyRewardPercent)/10000);

    //     return (timeDifference, rewardableDays, rewardableAmount);
    // }


    struct Test {
        uint value;
        bool isActive;
    }
    mapping (address => Test[]) public _mapping;
    function updateMapping() external {
        for (uint i; i < 5; i++){
            if(i % 2== 0){ 
                _mapping[msg.sender].push(Test({
                    value: i,
                    isActive: true
                }));
            }
            else {
                _mapping[msg.sender].push(Test({
                    value: i,
                    isActive: false
                }));
            }
        }
    }

    function returnMapping(address _addr) external view returns (Test[] memory) {
        return _mapping[_addr];
    }
    function _update(address _addr) external {
        Test[] storage _mapArray = _mapping[_addr];
        for (uint i; i < 5; i++){
            Test memory _map = _mapArray[i];
            if(_map.isActive){
                _map.isActive = !_map.isActive;
            } else {
                _map.isActive = !_map.isActive;
            }
            
            if(_map.isActive){
                _map.value = 10;
            }
            _mapArray[i] = _map;
        }
    }

function calculateNonWorkingRewardOf(address _addr) public view returns (uint) {
        Account[] memory userAccounts = accounts[_addr];

        uint totalReward;
        for (uint i; i < userAccounts.length; i++){
            if(userAccounts[i].isActive){
                totalReward += calculateNonWorkingRewardOfAt(_addr, i);
            }
        }
        return totalReward;
    }
    
    function calculateNonWorkingRewardOfAt(address _addr, uint _index) public view returns (uint) {
        Account memory userAccount = accounts[_addr][_index];
        require(userAccount.isActive, "Referral: ID is inActive.");
        MetaInfo memory userMetaInfo = metaInfoOf[_addr];
        uint256 timeDifference = block.timestamp - (userAccount.lastNonWorkingWithdrawTime);
        uint256 rewardableDays = timeDifference/(1); // at the time of deployment change 10 to 1 days
        uint256 rewardableAmount = rewardableDays*(userAccount.investedAmount * (userMetaInfo.dailyRewardPercent)/(DECIMALS));

        return rewardableAmount;
    }
    function calculateWorkingRewardOf(address _addr) public view returns (uint) {
        MetaInfo memory userMetaInfo = metaInfoOf[_addr];
        return userMetaInfo.totalWorkingReward_Pending;
    }

    function calculateActualRewardReadOnly(address _addr, uint _nonWorkingReward, uint _workingReward) public view returns (uint) {
        MetaInfo memory userMetaInfo = metaInfoOf[_addr];
        Account[] memory userAccounts = accounts[_addr];
        uint actualReward;

        if(_workingReward == 0){
            for(uint i; i < userAccounts.length; i++) {
                Account memory userAccount = userAccounts[i];
                if(userAccount.isActive){
                    uint256 _totalPending = userAccount.nonWorkingRewardPending; // = 2x
                    if(_nonWorkingReward >= _totalPending){
                        actualReward += _totalPending;
                        _nonWorkingReward -= _totalPending;
                        userAccount.isActive = false;
                    }
                    else {
                        actualReward += _nonWorkingReward;
                        break;
                    }
                } 
            }
        }
        else {
            for(uint i; i < userAccounts.length; i++) {
                Account memory userAccount = userAccounts[i];
                if(userAccount.isActive){
                    uint256 _investedAmount = userAccount.investedAmount;
                    uint256 _totalPending = userAccount.nonWorkingRewardPending + _investedAmount;  // = 3x
                    uint256 _totalReward = _workingReward + _nonWorkingReward;
                    if(_workingReward >= _totalPending){
                        actualReward += _totalPending;
                        _workingReward -= _totalPending;
                        userMetaInfo.totalWorkingReward_Pending -= _totalPending;
                        userAccount.nonWorkingRewardPending = 0;
                        userAccount.isActive = false;
                    }
                    else if (_totalReward > _totalPending) {
                        actualReward += _totalPending;
                        if(_workingReward <= _investedAmount){
                            _nonWorkingReward -= userAccount.nonWorkingRewardPending + (_investedAmount - _workingReward);
                            _workingReward = 0;
                        } else {
                            _workingReward -= userAccount.nonWorkingRewardPending + (_investedAmount - _nonWorkingReward);
                            _nonWorkingReward = 0;
                        }
                        userMetaInfo.totalWorkingReward_Pending -= _totalPending;
                        userAccount.nonWorkingRewardPending = 0;
                        userAccount.isActive = false;
                    }
                    else {
                        actualReward += _totalReward;
                        userAccount.nonWorkingRewardPending -= _totalReward;
                        userMetaInfo.totalWorkingReward_Pending -= _totalReward;
                        _workingReward = 0;
                        _nonWorkingReward = 0;
                        break;
                    }
                }
            }
        }
        return actualReward;
    }

    function calculateActualReward(address _addr, uint _nonWorkingReward, uint _workingReward) public returns (uint) {
        MetaInfo storage userMetaInfo = metaInfoOf[_addr];
        Account[] storage userAccounts = accounts[_addr];
        uint actualReward;

        if(_workingReward == 0){
            for(uint i; i < userAccounts.length; i++) {
                Account storage userAccount = userAccounts[i];
                if(userAccount.isActive){
                    uint256 _totalPending = userAccount.nonWorkingRewardPending; // = 2x
                    if(_nonWorkingReward >= _totalPending){
                        actualReward += _totalPending;
                        _nonWorkingReward -= _totalPending;
                        userAccount.nonWorkingRewardPending = 0;
                        _inActiveID(userAccount);
                        // userAccount.isActive = false
                    }
                    else {
                        actualReward += _nonWorkingReward;
                        userAccount.nonWorkingRewardPending -= _nonWorkingReward;
                        userAccount.workingAndNonWorkingRewardPending -= _nonWorkingReward;
                        _nonWorkingReward = 0;
                        break;
                    }
                } 
            }
        }
        else {
            for(uint i; i < userAccounts.length; i++) {
                Account storage userAccount = userAccounts[i];
                if(userAccount.isActive){
                    uint256 _investedAmount = userAccount.investedAmount;
                    uint256 _totalPending = userAccount.workingAndNonWorkingRewardPending;  // = 3x
                    uint256 _totalReward = _workingReward + _nonWorkingReward;
                    if(_workingReward > _totalPending){
                        actualReward += _totalPending;
                        _workingReward -= _totalPending;
                        userMetaInfo.totalWorkingReward_Pending -= _totalPending;
                        userAccount.nonWorkingRewardPending = 0;
                        userAccount.isActive = false;
                    }
                    else if (_totalReward > _totalPending) {
                        actualReward += _totalPending;
                        if(_workingReward <= _investedAmount){
                            _nonWorkingReward -= userAccount.nonWorkingRewardPending + (_investedAmount - _workingReward);
                            _workingReward = 0;
                        } else {
                            _workingReward -= userAccount.nonWorkingRewardPending + (_investedAmount - _nonWorkingReward);
                            _nonWorkingReward = 0;
                        }
                        userMetaInfo.totalWorkingReward_Pending -= _totalPending;
                        userAccount.nonWorkingRewardPending = 0;
                        userAccount.isActive = false;
                    }
                    else {
                        actualReward += _totalReward;
                        if(_totalReward > userAccount.nonWorkingRewardPending){
                            userAccount.nonWorkingRewardPending = 0;  
                        }
                        else {
                            userAccount.nonWorkingRewardPending -= _totalReward;
                        }
                        userAccount.workingAndNonWorkingRewardPending -= _totalReward;
                        userMetaInfo.totalWorkingReward_Pending -= _totalReward;
                        _workingReward = 0;
                        _nonWorkingReward = 0;
                        // if(_totalReward )
                        // break;
                    }
                }
            }
        }
        return actualReward;
   }
   function _inActiveID(Account storage userAccount) internal {
        userAccount.isActive = false;
        userAccount.nonWorkingRewardPending = 0;
        userAccount.workingAndNonWorkingRewardPending = 0;
   }

}
