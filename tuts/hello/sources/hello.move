//! package: playground
//! module: hello

module playground::hello {
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID};
    use sui::transfer;

    /// Greet object
    struct Greet has key, store {
        id: UID,
        name: String
    }

    // Error codes
    /// Empty name
    const EEmptyName: u64 = 0;

    public entry fun create_greet(name: String, ctx: &mut TxContext) {
        assert!(string::length(&name) > 0, EEmptyName);

        let greet = Greet {
            id: object::new(ctx),
            name: name
        };

        transfer::public_transfer(greet, tx_context::sender(ctx));
    }
}