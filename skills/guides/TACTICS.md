# Tactical Values

## Tactical

* Even when using a dynamically typed language, such as Ruby or Elixir, treat types as static.
    * Always use code comments to document types when not provided by the language.
    * Required validations should be made as close to the module boundary as possible.
* Enforce dependency injection for values supplied by another module.

## Ruby Models

* Prefer deep modules for business logic with a defined public interface.
    * Models with fewer than 5 custom (e.g. not language or framework features) business logic
        implementations are candidates for wrapping in a Deep Module.

## Ruby Deep Modules

* Deep modules have a `module` type top level object which acts as its public interface.
    * The top level module itself should contain minimal logic, preferring to delegate to objects
        in its namespace.
* The top level module namespace contains other objects within them.
* Deep modules must have robust tests for the public interface.
    * Black-box testing is required.
        * Test only vie the public interface to call commands using return values, or public query
            methods, to check results/effects.

### Deep Modules Example - Cart

In the case of a `Cart` which began as an ActiveRecord object, you may need to change

Bad example:

```ruby
    class Cart < ApplicationRecord
        has_many :items
        belogs_to :customer
    end
    # At least 5 business logic modules or classes like:
    module Checkout
        extend self
        def finalize!(cart:)
            # ...
        end
    end
```

Good example:

```ruby
    module Cart
        extend self
        delegate :find, :create, to: Model
        class Model < ApplicationRecord
            self.table_name = "carts"
            has_many :items
            belogs_to :customer
        end
        module Checkout
            extend self
            def finalize!(cart:)
                # ...
            end
        end
    end
```

## Strategy Pattern

Whenever an operation has three or more potential ways to act, prefer using the gang-of-four
strategy pattern to implement.

Bad example:

```ruby
    # inside Cart::Checkout
    case cart.shipping_option
    when :ground
        Shipping.ship_via_ground(cart)
    when :next_day
        Shipping.ship_via_next_day(cart)
    when :option3
        # ... steps to perform option 3
    when :option4
        # ... steps to perform option 4
    end
```

Good example:

```ruby
    class Cart
        # The Cart knows/owns shipping options, so interrogate it to find out the correct strategy.
        def shipping_strategy
            case shipping_option
            when :ground
                Shipping::ViaGround
            when :next_day
                Shipping::ViaNextDay
            # ...
            end
        end
    end
    # inside Cart::Checkout
    Shipping.ship_via(strategy: cart.shipping_strategy)
```
