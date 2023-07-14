---
title: Get mutable reference
---

```rust
/// Get a mutable reference to the balance of a coin.
public fun balance_mut<T>(coin: &mut Coin<T>): &mut Balance<T> {
    &mut coin.balance
}
```
