---
title: Zero Vector
---

Create a zero vector of given length

```rust
fun zero_vector(length: u64): vector<u8> {
    let vec = vector::empty<u8>();
    let i=0;
    while (i < length) {
        vector::push_back(&mut vec, 0);
        i = i+1;
    };
    vec
}
```
