pragma solidity ^0.5.3;

contract rsp {

    address player1;
    address player2;

    bytes32 hash1;
    bytes32 hash2;

    uint8 res1;
    uint8 res2;

    address winner;
    uint8 counter;

    bool draw;
    bool open;



function startGame() public {
    open = true;
    player1 = msg.sender;
    counter = 1;
}

function joinPlayer() public {
    require(msg.sender != player1 && counter == 1 && open == true);
    player2 = msg.sender;
    counter = 2;
}

function movePlayer1(bytes32 newhash1) public {
    require(msg.sender == player1 && counter == 2 && open == true);
    hash1 = newhash1;
    if (hash2 != 0x0) {
        counter = 3;
    }
}
function movePlayer2(bytes32 newhash2) public {
    require(msg.sender == player2 && counter == 2 && open == true);
    hash2 = newhash2;
    if (hash1 != 0x0) {
        counter = 3;
    }
}

function decodeHash1(string memory seed1) public {
    require(msg.sender == player1 && counter == 3 && keccak256(abi.encode(seed1)) == hash1 && open == true);
    if (str_to_bytes_1(seed1) == 0x31) res1 = 1;
    if (str_to_bytes_1(seed1) == 0x32) res1 = 2;
    if (str_to_bytes_1(seed1) == 0x33) res1 = 3;
    if (res1 != 0x0 &&  res2 != 0x0) {
        counter == 4;
        play();
    }
}

function decodeHash2(string memory seed2) public {
    require(msg.sender == player2 && counter == 3 && keccak256(abi.encode(seed2)) == hash2 && open == true);
    if (str_to_bytes_1(seed2) == 0x31) res2 = 1;
    if (str_to_bytes_1(seed2) == 0x32) res2 = 2;
    if (str_to_bytes_1(seed2) == 0x33) res2 = 3;
    if (res1 != 0x0 &&  res2 != 0x0) {
        counter == 4;
        play();
    }
}


function play() internal {
    if (res1 == res2) draw = true;
    
    if (res1 == 1 && res2 == 2) winner = player1;
    if (res1 == 1 && res2 == 3) winner = player2;
    if (res1 == 2 && res2 == 1) winner = player2;
    if (res1 == 2 && res2 == 3) winner = player1;
    if (res1 == 3 && res2 == 1) winner = player1;
    if (res1 == 3 && res2 == 2) winner = player2;
    open = false;
}

function seeWinner() view public returns(address) {
    if (draw == true) return address(0);
    else return winner;
}

function str_to_bytes_1(string memory seed) internal returns(bytes1){
    bytes memory seed_b;
    seed_b = bytes(seed);
    return seed_b[0];
}

}
