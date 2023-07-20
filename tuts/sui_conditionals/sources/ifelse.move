#[test_only]
module sui_conditionals::ifelse_tests {
    #[test]
    fun test_if() {
        let a = 1;
        if (a == 1) {
            std::debug::print(&a);
        }
    }

    #[test]
    fun test_if_else() {
        let a = 10;

        if (a == 1) {
            std::debug::print(&a);
        } else {
            std::debug::print(&a);
        };
    }
}