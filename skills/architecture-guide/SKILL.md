---
name: architecture-guide
description: Where code belongs in an application (Rails: models, views, controllers, service objects, decorators). Use when deciding where a module should live, how to split responsibilities, and whenever strategy-guide applies.
---

# Architecture

## Rails

Use this architecture when working with Ruby on Rails applications.

* Default to Rails idiomatic architecture.
    * Model, View, Controller, in `app/models`, `app/views`, and `app/controllers`, respectively.
        * Service objects can be added for complex business logic in `app/services`.
    * Controllers should stick to the Rails convention 7 default controller-actions.  `index`, `show`, `new`,
      `create`, `edit`, `update`, `destroy`.
      * Prefer to create a new folder when one of these actions does not fit, rather than inventing
          a new type of action.
* Controllers should be thin wrappers around business logic, responsible for:
    * Parsing parameters.
    * Calling business logic on a model, or service object (e.g. `find`, `call`).
    * Determining the result of the business logic (e.g. `.success?`, `.errors.any?`).
    * Optional:  Creating a decorator for the result of the business logic.
        * Useful when the view needs data from multiple models, needs a subset of data, or if the
            view will render an object not associated with this controller (e.g. `CartsController`
            creating a decorator to show both `Cart` and `Product` data).
    * Rendering the view (HTML, JSON, XML, etc).
* Models should contain business logic, and can be ActiveRecord models, plain Ruby objects, or SDK
    objects for interacting with other services.
    * Specifically for ActiveRecord Models
        * Must implement validations required for the database.
        * Answer implementation questions for associated logic, such as choosing a strategy.
            * e.g. `Cart` with`.shipping_strategy` which returns a `Shipping::Strategy::Ground`
                object for passing to `Shipping.calculate_price(strategy:)`.
    * Collections of related functionality, focusing on locality and cohesion.
    * Complex business logic can be contained in sub-modules (e.g.
        `Cart::Checkout.finalize!(cart:)`, or `Inventory::AllocateForShipping.ship!(items:)`).
* Service Objects are similar to Models, but are used for crossing between multiple models (e.g.
    performing actions for a shopping cart checkout which performs business logic on `Cart`,
    `Inventory`, `Shipping`, and `Payment` objects).
* Views should render output.
    * Views should never retrieve data from the database.
    * All dependencies should be injected into the view by the controller.
    * Prefer explicit injection where possible.


