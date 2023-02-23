//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
 //[10,20,20,20,50,10,20,20,20,50,10,20,20,20,50,10,20,20,20,50,10,20,20,20,50]
interface IERC20 {
    
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;
        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping(bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            if (lastIndex != toDeleteIndex) {
                bytes32 lastValue = set._values[lastIndex];

                // Move the last value to the index where the value to delete is
                set._values[toDeleteIndex] = lastValue;
                // Update the index for the moved value
                set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
            }

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        return set._values[index];
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function _values(Set storage set) private view returns (bytes32[] memory) {
        return set._values;
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
        bytes32[] memory store = _values(set._inner);
        bytes32[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(AddressSet storage set) internal view returns (address[] memory) {
        bytes32[] memory store = _values(set._inner);
        address[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(UintSet storage set) internal view returns (uint256[] memory) {
        bytes32[] memory store = _values(set._inner);
        uint256[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }
}

contract Referral is Ownable {
    using SafeMath for uint256;
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.UintSet;
    /**
     * @dev Max referral level depth
     */
    uint8 constant MAX_REFER_DEPTH = 25;

    uint256 constant DECIMALS = 100e2; // 10000 % to handle decimals. denomenator for calculating percentage

    struct Account {
        bool isActive;
        uint256 id;
        uint256 investedTime;
        uint256 investedAmount;
        uint256 nonWorkingRewardPending;
        uint256 workingAndNonWorkingRewardPending;
        uint256 lastNonWorkingWithdrawTime;
    }

    struct MetaInfo {
        address referrer;
        uint256 totalReferredCount;
        uint256 referredCount_sinceLastWithdrawl;
        uint256 dailyRewardPercent;
        uint256 biggesetInvestment;
        uint256 totalInvestedAmount;
        uint256 workingDailyReward_Pending;
        uint256 workingOneTimeReward_Pending;
        uint256 lastRewardWithdrawTime;
        uint256 totalWorkingReward_Pending;
    }

    mapping(address => Account[]) public accounts;
    mapping(address => MetaInfo) public metaInfoOf;
    mapping(address => uint256) public maxActiveInvestmentOf;
    mapping(address => bool) public isOldComer; // for register or invest

    // variable using Enumerableset library to count different scenarios.
    uint256 totalIDs; // total ids uptill now
    EnumerableSet.AddressSet private totalUsers; // total count of users entered in the system
    EnumerableSet.AddressSet private activeUsers; // total users having at least one active id. 
    EnumerableSet.UintSet private activeIDs;

    uint8 private defaultRewardPercent = 50; // (50 / 100) = 0.5%
    uint8 private boostRewardPercentPerActiveID = 5; // (5 / 100) = 0.05%
    uint8 private rewardForFailedToMaintainBooster = 35; // (35 / 100) = 0.35%
    uint8 private maxRewardPercent = 75; // (75 / 100) = 0.75 %
    uint256 private marketingPercentage= 333; // (333 / 100) = 3.33%

    // @dev: change 30 to 30 days and 90  to 90 days at the time of real deployment
    uint256 public timeDurationToBoostReward = 30; // 30 seconds
    uint256 public timeDurationToDowngradeReward = 90; // 90  seconds
    
    // @dev: change 100  to 100e18 and 10000 to 10000e18
    uint256 public minInvestAmount = 100; 
    uint256 public maxInvestAmount = 10000;
    
    uint256[MAX_REFER_DEPTH] public levelRate_OneTimeWorkingReward; // described as Level bonus in documentation
    uint256[MAX_REFER_DEPTH] public levelRate_DailyReward; // described as Reference bonus in description
    
    IERC20 public Token;
    address immutable public defaultReferrerAddress; 
    // @dev: change these marketing addresses to real addresses at the time of real deployment.
    address private marketing1 = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
    address private marketing2 = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
    address private marketing3 = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;


    event RegisteredReferer(address referee, address referrer);
    event RegisteredRefererFailed(
        address referee,
        address referrer,
        string reason
    );
    event PaidOnetimeReferral(address from, address to, uint256 amount, uint256 level);
    event PaidDailyReferral(address from, address to, uint256 amount, uint256 level);
    event UpdatedUserLastActiveTime(address user, uint256 timestamp);
    event TotalPaidLevelBonus(address invester, uint256 amount, uint256 userAccountNo);
    event TotalPaidReferenceBonus(address from, uint256 amount, uint256 time);
    event UpdatedDailyRewardPercent(address _addr, uint256 from, uint256 to, uint256 time);
    event InActiveTimeOfID(uint256 id, uint256 time);
    event WithDraw(address caller, uint amount, uint256 time);

    constructor(address _token, address _defaultReferrerAddress) {
        require(_token != address(0), "Referral: Invalid Token address");

        Token = IERC20(_token);

        // Level Bonus: [5%, 3%, 2%, 1%, 0.5%, 0.5%, 0.25%, 0.25%, 0.25%, 0.25%, 0.25%, 0.25%, 0.25%, 0.25%, 0.25%, 0.25%, 0.25%, 0.25%, 0.25%, 0.25%, 0.25%, 0.25%, 0.25%, 0.25%, 0.25%]
        levelRate_OneTimeWorkingReward = [500, 300, 200, 100, 50, 50, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25];
        // Reference Bonus: [25%, 10%, 5%, 3%, 1%, 1%, 0.5%, 0.5%, 0.5%, 0.5%, 0.5%, 0.5%, 0.5%, 0.5%, 0.5%, 0.5%, 0.5%, 0.5%, 0.5%, 0.5%, 0.5%, 0.5%, 0.5%, 0.5%, 0.5%]
        levelRate_DailyReward = [2500, 1000, 500, 300, 100, 100, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50];
        
        defaultReferrerAddress = _defaultReferrerAddress;
    }


    function register(address _referrer, uint256 _amount) external {
        address caller = msg.sender; // to reduce gas cost

        require(caller != defaultReferrerAddress, "Referral: No need for default referrer to register");
        if(maxActiveInvestmentOf[caller] == 0){
            require(_amount >= minInvestAmount && _amount <= maxInvestAmount, "Referral: Exceeds Limit");
        }
        else {
            require(_amount >= minInvestAmount && _amount <= maxActiveInvestmentOf[caller], "Referral: Excees Limit");
        }
        require(_amount > 0, "Referral: Invalid amount");
        require(!isOldComer[caller], "Referral: Already Registered");

        bool isRegistered = _register(_referrer);
        require(isRegistered, "Referral: Invalid referrer address");
       
        Token.transferFrom(caller, address(this), _amount);

        _initialize(_amount);
        _transferToMarketingAddresses(_amount);

        isOldComer[caller] = true;
        
        uint totalPaid = _payReferral(_amount);
        emit TotalPaidLevelBonus(caller, totalPaid, accounts[caller].length);
    }
        function isCircularReference(address referrer, address referee)
            internal
            view
            returns (bool)
        {
            address parent = referrer;

            for (uint256 i; i < MAX_REFER_DEPTH; i++) {
                if (parent == address(0)) {
                    break;
                }

                if (parent == referee) {
                    return true;
                }

                parent = metaInfoOf[parent].referrer;
            }

            return false;
        }
        function _register(address _referrer) internal returns (bool) {
            return _addReferrer(_referrer);
        }
        /**
        * @dev Add an address as referrer
        * @param referrer The address would set as referrer of msg.sender
        * @return whether success to add upline
        */
        function _addReferrer(address referrer) internal returns (bool) {
            address caller = msg.sender; // to reduce gas cost

            if (referrer == address(0)) {
                emit RegisteredRefererFailed(
                    caller,
                    referrer,
                    "Referrer cannot be 0x0 address"
                );
                return false;
            } else if (isCircularReference(referrer, caller)) {
                emit RegisteredRefererFailed(
                    caller,
                    referrer,
                    "Referee cannot be one of referrer uplines"
                );
                return false;
            }

            MetaInfo storage userMetaInfo = metaInfoOf[caller];
            MetaInfo storage parentMetaInfo = metaInfoOf[referrer];

            userMetaInfo.referrer = referrer;
            userMetaInfo.dailyRewardPercent = defaultRewardPercent;
            userMetaInfo.lastRewardWithdrawTime = block.timestamp;

            parentMetaInfo.totalReferredCount = parentMetaInfo.totalReferredCount.add(1);
            parentMetaInfo.referredCount_sinceLastWithdrawl = parentMetaInfo.referredCount_sinceLastWithdrawl.add(1);
            totalUsers.add(caller);
            activeUsers.add(caller);

            emit RegisteredReferer(caller, referrer);
            return true;
        }


    function invest(uint256 _amount) external {
        address caller = msg.sender;

        require(isOldComer[caller] || caller == defaultReferrerAddress, "Referral: Not registered yet or not a default referrer.");
        if(maxActiveInvestmentOf[caller] == 0){
            require(_amount >= minInvestAmount && _amount <= maxInvestAmount, "Referral: Exceeds Limit");
        }
        else {
            require(_amount >= minInvestAmount && _amount <= maxActiveInvestmentOf[caller], "Referral: Excees Limit");
        }

        Token.transferFrom(caller, address(this), _amount);

        _initialize(_amount);
        _transferToMarketingAddresses(_amount);
        
        uint totalPaid = _payReferral(_amount);
        emit TotalPaidLevelBonus(caller, totalPaid, accounts[caller].length);
    }

        function _initialize(uint _amount) internal {
            Account[] storage userAccounts = accounts[msg.sender];
            userAccounts.push(Account({
                isActive: true,
                id: ++totalIDs,
                nonWorkingRewardPending: _amount.mul(2),
                workingAndNonWorkingRewardPending: _amount.mul(3),
                investedAmount: _amount,
                investedTime: block.timestamp,
                lastNonWorkingWithdrawTime: block.timestamp
            }));
            activeIDs.add(totalIDs);
        }
        function _transferToMarketingAddresses(uint _amount) internal {
            Token.transfer(marketing1 , _amount.mul(marketingPercentage).div(DECIMALS));
            Token.transfer(marketing2 , _amount.mul(marketingPercentage).div(DECIMALS));
            Token.transfer(marketing3 , _amount.mul(marketingPercentage).div(DECIMALS));
        }

        /**
        * @dev This will calc and pay referral to uplines instantly
        * @param value The number tokens will be calculated in referral process
        * @return the total referral bonus paid
        */
        function _payReferral(uint256 value) internal returns (uint256) {
            MetaInfo storage userMetaInfo = metaInfoOf[msg.sender];
            MetaInfo storage parentMetaInfo = metaInfoOf[userMetaInfo.referrer];
            uint256 totalReferal;

            for (uint256 i; i < MAX_REFER_DEPTH; i++) {
                address parent = userMetaInfo.referrer;
                MetaInfo storage _parentMetaInfo = metaInfoOf[userMetaInfo.referrer];

                if (parent == address(0)) {
                    break;
                }

                uint c = value.mul(levelRate_OneTimeWorkingReward[i]).div(DECIMALS);

                totalReferal = totalReferal.add(c);

                _parentMetaInfo.workingOneTimeReward_Pending = _parentMetaInfo.workingOneTimeReward_Pending.add(c);
                _parentMetaInfo.totalWorkingReward_Pending = _parentMetaInfo.totalWorkingReward_Pending.add(c);
                
                emit PaidOnetimeReferral(msg.sender, parent, c, i + 1);

                userMetaInfo = _parentMetaInfo;
            }

            userMetaInfo.totalInvestedAmount = userMetaInfo.totalInvestedAmount.add(value);
            if(value > parentMetaInfo.biggesetInvestment) {
                parentMetaInfo.biggesetInvestment = value;
            }

            // updateActiveTimestamp(msg.sender);
            return totalReferal;
        }
    


    function withDrawReward() external {
        address caller = msg.sender; // to reduce gas cost

        _updateDailyRewardPercent(caller); // update daily reward percent before transfer to uplines.

        uint256 _nonWorkingReward = calculateNonWorkingRewardOf(caller);
        uint256 _workingReward = calculateWorkingRewardOf(caller);
        uint256 _actualReward = _calculateActualReward(caller, _nonWorkingReward, _workingReward);
        
        Token.transfer(caller, _actualReward);

        uint256 _totalPaid = _payWorkingRewardToUplines(_nonWorkingReward);
        _updateDataAccordingly(caller);

        emit TotalPaidReferenceBonus(caller, _totalPaid, block.timestamp);
        emit WithDraw(caller, _actualReward, block.timestamp);
    }
        function _updateDailyRewardPercent(address _addr) internal {
            MetaInfo storage userMetaInfo = metaInfoOf[_addr];
            uint256 currentTime = block.timestamp;

            if(currentTime > userMetaInfo.lastRewardWithdrawTime + timeDurationToDowngradeReward && userMetaInfo.referredCount_sinceLastWithdrawl == 0){
                emit UpdatedDailyRewardPercent(_addr, userMetaInfo.dailyRewardPercent, rewardForFailedToMaintainBooster, block.timestamp);
                userMetaInfo.dailyRewardPercent = rewardForFailedToMaintainBooster;
                
                return;
            }
            else {
                if(userMetaInfo.referredCount_sinceLastWithdrawl == 0){
                    return;
                }
                else {
                    uint256 _rewardPercent = userMetaInfo.dailyRewardPercent.add(userMetaInfo.referredCount_sinceLastWithdrawl.mul(boostRewardPercentPerActiveID));
                    if(_rewardPercent > maxRewardPercent){
                        emit UpdatedDailyRewardPercent(_addr, userMetaInfo.dailyRewardPercent, maxRewardPercent, block.timestamp);
                        userMetaInfo.dailyRewardPercent = maxRewardPercent;
                    }
                    else {
                        emit UpdatedDailyRewardPercent(_addr, userMetaInfo.dailyRewardPercent, _rewardPercent, block.timestamp);
                        userMetaInfo.dailyRewardPercent = _rewardPercent;
                    }
                }
                
            }
            
        } 
        function _updateDataAccordingly(address caller) internal {
            uint256 currentTime = block.timestamp;

            MetaInfo storage userMetaInfo = metaInfoOf[caller];
            Account[] storage userAccounts = accounts[caller];

            uint count;
            for(uint i; i < userAccounts.length; i++){
                userAccounts[i].lastNonWorkingWithdrawTime = currentTime;
                if(!userAccounts[i].isActive)
                    count++;
            }
            if(count == userAccounts.length)
                activeUsers.remove(caller);

            userMetaInfo.workingDailyReward_Pending = 0;
            userMetaInfo.workingOneTimeReward_Pending = 0;
            userMetaInfo.totalWorkingReward_Pending = 0;
            userMetaInfo.referredCount_sinceLastWithdrawl = 0;
            userMetaInfo.lastRewardWithdrawTime = currentTime;
        }
        function _payWorkingRewardToUplines(uint256 value) internal returns (uint256) {
            MetaInfo storage userMetaInfo = metaInfoOf[msg.sender];
            uint256 totalReferal;

            for (uint256 i; i < MAX_REFER_DEPTH; i++) {
                address parent = userMetaInfo.referrer;
                MetaInfo storage parentMetaInfo = metaInfoOf[parent];

                if (parent == address(0)) {
                    break;
                }

                uint256 c = value.mul(levelRate_DailyReward[i]).div(DECIMALS);

                totalReferal = totalReferal.add(c);

                parentMetaInfo.workingDailyReward_Pending = parentMetaInfo.workingDailyReward_Pending.add(c);
                parentMetaInfo.totalWorkingReward_Pending = parentMetaInfo.totalWorkingReward_Pending.add(c);
                
                emit PaidDailyReferral(msg.sender, parent, c, i + 1);

                userMetaInfo = parentMetaInfo;
            }

            return totalReferal;
        }
        function _calculateActualReward(address _addr, uint _nonWorkingReward, uint _workingReward) internal returns (uint) {
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
                            _inActiveID(userAccount);
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
                uint256 _totalReward = _workingReward + _nonWorkingReward;
                for(uint i; i < userAccounts.length; i++) {
                    Account storage userAccount = userAccounts[i];
                    if(userAccount.isActive){
                        uint256 _totalPending = userAccount.workingAndNonWorkingRewardPending;  // = 3x
                        if(_totalReward <= _totalPending){
                            actualReward += _totalReward;
                            if(_totalReward < userAccount.nonWorkingRewardPending){
                                userAccount.nonWorkingRewardPending -= _totalReward;
                            }
                            else {
                                userAccount.nonWorkingRewardPending = 0;
                            }
                            userAccount.workingAndNonWorkingRewardPending -= _totalReward;
                            if(_totalReward == _totalPending) {
                                _inActiveID(userAccount);
                            }
                            _totalReward = 0;
                            break;
                        }
                        else { // if _totalReward > _totalPending
                            actualReward += _totalPending;
                            _inActiveID(userAccount);
                            _totalReward -= _totalPending;
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
                activeIDs.remove(userAccount.id);

                emit InActiveTimeOfID(userAccount.id, block.timestamp);
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
        MetaInfo memory userMetaInfo = metaInfoOf[_addr];

        require(userAccount.isActive, "Referral: ID is inActive.");
        
        uint256 timeDifference = block.timestamp.sub(userAccount.lastNonWorkingWithdrawTime);
        // @dev: change 10 to 1 days at the time real deployment.
        uint256 rewardableDays = timeDifference.div(10); 
        uint256 rewardableAmount = rewardableDays.mul(userAccount.investedAmount.mul(userMetaInfo.dailyRewardPercent).div(DECIMALS));

        return rewardableAmount;
    }
    function calculateWorkingRewardOf(address _addr) public view returns (uint) {
        MetaInfo memory userMetaInfo = metaInfoOf[_addr];
        return userMetaInfo.totalWorkingReward_Pending;
    }
    function calculateActualReward(address _addr) external view returns (uint) {
        uint256 _nonWorkingReward = calculateNonWorkingRewardOf(_addr);
        uint256 _workingReward = calculateWorkingRewardOf(_addr);
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
            uint256 _totalReward = _workingReward + _nonWorkingReward;
            for(uint i; i < userAccounts.length; i++) {
                Account memory userAccount = userAccounts[i];
                if(userAccount.isActive){
                    uint256 _totalPending = userAccount.workingAndNonWorkingRewardPending;  // = 3x
                    if(_totalReward <= _totalPending){
                        actualReward += _totalReward;
                        if(_totalReward < userAccount.nonWorkingRewardPending){
                            userAccount.nonWorkingRewardPending -= _totalReward;
                        }
                        else {
                            userAccount.nonWorkingRewardPending = 0;
                        }
                        userAccount.workingAndNonWorkingRewardPending -= _totalReward;
                        _totalReward = 0;
                        break;
                    }
                    else { // if _totalReward > _totalPending
                        actualReward += _totalPending;
                        _totalReward -= _totalPending;
                    }
                }
            }
        }
        return actualReward;
    }

    



    function updateToken(address _token) external onlyOwner {
        Token = IERC20(_token);
    }
    function updateMaxActiveInvestmentOf(address _addr, uint256 _amount)
        external
        onlyOwner
    {
        maxActiveInvestmentOf[_addr] = _amount;
    }
    function updateDefaultRewardPercent(uint8 _percent) external onlyOwner {
        defaultRewardPercent = _percent;
    }
    function updateMinInvestAmount (uint _amount) external onlyOwner{
        minInvestAmount = _amount;
    }
    function updateMaxInvestAmount (uint _amount) external onlyOwner{
        maxInvestAmount = _amount;
    }
    function changeMarketingPercent (uint256 _percent) external onlyOwner {
        marketingPercentage = _percent;
    }



    function withdrawToken(address _Token, uint256 _amount) external onlyOwner{
        require(IERC20(_Token).transfer(msg.sender,_amount),"Token transfer Error!");
    }
    function withdrawBNB(uint256 _amount) public onlyOwner{
        payable(msg.sender).transfer(_amount);
    }



    function total_users_count() public view returns (uint256 _totalUsersCount, uint256 _activeUsersCount){
        return (totalUsers.length(), activeUsers.length());
    }
    function total_users() public view returns (address[] memory _totalUsers, address[] memory _activeUsers){
        return (totalUsers.values(), activeUsers.values());
    }
    function total_ids_count() public view returns (uint256 _totalIdsCount, uint256 _activeIdsCount) {
        return (totalIDs, activeIDs.length());
    }
    function total_active_ids() public view returns (uint256[] memory _activeIds) {
        return (activeIDs.values());
    }
    // investment detail of specific user
    function investment_of(address _addr) public view returns (uint256 _investmentCount, uint256 _activeInvestmentCount, uint256 _totalInvestment, uint256 _activeInvestment) {
        Account[] memory userAccounts = accounts[_addr];
        _investmentCount = userAccounts.length;

        for (uint i; i < userAccounts.length; i++){
            _totalInvestment += userAccounts[i].investedAmount;
            if(userAccounts[i].isActive){
                _activeInvestmentCount++;
                _activeInvestment += userAccounts[i].investedAmount;
            }
        }
    }
}
