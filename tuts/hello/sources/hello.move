//! Lessons:
//! 1. `store` is optional, as we are creating multiple instances of Hello. Only needed if we require data persistence.
//! Otherwise, only `key` ability is enough.
//! 2. `event` requires only `Copy` & `Drop` abilities. Also expects its fields to have `Copy` & `Drop` abilities.
//!     NOTE: AS `UID` doesn't have `Copy` ability, we can't use it in `event` struct.
//! 
//!     TODO: find a solution for this ???
//! TODO: change the `String` to `vector<u8>` type (utf8 encoded)
//! - "Hello world" to be parsed into CLI as "\x48\x65\x6c\x6c\x6f\x20\x77\x6f\x72\x6c\x64"
//! - Tool: https://www.browserling.com/tools/utf8-encode
//! Also., check in your CLI:
//! ```console
//! echo -e "\x48\x65\x6c\x6c\x6f\x20\x77\x6f\x72\x6c\x64"
//!  Hello world
//! ```
//! - Code reference: https://examples.sui.io/basics/strings.html
//! 
//! TODO: Add another field `hashed_message`
//! - Reference: https://github.com/MystenLabs/sui/blob/main/sui_programmability/examples/math/sources/ecdsa.move
//! 
//! TODO: Add tests ???
//! 

module hello::hello {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use std::string::{Self, String};
    use sui::clock::{Self, Clock};
    use sui::event;
    
    // use std::vector;

    /// Hello, World!
    /// In this eg, `store` is optional, as we are creating multiple
    /// instances of Hello.
    /// NOTE: `store` is required for data persistence.
    struct Hello has key, store {
        id: UID,
        message: string::String,
        timestamp: u64, // in ms as the network `timestamp_ms` function 
    }
    

    /// Wrapper for Hello, World!, usage: delete
    struct Wrapper has key {
        id: UID,
        o: Hello,
    }

    // Error codes
    /// Empty message
    const EEmptyMessage: u64 = 1;

    /// Zero address
    const EZeroAddress: u64 = 2;

    /// Event for Hello
    /// NOTE: Here, sender & recipient may be same.
    struct HelloCreatedTransferred has copy, drop {
        sender: address,
        // id: UID,
        message: string::String,
        recipient: address,
        timestamp: u64,
    }
    
    /// Event for Hello object updated
    struct HelloUpdated has copy, drop {
        sender: address,
        // id: UID,
        message: string::String,
        timestamp: u64,
    }

    /// Event for Hello object transferred
    struct HelloTransferred has copy, drop {
        // id: UID,
        old_owner: address,
        new_owner: address,
        timestamp: u64,
    }


    /// Event for Hello object deleted
    struct HelloDeleted has copy, drop {
        sender: address,
        // id: UID,
        timestamp: u64,
    }

    fun init(ctx: &mut TxContext) {
        let hello = Hello {
            id: object::new(ctx),
            message: string::utf8(b"Hello, World"),
            timestamp: 0,
        };
        transfer::transfer(hello, tx_context::sender(ctx));
    }

    /// get the message 
    public fun get_message(hello: &Hello): String {
        hello.message
    }

    public fun get_timestamp(hello: &Hello): u64 {
        hello.timestamp
    }

    public fun get_hello(hello: &Hello): (String, u64) {
        (hello.message, hello.timestamp)
    }

    public entry fun create_transfer_hello(message: String, clock: &Clock, new_owner: address, ctx: &mut TxContext) {
        assert!(string::length(&message) != 0, EEmptyMessage);
        
        // read the current timestamp
        let current_timestamp = clock::timestamp_ms(clock);
        let new_id = object::new(ctx);

        // create a hello object
        let hello = Hello {
            id: new_id,
            message: message,
            timestamp: current_timestamp,  // get the latest timestamp
        };
        transfer::transfer(hello, new_owner);

        // emit the event
        event::emit(HelloCreatedTransferred { 
            sender: tx_context::sender(ctx), 
            // id: copy new_id, 
            message: message, 
            recipient: new_owner, 
            timestamp: current_timestamp 
        });
    }

    public entry fun update_hello(hello: &mut Hello, message: String, clock: &Clock, ctx: &mut TxContext) {
        assert!(string::length(&message) != 0, EEmptyMessage);
        // get the object id
        // let Hello { id, message: _, timestamp: _} = hello;

        // read the current timestamp
        let current_timestamp = clock::timestamp_ms(clock);

        // update the hello object
        hello.message = message;
        hello.timestamp = clock::timestamp_ms(clock); // get the latest timestamp
        // transfer::transfer(new_hello, new_owner);    // NOTE: can't modify & then transfer in single run.

        // emit the event
        event::emit(HelloUpdated { 
            sender: tx_context::sender(ctx), 
            // id: id, 
            message, 
            timestamp: current_timestamp 
        });
    }

    public entry fun transfer_hello(hello: Hello, new_owner: address, clock: &Clock, ctx: &mut TxContext) {
        assert!(new_owner != @0x0, EZeroAddress);
        
        // get the object id
        // let Hello { id, message: _, timestamp: _} = hello;

        // read the current timestamp
        let current_timestamp = clock::timestamp_ms(clock);

        // transfer the hello object
        transfer::transfer(hello, new_owner);

        // emit the event
        event::emit(HelloTransferred { 
            // id, 
            old_owner: tx_context::sender(ctx), 
            new_owner, 
            timestamp: current_timestamp 
        });
    }

    public entry fun del_hello(hello: Hello, clock: &Clock, ctx: &mut TxContext) {
        // get the object id
        let Hello { id, message: _, timestamp: _} = hello;
        
        // delete the object using id
        object::delete(id);

        // emit the event
        event::emit(HelloDeleted { 
            sender: tx_context::sender(ctx), 
            // id, 
            timestamp: clock::timestamp_ms(clock) 
        });
    }
}