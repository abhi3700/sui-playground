---
title: Assertions
---

Assertions of all types

```rust
/// Error: Non-empty message
const EEmptyMessage: u64 = 1;

/// Error: Zero address
const EZeroAddress: u64 = 2;


assert!(string::length(&message) != 0, EEmptyMessage);
// new_owner: address
assert!(new_owner != @0x0, EZeroAddress);
```
