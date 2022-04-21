@isTest
private without sharing class ortoo_SimpleObjectFactoryTest
{
    private static Map<Type,Type> NO_TYPE_MAPPINGS = new Map<Type,Type>();
    private static Map<String,String> NO_STRING_MAPPINGS = new Map<String,String>();

    @isTest
    private static void newInstance_whenCalledWithARegisteredTypeViaType_willReturnTheMappedType() // NOPMD: Test method name format
    {
        Map<Type,Type> implementationByType = new Map<Type,Type>{
            ClassToRetrieveVia.class => RegisterableType.class
        };

        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( implementationByType );

        Test.startTest();
            Object returnedInstance = factory.newInstance( ClassToRetrieveVia.class );
        Test.stopTest();

        System.assertNotEquals( null, returnedInstance, 'newInstance, when called with a registered type, will return an instance' );
        System.assert( returnedInstance instanceOf RegisterableType, 'newInstance, when called with a registered type, will return an instance of the mapped type' );
    }

    @isTest
    private static void newInstance_whenCalledWithARegisteredTypeViaString_willReturnTheMappedType() // NOPMD: Test method name format
    {
        Map<String,String> implementationNameByTypeName = new Map<String,String>{
            'ortoo_SimpleObjectFactoryTest.ClassToRetrieveVia' => 'ortoo_SimpleObjectFactoryTest.RegisterableType'
        };

        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( implementationNameByTypeName );

        Test.startTest();
            Object returnedInstance = factory.newInstance( ClassToRetrieveVia.class );
        Test.stopTest();

        System.assertNotEquals( null, returnedInstance, 'newInstance, when called with a registered type, will return an instance' );
        System.assert( returnedInstance instanceOf RegisterableType, 'newInstance, when called with a registered type, will return an instance of the mapped type' );
    }

    @isTest
    private static void newInstance_whenCalledWithATypeViaTypeThatCannotBeConstructed_throwsException() // NOPMD: Test method name format
    {

        Map<Type,Type> implementationByType = new Map<Type,Type>{
            ClassToRetrieveVia.class => NonConstructableType.class
        };

        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( implementationByType );

        Test.startTest();
            String exceptionMessage;
            try
            {
                factory.newInstance( ClassToRetrieveVia.class );
            }
            catch ( Exceptions.DeveloperException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'NonConstructableType does not have parameterless constructor', exceptionMessage, 'newInstance, when called with a type that cannot be constructed, will throw an exception' );
    }

    @isTest
    private static void newInstance_whenCalledWithATypeViaStringThatCannotBeConstructed_throwsException() // NOPMD: Test method name format
    {
        Map<String,String> implementationNameByTypeName = new Map<String,String>{
            'ortoo_SimpleObjectFactoryTest.ClassToRetrieveVia' => 'ortoo_SimpleObjectFactoryTest.NonConstructableType'
        };

        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( implementationNameByTypeName );

        Test.startTest();
            String exceptionMessage;
            try
            {
                factory.newInstance( ClassToRetrieveVia.class );
            }
            catch ( Exceptions.DeveloperException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'NonConstructableType does not have parameterless constructor', exceptionMessage, 'newInstance, when called with a type that cannot be constructed, will throw an exception' );
    }

    @isTest
    private static void newInstance_whenCalledWithATypeViaStringThatisInvalid_throwsException() // NOPMD: Test method name format
    {

        Map<String,String> implementationNameByTypeName = new Map<String,String>{
            'ortoo_SimpleObjectFactoryTest.ClassToRetrieveVia' => 'NotAValidClass'
        };

        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( implementationNameByTypeName );

        Test.startTest();
            String exceptionMessage;
            try
            {
                factory.newInstance( ClassToRetrieveVia.class );
            }
            catch ( Exceptions.DeveloperException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'Invalid implementation registered for Unknown ortoo_SimpleObjectFactoryTest.ClassToRetrieveVia: NotAValidClass does not exist, or is not visible', exceptionMessage, 'newInstance, when called with a type that has an invalid type, will throw an exception' );
    }

    @isTest
    private static void newInstance_whenSetToAllowUnmappedAndNoMappingsSetUpViaType_willReturnAnInstance() // NOPMD: Test method name format
    {
        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( NO_TYPE_MAPPINGS );

        Test.startTest();
            factory.setErrorOnUnmappedType( false );
            Object returnedInstance = factory.newInstance( RegisterableType.class );
        Test.stopTest();

        System.assertNotEquals( null, returnedInstance, 'newInstance, when set to allow unmapped and no mappings exist, will return an instance' );
        System.assert( returnedInstance instanceOf RegisterableType, 'newInstance, when set to allow unmapped and no mappings exist, will return an instance of the requested type' );
    }

    @isTest
    private static void newInstance_whenSetToAllowUnmappedAndNoMappingsSetUpViaString_willReturnAnInstance() // NOPMD: Test method name format
    {
        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( NO_STRING_MAPPINGS );

        Test.startTest();
            factory.setErrorOnUnmappedType( false );
            Object returnedInstance = factory.newInstance( RegisterableType.class );
        Test.stopTest();

        System.assertNotEquals( null, returnedInstance, 'newInstance, when set to allow unmapped and no mappings exist, will return an instance' );
        System.assert( returnedInstance instanceOf RegisterableType, 'newInstance, when set to allow unmapped and no mappings exist, will return an instance of the requested type' );
    }

    @isTest
    private static void newInstance_whenSetToAllowUnmappedAndCalledWithAnUnmappedViaType_willReturnAnInstance() // NOPMD: Test method name format
    {
        Map<Type,Type> implementationByType = new Map<Type,Type>{
            ClassToRetrieveVia.class => ClassToRetrieveVia.class
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
    private static void newInstance_whenSetToAllowUnmappedAndCalledWithAnUnmappedViaString_willReturnAnInstance() // NOPMD: Test method name format
    {
        Map<String,String> implementationNameByTypeName = new Map<String,String>{
            'ortoo_SimpleObjectFactoryTest.ClassToRetrieveVia' => 'ortoo_SimpleObjectFactoryTest.ClassToRetrieveVia'
        };

        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( implementationNameByTypeName );

        Test.startTest();
            factory.setErrorOnUnmappedType( false );
            Object returnedInstance = factory.newInstance( RegisterableType.class );
        Test.stopTest();

        System.assertNotEquals( null, returnedInstance, 'newInstance, when set to allow unmapped and then called with an unmapped type, will return an instance' );
        System.assert( returnedInstance instanceOf RegisterableType, 'newInstance, when set to allow unmapped and then called with an unmapped type, will return an instance of the requested type' );
    }

    @isTest
    private static void newInstance_whenAMockIsSetOnAnAllowedUnmappedTypeViaTypeAndNewInstanceCalled_willReturnTheMock() // NOPMD: Test method name format
    {
        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( NO_TYPE_MAPPINGS );
        factory.setErrorOnUnmappedType( false );

        RegisterableType mockInstance = new RegisterableType( 'mockone' );

        Test.startTest();
            factory.setMock( RegisterableType.class, mockInstance );
            Object returnedInstance = factory.newInstance( RegisterableType.class );
        Test.stopTest();

        System.assertEquals( mockInstance, returnedInstance, 'newInstance, when a mock is set on an unmapped type, and newInstance called, will return the Mock' );
    }

    @isTest
    private static void newInstance_whenAMockIsSetOnAnAllowedUnmappedTypeViaStringAndNewInstanceCalled_willReturnTheMock() // NOPMD: Test method name format
    {
        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( NO_STRING_MAPPINGS );
        factory.setErrorOnUnmappedType( false );

        RegisterableType mockInstance = new RegisterableType( 'mockone' );

        Test.startTest();
            factory.setMock( RegisterableType.class, mockInstance );
            Object returnedInstance = factory.newInstance( RegisterableType.class );
        Test.stopTest();

        System.assertEquals( mockInstance, returnedInstance, 'newInstance, when a mock is set on an unmapped type, and newInstance called, will return the Mock' );
    }

    @isTest
    private static void newInstance_whenSetToNotAllowUnmappedViaTypeAndCalledWithAnUnmapped_throwsException() // NOPMD: Test method name format
    {
        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( NO_TYPE_MAPPINGS );

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

        ortoo_Asserts.assertContains( 'No implementation registered for', exceptionMessage, 'newInstance, when set to not allow unmapped, and called with an unmapped, will throw an exception' );
    }

    @isTest
    private static void newInstance_whenSetToNotAllowUnmappedViaStringAndCalledWithAnUnmapped_throwsException() // NOPMD: Test method name format
    {
        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( NO_STRING_MAPPINGS );

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

        ortoo_Asserts.assertContains( 'No implementation registered for', exceptionMessage, 'newInstance, when set to not allow unmapped, and called with an unmapped, will throw an exception' );
    }

    @isTest
    private static void newInstance_whenAMockIsSetOnAnNotAllowedUnmappedTypeViaTypeAndNewInstanceCalled_noException() // NOPMD: Test method name format
    {
        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( NO_TYPE_MAPPINGS );
        RegisterableType mockInstance = new RegisterableType( 'mockone' );

        Test.startTest();

            factory.setErrorOnUnmappedType( true );
            factory.setMock( RegisterableType.class, mockInstance );

            RegisterableType returnedType = (RegisterableType)factory.newInstance( RegisterableType.class );

        Test.stopTest();

        System.assertNotEquals( null, returnedType, 'newInstance, when a mock is set on an unmapped type, unmapped types are not allowed, and newInstance called, will not throw an exception' );
    }

    @isTest
    private static void newInstance_whenAMockIsSetOnAnNotAllowedUnmappedTypeViaStringAndNewInstanceCalled_noException() // NOPMD: Test method name format
    {
        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( NO_STRING_MAPPINGS );
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
        ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( NO_TYPE_MAPPINGS );

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

        ortoo_Asserts.assertContains( 'No implementation registered for thingy', exceptionMessage, 'setTypeName, when an error occurs, will set the name of the type in the message' );
    }

    @isTest
    private static void setTypeName_whenCalledWithNull_throwsException() // NOPMD: Test method name format
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

        ortoo_Asserts.assertContains( 'setTypeName called with a null typeName', exceptionMessage, 'setTypeName, when called with null, will throw an exception' );
    }

    @isTest
    private static void newInstance_whenCalledWithNull_throwsException() // NOPMD: Test method name format
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

        ortoo_Asserts.assertContains( 'newInstance called with a null requestedType', exceptionMessage, 'newInstance, when called with null, will throw an exception' );
    }

    @isTest
    private static void setErrorOnUnmappedType_whenCalledWithNull_throwsException() // NOPMD: Test method name format
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

        ortoo_Asserts.assertContains( 'setErrorOnUnmappedType called with a null errorOnUnmappedType', exceptionMessage, 'setErrorOnUnmappedType, when called with null, will throw an exception' );
    }

    @isTest
    private static void constructor_Type_whenCalledWithNull_throwsException() // NOPMD: Test method name format
    {
		Map<Type,Type> nullMapping = null;
        Test.startTest();
            String exceptionMessage;
            try
            {
                ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( nullMapping );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'ortoo_SimpleObjectFactory instantiated with a null implementationByType', exceptionMessage, 'constructor, when called with null, will throw an exception' );
    }

    @isTest
    private static void constructor_String_whenCalledWithNull_throwsException() // NOPMD: Test method name format
    {
		Map<String,String> nullMapping = null;
        Test.startTest();
            String exceptionMessage;
            try
            {
                ortoo_SimpleObjectFactory factory = new ortoo_SimpleObjectFactory( nullMapping );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'ortoo_SimpleObjectFactory instantiated with a null implementationNameByTypeName', exceptionMessage, 'constructor with types, when called with null, will throw an exception' );
    }

    public without sharing class ClassToRetrieveVia {}

    public without sharing class RegisterableType
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

    public without sharing class NonConstructableType
    {
        String name;
        public NonConstructableType( String name )
        {
            this.name = name;
        }
    }
}