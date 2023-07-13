module car::car_tests {
    use sui::test_scenario::Self as ts;
    use car::car::{Self, Car};

    const Owner: address = @0x1;
    const Alice: address = @0x2;
    const Bob: address = @0x3;
    const Charlie: address = @0x4;

    #[test]
    fun test_create() {
        let scenario_val = ts::begin(Owner);
        let scenario = &mut scenario_val;

        {
            let ctx = ts::ctx(scenario);
            car::create(50, 50, 50, ctx);
        };

        // ensure that the owner should own the car
        ts::next_tx(scenario, Owner);
        {
            assert!(ts::has_most_recent_for_sender<Car>(scenario), 0);
        };

        // ensure that Alice should not own the car
        ts::next_tx(scenario, Alice);
        {
            assert!(!ts::has_most_recent_for_sender<Car>(scenario), 1);
        };

        // ensure the car's stats match with the set values
        ts::next_tx(scenario, Owner);
        {
            let car = ts::take_from_sender<Car>(scenario);
            let (speed, acceleration, handling) = car::stats(&car);
            assert!(speed == 50, 2);
            assert!(acceleration == 50, 3);
            assert!(handling == 50, 4);
            ts::return_to_sender(&scenario_val, car)
        };

        ts::end(scenario_val);
    }
}