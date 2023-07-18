# Car

## Overview

**Car**:

1. 🧍 [Anyone] can create a car 🚘 & get it transferred to itself. [code](./sources/car.move)

---

**Car Admin**: Shows admin capability (i.e. Access Control) of creating a car and transfer to a person. [code](./sources/car_admin.move)

1. 👨🏻‍✈️ [ShopOwner] --create a car with given stats--> 🚘 --transfer to a person-->

---

**Car Shop**: Shows how to take payment from a person and create & transfer a car to the person as a purchase. Also admin capability of setting a price for a car. [code](./sources/car_shop.move)

1. 👨🏻‍✈️ [ShopOwner] --shop owner set a price--> 🏬
2. 🧍 [Buyer] --buy a car--> 🏬 [CarShop] --creates a car 🚘 & transfer to the buyer--> 🧍 [Buyer]

## Resources

- [Video](https://youtu.be/0wTpVQb09qs)
- [Code](https://github.com/sui-foundation/encode-sui-educate/tree/main/lesson-2)
  > Doesn't have unit tests
