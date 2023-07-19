//! package: counter
//! module: counter

module counter::counter {
    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui::test_scenario::Self as ts;

    struct Counter has key {
        id: UID,
        value: u16
    }


    #[allow(unused_function)]
    fun init(ctx: &mut TxContext) {
        let counter = Counter {
            id: object::new(ctx),
            value: 3
        }; 

        transfer::share_object(counter);
    }

    // for testing purpose only
    #[test_only]
    public fun test_init(ctx: &mut TxContext) {
        init(ctx);
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

    #[test]
    // test only `init` function here, rest are into `tests/` folder, as `init` function can't be defined public &
    // not accessed from outside of the module (including test module)
    fun test_init_works() {
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

