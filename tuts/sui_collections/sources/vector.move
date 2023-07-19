#[test_only]
module sui_collections::vector {
    use std::vector;
    use std::debug;

    #[test]
    fun test_vector_u256_works() {
        // create
        let v1: vector<u256> = vector::empty();
        assert!(vector::length(&v1) == 0, 0);

        // push_back
        vector::push_back(&mut v1, 145u256);
        vector::push_back(&mut v1, 155u256);
        vector::push_back(&mut v1, 165u256);
        vector::push_back(&mut v1, 175u256);
        vector::push_back(&mut v1, 185u256);
        debug::print(&v1);
        assert!(vector::length(&v1) == 5, 1);

        // pop_back
        let e1 = vector::pop_back(&mut v1);
        assert!(e1 == 185u256, 2);
        // get length
        assert!(vector::length(&v1) == 4, 2);

        // check if vector contains element
        assert!(vector::contains(&v1, &155u256), 3);

        // check if its empty
        assert!(!vector::is_empty(&v1), 4);

        // insert at an index (begin, middle, end) of vector
        vector::insert(&mut v1, 200u256, 2);
        debug::print(&v1);
        assert!(vector::length(&v1) == 5, 2);

        // remove element by index (begin, middle, end) of vector
        vector::remove(&mut v1, 2);
        debug::print(&v1);
        assert!(vector::length(&v1) == 4, 3);

        // get index of element (begin, middle, end) of vector
        let (is_present, ele) = vector::index_of(&v1, &165u256);
        assert!(is_present, 3);     // assert the existence of element
        debug::print(&ele);     // print the index
        assert!(ele == 2, 3);       // assert the index

        // append a vector to another vector
        let v2 = vector::empty();
        vector::push_back(&mut v2, 326u256);
        vector::append(&mut v1, v2);
        assert!(vector::length(&v1) == 5, 4);

        // destroy vector if empty
        if (vector::is_empty(&v1)) {
            vector::destroy_empty(v1);
        }
    }
}