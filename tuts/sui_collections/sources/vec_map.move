#[test_only]
module sui_collections::vec_map {
    use sui::vec_map;
    use std::debug;
    use std::vector;
    use std::string::{Self, String};

    #[test]
    fun test_vec_map_u64_bool_works() {
        // create a VecMap
        let v1 = vec_map::empty<u64, bool>();

        // insert
        vec_map::insert(&mut v1, 1, true);
        vec_map::insert(&mut v1, 12, true);
        vec_map::insert(&mut v1, 22, false);
        vec_map::insert(&mut v1, 32, true);
        vec_map::insert(&mut v1, 42, false);
        assert!(vec_map::size(&v1) == 5, 0);
        // debug::print(&v1);

        // remove by key
        vec_map::remove(&mut v1, &1);
        assert!(vec_map::size(&v1) == 4, 1);

        // remove by index
        vec_map::remove_entry_by_idx(&mut v1, 0);
        assert!(vec_map::size(&v1) == 3, 2);

        // ensure it's not empty
        assert!(!vec_map::is_empty(&v1), 1);
        assert!(vec_map::size(&v1) == 3, 3);

        // get keys from vec_map
        let keys = vec_map::keys(&v1);
        assert!(vector::length(&keys) == 3, 4);
        
        // get keys, values from vec_map
        let (keys, values) = vec_map::into_keys_values(v1);
        debug::print(&keys);
        debug::print(&values);
        assert!(vec_map::size(&v1) == 3, 5);

        // destroy vec_map if it's empty
        if (vec_map::is_empty(&v1)) {

            vec_map::destroy_empty(v1);
            assert!(vec_map::size(&v1) == 3, 6);
        }
    }

    #[test]
    fun test_vec_map_u64_string_works() {
        // create an empty VecMap
        let v1 = vec_map::empty<u64, String>();

        // insert
        vec_map::insert(&mut v1, 1, string::utf8(b"alice"));
        vec_map::insert(&mut v1, 2, string::utf8(b"bob"));
        vec_map::insert(&mut v1, 3, string::utf8(b"charlie"));
        vec_map::insert(&mut v1, 5, string::utf8(b"dave"));
        vec_map::insert(&mut v1, 8, string::utf8(b"eve"));
        assert!(vec_map::size(&v1) == 5, 0);
        // debug::print(&v1);

        // remove by key
        vec_map::remove(&mut v1, &1);
        assert!(vec_map::size(&v1) == 4, 1);

        // remove by index
        vec_map::remove_entry_by_idx(&mut v1, 0);
        assert!(vec_map::size(&v1) == 3, 2);

        // ensure it's not empty
        assert!(!vec_map::is_empty(&v1), 1);
        assert!(vec_map::size(&v1) == 3, 3);

        // get keys from vec_map
        let keys = vec_map::keys(&v1);
        assert!(vector::length(&keys) == 3, 4);
        
        // get keys, values from vec_map
        let (keys, values) = vec_map::into_keys_values(v1);
        debug::print(&keys);
        debug::print(&values);
        assert!(vec_map::size(&v1) == 3, 5);

        // destroy vec_map if it's empty
        if (vec_map::is_empty(&v1)) {

            vec_map::destroy_empty(v1);
            assert!(vec_map::size(&v1) == 3, 6);
        }
    }    

    #[test]
    fun test_vec_map_address_string_works() {
        // create a VecMap
        let v1 = vec_map::empty<address, String>();

        // insert
        vec_map::insert(&mut v1, @0x01, string::utf8(b"alice"));
        vec_map::insert(&mut v1, @0x02, string::utf8(b"bob"));
        vec_map::insert(&mut v1, @0x03, string::utf8(b"charlie"));
        vec_map::insert(&mut v1, @0x05, string::utf8(b"dave"));
        vec_map::insert(&mut v1, @0x08, string::utf8(b"eve"));
        assert!(vec_map::size(&v1) == 5, 0);
        // debug::print(&v1);

        // remove by key
        vec_map::remove(&mut v1, &@0x01);
        assert!(vec_map::size(&v1) == 4, 1);

        // remove by index
        vec_map::remove_entry_by_idx(&mut v1, 0);
        assert!(vec_map::size(&v1) == 3, 2);

        // ensure it's not empty
        assert!(!vec_map::is_empty(&v1), 1);
        assert!(vec_map::size(&v1) == 3, 3);

        // get keys from vec_map
        let keys = vec_map::keys(&v1);
        assert!(vector::length(&keys) == 3, 4);
        
        // get keys, values from vec_map
        let (keys, values) = vec_map::into_keys_values(v1);
        debug::print(&keys);
        debug::print(&values);
        assert!(vec_map::size(&v1) == 3, 5);

        // destroy vec_map if it's empty
        if (vec_map::is_empty(&v1)) {

            vec_map::destroy_empty(v1);
            assert!(vec_map::size(&v1) == 3, 6);
        }
    }    

}