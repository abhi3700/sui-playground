---
title: Destroy objects instead of returning them
---

Before ending a test function, we are supposed to destroy all the objects created/taken from the sender in a transaction in the test function.

In the below example, as the objects are not created in the current transaction. It was supposed to be returned in the corresponding transactions itself, before the next transaction is called.

```rust
#[test]
fun test_coin_split_n() {
    // Here, `test_scenario` is used instead of `dummy` context because we want to
    // take the objects created from the last transaction by the sender using `take_from_sender()`
    // function
    let scenario_val = ts::begin(ALICE);
    let scenario = &mut scenario_val;
    // let ctx = ts::ctx(scenario);
    let coin = coin::mint_for_testing<SUI>(10, ts::ctx(scenario));

    ts::next_tx(scenario, ALICE);
    pay::divide_and_keep(&mut coin, 3, ts::ctx(scenario));
    // Now, ALICE has all 3 coin objects in her possession.
    // The order is in last to first order.

    ts::next_tx(scenario, ALICE);
    let coin1 = ts::take_from_sender<Coin<SUI>>(scenario);

    ts::next_tx(scenario, ALICE);
    let coin2 = ts::take_from_sender<Coin<SUI>>(scenario);

    ts::next_tx(scenario, ALICE);
    assert!(coin::value(&coin1) == 3, 0);
    assert!(coin::value(&coin2) == 3, 0);
    assert!(coin::value(&coin) == 4, 0);
    // Hence, total value is 10.
    assert!(
        !ts::has_most_recent_for_sender<Coin<SUI>>(scenario),
        1
    );

    // Now, destroy all the objects
    test_utils::destroy(coin);
    test_utils::destroy(coin1);
    test_utils::destroy(coin2);


    // NOTE: return doesn't work here, because the objects are not created in the current
    //  transaction. It was supposed to be returned in the corresponding transactions itself, before
    // the next transaction is called.
    // ts::return_to_sender(&scenario_val, coin);
    // ts::return_to_sender(&scenario_val, coin1);
    // ts::return_to_sender(&scenario_val, coin2);

    ts::end(scenario_val);

}
```
