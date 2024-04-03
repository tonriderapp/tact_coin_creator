import "./messages.tact";
import "./jetton.tact";

message Mint {
    amount: Int;
    receiver: Address;
}

contract CoinContract with Jetton {

    total_supply: Int as coins;
    owner: Address;
    content: Cell;
    mintable: Bool;
    contract_id: Int as uint64;

    init(owner: Address, contract_id: Int, content: Cell) {
        self.owner = owner;
        self.contract_id = contract_id;
        self.content = content;
        self.mintable = true;
        self.total_supply = 0;
    }

    receive() {
        // receive TON
    }

    receive(msg: InitialMint) {
        let ctx: Context = context();
        require(ctx.sender == self.owner, "Not owner");
        require(self.mintable, "Not mintable");
        self.mint(msg.new_owner, msg.amount, msg.new_owner);
        // change owner
        self.owner = msg.new_owner;
    }

    receive(msg: SetNewOwner) {
        let ctx: Context = context();
        require(ctx.sender == self.owner, "Not owner");
        self.owner = msg.new_owner;
    }

    receive(msg: Mint) { // 0xfc708bd2
        let ctx: Context = context();
        require(ctx.sender == self.owner, "Not owner");
        require(self.mintable, "Not mintable");
        self.mint(msg.receiver, msg.amount, self.owner);
    }

    receive("Owner: MintClose") {
        let ctx: Context = context();
        require(ctx.sender == self.owner, "Not owner");
        self.mintable = false;
    }

    get fun getTokenOwner(): Address {
        return self.owner;
    }
}
