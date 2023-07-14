---
title: Get immutable reference
---

```rust
/// Get immutable reference to the balance of a coin.
public fun balance<T>(coin: &Coin<T>): &Balance<T> {
    &coin.balance
}
```
