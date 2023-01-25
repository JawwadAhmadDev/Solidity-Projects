//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
-----------------------------------------------------------------------------
* ************Description of this locking Smart Contract******************
-----------------------------------------------------------------------------
* This is contract is designed to lock supply for a specific time of period. 
* Detail is as follows:
* 1. Any one can lock the supply.
  2. Whenever user will come for locking, he will provide following things.
    i. token address
    ii. time limit
    iii. total supply to be locked.
  3. More than one users can lock supply of same token. This contract will handle separately.
  4. Only this contract owner or supply locker can withDraw supply.
  5. Once supply is locked, same user cannot lock supply till the exiry of time limit for that token.
  6. Only contract owner / supply provider can reduce the time limit.
  7. Only contract owner can withDraw emergency withDraw from the contract.
  8. All the amount of given token will be withDrawn by using emergency WithDraw function. and all the data will be reset to null.
*/


library SafeMath {
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
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
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
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
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
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
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
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
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
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IERC20 {
  function totalSupply() external view returns (uint256);
  function decimals() external view returns (uint8);
  function symbol() external view returns (string memory);
  function name() external view returns (string memory);
  function getOwner() external view returns (address);
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function allowance(address _owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}



contract SupplyLocker {

    using SafeMath for uint256;
    address private contractOwner;

    constructor() {
        contractOwner = msg.sender;
    }

    // structure: to store Token data which is locked in our contract
    struct TokenData{
        uint256 startTime;   // to hold startTime.
        uint256 endTime;     // to hold: startTime + timeLimit
        uint256 totalSupply;
        uint256 remainingSupply; 
        uint256 oneSecondSupply; // amount of tokens in one second.
        uint256 withDrawnAmount; // total amount withDrawn till.
        uint256 lastWithDrawTime;
        address supplier;        // supplier of the token. because only supplier can withDraw
    }
    
    // mapping TokenAddress => TokenData.
    mapping (IERC20 => mapping (address => TokenData)) public _tokenData;


    // modifier: Only token Owner or contract owner
    modifier onlyAuthorized(IERC20 _token) {
        require(msg.sender == contractOwner || msg.sender == _tokenData[_token][msg.sender].supplier, "Not authorized");
        _;
    }
    // // modifer: only token Owner
    modifier onlyContractOwner(){
        require(msg.sender == contractOwner, "Not a contract owner");
        _;
    }



    /// @notice This function is used to lock timelimit and total supply
    /// @param	_token: Address of Token, caller is willing to lock.
    /// @param	_timeLimit: Total Time for locked tokens
    /// @param	_supply: Total supply to be locked.
    function lockSupply(IERC20 _token, uint256 _timeLimit, uint256 _supply) external {
        
        TokenData storage _data = _tokenData[_token][msg.sender];

        // prevents againt enterance of already given token before time limit ends.
        require(_data.remainingSupply == 0, "You already have locked this token");

        // take tokens from caller.
        _token.transferFrom(msg.sender, address(this), _supply);

        // setting supplier address for verification at withDraw time.
        _data.supplier = msg.sender;
        
        // update data of token after locking.
        _data.startTime = block.timestamp;
        _data.lastWithDrawTime = _data.startTime;
        _data.endTime = _data.startTime.add(_timeLimit);
        _data.totalSupply = _supply;
        _data.remainingSupply = _data.totalSupply;
        _data.oneSecondSupply = _data.totalSupply.div(_timeLimit);
    }


    /// @notice This function is used to withDraw authrozied amount of token
    /// @param _token:  address, user want to withDraw
    function withDrawSupply(IERC20 _token) external onlyAuthorized(_token) {
        TokenData storage _data = _tokenData[_token][msg.sender];

        // if all the amount is already withDrawn then error will be shown and function will not be executed.
        require(_data.remainingSupply != 0, "Total supply has been withDrawn");

        uint256 _withDrawAmount = _calculateWithDrawAmount(_token);

        _data.remainingSupply = _data.remainingSupply.sub(_withDrawAmount);
        _data.lastWithDrawTime = block.timestamp;
        _data.withDrawnAmount = _data.withDrawnAmount.add(_withDrawAmount);
        
        _token.transfer(_data.supplier, _withDrawAmount);
    }
    
    /// @notice This function calculates the total amount of tokens from start time to now.
    /// @return	Tokens: total tokens from start to now.
    function _calculateWithDrawAmount(IERC20 _token) internal view returns (uint256){
        TokenData storage _data = _tokenData[_token][msg.sender];

        uint256 _withDrawAmount;
        if(block.timestamp < _data.endTime) {
            uint256 _balanceSeconds = block.timestamp.sub(_data.lastWithDrawTime);
            _withDrawAmount = _balanceSeconds.mul(_data.oneSecondSupply);
        }
        else {
            _withDrawAmount = _data.remainingSupply;
        }
        
        return _withDrawAmount;
    }

 
    // this function is used to update timeLimit.
    // only supplier of the token is authorized.
    function updateTimeLimit(IERC20 _token, uint256 _timeLimit) external onlyAuthorized(_token){
        TokenData storage _data = _tokenData[_token][msg.sender];

        // check if total supply is ended or not.
        require(_data.remainingSupply != 0, "Entire supply ended. Lock some supply first.");

        _data.lastWithDrawTime = block.timestamp;
        // calculate oneSecond supply according to new timelimit.
        _data.endTime = _data.lastWithDrawTime.add(_timeLimit);
        _data.oneSecondSupply = _data.remainingSupply.div(_timeLimit);
    }


    /// @notice This function returns the withDrawable amount uptil now from last withDraw.
    /// @return	Tokens: total tokens from last withDraw to now.
    function checkWithDrawableAmount(IERC20 _token, address _supplier) external view returns (uint256){
        // stores amount of tokens uptill now from last withDraw
        TokenData storage _data = _tokenData[_token][_supplier];

        uint256 _withDrawableAmount;
        if(block.timestamp < _data.endTime) {
            uint256 _balanceSeconds = block.timestamp.sub(_data.lastWithDrawTime);
            _withDrawableAmount = _balanceSeconds.mul(_data.oneSecondSupply);
        }
        else {
            _withDrawableAmount = _data.remainingSupply;
        }
        
        return _withDrawableAmount;
    }


    // only contract owner can withDraw
    function emergencyWithDraw(IERC20 _token) external onlyContractOwner {
        TokenData storage _data = _tokenData[_token][msg.sender];
        uint256 _remainingBalance = _data.remainingSupply;

        // reset all the data stored against this token and caller.
        delete _tokenData[_token][msg.sender];

        _token.transfer(msg.sender, _remainingBalance);
    }
}