#[test_only]
module counter::counter_admin_tests {
    use sui::test_scenario::Self as ts;
    use counter::counter_admin::{Self, Counter};
    use counter::counter_admin::EOnlyOwner;
    
    const Owner: address = @0x1;
    const Alice: address = @0x2;
    const Bob: address = @0x3;
    const Charlie: address = @0x4;

    #[test]
    #[expected_failure(abort_code = EOnlyOwner)]
    fun inc_fails_when_called_by_non_owner() {
        let scenario_val = ts::begin(Owner);

        {
            let ctx = ts::ctx(&mut scenario_val);
            counter_admin::create(ctx);
        };

        // check if the counter is incremented
        ts::next_tx(&mut scenario_val, Alice);
        {
            let counter_object = ts::take_shared<Counter>(&mut scenario_val);
            let ctx = ts::ctx(&mut scenario_val);
            counter_admin::inc(&mut counter_object, ctx);
            ts::return_shared(counter_object);
        };

        ts::end(scenario_val);
    }

    #[test]
    #[expected_failure(abort_code = EOnlyOwner)]
    fun dec_fails_when_called_by_non_owner() {
        let scenario_val = ts::begin(Owner);
        // let scenario = &mut scenario_val;

        {
            let ctx = ts::ctx(&mut scenario_val);
            counter_admin::create(ctx);
        };

        // check if the counter is decremented
        ts::next_tx(&mut scenario_val, Alice);
        {
            let counter_object = ts::take_shared<Counter>(&mut scenario_val);
            let ctx = ts::ctx(&mut scenario_val);
            counter_admin::dec(&mut counter_object, ctx);
            ts::return_shared(counter_object);
        };

        ts::end(scenario_val);
    }

    #[test]
    #[expected_failure(abort_code = EOnlyOwner)]
    fun reset_fails_when_called_by_non_owner() {
        let scenario_val = ts::begin(Owner);
        // let scenario = &mut scenario_val;

        {
            let ctx = ts::ctx(&mut scenario_val);
            counter_admin::create(ctx);
        };

        // check if the counter is reset
        ts::next_tx(&mut scenario_val, Alice);
        {
            let counter_object = ts::take_shared<Counter>(&mut scenario_val);
            let ctx = ts::ctx(&mut scenario_val);
            counter_admin::reset(&mut counter_object, ctx);
            ts::return_shared(counter_object);
        };

        ts::end(scenario_val);
    }
}