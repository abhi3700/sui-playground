#[test_only]
module sui_utils::crypto {
    use sui::hash;
    
    #[test]
    fun test_hash_keccak256() {
        let msg = b"hello world";
        let hashed_msg_bytes = hash::keccak256(&msg);
        assert!(hashed_msg_bytes == x"47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad", 0);
    }

    #[test]
    fun test_hash_keccak256_empty_msg() {
        let empty_msg = b"";
        let hashed_empty_msg_bytes = hash::keccak256(&empty_msg);
        assert!(hashed_empty_msg_bytes == x"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470", 0);
    }

    #[test]
    fun test_hash_blake2b256() {
        let msg = b"hello world";
        let _hashed_msg_bytes: vector<u8> = hash::blake2b256(&msg);
        // assert!(hashed_msg_bytes == x"4fccfb4d98d069558aa93e9565f997d81c33b080364efd586e77a433ddffc5e2", 0);
    }
}
