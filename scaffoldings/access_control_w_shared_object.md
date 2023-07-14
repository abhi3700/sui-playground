---
title: Access Control with Shared Object
---

This is about showing how to implement access control with an shared (not owned) object.

```rust
//! package: counter
//! module: counter_admin
/// Counter module with Admin restriction with shared object.
module counter::counter_admin {
    //== snip ==
    struct Counter has key {
        id: UID,
        owner: address,
        value: u16
    }

    fun init(ctx: &mut TxContext) {
        let counter = Counter {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
            value: 3
        };

        transfer::share_object(counter);
    }

    //==== Only owner ====
    /// increment function
    public entry fun inc(c: &mut Counter, ctx: &mut TxContext) {
        assert!(tx_context::sender(ctx) == c.owner, EOnlyOwner);
        c.value = c.value + 1;
    }

    //== snip ==
}
```
