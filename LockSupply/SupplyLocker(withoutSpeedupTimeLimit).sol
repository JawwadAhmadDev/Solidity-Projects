//SPDX-License-Identifier: MIT

/*
-----------------------------------------------------------------------------
* ************Declaration of this locking Smart Contract******************
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
*/
pragma solidity ^0.8.17;

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
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function allowance(address _owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract SupplyProvider{

    using SafeMath for uint256;
    address private contractOwner;

    constructor() {
        contractOwner = msg.sender;
    }

    // structure: to store Token data which is locked in our contract
    struct TokenData{
        uint256 startTime;       // to hold startTime.
        uint256 endTime;         // to hold: startTime + timeLimit
        uint256 totalSupply;
        uint256 remainingSupply; 
        uint256 oneSecondSupply; // amount of tokens in one second.
        uint256 withDrawnAmount; // total amount withDrawn till.
        address supplier;        // supplier of the token. because only supplier can withDraw
    }
    
    // mapping TokenAddress => owner => tokenData
    mapping (IERC20 => mapping (address => TokenData)) public _tokenData;


    // modifier: Only token Owner or contract owner
    modifier onlyAuthorized(IERC20 _token) {
        require(msg.sender == contractOwner || msg.sender == _tokenData[_token][msg.sender].supplier, "Not authorized");
        _;
    }



    /// @notice This function is used to lock timelimit and total supply
    /// @param	_token: Address of Token, caller is willing to lock.
    /// @param	_timeLimit: Total Time for locked tokens
    /// @param	_supply: Total supply to be locked.
    function lockSupply(IERC20 _token, uint256 _timeLimit, uint256 _supply) external {
        
        TokenData storage _data = _tokenData[_token][msg.sender];

        // prevents again enterance for locking of already locked token before time limit ends.
        require(_data.remainingSupply == 0, "You already have locked this token");

        // take tokens from caller.
        _token.transferFrom(msg.sender, address(this), _supply);

        // setting supplier address for later verification at withDraw time.
        _data.supplier = msg.sender;
        
        // update data of token after locking.
        _data.startTime = block.timestamp;
        _data.endTime = _data.startTime.add(_timeLimit);
        _data.totalSupply = _supply;
        _data.remainingSupply = _data.totalSupply;
        _data.oneSecondSupply = _data.totalSupply.div(_timeLimit);
    }


    /// @notice This function is used to withDraw allowed amount of token
    /// @param _token:  address of token, user want to withDraw
    function withDrawSupply(IERC20 _token) external onlyAuthorized(_token) {
        TokenData storage _data = _tokenData[_token][msg.sender];

        // if amount is withDrawn then error will be shown and function will not be executed.
        require(_data.remainingSupply != 0, "Total supply has been withDrawn");

        uint256 actualWithDrawAmount;   // to store actual amount to be withDrawn.
        // withDrawable amount shows the total withDrawable amount from start time to till.
        uint256 withDrawableAmount = _calculateWithDrawableAmount(_token);
        
        // if time didn't passed, withDrawable amount will be greater than totalSupply
        if(withDrawableAmount <= _data.totalSupply){
            actualWithDrawAmount = withDrawableAmount.sub(_data.withDrawnAmount);
            _data.withDrawnAmount = _data.withDrawnAmount.add(actualWithDrawAmount);
            _data.remainingSupply = _data.remainingSupply.sub(actualWithDrawAmount); 
        }
        else{
            actualWithDrawAmount = _data.remainingSupply;
            _data.withDrawnAmount = _data.withDrawnAmount.add(_data.remainingSupply);
            _data.remainingSupply = 0;
        }   
        _token.transfer(_data.supplier, actualWithDrawAmount);
    }

    /// @notice This function calculates the total amount of tokens from start time to now.
    /// @return	Tokens: total tokens from start to now.
    function _calculateWithDrawableAmount(IERC20 _token) internal view returns (uint256){
        TokenData storage _data = _tokenData[_token][msg.sender];

        uint256 _nowTime = block.timestamp;
        uint256 _withDrawableAmount;

        // caculating total amount of token uptill now.
        uint256 _balanceSeconds = _nowTime.sub(_data.startTime);
        _withDrawableAmount = _balanceSeconds.mul(_data.oneSecondSupply);
  
        return _withDrawableAmount;
    }
}