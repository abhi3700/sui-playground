#[test_only]
module car::car_tests {
    use sui::test_scenario::Self as ts;
    use car::car::{Self, Car};
    use sui::tx_context::Self as tc;

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

    // use sui::test_scenario::EEmptyInventory;
    #[test]
    #[expected_failure(abort_code = sui::test_scenario::EEmptyInventory)]
    fun test_transfer_fails_when_transferred_by_non_owner() {
        let scenario_val = ts::begin(Owner);

        {
            let ctx = ts::ctx(&mut scenario_val);
            car::create(50, 50, 50, ctx);
        };

        // transfer the car from Alice to Bob
        ts::next_tx(&mut scenario_val, Alice);
        {
            let car_object = ts::take_from_sender<Car>(&mut scenario_val);
            // car::transfer(car_object, Bob);      // didn't even reach at this level.
            ts::return_to_sender(&scenario_val, car_object)
        };

        ts::end(scenario_val);
    }

    // NOTE: In this example, we are not using test_scenario because
    // we are not testing the transfer function, but rather testing if it works.
    #[test]
    public fun test_transfer_works() {
        let ctx = &mut tc::dummy();

        // create a car object & transfer to the owner.
        car::create(50, 50, 50, ctx);

        // create a car object with same values.
        // M-1: recommended outside the module
        // NOTE: Use a function that returns a car object 'Car'.
        let car_object = car::new(50, 50, 50, ctx);

        // M-2: recommended inside the module `car`
        // let car_object = car::car::Car {
        //     id: object::new(ctx),
        //     speed: 50,
        //     acceleration: 50,
        //     handling: 50,
        // };

        // transfer the car from Owner to Alice
        car::transfer(car_object, Alice);       // here w/o using test_scenario, we knew that the owner is 'Owner'.
    }


    #[test]
    fun test_update_stats() {
        let scenario_val = ts::begin(Owner);
            
        {
            let ctx = ts::ctx(&mut scenario_val);
            car::create(50, 50, 50, ctx);
        };

        // update the car's stats
        ts::next_tx(&mut scenario_val, Owner);
        {
            let car_object = ts::take_from_sender<Car>(&mut scenario_val);
            car::update_stats(&mut car_object, 100, 100, 100);
            ts::return_to_sender(&mut scenario_val, car_object)
        };

        ts::end(scenario_val);
    }
}