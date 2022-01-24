@isTest
public inherited sharing class SearchOrderByTest
{
	@isTest
	private static void configure_whenGivenProperties_mapsTheFieldNameAndSetsTheDirection() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'fieldName' => 'sourceFieldName',
			'direction' => 'asc'
		};
		Type configurationType = ISearchConfiguration.class;

		Amoss_Instance configurationController = ApplicationMockRegistrar.registerMockAppLogic( configurationType );
		configurationController
			.expects( 'getMappedSobjectField' )
			.withParameter( 'sourceFieldName' )
			.returning( 'targetFieldName' );

		Test.startTest();
			SearchOrderBy orderBy = new SearchOrderBy().configure( properties, configurationType );
		Test.stopTest();

		configurationController.verify();

		System.assertEquals( 'targetFieldName', orderBy.fieldName, 'configure, when given properties with a fieldName and direction, will map the fieldName using the configuration and set the member variable' );
		System.assertEquals( 'asc', orderBy.direction, 'configure, when given properties with a fieldName and direction, will set the direction member variable' );

		System.assert( orderBy.isConfigured(), 'configure, when given properties with a fieldName and direction, will set the orderBy to configured' );
	}

	@isTest
	private static void configure_whenNoFieldName_setsFieldNameAndDirectionToNull() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'direction' => 'asc'
		};
		Type configurationType = ISearchConfiguration.class;

		Amoss_Instance configurationController = ApplicationMockRegistrar.registerMockAppLogic( configurationType );
		configurationController
			.expectsNoCalls();

		Test.startTest();
			SearchOrderBy orderBy = new SearchOrderBy().configure( properties, configurationType );
		Test.stopTest();

		configurationController.verify();

		System.assertEquals( null, orderBy.fieldName, 'configure, when given properties with no fieldName and direction, will set the fieldName to null' );
		System.assertEquals( null, orderBy.direction, 'configure, when given properties with no fieldName and direction, will set the direction to null' );

		System.assert( ! orderBy.isConfigured(), 'configure, when given properties with no fieldName and direction, will set the orderBy to not configured' );
	}

	@isTest
	private static void configure_whenFieldNameEmpty_setsFieldNameAndDirectionToNull() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'fieldName' => '',
			'direction' => 'asc'
		};
		Type configurationType = ISearchConfiguration.class;

		Amoss_Instance configurationController = ApplicationMockRegistrar.registerMockAppLogic( configurationType );
		configurationController
			.expectsNoCalls();

		Test.startTest();
			SearchOrderBy orderBy = new SearchOrderBy().configure( properties, configurationType );
		Test.stopTest();

		configurationController.verify();

		System.assertEquals( null, orderBy.fieldName, 'configure, when given properties with empty fieldName and direction, will set the fieldName to null' );
		System.assertEquals( null, orderBy.direction, 'configure, when given properties with empty fieldName and direction, will set the fieldName to null' );

		System.assert( ! orderBy.isConfigured(), 'configure, when given properties with empty fieldName and direction, will set the orderBy to not configured' );
	}

	@isTest
	private static void configure_whenFieldNameIsUnmapped_setsFieldNameAndDirectionToNull() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'fieldName' => 'unmapped',
			'direction' => 'asc'
		};
		Type configurationType = ISearchConfiguration.class;

		Amoss_Instance configurationController = ApplicationMockRegistrar.registerMockAppLogic( configurationType );
		configurationController
			.when( 'getMappedSobjectField' )
			.returns( null );

		Test.startTest();
			SearchOrderBy orderBy = new SearchOrderBy().configure( properties, configurationType );
		Test.stopTest();

		configurationController.verify();

		System.assertEquals( null, orderBy.fieldName, 'configure, when given properties with unmapped fieldName, will set the fieldName to null' );
		System.assertEquals( null, orderBy.direction, 'configure, when given properties with unmapped fieldName, will set the direction to null' );

		System.assert( ! orderBy.isConfigured(), 'configure, when given properties with unmapped fieldName, will set the orderBy to not configured' );
	}

	@isTest
	private static void configure_whenNoDirection_setsDirectionToAsc() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'fieldName' => 'source'
		};
		Type configurationType = ISearchConfiguration.class;

		Amoss_Instance configurationController = ApplicationMockRegistrar.registerMockAppLogic( configurationType );
		configurationController
			.when( 'getMappedSobjectField' )
			.returns( 'target' );

		Test.startTest();
			SearchOrderBy orderBy = new SearchOrderBy().configure( properties, configurationType );
		Test.stopTest();

		configurationController.verify();

		System.assertEquals( 'asc', orderBy.direction, 'configure, when given properties with no direction, will set the direction to asc' );
		System.assertEquals( 'target', orderBy.fieldName, 'configure, when given properties with no direction, will set the fieldName' );

		System.assert( orderBy.isConfigured(), 'configure, when given properties with no direction, will set the orderBy to configured' );
	}

	@isTest
	private static void configure_whenDirectionAsc_setsDirectionToAsc() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'fieldName' => 'source',
			'direction' => 'asc'
		};
		Type configurationType = ISearchConfiguration.class;

		Amoss_Instance configurationController = ApplicationMockRegistrar.registerMockAppLogic( configurationType );
		configurationController
			.when( 'getMappedSobjectField' )
			.returns( 'target' );

		Test.startTest();
			SearchOrderBy orderBy = new SearchOrderBy().configure( properties, configurationType );
		Test.stopTest();

		configurationController.verify();

		System.assertEquals( 'asc', orderBy.direction, 'configure, when given properties with asc direction, will set the direction to asc' );
		System.assertEquals( 'target', orderBy.fieldName, 'configure, when given properties with asc direction, will set the fieldName' );
	}

	@isTest
	private static void configure_whenDirectionDesc_setsDirectionToDesc() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'fieldName' => 'source',
			'direction' => 'desc'
		};
		Type configurationType = ISearchConfiguration.class;

		Amoss_Instance configurationController = ApplicationMockRegistrar.registerMockAppLogic( configurationType );
		configurationController
			.when( 'getMappedSobjectField' )
			.returns( 'target' );

		Test.startTest();
			SearchOrderBy orderBy = new SearchOrderBy().configure( properties, configurationType );
		Test.stopTest();

		configurationController.verify();

		System.assertEquals( 'desc', orderBy.direction, 'configure, when given properties with desc direction, will set the direction to desc' );
		System.assertEquals( 'target', orderBy.fieldName, 'configure, when given properties with desc direction, will set the fieldName' );
	}

	@isTest
	private static void configure_whenPassedInvalidDirection_throwsAnException() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'fieldName' => 'source',
			'direction' => 'invalid'
		};
		Type configurationType = ISearchConfiguration.class;

		Amoss_Instance configurationController = ApplicationMockRegistrar.registerMockAppLogic( configurationType );
		configurationController
			.when( 'getMappedSobjectField' )
			.returns( 'target' );

		Test.startTest();
			String exceptionMessage;
			try
			{
				new SearchOrderBy().configure( properties, configurationType );
			}
			catch ( Contract.AssertException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'configure called with an invalid direction.  Was "invalid", but should be one of [asc,desc]', exceptionMessage, 'configure, when passed an invalid direction, will throw an exception' );
	}

	@isTest
	private static void configure_whenPassedANullProperties_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				new SearchOrderBy().configure( null, ISearchConfiguration.class );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'configure called with a null properties', exceptionMessage, 'configure, when passed a null properties, will throw an exception' );
	}

	@isTest
	private static void configure_whenPassedANullSearchConfigurationType_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				new SearchOrderBy().configure( new Map<String,Object>(), null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'configure called with a null searchConfigurationType', exceptionMessage, 'configure, when passed a null searchConfigurationType, will throw an exception' );
	}

	@isTest
	private static void configure_whenPassedAnInvalidSearchConfigurationType_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				new SearchOrderBy().configure( new Map<String,Object>(), SearchOrderByTest.class );
			}
			catch ( Contract.AssertException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'configure called with a searchConfigurationType ('+SearchOrderByTest.class+') that does not implement ISearchConfiguration or does not have a parameterless constructor', exceptionMessage, 'configure, when passed an invalid searchConfigurationType, will throw an exception' );
	}

	@isTest
	private static void configure_whenPassedASearchConfigurationTypeThatCannotBeConstructed_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				new SearchOrderBy().configure( new Map<String,Object>(), SearchOrderByTest.NoParameterlessConstructor.class );
			}
			catch ( Contract.AssertException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'configure called with a searchConfigurationType ('+SearchOrderByTest.NoParameterlessConstructor.class+') that does not implement ISearchConfiguration or does not have a parameterless constructor', exceptionMessage, 'configure, when passed an invalid searchConfigurationType, will throw an exception' );
	}


	class NoParameterlessConstructor implements ISearchConfiguration
	{
		public NoParameterlessConstructor( String parameter ) {}

		public List<String> getRequiredFields()
		{
			return null;
		}
		public List<String> getSortableFields()
		{
			return null;
		}
		public String getMappedSobjectField( String resultField )
		{
			return null;
		}
		public SobjectType getBaseSobjectType()
		{
			return null;
		}
	}
}