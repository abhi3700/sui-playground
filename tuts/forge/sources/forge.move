// forked from https://github.com/MystenLabs/sui/blob/main/sui_programmability/examples/move_tutorial/sources/my_module.move
module forge::forge {
    // Part 1: imports
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    // Part 2: struct definitions
    struct Sword has key, store {
        id: UID,
        magic: u64,
        strength: u64,
    }

    struct Forge has key, store {
        id: UID,
        swords_created: u64,
    }

    // Part 3: module initializer to be executed when this module is published
    fun init(ctx: &mut TxContext) {
        let admin = Forge {
            id: object::new(ctx),
            swords_created: 0,
        };
        // transfer the forge object to the module/package publisher
        transfer::transfer(admin, tx_context::sender(ctx));
    }

    // Part 4: accessors required to read the struct attributes
    public fun magic(self: &Sword): u64 {
        self.magic
    }

    public fun strength(self: &Sword): u64 {
        self.strength
    }

    public fun swords_created(self: &Forge): u64 {
        self.swords_created
    }

    // part 5: public/entry functions (introduced later in the tutorial)
    public entry fun sword_create(forge: &mut Forge, magic: u64, strength: u64, recipient: address, ctx: &mut TxContext) {
        // create a sword
        let sword = Sword {
            id: object::new(ctx),
            magic: magic,
            strength: strength,
        };
        forge.swords_created = forge.swords_created + 1;
        transfer::transfer(sword, recipient);
    }
}