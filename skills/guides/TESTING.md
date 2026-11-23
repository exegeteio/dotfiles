# Testing

* Tests focus on the public API of a module, testing behavior and side effects of code, rather than
    the code itself.
    * An exception is in highly-complex individual components, where unit-tests are required to
        ensure the complexity is strictly adhered to.
* When testing, the test must focus on the behavior under test, rather than the specific
    implementation.
* Tests which resemble the implementation may be causing deep coupling, and should be considered for
    restructuring.
* Tests should act as documentation, telling the story of the implementation.
* Never test language or framework features.
