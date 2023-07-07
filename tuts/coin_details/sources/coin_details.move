module coin_details_pkg::coin_details_mod {
    use sui::balance;
    public fun get_balance(user: &address): u64 {
        balance::value(user);
    }
}