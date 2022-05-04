@isTest
public inherited sharing class SearchConfigurationTest
{
	@isTest
	private static void constructor_whenPassedANullSobjectType_willThrowAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				new TestableSearchConfiguration( null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'constructor called with a null baseSobjectType', exceptionMessage, 'constructor, when passed a null baseSobjectType, will throw an exception' );
	}

	@isTest
	private static void getBaseSobjectType_whenCalled_returnsTheBaseType() // NOPMD: Test method name format
	{
		SearchConfiguration config = new TestableSearchConfiguration( Contact.SobjectType );

		Test.startTest();
			SobjectType got = config.getBaseSobjectType();
		Test.stopTest();

		System.assertEquals( Contact.SobjectType, got, 'getBaseSobjectType, when called, will return the base SObject type' );
	}

	@isTest
	private static void getSortableFields_whenMappingsAreConfigured_returnsTheResultFieldSideOfMapping() // NOPMD: Test method name format
	{
		SearchConfiguration config = new TestableSearchConfiguration( Contact.SobjectType );

		List<String> expected = new List<String>
		{
			'resultField1',
			'resultField2',
			'resultField3'
		};

		Test.startTest();
			List<String> got = config.getSortableFields();
		Test.stopTest();

		System.assertEquals( expected, got, 'getSortableFields, when field mappings are configured, will return the result field side of the mapping' );
	}

	@isTest
	private static void getSortableFields_whenNoMappingsAreConfigured_returnsAnEmptyList() // NOPMD: Test method name format
	{
		SearchConfiguration config = new EmptySearchConfiguration( Contact.SobjectType );

		List<String> expected = new List<String>();

		Test.startTest();
			List<String> got = config.getSortableFields();
		Test.stopTest();

		System.assertEquals( expected, got, 'getSortableFields, when no field mappings are configured, will return an empty list' );
	}

	@isTest
	private static void getRequiredFields_whenMappingsAreConfigured_returnsTheSobjectFieldSideOfMapping() // NOPMD: Test method name format
	{
		SearchConfiguration config = new TestableSearchConfiguration( Contact.SobjectType );

		List<String> expected = new List<String>
		{
			'sobjectField1',
			'sobjectField2',
			'sobjectField3'
		};

		Test.startTest();
			List<String> got = config.getRequiredFields();
		Test.stopTest();

		System.assertEquals( expected, got, 'getRequiredFields, when field mappings are configured, will return the sobject field side of the mapping' );
	}

	@isTest
	private static void getRequiredFields_whenNoMappingsAreConfigured_returnsAnEmptyList() // NOPMD: Test method name format
	{
		SearchConfiguration config = new EmptySearchConfiguration( Contact.SobjectType );

		List<String> expected = new List<String>();

		Test.startTest();
			List<String> got = config.getRequiredFields();
		Test.stopTest();

		System.assertEquals( expected, got, 'getRequiredFields, when no field mappings are configured, will return an empty list' );
	}

	@isTest
	private static void getMappedSobjectField_whenGivenAFieldThatIsMapped_returnsTheSObjectField() // NOPMD: Test method name format
	{
		SearchConfiguration config = new TestableSearchConfiguration( Contact.SobjectType );

		Test.startTest();
			String got = config.getMappedSobjectField( 'resultField2' );
		Test.stopTest();

		System.assertEquals( 'sobjectField2', got, 'getMappedSobjectField, when given a result field that is mapped, will return the SObject field' );
	}

	@isTest
	private static void getMappedSobjectField_whenGivenAFieldThatIsNotMapped_returnsNull() // NOPMD: Test method name format
	{
		SearchConfiguration config = new TestableSearchConfiguration( Contact.SobjectType );

		Test.startTest();
			String got = config.getMappedSobjectField( 'invalid field' );
		Test.stopTest();

		System.assertEquals( null, got, 'getMappedSobjectField, when given a result field that is not mapped, will return null' );
	}

	@isTest
	private static void getMappedSobjectField_whenPassedANull_throwsAnException() // NOPMD: Test method name format
	{
		SearchConfiguration config = new TestableSearchConfiguration( Contact.SobjectType );

		Test.startTest();
			String exceptionMessage;
			try
			{
				config.getMappedSobjectField( null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'getMappedSobjectField called with a blank resultField', exceptionMessage, 'getMappedSobjectField, when passed a null result field, will throw an exception' );
	}

	@isTest
	private static void getMappedSobjectField_whenPassedBlank_throwsAnException() // NOPMD: Test method name format
	{
		SearchConfiguration config = new TestableSearchConfiguration( Contact.SobjectType );

		Test.startTest();
			String exceptionMessage;
			try
			{
				config.getMappedSobjectField( '	 	' );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'getMappedSobjectField called with a blank resultField', exceptionMessage, 'getMappedSobjectField, when passed a null result field, will throw an exception' );
	}

	@isTest
	private static void addFieldMapping_whenPassedANullResultField_throwsAnException() // NOPMD: Test method name format
	{
		TestableSearchConfiguration config = new TestableSearchConfiguration( Contact.SobjectType );

		Test.startTest();
			String exceptionMessage;
			try
			{
				config.addFieldMapping( null, 'sobjectField' );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'addFieldMapping called with a blank resultField', exceptionMessage, 'addFieldMapping, when passed a null result field, will throw an exception' );
	}

	@isTest
	private static void addFieldMapping_whenPassedABlankResultField_throwsAnException() // NOPMD: Test method name format
	{
		TestableSearchConfiguration config = new TestableSearchConfiguration( Contact.SobjectType );

		Test.startTest();
			String exceptionMessage;
			try
			{
				config.addFieldMapping( '	 	', 'sobjectField' );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'addFieldMapping called with a blank resultField', exceptionMessage, 'addFieldMapping, when passed a blank result field, will throw an exception' );
	}

	@isTest
	private static void addFieldMapping_whenPassedANullSobjectField_throwsAnException() // NOPMD: Test method name format
	{
		TestableSearchConfiguration config = new TestableSearchConfiguration( Contact.SobjectType );

		Test.startTest();
			String exceptionMessage;
			try
			{
				config.addFieldMapping( 'resultField', null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'addFieldMapping called with a blank sobjectField', exceptionMessage, 'addFieldMapping, when passed a null sobject field, will throw an exception' );
	}

	@isTest
	private static void addFieldMapping_whenPassedABlankSobjectField_throwsAnException() // NOPMD: Test method name format
	{
		TestableSearchConfiguration config = new TestableSearchConfiguration( Contact.SobjectType );

		Test.startTest();
			String exceptionMessage;
			try
			{
				config.addFieldMapping( 'resultField', ' 		 ' );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'addFieldMapping called with a blank sobjectField', exceptionMessage, 'addFieldMapping, when passed a blank sobject field, will throw an exception' );
	}

	class TestableSearchConfiguration extends SearchConfiguration
	{
		public TestableSearchConfiguration( SobjectType baseSobjectType )
		{
			super( baseSobjectType );
			addFieldMapping( 'resultField1', 'sobjectField1' );
			addFieldMapping( 'resultField2', 'sobjectField2' );
			addFieldMapping( 'resultField3', 'sobjectField3' );
		}
	}

	class EmptySearchConfiguration extends SearchConfiguration
	{
		public EmptySearchConfiguration( SobjectType baseSobjectType )
		{
			super( baseSobjectType );
		}
	}
}