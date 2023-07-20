#[test_only]
module sui_utils::pay {
    use sui::pay;
    // use std::debug;
    use sui::test_utils;
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::test_scenario::Self as ts;
    use std::vector;

    const TEST_SENDER_ADDR: address = @0xA11CE;
    const ALICE: address = @0xA11CE;
    const BOB: address = @0xB0B;
    const CHARLIE: address = @0xC8C2;

    #[test]
    fun test_coin_split_by_n() {
        // Here, `test_scenario` is used instead of `dummy` context because we want to
        // take the objects created from the last transaction by the sender using `take_from_sender()` 
        // function
        let scenario_val = ts::begin(ALICE);
        let scenario = &mut scenario_val;
        let ctx = ts::ctx(scenario);
        let coin = coin::mint_for_testing<SUI>(10, ctx);

        ts::next_tx(scenario, ALICE);
        pay::divide_and_keep(&mut coin, 3, ts::ctx(scenario));
        // Now, ALICE has all 3 coin objects in her possession.
        // The order is in last to first order.

        ts::next_tx(scenario, ALICE);
        let coin1 = ts::take_from_sender<Coin<SUI>>(scenario);
        
        // [OPTIONAL] ts::next_tx(scenario, ALICE);
        let coin2 = ts::take_from_sender<Coin<SUI>>(scenario);

        ts::next_tx(scenario, ALICE);
        assert!(coin::value(&coin1) == 3, 0);
        assert!(coin::value(&coin2) == 3, 0);
        assert!(coin::value(&coin) == 4, 0);
        // Hence, total value is 10.
        // assert that the sender doesn't have any more coins.
        assert!(
            !ts::has_most_recent_for_sender<Coin<SUI>>(scenario),
            1
        );

        // Now, destroy all the objects
        test_utils::destroy(coin);
        test_utils::destroy(coin1);
        test_utils::destroy(coin2);

        // NOTE: return to sender is not working as expected because
        // the coin objects are not created in the current transaction (scenario).
        // Hence, the coin objects were supposed to be returned in the respective transaction.
        // ts::return_to_sender(&scenario_val, coin);
        // ts::return_to_sender(&scenario_val, coin1);
        // ts::return_to_sender(&scenario_val, coin2);
        
        ts::end(scenario_val);
    }

    #[test]
    fun test_coin_split_by_n_to_vec() {
        let scenario_val = ts::begin(ALICE);
        let scenario = &mut scenario_val;
        let ctx = ts::ctx(scenario);
        let coin = coin::mint_for_testing<SUI>(20, ctx);

        ts::next_tx(scenario, ALICE);
        let split_coins = coin::divide_into_n(&mut coin, 3, ts::ctx(scenario));

        assert!(vector::length(&split_coins) == 2, 0);
        // debug::print(&split_coins);
        let coin1 = vector::pop_back(&mut split_coins);
        let coin2 = vector::pop_back(&mut split_coins);

        // assertions of balance values
        // debug::print(&coin1);
        // debug::print(&coin2);
        assert!(coin::value(&coin1) == 6, 0);
        assert!(coin::value(&coin2) == 6, 0);
        assert!(coin::value(&coin) == 8, 0);

        // destroy the objects & vector
        test_utils::destroy(coin);
        test_utils::destroy(coin1);
        test_utils::destroy(coin2);
        vector::destroy_empty(split_coins);

        ts::end(scenario_val);
    }

    #[test]
    fun test_split_by_amounts() {
        let scenario_val = ts::begin(ALICE);
        let scenario = &mut scenario_val;
        let ctx = ts::ctx(scenario);
        let coin = coin::mint_for_testing<SUI>(20, ctx);

        ts::next_tx(scenario, ALICE);
        let split_amounts = vector[2, 3];
        pay::split_vec(&mut coin, split_amounts, ts::ctx(scenario));

        ts::next_tx(scenario, ALICE);
        let coin1 = ts::take_from_sender<Coin<SUI>>(scenario);

        // [OPTIONAL] ts::next_tx(scenario, ALICE);
        let coin2 = ts::take_from_sender<Coin<SUI>>(scenario);

        assert!(coin::value(&coin1) == 3, 0);
        assert!(coin::value(&coin2) == 2, 0);
        assert!(coin::value(&coin) == 15, 0);

        // destroy the objects
        test_utils::destroy(coin);
        test_utils::destroy(coin1);
        test_utils::destroy(coin2);

        // NOTE: No need to destroy the split_amounts vector as they are not an object
        // vector::pop_back(&mut split_amounts);
        // vector::pop_back(&mut split_amounts);
        // vector::destroy_empty(split_amounts);

        ts::end(scenario_val);
    }

    #[test]
    fun test_spit_by_amount_and_transfer() {
        let scenario_val = ts::begin(ALICE);
        let scenario = &mut scenario_val;
        let ctx = ts::ctx(scenario);
        let coin = coin::mint_for_testing<SUI>(20, ctx);

        ts::next_tx(scenario, ALICE);
        pay::split_and_transfer(&mut coin, 7, BOB, ts::ctx(scenario));

        ts::next_tx(scenario, BOB);
        let coin1 = ts::take_from_sender<Coin<SUI>>(scenario);
        assert!(coin::value(&coin1) == 7, 0);
        assert!(coin::value(&coin) == 13, 0);

        // destroy the objects
        test_utils::destroy(coin);
        test_utils::destroy(coin1);

        ts::end(scenario_val);
    }

    #[test]
    #[expected_failure(abort_code = sui::balance::ENotEnough)]
    fun test_split_by_amount_and_transfer_fail() {
        let scenario_val = ts::begin(ALICE);
        let scenario = &mut scenario_val;
        let ctx = ts::ctx(scenario);
        let coin = coin::mint_for_testing<SUI>(20, ctx);

        ts::next_tx(scenario, ALICE);
        pay::split_and_transfer(&mut coin, 21, BOB, ts::ctx(scenario));

        // destroy the object
        test_utils::destroy(coin);

        ts::end(scenario_val);
    }

    

    #[test]
    fun test_join() {
        let scenario_val = ts::begin(ALICE);
        let scenario = &mut scenario_val;
        let ctx = ts::ctx(scenario);
        let coin1 = coin::mint_for_testing<SUI>(10, ctx);
        let coin2 = coin::mint_for_testing<SUI>(20, ctx);

        ts::next_tx(scenario, ALICE);
        pay::join(&mut coin1, coin2);

        // destroy the object
        test_utils::destroy(coin1);

        ts::end(scenario_val);
    }

    #[test]
    fun test_join_vec() {
        let scenario_val = ts::begin(ALICE);
        let scenario = &mut scenario_val;
        let ctx = ts::ctx(scenario);
        let coin1 = coin::mint_for_testing<SUI>(10, ctx);
        let coin2 = coin::mint_for_testing<SUI>(20, ctx);
        let coin3 = coin::mint_for_testing<SUI>(30, ctx);

        ts::next_tx(scenario, ALICE);
        let coins = vector[coin2, coin3];
        pay::join_vec(&mut coin1, coins);

        assert!(coin::value(&coin1) == 60, 0);

        // destroy the object
        test_utils::destroy(coin1);

        ts::end(scenario_val);
    }

    #[test]
    fun test_join_vec_and_transfer_simple() {
        let scenario_val = ts::begin(ALICE);
        let scenario = &mut scenario_val;
        let ctx = ts::ctx(scenario);
        let coin1 = coin::mint_for_testing<SUI>(10, ctx);
        let coin2 = coin::mint_for_testing<SUI>(20, ctx);
        let coin3 = coin::mint_for_testing<SUI>(30, ctx);

        ts::next_tx(scenario, ALICE);
        let coins = vector[coin1, coin2, coin3];

        ts::next_tx(scenario, ALICE);
        pay::join_vec_and_transfer(coins, BOB);

        ts::next_tx(scenario, BOB);
        let coin4 = ts::take_from_sender<Coin<SUI>>(scenario);
        assert!(coin::value(&coin4) == 60, 0);

        // destroy the object
        test_utils::destroy(coin4);

        ts::end(scenario_val);
    }

    #[test]
    fun test_join_vec_and_transfer_complex() {
        let scenario_val = ts::begin(ALICE);
        let scenario = &mut scenario_val;
        let ctx = ts::ctx(scenario);
        let coin = coin::mint_for_testing<SUI>(25, ctx);

        ts::next_tx(scenario, ALICE);
        // basically want the splitted coins i.e. 3 & 1 original.
        let splitted_coins = coin::divide_into_n(&mut coin, 4, ts::ctx(scenario));

        ts::next_tx(scenario, ALICE);
        // Now, transfer the splitted coins to BOB
        pay::join_vec_and_transfer(splitted_coins, BOB);

        ts::next_tx(scenario, BOB);
        // collect the joined coins from Bob
        let joined_coin = ts::take_from_sender<Coin<SUI>>(scenario);
        assert!(coin::value(&joined_coin) == 18, 0);
        assert!(coin::value(&coin) == 7, 0);

        // destroy the objects
        test_utils::destroy(coin);
        test_utils::destroy(joined_coin);

        ts::end(scenario_val);
    }
}