//! Create a coin
//! Source: https://github.com/MystenLabs/sui/blob/bdd29d7f8e70d6632d7881dbe3e5c86cb455e507/crates/sui/tests/data/dummy_modules_publish/sources/trusted_coin.move
//! 1. Add your own struct name MY_COIN with custom name, symbol, decimals, and supply
//! 2. freeze the metadata - name, symbol, decimals
//! 3. `mint`, `burn` function available only to the owner
//! 
//! NOTE: `sui::coin::TreasuryCap` has the token supply value
//! Source: https://github.com/MystenLabs/sui/blob/bdd29d7f8e70d6632d7881dbe3e5c86cb455e507/crates/sui-framework/packages/sui-framework/sources/coin.move#L50-L57
//!     /// Capability allowing the bearer to mint and burn
//!    /// coins of type `T`. Transferable
//!    struct TreasuryCap<phantom T> has key, store {
//!        id: UID,
//!        total_supply: Supply<T>
//!    }
//! 
//! Coin lib: https://github.com/MystenLabs/sui/blob/main/crates/sui-framework/packages/sui-framework/sources/coin.move