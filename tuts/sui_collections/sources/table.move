#[test_only]
module sui_collections::table {
    use sui::table::{Self, Table, borrow, borrow_mut, contains, destroy_empty, drop, is_empty, length, new, remove, add};
    use std::debug;
    use sui::tx_context;
    use std::string::{Self, String, utf8};

    #[test]
    fun test_table_works() {
        let ctx = &mut tx_context::dummy();
        let t1: Table<address, String>  = new(ctx);

        add(&mut t1, @0x1, string::utf8(b"hello"));
        add(&mut t1, @0x2, string::utf8(b"hello"));
        add(&mut t1, @0x31, string::utf8(b"alice"));

        // get the size of the table
        assert!(length(&t1) == 3, 1);

        debug::print(&t1);

        // check the table contains
        assert!(contains(&t1, @0x1), 0);
        assert!(contains(&t1, @0x31), 1);

        // borrow immutably
        let v1a = table::borrow(&t1, @0x1);
        assert!(v1a == &string::utf8(b"hello"), 2);
        assert!(*borrow(&t1, @0x31) == utf8(b"alice"), 3);

        // NOTE: borrow mutably not possible with value of `String` type
        // *table::borrow_mut(&mut t1, @0x1) = *table::borrow(&t1, @0x1) * 2;
        // *borrow_mut(&mut t1, b"hello") = *borrow(&t1, b"hello") * 2;

        // remove the value and check it
        assert!(remove(&mut t1, @0x1) == utf8(b"hello"), 2);
        assert!(remove(&mut t1, @0x2) == utf8(b"hello"), 3);
        assert!(remove(&mut t1, @0x31) == utf8(b"alice"), 4);
        
        // check that the table is empty
        assert!(is_empty(&t1), 1);
        debug::print(&t1);
        
        // destroy empty table
        destroy_empty(t1);
    }

    #[test]
    fun test_table_borrow_mutably() {
        let ctx = &mut tx_context::dummy();
        let t1  = new(ctx);

        add(&mut t1, @0x1, 10);
        add(&mut t1, @0x2, 20);
        add(&mut t1, @0x3, 30);

        // borrow mutably only possible with numbers of any type
        *borrow_mut(&mut t1, @0x1) = *borrow(&t1, @0x1) * 2;
        *borrow_mut(&mut t1, @0x2) = *borrow(&t1, @0x2) * 4;
        *borrow_mut(&mut t1, @0x3) = *borrow(&t1, @0x3) * 6;

        // check the new value
        assert!(*borrow(&t1, @0x1) == 20, 1);
        assert!(*borrow(&t1, @0x2) == 80, 1);
        assert!(*borrow(&t1, @0x3) == 180, 1);

        // destroy non-empty table
        drop(t1);
    }

    #[test]
    fun test_drop_non_empty_table() {
        let ctx = &mut tx_context::dummy();
        let t1: Table<address, String>  = new(ctx);
    
        add(&mut t1, @0x1, string::utf8(b"hello"));
        assert!(length(&t1) == 1, 1);

        // drop the empty table
        drop(t1);
    }
}