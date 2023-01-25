//SPDX-License-Identifier: MIT
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




contract SupplyProvider{

    using SafeMath for uint256;
    uint256 public startTime;   // to hold startTime.
    uint256 public endTime;     // to hold: startTime + timeLimit
    uint256 public totalSupply;
    uint256 public remainingSupply; 
    uint256 public oneSecondSupply; // amount of tokens in one second.
    uint256 public withDrawnAmount; // total amount withDrawn till.
    address public owner;
    address public authorizedPerson;


    /// @notice This function is used to lock timelimit and total supply
    /// @param	_timeLimit: Total Time for locked tokens
    /// @param	_supply: Total supply to be locked.
    function lockSupply(uint256 _timeLimit, uint256 _supply, address _authorizedPerson) external {
        owner = msg.sender;
        authorizedPerson = _authorizedPerson;
        startTime = block.timestamp;
        endTime = startTime.add(_timeLimit);
        totalSupply = _supply;
        remainingSupply = totalSupply;
        oneSecondSupply = totalSupply.div(_timeLimit);
    }


    modifier onlyAuthorized() {
        require(msg.sender == owner || msg.sender == authorizedPerson, "Not authorized");
        _;
    }

    /// @notice This function is used to withDraw authrozied amount of token
    /// @return	Tokens: uptill now from last withDraw.
    function withDrawSupply() external onlyAuthorized returns (uint256) {
        uint256 actualWithDrawAmount;
        uint256 withDrawableAmount = _calculateWithDrawableAmount();
        
        // if time doesn't, withDrawable amount will be greater than totalSupply
        if(withDrawableAmount <= totalSupply){
            actualWithDrawAmount = withDrawableAmount.sub(withDrawnAmount);
            withDrawnAmount = withDrawnAmount.add(actualWithDrawAmount);
            remainingSupply = remainingSupply.sub(actualWithDrawAmount); 
        }
        else{
            actualWithDrawAmount = remainingSupply;
            withDrawnAmount = withDrawnAmount.add(remainingSupply);
            remainingSupply = 0;
        }
        
        return actualWithDrawAmount;
    }

    /// @notice This function calculates the total amount of tokens from start time to now.
    /// @return	Tokens: total tokens from start to now.
    function _calculateWithDrawableAmount() internal view returns (uint256){
        uint256 _nowTime = block.timestamp;
        uint256 _withDrawableAmount;

        uint256 _balanceSeconds = _nowTime.sub(startTime);
        _withDrawableAmount = _balanceSeconds.mul(oneSecondSupply);
  
        return _withDrawableAmount;
    }


}