//! package: counter
//! module: counter_admin
/// Counter module with Admin restriction with shared object.
module counter::counter_admin {
    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::test_scenario::Self as ts;

    struct Counter has key {
        id: UID,
        owner: address,
        value: u16
    }

    // Error codes
    const EOnlyOwner: u64 = 1;

    fun init(ctx: &mut TxContext) {
        let counter = Counter {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
            value: 3
        }; 

        transfer::share_object(counter);
    }

    // for testing purpose only
    #[test_only]
    public fun test_init(ctx: &mut TxContext) {
        init(ctx);
    }

    //==== Only owner ====
    /// increment function
    public entry fun inc(c: &mut Counter, ctx: &mut TxContext) {
        assert!(tx_context::sender(ctx) == c.owner, EOnlyOwner);
        c.value = c.value + 1;
    }

    // decrement function
    public entry fun dec(c: &mut Counter, ctx: &mut TxContext) {
        assert!(tx_context::sender(ctx) == c.owner, EOnlyOwner);
        c.value = c.value - 1;
    }

    /// reset function
    public entry fun reset(c: &mut Counter, ctx: &mut TxContext) {
        assert!(tx_context::sender(ctx) == c.owner, EOnlyOwner);
        c.value = 0;
    }

    //==== Getters =====

    /// getter function for owner
    public fun owner(counter: &Counter): address {
        counter.owner
    }

    /// getter function for value
    public fun value(counter: &Counter): u16 {
        counter.value
    }

    #[test]
    // test only `init` function here, rest are into `tests/` folder, as `init` function can't be defined public &
    // not accessed from outside of the module (including test module)
    fun tests_init_works() {
        let scenario_val = ts::begin(@0x0);
        let scenario = &mut scenario_val;

        {
            let ctx = ts::ctx(scenario);
            init(ctx);
        };

        // check if the object created is shared with the sender
        ts::next_tx(scenario, @0x0);
        {
            assert!(ts::has_most_recent_shared<Counter>(), 0);
        };


        // check if the object created is shared with the sender
        ts::next_tx(scenario, @0x1);
        {
            assert!(ts::has_most_recent_shared<Counter>(), 0);
        };

        // check the values are set correctly
        ts::next_tx(scenario, @0x0);
        {
            let counter = ts::take_shared<Counter>(scenario);
            assert!(counter.value == 3, 1);
            ts::return_shared(counter);
        };

        ts::end(scenario_val);
    }

}

