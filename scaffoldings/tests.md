---
title: How to write tests
---

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
