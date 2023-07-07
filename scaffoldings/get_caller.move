//! Get the caller of the contract
//! using `tx_context::sender(ctx)`

fun init(ctx: &mut TxContext) {
    transfer::transfer(hello, tx_context::sender(ctx));
}
