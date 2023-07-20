#[test_only]
module sui_conditionals::loop_tests {
    #[test]
    fun test_loop_w_continue_break_ifelse() {
        let x = 1;

        loop {
            x = x + 1;
            if (x < 10) { 
                continue 
            } else { 
                break 
            }
        };

        std::debug::print(&x);
    }

    #[test]
    fun test_loop_w_break_if() {
        let x = 1;

        loop {
            x = x + 1;
            if (x > 10) { 
                break 
            }
        };

        std::debug::print(&x);
    }


    #[test]
    fun test_loop_nested() {
        let x = 1;
        let y = 4;

        loop {
            x = x + 1;
            loop {
                y = y + 1;
                if (y > 7) {
                    break
                }
            };

            if (x > 10) {
                break
            }
        };

        std::debug::print(&x);
        std::debug::print(&y);
    }
}