---
title: error[E07005] invalid transfer of references
---

![](../img/e07005_invalid_transfer_of_refs_1.png)

- _Cause_: In the code below, we can see the mutuable reference is being transferred from one scenario (txn) to another scenario (txn). This is not allowed in Move. So, we need to clone or re-create the `ctx`.
  ![](../img/e07005_invalid_transfer_of_refs_1_before.png)

- _Solution_: Here, we recreated the `ctx` & parsed inside `divide_into_n()` function. L-72 is commented out as not required. Basically, there has to be continuous flow in single transaction or scenario.
  ![](../img/e07005_invalid_transfer_of_refs_1_after.png)

  Now, if we want to run the code with `next_tx`, then use this code:
  ![](../img/e07005_invalid_transfer_of_refs_1_after_2.png)

  > NOTE: We can move `scenario (&mut Scenario)` from one transaction to another. But, we cannot move `ctx (&mut Context)` from one transaction to another.
