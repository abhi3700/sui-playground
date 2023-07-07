//! Create object id (global unique id) and transfer it to sender.
//! using `object::new(ctx)`

fun init(ctx: &mut TxContext) {
    let hello = Hello {
        id: object::new(ctx),
        message: string::utf8(b"Hello, World"),
        timestamp: 0,
    };
    transfer::transfer(hello, tx_context::sender(ctx));
}
