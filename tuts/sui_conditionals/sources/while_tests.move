#[test_only]
module sui_conditionals::while_tests {
    #[test]
    fun test_while() {
        let x = 1;

        while (x < 10) {
            x = x + 1;
        };

        std::debug::print(&x);
    }

    #[test]
    fun test_while_break() {
        let x = 4;

        while(x < 10) {
            x = x + 1;
            if (x == 7) {
                break
            }
        };

        std::debug::print(&x);
    }

    #[test]
    fun test_while_continue() {
        let x = 4;

        while(x < 10) {
            x = x + 1;
            if (x == 7) {
                continue
            };
            std::debug::print(&x);  // skipped when x == 7, skip the rest of the loop body and move on to the next iteration.
        };
    }

    #[test]
    fun test_while_nested() {
        let x = 1;
        let y = 4;

        while(x < 10) {
            x = x + 1;
            while(y < 10) {
                y = y + 1;
                if (y == 7) {
                    break
                }
            };
        };

        std::debug::print(&x);
        std::debug::print(&y);
    }
}