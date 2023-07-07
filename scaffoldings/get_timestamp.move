//! Get latest timestamp of the network.
//! Assume 2-3s of network delay due to finality during complex transactions
//! involving shared object.

use sui::clock::{Self, Clock};

/// In the module, there is a getter (public) function which can be called 
/// by other modules
module my_pkg::hello {
    public entry fun create_transfer_hello(message: String, clock: &Clock, new_owner: address, ctx: &mut TxContext) {
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

}