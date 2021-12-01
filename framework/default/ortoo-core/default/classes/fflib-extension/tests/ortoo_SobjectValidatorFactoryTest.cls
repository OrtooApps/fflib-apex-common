@isTest
private without sharing class ortoo_SobjectValidatorFactoryTest
{
	private static Map<SobjectType,Type> NO_MAPPINGS = new Map<SobjectType,Type>();

	@isTest
	private static void newInstance_whenCalledWithARegisteredType_willReturnTheMappedType() // NOPMD: Test method name format
	{
		Map<SobjectType,Type> implementationByType = new Map<SobjectType,Type>{
			Contact.sobjectType => RegisterableType.class
		};

		ortoo_SobjectValidatorFactory factory = new ortoo_SobjectValidatorFactory( implementationByType );

		Test.startTest();
			Object returnedInstance = factory.newInstance( new Contact() );
		Test.stopTest();

		System.assertNotEquals( null, returnedInstance, 'newInstance, when called with a registered type, will return an instance' );
		System.assert( returnedInstance instanceOf RegisterableType, 'newInstance, when called with a registered type, will return an instance of the mapped type' );
	}

	@isTest
	private static void newInstance_whenCalledWithATypeThatCannotBeConstructed_willThrowAnException() // NOPMD: Test method name format
	{
		Map<SobjectType,Type> implementationByType = new Map<SobjectType,Type>{
			Contact.sobjectType => NonConstructableType.class
		};

		ortoo_SobjectValidatorFactory factory = new ortoo_SobjectValidatorFactory( implementationByType );

		Test.startTest();
			String exceptionMessage;
			try
			{
				factory.newInstance( new Contact() );
			}
			catch ( Exceptions.DeveloperException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'NonConstructableType does not have parameterless constructor', exceptionMessage, 'newInstance, when called with a type that cannot be constructed, will throw an exception' );
	}

	@isTest
	private static void newInstance_whenCalledWithATypeOfTheWrongInterface_willThrowAnException() // NOPMD: Test method name format
	{
		Map<SobjectType,Type> implementationByType = new Map<SobjectType,Type>{
			Contact.sobjectType => NonRegisterableType.class
		};

		ortoo_SobjectValidatorFactory factory = new ortoo_SobjectValidatorFactory( implementationByType );

		Test.startTest();
			String exceptionMessage;
			try
			{
				factory.newInstance( new Contact() );
			}
			catch ( Exceptions.DeveloperException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'ortoo_SobjectValidatorFactoryTest.NonRegisterableType is not an implementation of ISobjectValidator', exceptionMessage, 'newInstance, when called with a type that cannot be constructed, will throw an exception' );
	}

	@isTest
	private static void newInstance_whenCalledWithAnUnmappedType_willThrowAnException() // NOPMD: Test method name format
	{
		Map<SobjectType,Type> implementationByType = new Map<SobjectType,Type>{
			Contact.sobjectType => NonConstructableType.class
		};

		ortoo_SobjectValidatorFactory factory = new ortoo_SobjectValidatorFactory( implementationByType );

		Test.startTest();

			String exceptionMessage;
			try
			{
				factory.newInstance( new Account() );
			}
			catch ( Exceptions.DeveloperException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'No implementation registered for', exceptionMessage, 'newInstance, when called with an unmapped, will throw an exception' );
	}

	@isTest
	private static void newInstance_whenAMockIsSetOnAnUnmappedType_willReturnTheMock() // NOPMD: Test method name format
	{
		ortoo_SobjectValidatorFactory factory = new ortoo_SobjectValidatorFactory( NO_MAPPINGS );

		RegisterableType mockInstance = new RegisterableType();

		Test.startTest();
			factory.setMock( Contact.sobjectType, mockInstance );
			Object returnedInstance = factory.newInstance( new Contact() );
		Test.stopTest();

		System.assertEquals( mockInstance, returnedInstance, 'newInstance, when a mock is set on an unmapped type, and newInstance called, will return the Mock' );
	}

	@isTest
	private static void newInstance_whenAMockIsSetOnAnMappedType_willReturnTheMock() // NOPMD: Test method name format
	{
		Map<SobjectType,Type> implementationByType = new Map<SobjectType,Type>{
			Contact.sobjectType => NonConstructableType.class
		};

		ortoo_SobjectValidatorFactory factory = new ortoo_SobjectValidatorFactory( implementationByType );

		RegisterableType mockInstance = new RegisterableType();

		Test.startTest();
			factory.setMock( Contact.sobjectType, mockInstance );
			Object returnedInstance = factory.newInstance( new Contact() );
		Test.stopTest();

		System.assertEquals( mockInstance, returnedInstance, 'newInstance, when a mock is set on an mapped type, and newInstance called, will return the Mock' );
	}

    @isTest
    private static void newInstance_whenCalledWithNull_willThrowAnException() // NOPMD: Test method name format
    {
        ortoo_SobjectValidatorFactory factory = new ortoo_SobjectValidatorFactory( new Map<SobjectType,Type>() );

		Sobject nullObject = null;

        Test.startTest();
            String exceptionMessage;
            try
            {
                factory.newInstance( nullObject );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'newInstance called with a null sobjectToValidate', exceptionMessage, 'newInstance, when called with null, will throw an exception' );
    }

	@isTest
	private static void newInstance_List_whenCalledWithARegisteredType_willReturnAListOfTheMappedType() // NOPMD: Test method name format
	{
		Map<SobjectType,Type> implementationByType = new Map<SobjectType,Type>{
			Contact.sobjectType => RegisterableType.class
		};

		ortoo_SobjectValidatorFactory factory = new ortoo_SobjectValidatorFactory( implementationByType );

		Test.startTest();
			List<Object> returnedInstance = factory.newInstance( new List<Contact>{ new Contact() } );
		Test.stopTest();

		System.assertNotEquals( null, returnedInstance, 'newInstance, when called with a registered type, will return an instance' );
		System.assert( returnedInstance[0] instanceOf RegisterableType, 'newInstance, when called with a registered type, will return a list of instances of the mapped type' );
	}

	@isTest
	private static void newInstance_List_whenCalledWithATypeThatCannotBeConstructed_willThrowAnException() // NOPMD: Test method name format
	{
		Map<SobjectType,Type> implementationByType = new Map<SobjectType,Type>{
			Contact.sobjectType => NonConstructableType.class
		};

		ortoo_SobjectValidatorFactory factory = new ortoo_SobjectValidatorFactory( implementationByType );

		Test.startTest();
			String exceptionMessage;
			try
			{
				factory.newInstance( new List<Contact>{ new Contact() } );
			}
			catch ( Exceptions.DeveloperException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'NonConstructableType does not have parameterless constructor', exceptionMessage, 'newInstance, when called with a type that cannot be constructed, will throw an exception' );
	}

	@isTest
	private static void newInstance_List_whenCalledWithATypeOfTheWrongInterface_willThrowAnException() // NOPMD: Test method name format
	{
		Map<SobjectType,Type> implementationByType = new Map<SobjectType,Type>{
			Contact.sobjectType => NonRegisterableType.class
		};

		ortoo_SobjectValidatorFactory factory = new ortoo_SobjectValidatorFactory( implementationByType );

		Test.startTest();
			String exceptionMessage;
			try
			{
				factory.newInstance( new List<Contact>{ new Contact() } );
			}
			catch ( Exceptions.DeveloperException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'ortoo_SobjectValidatorFactoryTest.NonRegisterableType is not an implementation of ISobjectValidator', exceptionMessage, 'newInstance, when called with a type that cannot be constructed, will throw an exception' );
	}

	@isTest
	private static void newInstance_List_whenCalledWithAnUnmappedType_willThrowAnException() // NOPMD: Test method name format
	{
		Map<SobjectType,Type> implementationByType = new Map<SobjectType,Type>{
			Contact.sobjectType => NonConstructableType.class
		};

		ortoo_SobjectValidatorFactory factory = new ortoo_SobjectValidatorFactory( implementationByType );

		Test.startTest();

			String exceptionMessage;
			try
			{
				factory.newInstance( new List<Account>{ new Account() } );
			}
			catch ( Exceptions.DeveloperException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'No implementation registered for', exceptionMessage, 'newInstance, when called with an unmapped, will throw an exception' );
	}

	@isTest
	private static void newInstance_List_whenAMockIsSetOnAnUnmappedType_willReturnTheMock() // NOPMD: Test method name format
	{
		ortoo_SobjectValidatorFactory factory = new ortoo_SobjectValidatorFactory( NO_MAPPINGS );

		List<ISobjectValidator> mockInstance = new List<ISobjectValidator>{ new RegisterableType() };

		Test.startTest();
			factory.setMock( Contact.sobjectType, mockInstance );
			Object returnedInstance = factory.newInstance( new List<Contact>{ new Contact() } );
		Test.stopTest();

		System.assertEquals( mockInstance, returnedInstance, 'newInstance, when a mock is set on an unmapped type, and newInstance called, will return the Mock' );
	}

	@isTest
	private static void newInstance_List_whenAMockIsSetOnAnMappedType_willReturnTheMock() // NOPMD: Test method name format
	{
		Map<SobjectType,Type> implementationByType = new Map<SobjectType,Type>{
			Contact.sobjectType => NonConstructableType.class
		};

		ortoo_SobjectValidatorFactory factory = new ortoo_SobjectValidatorFactory( implementationByType );

		List<ISobjectValidator> mockInstance = new List<ISobjectValidator>{ new RegisterableType() };

		Test.startTest();
			factory.setMock( Contact.sobjectType, mockInstance );
			Object returnedInstance = factory.newInstance( new List<Contact>{ new Contact() } );
		Test.stopTest();

		System.assertEquals( mockInstance, returnedInstance, 'newInstance, when a mock is set on an mapped type, and newInstance called, will return the Mock' );
	}

    @isTest
    private static void newInstance_List_whenCalledWithNull_willThrowAnException() // NOPMD: Test method name format
    {
		List<Sobject> nullList = null;

        ortoo_SobjectValidatorFactory factory = new ortoo_SobjectValidatorFactory( new Map<SobjectType,Type>() );

        Test.startTest();
            String exceptionMessage;
            try
            {
                factory.newInstance( nullList );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'newInstance called with a null sobjectsToValidate', exceptionMessage, 'newInstance, when called with null, will throw an exception' );
    }

    @isTest
    private static void constructor_whenCalledWithNull_willThrowAnException() // NOPMD: Test method name format
    {
        Test.startTest();
            String exceptionMessage;
            try
            {
                ortoo_SobjectValidatorFactory factory = new ortoo_SobjectValidatorFactory( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'ortoo_SobjectValidatorFactory instantiated with a null validatorBySobjectType', exceptionMessage, 'constructor, when called with null, will throw an exception' );
    }

	public without sharing class RegisterableType implements ISobjectValidator
	{
		public ISobjectValidator setSobject( Sobject thisSobjectToValidate )
		{
			return this;
		}
		public void validate() {} // NOPMD: Empty test implementation
	}

	public without sharing class NonRegisterableType {}

	public without sharing class NonConstructableType implements ISobjectValidator
	{
		String name;
		public NonConstructableType( String name )
		{
			this.name = name;
		}
		public ISobjectValidator setSobject( Sobject thisSobjectToValidate )
		{
			return this;
		}
		public void validate() {} // NOPMD: Empty test implementation
	}
}