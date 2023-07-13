module car::car_shop {

    use sui::transfer;
    use sui::sui::SUI;
    use sui::coin::{Self, Coin};
    use sui::object::{Self, UID};
    use sui::balance::{Self, Balance};
    use sui::tx_context::{Self, TxContext};

    // Error codes
    /// Insufficient balance
    const EInsufficientBalance: u64 = 0;

    /// Price value is same or zero
    const EPriceValueSameOrZero: u64 = 1;

    struct Car has key {
        id: UID,
        speed: u8,
        acceleration: u8,
        handling: u8,
    }

    /// In this case, only 1 shop for a car type. Hence, is a shared object 
    /// i.e. publicly available to everyone (i.e. buyer)
    /// NOTE: We can associate each `CarShop` as child object of `Car`.
    struct CarShop has key {
        id: UID,
        price: u64,
        balance: Balance<SUI>
    }


    /// exclusive for Admin i.e. Shop Owner.
    struct ShopOwnerCap has key {
        id: UID,
    }

    #[allow(unused_function)]
    fun init(ctx: &mut TxContext) {
        // set the owner of the shop, so, transfer the object to the caller.
        transfer::transfer(ShopOwnerCap {id: object::new(ctx)}, tx_context::sender(ctx));

        // init the price of the car
        transfer::share_object(CarShop{id: object::new(ctx), price: 1000, balance: balance::zero()});
    }

    /// Only ShopOwner can set/update the price of the car
    public entry fun set_price(_: &ShopOwnerCap, carshop: &mut CarShop, new_price: u64) {
        assert!(new_price != 0 && new_price != carshop.price, 1);
        carshop.price = new_price;
    }

    /// buy a car with SUI coin & then a car object is created & transferred to the buyer.
    /// This is like a factory pattern which creates a car object & transfer it to the buyer.
    public entry fun buy_car(shop: &mut CarShop, payment_coin: &mut Coin<SUI>, ctx: &mut TxContext) {
        // check the balance of the buyer is >= the price of the car
        assert!(coin::value(payment_coin) >= shop.price, EInsufficientBalance);

        // TODO: review this via test case if it works via this step only.
        // coin::split(payment_coin, shop.price, ctx);
        // transfer the price of the car to the shop
        let coin_balance = coin::balance_mut(payment_coin);
        let paid = balance::split(coin_balance, shop.price);

        // add the paid amount to the shop balance
        balance::join(&mut shop.balance, paid);

        // create the car & then transfer to the buyer
        transfer::transfer(
            Car {
                id: object::new(ctx), 
                speed: 50, 
                acceleration: 50, 
                handling: 50
            }, 
            tx_context::sender(ctx)
        );
    }

    /// Only ShopOwner can collect the earning from the shop
    /// M-1: Owner has to parse one of its gascoin objects' ids as mutable & then its balance's value is modified with the shop's balance
    /// M-2: Owner doesn't have to parse any gascoin object id, instead, a new  gascoin object is created & then it's transferred to the owner.
    public entry fun collect_earning(_: &ShopOwnerCap, shop: &mut CarShop, /* coin: &mut Coin<SUI>, */ ctx: &mut TxContext) {
        // get the balance of the shop & then join it to the admin's coin

        // === M-1:
        // let owner_coin_balance = coin::balance_mut(coin);
        // balance::join(owner_coin_balance, shop.balance);


        // === M-2:
        let amount = balance::value(&shop.balance);
        let earnings = coin::take(&mut shop.balance, amount, ctx);

        // reset the balance of the shop
        // shop.balance = balance::zero();  // TODO: during tests, check if the balance is reset or not in the shop object.

        // transfer the earning to the owner
        transfer::public_transfer(earnings, tx_context::sender(ctx));
    }

} 


