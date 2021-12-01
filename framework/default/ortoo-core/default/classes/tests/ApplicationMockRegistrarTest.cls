@isTest
private without sharing class ApplicationMockRegistrarTest
{
    @isTest
    private static void registerMockService_whenGivenAServiceType_willGenerateAMockAndReturnIt() // NOPMD: Test method name format
    {
        Test.startTest();
            Amoss_Instance mockController = ApplicationMockRegistrar.registerMockService( SetUtils.class ); // yes, this isn't a valid service, but it serves for the test
        Test.stopTest();

        System.assertEquals( mockController.getDouble(), Application.SERVICE.newInstance( SetUtils.class ), 'registerMockService, when given an object, will register is as a mock service so that its double is returned for that type' );
    }

    @isTest
    private static void registerMockDomain_whenGivenAnSobjectThatIsRegistered_willGenerateAMockAndReturnIt() // NOPMD: Test method name format
    {
        Application.DOMAIN = new ortoo_DomainFactory(
            null,
            new Map<SobjectType,Type>
            {
                Contact.SobjectType => fflib_ISObjectDomain.class
            }
        );

        Test.startTest();
            Amoss_Instance mockController = ApplicationMockRegistrar.registerMockDomain( Contact.sobjectType );
        Test.stopTest();

        System.assertEquals( mockController.getDouble(), Application.DOMAIN.newInstance( new List<Contact>{ new Contact() } ), 'registerMockDomain, when given an sobject type that is registered, will register is as a mock selector so that its double is returned for that sobject type' );
        System.assert( mockController.getDouble() instanceOf fflib_ISObjectDomain, 'registerMockDomain, when given an sobject type that is registered, will register is as a selector of the registered type' );
    }

    @isTest
    private static void registerMockDomain_whenGivenAnSobjectThatIsNotRegistered_willGenerateAGenericMockAndReturnIt() // NOPMD: Test method name format
    {
        Application.DOMAIN = new ortoo_DomainFactory( null, new Map<SobjectType,Type>() );

        Test.startTest();
            Amoss_Instance mockController = ApplicationMockRegistrar.registerMockDomain( Contact.sobjectType );
        Test.stopTest();

        System.assertEquals( mockController.getDouble(), Application.DOMAIN.newInstance( new List<Contact>{ new Contact() } ), 'registerMockDomain, when given an sobject type that is not registered, will register is as a mock selector so that its double is returned for that sobject type' );
        System.assert( mockController.getDouble() instanceOf fflib_ISObjectDomain, 'registerMockDomain, when given an sobject type that is not registered, will register is as a generic selector' );
    }

    @isTest
    private static void registerMockSelector_whenGivenAnSobjectThatIsRegistered_willGenerateAMockAndReturnIt() // NOPMD: Test method name format
    {
        Application.SELECTOR = new ortoo_SelectorFactory(
            new Map<SobjectType,Type>
            {
                Contact.SobjectType => fflib_ISObjectSelector.class
            }
        );

        Test.startTest();
            Amoss_Instance mockController = ApplicationMockRegistrar.registerMockSelector( Contact.sobjectType );
        Test.stopTest();

        System.assertEquals( mockController.getDouble(), Application.SELECTOR.newInstance( Contact.sobjectType ), 'registerMockSelector, when given an sobject type that is registered, will register is as a mock selector so that its double is returned for that sobject type' );
        System.assert( mockController.getDouble() instanceOf fflib_ISObjectSelector, 'registerMockSelector, when given an sobject type that is registered, will register is as a selector of the registered type' );
    }

    @isTest
    private static void registerMockSelector_whenGivenAnSobjectThatIsNotRegistered_willGenerateAGenericMockAndReturnIt() // NOPMD: Test method name format
    {
        Application.SELECTOR = new ortoo_SelectorFactory( new Map<SobjectType,Type>() );

        Test.startTest();
            Amoss_Instance mockController = ApplicationMockRegistrar.registerMockSelector( Contact.sobjectType );
        Test.stopTest();

        System.assertEquals( mockController.getDouble(), Application.SELECTOR.newInstance( Contact.sobjectType ), 'registerMockSelector, when given an sobject type that is not registered, will register is as a mock selector so that its double is returned for that sobject type' );
        System.assert( mockController.getDouble() instanceOf fflib_ISObjectSelector, 'registerMockSelector, when given an sobject type that is not registered, will register is as a generic selector' );
    }

    @isTest
    private static void registerMockSobjectValidator_whenGivenAnSobjectThatIsRegistered_willGenerateAMockAndReturnIt() // NOPMD: Test method name format
    {
        Application.VALIDATOR = new ortoo_SobjectValidatorFactory(
            new Map<SobjectType,Type>
            {
                Contact.SobjectType => ISobjectValidator.class
            }
        );

        Test.startTest();
            Amoss_Instance mockController = ApplicationMockRegistrar.registerMockSobjectValidator( Contact.sobjectType );
        Test.stopTest();

        System.assertEquals( mockController.getDouble(), Application.VALIDATOR.newInstance( new Contact() ), 'registerMockSobjectValidator, when given an sobject type that is registered, will register is as a mock validator so that its double is returned for that sobject type' );
    }

    @isTest
    private static void registerMockSobjectValidator_whenGivenAnSobjectThatIsNotRegistered_willGenerateAGenericMockAndReturnIt() // NOPMD: Test method name format
    {
        Application.VALIDATOR = new ortoo_SobjectValidatorFactory( new Map<SobjectType,Type>() );
        Amoss_Instance mockController = ApplicationMockRegistrar.registerMockSobjectValidator( Contact.sobjectType );

        System.assertEquals( mockController.getDouble(), Application.VALIDATOR.newInstance( new Contact() ), 'registerMockSobjectValidator, when given an sobject type that is not registered, will register is as a gneric mock validator so that its double is returned for that sobject type' );
    }

    @isTest
    private static void registerMockSobjectValidator_whenGivenAOfSobjectThatIsRegisteredAndAnInteger_willGenerateTheNumberOfMocksAndReturnThem() // NOPMD: Test method name format
    {
        Application.VALIDATOR = new ortoo_SobjectValidatorFactory(
            new Map<SobjectType,Type>
            {
                Contact.SobjectType => ISobjectValidator.class
            }
        );

        Test.startTest();
            List<Amoss_Instance> mockControllers = ApplicationMockRegistrar.registerMockSobjectValidators( Contact.sobjectType, 3 );
        Test.stopTest();

        System.assertEquals( 3, mockControllers.size(), 'registerMockSobjectValidator, when given an sobject type that is registered and a number, will register that number of mock validators so that a list of doubles are returned for that sobject type' );

        List<Object> returnedValidators = Application.VALIDATOR.newInstance( new List<Contact>{ new Contact() } );

        System.assertEquals( mockControllers[0].getDouble(), returnedValidators[0], 'registerMockSobjectValidator, when given an sobject type that is registered and a number, will register that number of mock validators so that a list of doubles are returned for that sobject type, checking validator 0' );
        System.assertEquals( mockControllers[1].getDouble(), returnedValidators[1], 'registerMockSobjectValidator, when given an sobject type that is registered and a number, will register that number of mock validators so that a list of doubles are returned for that sobject type, checking validator 1' );
        System.assertEquals( mockControllers[2].getDouble(), returnedValidators[2], 'registerMockSobjectValidator, when given an sobject type that is registered and a number, will register that number of mock validators so that a list of doubles are returned for that sobject type, checking validator 2' );
    }

    @isTest
    private static void registerMockSobjectValidator_whenGivenAOfSobjectThatIsNotRegisteredAndAnInteger_willGenerateTheNumberOfMocksAndReturnThem() // NOPMD: Test method name format
    {
        Application.VALIDATOR = new ortoo_SobjectValidatorFactory( new Map<SobjectType,Type>() );

        Test.startTest();
            List<Amoss_Instance> mockControllers = ApplicationMockRegistrar.registerMockSobjectValidators( Contact.sobjectType, 3 );
        Test.stopTest();

        System.assertEquals( 3, mockControllers.size(), 'registerMockSobjectValidator, when given an sobject type that is not registered and a number, will register that number of mock validators so that a list of doubles are returned for that sobject type' );

        List<Object> returnedValidators = Application.VALIDATOR.newInstance( new List<Contact>{ new Contact() } );

        System.assertEquals( mockControllers[0].getDouble(), returnedValidators[0], 'registerMockSobjectValidator, when given an sobject type that is registered not and a number, will register that number of mock validators so that a list of doubles are returned for that sobject type, checking validator 0' );
        System.assertEquals( mockControllers[1].getDouble(), returnedValidators[1], 'registerMockSobjectValidator, when given an sobject type that is registered not and a number, will register that number of mock validators so that a list of doubles are returned for that sobject type, checking validator 1' );
        System.assertEquals( mockControllers[2].getDouble(), returnedValidators[2], 'registerMockSobjectValidator, when given an sobject type that is registered not and a number, will register that number of mock validators so that a list of doubles are returned for that sobject type, checking validator 2' );
    }

    @isTest
    private static void registerMockChildRecordFinder_whenGivenAChildFinderType_willGenerateAMockAndReturnIt() // NOPMD: Test method name format
    {
        Test.startTest();
            Amoss_Instance mockController = ApplicationMockRegistrar.registerMockChildRecordFinder( SetUtils.class ); // yes, this isn't a valid finder, but it serves for the test
        Test.stopTest();

        System.assertEquals( mockController.getDouble(), Application.CHILD_RECORD_FINDER.newInstance( SetUtils.class ), 'registerMockChildRecordFinder, when given an object, will register is as a mock finder so that its double is returned for that type' );
    }

    @isTest
    private static void registerMockAppLogic_whenGivenAnObject_willGenerateAMockAndReturnIt() // NOPMD: Test method name format
    {
        Test.startTest();
            Amoss_Instance mockController = ApplicationMockRegistrar.registerMockAppLogic( SetUtils.class ); // yes, this isn't a valid finder, but it serves for the test
        Test.stopTest();

        System.assertEquals( mockController.getDouble(), Application.APP_LOGIC.newInstance( SetUtils.class ), 'registerMockAppLogic, when given an object, will register is as a mock app logic class so that its double is returned for that type' );
    }

    @isTest
    private static void registerMockMessageRenderer_whenGivenAType_willGenerateAMockAndReturnIt() // NOPMD: Test method name format
    {
        Test.startTest();
            Amoss_Instance mockController = ApplicationMockRegistrar.registerMockMessageRenderer( SetUtils.class ); // yes, this isn't a valid renderer, but it serves for the test
        Test.stopTest();

        ortoo_Exception e = new ortoo_Exception();
        MessageRendererEngine engine = Application.MESSAGE_RENDERER.newInstance( SetUtils.class, e );

        System.assertEquals( mockController.getDouble(), engine.getRenderer(), 'registerMockMessageRenderer, when given an object, will register is as a mock message renderer so that its double is used to construct the engine returned for that type' );
    }
}