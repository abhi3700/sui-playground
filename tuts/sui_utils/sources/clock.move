#[test_only]
module sui_utils::clock {
    use sui::clock;
    use sui::tx_context;

    #[test]
    fun test_clock_create() {
        let ctx = &mut tx_context::dummy();
        let clock = clock::create_for_testing(ctx);
        // clock with zero timestamp
        let now = clock::timestamp_ms(&clock);
        // std::debug::print(&now);
        assert!(now == 0, 0);

        clock::destroy_for_testing(clock);
    }

    #[test]
    fun test_clock_set_timestamp() {
        let ctx = &mut tx_context::dummy();
        let clock = clock::create_for_testing(ctx);
        clock::set_for_testing(&mut clock, 1000);
        let now = clock::timestamp_ms(&clock);
        // std::debug::print(&now);
        assert!(now == 1000, 0);

        clock::destroy_for_testing(clock);
    }

    // required during block production.
    #[test]
    fun test_clock_incrementing() {
        let ctx = &mut tx_context::dummy();
        let clock = clock::create_for_testing(ctx);
        clock::increment_for_testing(&mut clock, 1);
        let now = clock::timestamp_ms(&clock);
        assert!(now == 1, 0);

        clock::destroy_for_testing(clock);
    }
}