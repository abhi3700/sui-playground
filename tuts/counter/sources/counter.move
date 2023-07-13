//! package: counter
//! module: counter

module counter::counter {
    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    struct Counter has key {
        id: UID,
        value: u16
    }

    // for testing purpose only
    #[test_only]
    public fun create(ctx: &mut TxContext) {
        let counter = Counter {
            id: object::new(ctx),
            value: 3
        }; 

        transfer::share_object(counter);
    }

    #[allow(unused_function)]
    fun init(ctx: &mut TxContext) {
        let counter = Counter {
            id: object::new(ctx),
            value: 3
        }; 

        transfer::share_object(counter);
    }

    /// increment function
    public entry fun inc(c: &mut Counter) {
        c.value = c.value + 1;
    }

    // decrement function
    public entry fun dec(c: &mut Counter) {
        c.value = c.value - 1;
    }

    /// reset function
    public entry fun reset(c: &mut Counter) {
        c.value = 0;
    }

    /// getter function for value
    public fun get_value(counter: &Counter): u16 {
        counter.value
    }
}

