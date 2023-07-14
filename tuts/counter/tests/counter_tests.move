#[test_only]
module counter::counter_tests {
    use sui::test_scenario::Self as ts;
    use counter::counter::{Self, Counter};
    
    const Owner: address = @0x1;
    const Alice: address = @0x2;
    const Bob: address = @0x3;
    const Charlie: address = @0x4;

    #[test]
    fun test_counter() {
        let scenario_val = ts::begin(Owner);
        let scenario = &mut scenario_val;
        {
            let ctx = ts::ctx(scenario);
            // this can be tested inside the module only as its visibility is private, not public (not allowed for module initializer)
            // counter::init(ctx);
            // So, that's why we are using the create function to emulate contract initializer.
            counter::create(ctx);
        };

        // check if the object created is shared with Alice
        ts::next_tx(scenario, Alice);
        {
            assert!(ts::has_most_recent_shared<Counter>(), 0);
        };

        // check the value of the counter
        ts::next_tx(scenario, Alice);
        {
            let counter_object = ts::take_shared<Counter>(scenario);
            assert!(counter::get_value(&counter_object) == 3, 1);
            ts::return_shared(counter_object);
        };

        // check if the counter is shared with Bob
        ts::next_tx(scenario, Bob);
        {
            assert!(ts::has_most_recent_shared<Counter>(), 2);
        };

        // check if the counter is incremented
        ts::next_tx(scenario, Alice);
        {
            let counter_object = ts::take_shared<Counter>(scenario);
            counter::inc(&mut counter_object);
            assert!(counter::get_value(&counter_object) == 4, 3);
            ts::return_shared(counter_object);
        };

        // check if the counter is decremented
        ts::next_tx(scenario, Alice);
        {
            let counter_object = ts::take_shared<Counter>(scenario);
            counter::dec(&mut counter_object);
            assert!(counter::get_value(&counter_object) == 3, 4);
            ts::return_shared(counter_object);
        };

        // check if the counter is reset
        ts::next_tx(scenario, Alice);
        {
            let counter_object = ts::take_shared<Counter>(scenario);
            counter::reset(&mut counter_object);
            assert!(counter::get_value(&counter_object) == 0, 5);
            ts::return_shared(counter_object);
        };

        ts::end(scenario_val);

    }
}