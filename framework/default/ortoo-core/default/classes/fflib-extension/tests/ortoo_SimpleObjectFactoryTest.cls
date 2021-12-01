@isTest
private without sharing class ortoo_SimpleObjectFactoryTest
{
    private static Map<Type,Type> NO_MAPPINGS = new Map<Type,Type>();

    @isTest
    private static void newInstance_whenCalledWithARegisteredType_willReturnTheMappedType() // NOPMD: Test method name format
    {
        Map<Type,Type> implementationByType = new Map<Type,Type>{
            Object.class => RegisterableType.class
        };

        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( implementationByType );

        Test.startTest();
            Object returnedInstance = factory.newInstance( Object.class );
        Test.stopTest();

        System.assertNotEquals( null, returnedInstance, 'newInstance, when called with a registered type, will return an instance' );
        System.assert( returnedInstance instanceOf RegisterableType, 'newInstance, when called with a registered type, will return an instance of the mapped type' );
    }

    @isTest
    private static void newInstance_whenCalledWithATypeThatCannotBeConstructed_willThrowAnException() // NOPMD: Test method name format
    {

        Map<Type,Type> implementationByType = new Map<Type,Type>{
            Object.class => NonConstructableType.class
        };

        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( implementationByType );

        Test.startTest();
            String exceptionMessage;
            try
            {
                factory.newInstance( Object.class );
            }
            catch ( Exceptions.DeveloperException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'NonConstructableType does not have parameterless constructor', exceptionMessage, 'newInstance, when called with a type that cannot be constructed, will throw an exception' );
    }

    @isTest
    private static void newInstance_whenSetToAllowUnmappedAndNoMappingsSetUp_willReturnAnInstance() // NOPMD: Test method name format
    {
        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( NO_MAPPINGS );

        Test.startTest();
            factory.setErrorOnUnmappedType( false );
            Object returnedInstance = factory.newInstance( RegisterableType.class );
        Test.stopTest();

        System.assertNotEquals( null, returnedInstance, 'newInstance, when set to allow unmapped and no mappings exist, will return an instance' );
        System.assert( returnedInstance instanceOf RegisterableType, 'newInstance, when set to allow unmapped and no mappings exist, will return an instance of the requested type' );
    }

    @isTest
    private static void newInstance_whenSetToAllowUnmappedAndCalledWithAnUnmapped_willReturnAnInstance() // NOPMD: Test method name format
    {
        Map<Type,Type> implementationByType = new Map<Type,Type>{
            Object.class => Object.class
        };

        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( implementationByType );

        Test.startTest();
            factory.setErrorOnUnmappedType( false );
            Object returnedInstance = factory.newInstance( RegisterableType.class );
        Test.stopTest();

        System.assertNotEquals( null, returnedInstance, 'newInstance, when set to allow unmapped and then called with an unmapped type, will return an instance' );
        System.assert( returnedInstance instanceOf RegisterableType, 'newInstance, when set to allow unmapped and then called with an unmapped type, will return an instance of the requested type' );
    }

    @isTest
    private static void newInstance_whenAMockIsSetOnAnAllowedUnmappedTypeAndNewInstanceCalled_willReturnTheMock() // NOPMD: Test method name format
    {
        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( NO_MAPPINGS );
        factory.setErrorOnUnmappedType( false );

        RegisterableType mockInstance = new RegisterableType( 'mockone' );

        Test.startTest();
            factory.setMock( RegisterableType.class, mockInstance );
            Object returnedInstance = factory.newInstance( RegisterableType.class );
        Test.stopTest();

        System.assertEquals( mockInstance, returnedInstance, 'newInstance, when a mock is set on an unmapped type, and newInstance called, will return the Mock' );
    }

    @isTest
    private static void newInstance_whenSetToNotAllowUnmappedAndCalledWithAnUnmapped_willThrowAnException() // NOPMD: Test method name format
    {
        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( NO_MAPPINGS );

        Test.startTest();

            factory.setErrorOnUnmappedType( true );

            String exceptionMessage;
            try
            {
                factory.newInstance( RegisterableType.class );
            }
            catch ( Exceptions.DeveloperException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'No implementation registered for', exceptionMessage, 'newInstance, when set to not allow unmapped, and called with an unmapped, will throw an exception' );
    }

    @isTest
    private static void newInstance_whenAMockIsSetOnAnNotAllowedUnmappedTypeAndNewInstanceCalled_willNotThrowAnException() // NOPMD: Test method name format
    {
        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( NO_MAPPINGS );
        RegisterableType mockInstance = new RegisterableType( 'mockone' );

        Test.startTest();

            factory.setErrorOnUnmappedType( true );
            factory.setMock( RegisterableType.class, mockInstance );

            RegisterableType returnedType = (RegisterableType)factory.newInstance( RegisterableType.class );

        Test.stopTest();

        System.assertNotEquals( null, returnedType, 'newInstance, when a mock is set on an unmapped type, unmapped types are not allowed, and newInstance called, will not throw an exception' );
    }

    @isTest
    private static void setTypeName_whenAnErrorOccurs_willSetTheNameOfTheTypeInTheMessage() // NOPMD: Test method name format
    {
        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( NO_MAPPINGS );

        Test.startTest();

            factory.setErrorOnUnmappedType( true );
            factory.setTypeName( 'thingy' );

            String exceptionMessage;
            try
            {
                factory.newInstance( RegisterableType.class );
            }
            catch ( Exceptions.DeveloperException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'No implementation registered for thingy', exceptionMessage, 'setTypeName, when an error occurs, will set the name of the type in the message' );
    }

    @isTest
    private static void setTypeName_whenCalledWithNull_willThrowAnException() // NOPMD: Test method name format
    {
        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( new Map<Type,Type>() );

        Test.startTest();
            String exceptionMessage;
            try
            {
                factory.setTypeName( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'setTypeName called with a null typeName', exceptionMessage, 'setTypeName, when called with null, will throw an exception' );
    }

    @isTest
    private static void newInstance_whenCalledWithNull_willThrowAnException() // NOPMD: Test method name format
    {
        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( new Map<Type,Type>() );

        Test.startTest();
            String exceptionMessage;
            try
            {
                factory.newInstance( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'newInstance called with a null requestedType', exceptionMessage, 'newInstance, when called with null, will throw an exception' );
    }

    @isTest
    private static void setErrorOnUnmappedType_whenCalledWithNull_willThrowAnException() // NOPMD: Test method name format
    {
        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( new Map<Type,Type>() );

        Test.startTest();
            String exceptionMessage;
            try
            {
                factory.setErrorOnUnmappedType( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'setErrorOnUnmappedType called with a null errorOnUnmappedType', exceptionMessage, 'setErrorOnUnmappedType, when called with null, will throw an exception' );
    }

    @isTest
    private static void constructor_whenCalledWithNull_willThrowAnException() // NOPMD: Test method name format
    {
        Test.startTest();
            String exceptionMessage;
            try
            {
                ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'ortoo_SimpleObjectFactory instantiated with a null implementationByType', exceptionMessage, 'constructor, when called with null, will throw an exception' );
    }

    private without sharing class RegisterableType
    {
        String name;
        public RegisterableType()
        {
            this( 'realOne' );
        }

        public RegisterableType( String name )
        {
            this.name = name;
        }
    }

    private without sharing class NonConstructableType
    {
        String name;
        public NonConstructableType( String name )
        {
            this.name = name;
        }
    }
}