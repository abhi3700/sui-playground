//! Get an object details using a public function
//! 
//! Suppose, I have created multiple instances of same struct 'Hello',
//! using the unique ID generated via `object::new(ctx)`, I can create an instance per function call.
//! 
//! Now, I want to get the details of an object via its id.
//! then I would like to get the details of each instance using a public function.

// TODO: finish this
    public fun get_hello(hello: &Hello): (String, u64) {
        (hello.message, hello.timestamp)
    }
