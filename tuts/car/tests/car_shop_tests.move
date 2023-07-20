#[test_only]
module car::car_shop_tests {
    use sui::test_scenario::Self as ts;
    use car::car_shop::{Self, CarShop, ShopOwnerCap };

    const Owner: address = @0x1;
    const Alice: address = @0x2;
    const Bob: address = @0x3;
    const Charlie: address = @0x4;

    #[test]
    #[expected_failure(abort_code = sui::test_scenario::EEmptyInventory)]
    fun test_set_price_fails_by_non_owner() {
        let scenario_val = ts::begin(Owner);
        
        {
            let ctx = ts::ctx(&mut scenario_val);
            car_shop::test_init(ctx);

        };

        ts::next_tx(&mut scenario_val, Alice);
        {
            let shopownercap = ts::take_from_sender<ShopOwnerCap>(&scenario_val);
            let shop = ts::take_shared<CarShop>(&scenario_val);
            car_shop::set_price(&shopownercap, &mut shop, 1200);
            ts::return_to_sender(&scenario_val, shopownercap);
            ts::return_shared(shop);
        };

        ts::end(scenario_val);
    }
}