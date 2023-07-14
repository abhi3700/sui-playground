---
title: Get Caller of the SC function
---

Get the caller of the contract using `tx_context::sender(ctx)`

Here, `hello` struct must have `key` ability in order to be put into use `transfer::transfer()` function as they argument supports only `key` ability like this: `transfer<T: key>(o: T, to: address)`. [Code](https://github.com/MystenLabs/sui/blob/e7f5d3cdc187b5e4f45b1764f9c771be89d37921/crates/sui-framework/packages/sui-framework/sources/transfer.move#L24-L26)

```rust
use sui::tx_context::{Self, TxContext};

fun init(ctx: &mut TxContext) {
    transfer::transfer(hello, tx_context::sender(ctx));
}
```
