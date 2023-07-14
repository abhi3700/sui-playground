---
title: Define Getter function in a smart contract
---

```rust
//! Define Getter function for a struct 'Hello' in a smart contract.
//! This is to get the value of field(s) of struct 'Hello' from outside of the smart contract.

public fun get_hello(hello: &Hello): (String, u64) {
    (hello.message, hello.timestamp)
}

public fun get_msg(hello: &Hello): String {
    hello.message
}

public fun get_timestamp(hello: &Hello): u64 {
    hello.timestamp
}
```
