pragma solidity >=0.8.11 <0.9.0;

//SPDX-License-Identifier: MIT

contract Lottery {
    struct BetInfo {
        uint256 answerBlockNumber;
        address bettor;
        bytes challenges;
    }

    uint256 private _tail;
    uint256 private _head;
    mapping(uint256 => BetInfo) private _bets;

    address public owner;

    uint256 internal constant BLOCK_LIMIT = 256;
    uint256 internal constant BET_BLOCK_INTERVAL = 3;
    uint256 internal constant BET_AMOUNT = 5 * 10**15; // 10^18wei = 1ETH, 10^15wei = 0.001ETH
    uint256 private _pot;

    event BET(
        uint256 idx,
        address bettor,
        uint256 amount,
        bytes challengers,
        uint256 answerBlockNumber
    );

    constructor() public {
        owner = msg.sender;
    }

    function getPot() public view returns (uint256 pot) {
        return _pot;
    }

    /**
     * @dev betting하는 유저는 0.005 ETH 를 보내야되고, 1byte char를 보낸다
     * @param challenges 유저가 베팅하는 글자
     * @return result bool
     */
    function bet(bytes memory challenges) public payable returns (bool result) {
        // check the proper eth is sent
        require(msg.value == BET_AMOUNT, "Not enough eth");

        // push bet to the queue
        require(pushBet(challenges), "Failed to add a new Bet Info");

        // emit event
        emit BET(
            _tail - 1,
            msg.sender,
            msg.value,
            challenges,
            block.number + BET_BLOCK_INTERVAL
        );

        return true;
    }

    //    // TODO: distribute
    //    function distribute() {
    //
    //    }

    function getBetInfo(uint256 idx)
        public
        view
        returns (
            uint256 answerBlockNumber,
            address bettor,
            bytes memory challenges
        )
    {
        BetInfo memory b = _bets[idx];

        answerBlockNumber = b.answerBlockNumber;
        bettor = b.bettor;
        challenges = b.challenges;
    }

    function pushBet(bytes memory challenges) internal returns (bool) {
        BetInfo memory b;
        b.bettor = msg.sender;
        b.answerBlockNumber = block.number + BET_BLOCK_INTERVAL;
        b.challenges = challenges;

        _bets[_tail] = b;
        _tail++;

        return true;
    }

    function popBet(uint256 idx) internal returns (bool) {
        delete _bets[idx];
        return true;
    }
}
