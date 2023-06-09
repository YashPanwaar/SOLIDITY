//created by Yash PANWAR
//THIS solidity contrct is a lottery contract
pragma solidity >0.8.0;

contract lottery{
    address public manager;
    address payable[] public players;

    constructor(){
        manager = msg.sender;
    }

    function alreadyentered() view private returns(bool){
        for(uint i=0;i<players.length;i++){
            if(players[i]==msg.sender)
            return true;
        }
    }

    function enter() payable public{
        require(msg.sender!= manager,"manager cannot enter");
        require(alreadyentered() == false,"player is already there");
        require(msg.value>=1 ether ,"First pay the amount and then come back");
        players.push(payable(msg.sender));

    }

    function random() view private returns(uint){
        return uint(sha256(abi.encodePacked(block.difficulty,block.number,players)));
    } 

    function pickWinner() public{
        require(msg.sender == manager,"only manager can pick winner");
        uint index = random()%players.length;
        address contractAddress= address(this);
        players[index].transfer(contractAddress.balance);
        players = new address payable[](0);
    }

    function getplayers() view public returns(address payable[] memory){
        return players;
    }
}
