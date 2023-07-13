module car::car {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    /// to create a car object
    struct Car has key {
        id: UID,
        speed: u8,
        acceleration: u8,
        handling: u8,
    }

    /// create a new car
    public fun new(speed: u8, acceleration: u8, handling: u8, ctx: &mut TxContext): Car {
        Car {
            id: object::new(ctx),
            speed: speed,
            acceleration: acceleration,
            handling: handling,
        }
    }

    /// create a new car and transfer it to the sender
    public entry fun create(speed: u8, acceleration: u8, handling: u8, ctx: &mut TxContext) {
        let car = new(speed, acceleration, handling, ctx);
        transfer::transfer(car, tx_context::sender(ctx));
    }

    /// transfer a car to a recipient (friend for example)
    public entry fun transfer(car: Car, recipient: address) {
        transfer::transfer(car, recipient);
    }

    /// get the stats of a car
    public fun stats(car: &Car): (u8, u8, u8) {
        (car.speed, car.acceleration, car.handling)
    }

    /// update the speed of a car in a body shop
    public entry fun update_speed(car: &mut Car, by: u8) {
        car.speed = car.speed + by;
    }

    /// update the acceleration of a car in a body shop
    public entry fun update_acceleration(car: &mut Car, by: u8) {
        car.acceleration = car.acceleration + by;
    }

    /// update the handling of a car in a body shop
    public entry fun update_handling(car: &mut Car, by: u8) {
        car.handling = car.handling + by;
    }

}