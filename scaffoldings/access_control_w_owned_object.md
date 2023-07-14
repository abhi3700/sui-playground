---
title: Access Control with Owned Object
---

This is about showing how to implement access control with an owned (not shared) object.

```rust
module car::car_admin {

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

    // use car::car::new; [FAIL]
    // in case of transferred object, we can't use it, rather
    // we have to use the function definition here.
    fun new(speed: u8, acceleration: u8, handling: u8, ctx: &mut TxContext): Car {
        Car {
            id: object::new(ctx),
            speed,
            acceleration,
            handling
        }
    }

    /// create a new car and transfer it to the sender (admin).
    /// Here, the caller can be someone who has the AdminCapability object.
    /// Hence, this function can be called by the admin only.
    ///
    /// Real-world scenario: the admin creates a new car and transfers it to itself.
    /// NOTE: Here, the `Car` struct has been defined in this module, so we can use it.
    /// Also, the `new` function is defined in this module, so we can use it.
    /// SOURCE: https://youtu.be/0wTpVQb09qs?t=1576
    public entry fun create(_: &AdminCapability, speed: u8, acceleration: u8, handling: u8, ctx: &mut TxContext) {
        let car = new(speed, acceleration, handling, ctx);
        transfer::transfer(car, tx_context::sender(ctx));
    }
}
```
