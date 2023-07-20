#[test_only]
module sui_utils::coin_tests {
    use sui::test_scenario::Self as ts;
    use sui::coin::{Self};
    // use std::debug;
    use std::option;
    use std::string::{utf8};
    use std::ascii;
    use sui::test_utils;
    use sui::transfer;
    use sui::tx_context;

    const TEST_SENDER_ADDR: address = @0x01;
    const ALICE: address = @0xA11CE;
    const BOB: address = @0xB0B;
    const CHARLIE: address = @0xC8C2;

    // name of the witness should match with the module name
    struct COIN_TESTS has drop {}

    #[test]
    fun test_coin_metadata() {
        let scenario = ts::begin(ALICE);
        let scenario_val = &mut scenario;
        let ctx = ts::ctx(scenario_val);
        let witness = COIN_TESTS{};
        let (treasury_cap, donut_metadata) = coin::create_currency(
            witness, 
            10, 
            b"DONUT",
            b"Donut Coin", 
            b"A Social Currency", 
            option::some(sui::url::new_unsafe_from_bytes(b"https://donutcoin.com")), ctx);
        
        // get the variables
        let decimals = coin::get_decimals(&donut_metadata);
        let symbol_bytes = ascii::as_bytes(&coin::get_symbol(&donut_metadata));
        let name = coin::get_name(&donut_metadata);
        let description = coin::get_description(&donut_metadata);
        let icon_url = coin::get_icon_url(&donut_metadata);

        // assert the metadata is correct
        assert!(decimals == 10, 0);
        assert!(*symbol_bytes == b"DONUT", 0);
        assert!(name == utf8(b"Donut Coin"), 0);
        assert!(description == utf8(b"A Social Currency"), 0);
        assert!(icon_url == option::some(sui::url::new_unsafe_from_bytes(b"https://donutcoin.com")), 0);

        transfer::public_freeze_object(donut_metadata);
        transfer::public_transfer(treasury_cap,tx_context::sender(ts::ctx(scenario_val)));


        ts::end(scenario);
    }
}