#[test_only]
module sui_data_types::address {
    use std::address;
    use std::debug;

    #[test]
    fun test_address_works() {
        let alice = @0x12345678;
        let bob = @0x12345678;

        assert!(alice == bob, 0);
        let a1_len = address::length();
        debug::print(&a1_len);
    }
}