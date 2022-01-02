pragma solidity >0.4.22 <0.6.1;

contract Vote {
    address _adr;

    string[] public candidates;

    mapping (address => bool) public isVoted;
    mapping (address => bool) public isCandidate;
    mapping (uint => uint) countVotes;

    constructor () public {
        _adr = msg.sender;

        candidates.push("Ivan");
        candidates.push("Sergey");
        candidates.push("Fedor");
        candidates.push("Igor");
        candidates.push("Georgy");
    }

    function upToCandidate (string memory name) public{
        require(isCandidate[_adr] == false);
        candidates.push(name);

        isCandidate[_adr] = true;
    }

    function toVote(uint candidate) public {
        require(isVoted[_adr] == false);
        countVotes[candidate]++;

        isVoted[_adr] = true;
    }

    function getCandidate (uint index) public view returns (string) {
        return candidates[index];
    }
    
    function getWinner() public view returns (string memory _win) {
        uint countWinner = 0;

        for (uint i = 0; i < candidates.length; i++) {
            if (countVotes[i] > countWinner) {
                countWinner = countVotes[i];
                _win = candidates[i];
            }
        }
    }
}