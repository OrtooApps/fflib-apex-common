@isTest
private without sharing class SobjectListValidatorTest
{
    @isTest
    private static void validate_whenCalled_willGetValidatorsAndCheckTheRecords() // NOPMD: Test method name format
    {
        Amoss_Instance rendererController = ApplicationMockRegistrar.registerMockMessageRenderer( MessageRendererEngine.SobjectMessageAdder.class );
        List<Amoss_Instance> validatorControllers = ApplicationMockRegistrar.registerMockSobjectValidators( Contact.sobjectType, 3 );

        List<Contact> sobjectsToValidate = new List<Contact>{
            new Contact(),
            new Contact(),
            new Contact()
        };

        // In normal operation, the validation exception would contain MessageDetail records that tie
        // it to the right Sobject.  That's not needed to test the list validator
        ortoo_Exception validationException = new ortoo_Exception( 'The validation exception' );

        // One of the validators will throw an exception
        // Only that exception will be sent to the message renderer
        validatorControllers[0]
            .expects( 'validate' );

        validatorControllers[1]
            .expects( 'validate' )
            .throwing( validationException );

        validatorControllers[2]
            .expects( 'validate' );

        // This expectation depends on the behaviour of factory and MessageRendererEngine.render
        rendererController
            .expects( 'render' )
                .withParameter( validationException )
                .returning( true );

        Test.startTest();
            new SobjectListValidator( sobjectsToValidate ).validate();
        Test.stopTest();

        validatorControllers[0].verify();
        validatorControllers[1].verify();
        validatorControllers[2].verify();

        rendererController.verify();
    }

    @isTest
    private static void constructor_whenPassedANullList_willThrowAnException() // NOPMD: Test method name format
    {
        Test.startTest();
            String exceptionMessage;
            try
            {
                new SobjectListValidator( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'SobjectListValidator instantiated with a null records', exceptionMessage, 'constructor, when passed a null records, will throw an exception' );
    }
}