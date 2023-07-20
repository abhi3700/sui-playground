---
title: How to write tests
---

The `test_scenario` module in the sui codebase is a higher-level testing framework that provides a way to define test scenarios for the entire SUI framework. It is used to test the behavior of the SUI framework in various scenarios, such as creating and updating objects, transferring ownership, and so on.

Concise way to import test scenario:

```rust
use test_scenario::Self as ts;
```

---

Begin transaction with a address:

```rust
let scenario_val = ts::begin(Owner);
// if mutably referenced, use `&mut scenario_val` instead.
```

---

End transaction flow:

```rust
ts::end(scenario_val);
```

---

**Use of Error code from other module**:

If a function fails, it should be marked like this:

```rust
use counter::counter_admin::EOnlyOwner;

#[test]
#[expected_failure(abort_code = EOnlyOwner)]
fun reset_fails_when_called_by_non_owner() {
    let scenario_val = ts::begin(Owner);
    // let scenario = &mut scenario_val;

    {
        let ctx = ts::ctx(&mut scenario_val);
        counter_admin::create(ctx);
    };

    // check if the counter is reset
    ts::next_tx(&mut scenario_val, Alice);
    {
        let counter_object = ts::take_shared<Counter>(&mut scenario_val);
        let ctx = ts::ctx(&mut scenario_val);
        counter_admin::reset(&mut counter_object, ctx);
        ts::return_shared(counter_object);
    };

    ts::end(scenario_val);
}
```

Here, everything looks same except for `#[expected_failure(abort_code = EOnlyOwner)]` annotation. Also, notice that the error_code `EOnlyOwner` is updated with the error code of the actual module as that would originally be returned as `abort_code`. Hence, it is imported from the main module via `use counter::counter_admin::EOnlyOwner;`.

---

**Usage of `tx_context::dummy()`**:

The dummy function in the `sui::tx_context` module is a test-only function that creates a dummy `TxContext` for testing purposes. It is used to create a `TxContext` object with a predetermined transaction hash and epoch number, which can be used to test various functions that depend on a `TxContext` object.

**Cons**:

- This dummy context has only 1 user.
- Can't switch caller.

Imagine a situation, where you don't have `assertion` statement defined for "access control" or "asset ownership", but the error code is defined in the std. lib. Then define the test function (supposed to fail) like this:

```rust
// NOTE: 'EEmptyInventory' defined in `sui::test_scenario` module is used here.
#[test]
#[expected_failure(abort_code = sui::test_scenario::EEmptyInventory)]
fun test_transfer_fails_when_transferred_by_non_owner() {
    let scenario_val = ts::begin(Owner);

    {
        let ctx = ts::ctx(&mut scenario_val);
        car::create(50, 50, 50, ctx);
    };

    // transfer the car from Alice to Bob
    ts::next_tx(&mut scenario_val, Alice);      // NOTE: here, it is supposed to be 'Owner'
    {
        // we have to dive into the function `take_from_sender` to see the error code.
        let car_object = ts::take_from_sender<Car>(&mut scenario_val);
        // car::transfer(car_object, Bob);      // didn't even reach at this level.
        ts::return_to_sender(&scenario_val, car_object)
    };

    ts::end(scenario_val);
}
```

---

**Construct an object inside/outside the module during testing**:

We can construct an object (via `object::new(ctx)`) inside a module only. In order to construct the object outside the module, we need to create a `new` (not `entry` type) function that returns the same object like this:

```rust
// car.move
module car::car {
    /// to create a car object
    struct Car has key {
        id: UID,
        speed: u8,
        acceleration: u8,
        handling: u8,
    }

    /// create a new car from inside the SC function & outside the module like tests.
    public fun new(speed: u8, acceleration: u8, handling: u8, ctx: &mut TxContext): Car {
        Car {
            id: object::new(ctx),
            speed: speed,
            acceleration: acceleration,
            handling: handling,
        }
    }
}
```

And now tests can be written like this:

_for inside the module_:

```rust
// car.move
module car::car {
    #[test]
    public fun test_transfer_works() {
        let ctx = &mut tx_context::dummy();

        // create a car object & transfer to the owner.
        car::create(50, 50, 50, ctx);

        // create a car object with same values.
        // M-2: recommended inside the module `car`
        let car_object = car::car::Car {
            id: object::new(ctx),
            speed: 50,
            acceleration: 50,
            handling: 50,
        };

        // transfer the car from Owner to Alice
        car::transfer(car_object, Alice);       // here w/o using test_scenario, we knew that the owner is 'Owner'.
    }
}
```

_for outside the module_:

```rust
// car_tests.move
#[test_only]
module car::car_tests {
    #[test]
    public fun test_transfer_works() {
        let ctx = &mut tc::dummy();

        // create a car object & transfer to the owner.
        car::create(50, 50, 50, ctx);

        // create a car object with same values.
        // M-1: recommended outside the module
        // NOTE: Use a function that returns a car object 'Car'.
        let car_object = car::new(50, 50, 50, ctx);

        // transfer the car from Owner to Alice
        car::transfer(car_object, Alice);       // here w/o using test_scenario, we knew that the owner is 'Owner'.
    }
}
```

---

Inside a scope after each caller assignment, the `ctx` has to be provided in order to mutably use the `scenario_val`:

```rust
// caller assignment to the scenario
ts::next_tx(&mut scenario_val, Alice);
{
    // take the shared object from the scenario & also check if it exists & shared indeed.
    let counter_object = ts::take_shared<Counter>(&mut scenario_val);
    // ctx assignment to the scenario
    let ctx = ts::ctx(&mut scenario_val);
    counter_admin::reset(&mut counter_object, ctx);

    // returns the shared object to the scenario before the scope ends.
    // Otherwise, it gets dropped and then, the shared object would have
    // to use the `drop` ability in order to avoid panic.
    ts::return_shared(counter_object);
};
```

---

Fail ❌: Because of invalid borrowing i.e. `scenario` owned value is used twice in the same scope during `ts::next_txn()` usage.

```rust
let scenario_val = ts::begin(Owner);
let scenario = &mut scenario_val;

{
    // === snip ===
};
ts::next_txn(scenario, Alice);
{
    // === snip ===
};

ts::next_txn(scenario, Alice);
{
    // === snip ===
};

ts::end(scenario_val);
```

> NOTE: This is the workaround for the above problem. But, the above problem is not a problem. Rather it can also work in some cases.

Pass ✅: Because `scenario` is replaced by mutable referencing like this:

```rust
let scenario_val = ts::begin(Owner);

{
    // === snip ===
};
ts::next_txn(&mut scenario_val, Alice);
{
    // === snip ===
};

ts::next_txn(&mut scenario_val, Alice);
{
    // === snip ===
};

ts::end(scenario_val);
```

---

**How to use objects created in scope-1 in scope-2**?

Also covered: **how to test access control feature**?

> Remember to destroy/return the object before the scope (in which object is created) ends.

```rust
// car_admin_tests.move
#[test_only]
module car::car_admin_tests {
    #[test]
    #[expected_failure(abort_code = sui::test_scenario::EEmptyInventory)]
    fun test_create_fails_by_non_owner() {
        let scenario_val = ts::begin(Owner);

        // scope-1
        {
            let ctx = ts::ctx(&mut scenario_val);
            car_admin::create_admin_cap(ctx);   // Admin capability is given to Owner
        };

        ts::next_tx(&mut scenario_val, Alice);
        // scope-2
        {
            let car_admin_object = ts::take_from_sender<AdminCapability>(&scenario_val);    // it would fail at this level itself as Alice is not the owner
            let ctx = ts::ctx(&mut scenario_val);
            car_admin::create(&car_admin_object, 50, 50, 50, ctx);
            // car_admin::destroy_for_testing(car_admin_object);    // not required here as handled by `return_to_sender`.
            ts::return_to_sender(&scenario_val, car_admin_object);
        };

        ts::end(scenario_val);

    }
}
```

Here in scope-1, an object `AdminCapability` is created, but need to be used in `scope-2`. Just use `take_from_sender()` & `return_to_sender()` to destroy the object in `scope-2` itself.

There is another method to destroy the object if I create an object inside testing:

```rust
// car_admin.move
module car::car_admin {
    // Any object (w/o drop ability) created in a scope has to be consumed in the same scope or destroyed.
    #[test_only]
    public fun destroy_for_testing(admin_capability: AdminCapability) {
        let AdminCapability { id }  = admin_capability;
        object::delete(id);
    }

    #[test]
    fun test_create_works() {
        let ctx = &mut tx_context::dummy();
        init(ctx);

        // create an admin capability object using same ctx, same caller => same object id.
        let admin_capability_object = new_cap(ctx);
        create(&admin_capability_object, 50, 50, 50, ctx);

        destroy_for_testing(admin_capability_object);
    }
}
```
