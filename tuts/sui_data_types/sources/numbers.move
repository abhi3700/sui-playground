#[test_only]
module sui_data_types::numbers {
    use std::debug;

    #[test]
    fun test_u8() {
        let a: u8 = 255;
        debug::print(&a);
        assert!(a == 255, 0);

        let b= 35u8;
        debug::print(&b);
        assert!(b == 35u8, 0);
    }

    #[test]
    fun test_u256() {
        let a = 439u256;
        debug::print(&a);
    }
}