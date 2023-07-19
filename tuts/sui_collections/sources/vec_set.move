#[test_only]
module sui_collections::vec_set {
    use sui::vec_set::{Self, VecSet};
    use std::vector;
    use std::debug;

    #[test]
    fun test_vec_set_u256_works() {
        // create an empty vec_set
        let vs1: VecSet<u256> = vec_set::empty();

        // check if empty
        assert!(vec_set::is_empty(&vs1), 0);

        // create a single element vec_set i.e. singleton
        let vs1 = vec_set::singleton(123);
        assert!(vec_set::size(&vs1) == 1, 0);

        // insert an element
        vec_set::insert(&mut vs1, 1);
        vec_set::insert(&mut vs1, 2);
        vec_set::insert(&mut vs1, 3);
        vec_set::insert(&mut vs1, 4);
        debug::print(&vs1);

        // get the size
        assert!(vec_set::size(&vs1) == 5, 0);

        // remove an element
        vec_set::remove(&mut vs1, &1);
        assert!(vec_set::size(&vs1) == 4, 0);

        // get the keys
        vec_set::keys(&vs1);
        assert!(vec_set::size(&vs1) == 4, 0);

        let keys = vec_set::into_keys(vs1);
        assert!(vec_set::size(&vs1) == 4, 0);
        assert!(vector::length(&keys) == 4, 1);

    }
}