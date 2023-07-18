/// SOURCE: https://youtu.be/0wTpVQb09qs?t=1576

module car::car_admin {

    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID};
    use sui::transfer;
    
    // use car::car::Car; [FAIL] 
    // in case of transferred object, we can't use it, rather
    // we have to use the struct definition here.
    struct Car has key {
        id: UID,
        speed: u8,
        acceleration: u8,
        handling: u8
    }

    struct AdminCapability has key {
        id: UID
    }

    fun init(ctx: &mut TxContext) {
        // during the conntract deployment, the admin is transferred with the AdminCapability object.
        transfer::transfer(AdminCapability {
            id: object::new(ctx) 
        }, tx_context::sender(ctx));
    }

    #[test_only]
    /// replacement for `init` function, as it can only be private.
    public fun create_admin_cap(ctx: &mut TxContext) {
        // during the conntract deployment, the admin is transferred with the AdminCapability object.
        transfer::transfer(AdminCapability {
            id: object::new(ctx) 
        }, tx_context::sender(ctx));
    }
    
    #[test_only]
    public fun new_cap(ctx: &mut TxContext): AdminCapability {
        AdminCapability {
            id: object::new(ctx),
        }
    }

    // use car::car::new; [FAIL]
    // in case of transferred object, we can't use it, rather
    // we have to use the function definition here.
    public fun new(speed: u8, acceleration: u8, handling: u8, ctx: &mut TxContext): Car {
        Car {
            id: object::new(ctx),
            speed,
            acceleration,
            handling
        }
    }

    /// create a new car and transfer it to the sender (admin).
    /// Here, the caller can be someone who has the `AdminCapability` object.
    /// Hence, this function can be called by the admin only.
    /// 
    /// Real-world scenario: the admin creates a new car and transfers that to itself.
    /// NOTE: Here, the `Car` struct & `new` function has been defined in this module, 
    /// so it can be use inside `transfer::transfer` function.
    public entry fun create(_: &AdminCapability, speed: u8, acceleration: u8, handling: u8, ctx: &mut TxContext) {
        let car = new(speed, acceleration, handling, ctx);
        transfer::transfer(car, tx_context::sender(ctx));
    }

    // Any object (w/o drop ability) created in a scope has to be consumed in the same scope or destroyed.
    #[test_only]
    public fun destroy_for_testing(admin_capability: AdminCapability) {
        let AdminCapability { id }  = admin_capability;
        object::delete(id);
    }


    #[test]
    fun test_init_works() {
        let ctx = &mut tx_context::dummy();
        init(ctx);
    }

    #[test]
    fun test_create_by_admin() {
        let ctx = &mut tx_context::dummy();
        init(ctx);

        let admin_capability_object = new_cap(ctx);
        create(&admin_capability_object, 50, 50, 50, ctx);

        destroy_for_testing(admin_capability_object);
    }
}