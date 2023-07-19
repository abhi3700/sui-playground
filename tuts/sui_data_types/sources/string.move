#[test_only]
module sui_data_types::string {
    use std::string;
    use std::debug;

    #[test]
    fun test_string_works() {
        // create a string from 'utf-8' bytes
        let s1 = string::utf8(b"hello");
        debug::print(&s1);
        assert!(s1 == string::utf8(b"hello"), 0);

        // append a 'utf-8' to s1
        string::append_utf8(&mut s1, b" world");
        assert!(s1 == string::utf8(b"hello world"), 1);

        // get the substring of a string
        let s1_sub = string::sub_string(&s1, 0, 5);     // [0, 5) i.e. 0, 1, 2, 3, 4
        debug::print(&s1_sub);  // "hello"

        // join 2 strings
        let s1 = string::utf8(b"hello");
        let s2 = string::utf8(b" abhi");
        string::append(&mut s1, s2);
        assert!(s1 == string::utf8(b"hello abhi"), 2);

        // check if empty
        assert!(!string::is_empty(&s1), 3);

        // get the bytes of a string
        let b1 = string::bytes(&s1);
        debug::print(b1);       // print the bytes of "hello abhi"

        // get the length of a string
        let s1_len = string::length(&s1);
        debug::print(&s1_len);   // print the length of "hello abhi"

        // get the character at a given index
        let c1_idx = string::index_of(&s1, &string::utf8(b"h"));
        debug::print(&c1_idx);      // print the character at index 0

        // insert ch/string at a given index in a string
        string::insert(&mut s1, s1_len, string::utf8(b"! How are you doing?"));
        debug::print(&s1);
    }
}