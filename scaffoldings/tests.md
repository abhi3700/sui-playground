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
