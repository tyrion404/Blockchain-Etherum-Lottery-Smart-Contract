pragma solidity >=0.4.0;


contract Lottery {
    address public manager;
    address public lastWinner;
    uint256 public minEthReq; //it's not fixed type
    address[] public players;

    constructor() public {
        minEthReq = 0;
        manager = msg.sender;
    }

    function setMin(uint256 minEthMoney) public restricted {
        minEthReq = minEthMoney;
    }

    function enter() public payable {
        require(msg.value >= 0.01 ether);
        players.push(msg.sender);
    }

    function random() private view returns (uint256) {
        return
            uint256(
                keccak256(abi.encodePacked(block.difficulty, now, players))
            );
    }

    function pickWinner() public restricted {
        uint256 index = random() % players.length;
        players[index].transfer(address(this).balance);
        lastWinner = players[index];

        players = new address[](0);
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
}

// pragma solidity >=0.5.0;


// contract Lottery {
//     address public manager;
//     address lastWinner;
//     uint256 public minEthReq; //it's not fixed type
//     address payable[] public players;

//     constructor() public {
//         minEthReq = 0;
//         manager = msg.sender;
//     }

//     function setMin(uint256 minEthMoney) public restricted {
//         minEthReq = minEthMoney;
//     }

//     function enter() public payable {
//         require(msg.value >= 0.01 ether, "Not enough ether.");
//         players.push(msg.sender);
//     }

//     function random() private view returns (uint256) {
//         return
//             uint256(
//                 keccak256(abi.encodePacked(block.difficulty, now, players))
//             );
//     }

//     function pickWinner() public restricted {
//         uint256 index = random() % players.length;
//         players[index].transfer(address(this).balance);
//         lastWinner = players[index];
//         players = new address payable[](0);
//     }

//     function getPlayers() public view returns (address payable[] memory) {
//         return players;
//     }

//     modifier restricted() {
//         require(msg.sender == manager, "Not Authorised.");
//         _;
//     }
// }
