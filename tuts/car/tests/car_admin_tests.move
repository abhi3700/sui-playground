#[test_only]
module car::car_admin_tests {
    use sui::test_scenario::Self as ts;
    use car::car_admin::{Self, AdminCapability};

    const Owner: address = @0x1;
    const Alice: address = @0x2;
    const Bob: address = @0x3;
    const Charlie: address = @0x4;

    #[test]
    #[expected_failure(abort_code = sui::test_scenario::EEmptyInventory)]
    fun test_create_fails_by_non_owner() {
        let scenario_val = ts::begin(Owner);

        {
            let ctx = ts::ctx(&mut scenario_val);
            car_admin::test_init(ctx);   // Admin capability is given to Owner
        };

        ts::next_tx(&mut scenario_val, Alice);
        {
            let car_admin_object = ts::take_from_sender<AdminCapability>(&scenario_val);    // it would fail at this level itself as Alice is not the owner
            let ctx = ts::ctx(&mut scenario_val);
            car_admin::create(&car_admin_object, 50, 50, 50, ctx);
            ts::return_to_sender(&scenario_val, car_admin_object);
        };

        ts::end(scenario_val);

    }
}