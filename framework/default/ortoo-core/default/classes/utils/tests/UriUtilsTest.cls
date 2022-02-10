@isTest
private without sharing class UriUtilsTest
{
	@isTest
	private static void buildUriFragment_whenGivenStringProperties_willWriteStringOfProperties() // NOPMD: Test method name format
	{
        Map<String,Object> properties = new Map<String,Object>{
            'property1' => 'value1',
            'property2' => 'value2'
        };

		String expected = 'property1=%22value1%22&property2=%22value2%22';

		Test.startTest();
	        String got = UriUtils.buildUriFragment( properties );
		Test.stopTest();

		System.assertEquals( expected, got, 'buildUriFragment, when given string properties, will write a string of properties - each value JSON encoded, names and values both URI Encoded' );
	}

	@isTest
	private static void buildUriFragment_whenGivenAnEmptyStringProperty_willNotAddIt() // NOPMD: Test method name format
	{
        Map<String,Object> properties = new Map<String,Object>{
            'property1' => 'value1',
			'emptyProperty' => '',
            'property2' => 'value2'
        };

		String expected = 'property1=%22value1%22&property2=%22value2%22';

		Test.startTest();
	        String got = UriUtils.buildUriFragment( properties );
		Test.stopTest();

		System.assertEquals( expected, got, 'buildUriFragment, when given an empty property, will not add it' );
	}

	@isTest
	private static void buildUriFragment_whenGivenStringPropertiesWithUriChars_willEncodeThem() // NOPMD: Test method name format
	{
        Map<String,Object> properties = new Map<String,Object>{
            'property1' => 'value 1 & 2 = 3',
            'property2' => 'value 2 & 3 = 4'
        };

		String expected = 'property1=%22value%201%20%26%202%20%3D%203%22&property2=%22value%202%20%26%203%20%3D%204%22';

		Test.startTest();
	        String got = UriUtils.buildUriFragment( properties );
		Test.stopTest();

		System.assertEquals( expected, got, 'buildUriFragment, when given string properties with URI special chars in the values, will encode them' );
	}

	@isTest
	private static void buildUriFragment_whenGivenPropertyNamesWithUriChars_willEncodeThem() // NOPMD: Test method name format
	{
        Map<String,Object> properties = new Map<String,Object>{
            'property 1 & 2 = 3' => 'value1',
            'property 2 & 3 = 4' => 'value1'
        };

		String expected = 'property%201%20%26%202%20%3D%203=%22value1%22&property%202%20%26%203%20%3D%204=%22value1%22';

		Test.startTest();
	        String got = UriUtils.buildUriFragment( properties );
		Test.stopTest();

		System.assertEquals( expected, got, 'buildUriFragment, when given string properties with URI special chars in the names, will encode them' );
	}

	@isTest
	private static void buildUriFragment_whenGivenNestedMaps_willFlattenThem() // NOPMD: Test method name format
	{
        Map<String,Object> properties = new Map<String,Object>{
            'simpleProperty' => 'simpleValue',
            'objectProperty' => new Map<String,Object>{
                'childProperty'  => 'childValue',
                'childProperty2' => 'childValue2'
            }
        };

		String expected = 'simpleProperty=%22simpleValue%22&objectProperty.childProperty=%22childValue%22&objectProperty.childProperty2=%22childValue2%22';

		Test.startTest();
	        String got = UriUtils.buildUriFragment( properties );
		Test.stopTest();

		System.assertEquals( expected, got, 'buildUriFragment, when given nested maps, will flatten and then encode them' );
	}

	@isTest
	private static void buildUriFragment_whenGivenDeeplyNestedMaps_willFlattenThem() // NOPMD: Test method name format
	{
        Map<String,Object> properties = new Map<String,Object>{
            'simpleProperty' => 'simpleValue',
            'objectProperty' => new Map<String,Object>{
                'childProperty'  => 'childValue',
                'childProperty2' => 'childValue2',
				'childProperty3' => new Map<String,Object>{
                    'grandchildProperty' => 'grandchildValue'
                }
            }
        };

		String expected = 'simpleProperty=%22simpleValue%22&objectProperty.childProperty=%22childValue%22&objectProperty.childProperty2=%22childValue2%22&objectProperty.childProperty3.grandchildProperty=%22grandchildValue%22';

		Test.startTest();
	        String got = UriUtils.buildUriFragment( properties );
		Test.stopTest();

		System.assertEquals( expected, got, 'buildUriFragment, when given nested maps, will flatten and then encode them' );
	}

	@isTest
	private static void buildUriFragment_whenGivenAnArrayInAnElement_willRenderIt() // NOPMD: Test method name format
	{
        Map<String,Object> properties = new Map<String,Object>{
            'arrayProperty' => new List<String>{ 'value1', 'value2', 'value3' }
        };

		String expected = 'arrayProperty=%5B%22value1%22%2C%22value2%22%2C%22value3%22%5D';

		Test.startTest();
	        String got = UriUtils.buildUriFragment( properties );
		Test.stopTest();

		System.assertEquals( expected, got, 'buildUriFragment, when given an array value, will render it' );
	}

	@isTest
	private static void buildUriFragment_whenGivenAnEmptyMap_willReturnAnEmptyString() // NOPMD: Test method name format
	{
        Map<String,Object> properties = new Map<String,Object>{};

		String expected = '';

		Test.startTest();
	        String got = UriUtils.buildUriFragment( properties );
		Test.stopTest();

		System.assertEquals( expected, got, 'buildUriFragment, when given an empty map, will return an empty map' );
	}

	@isTest
	private static void buildUriFragment_whenGivenAMapWithDifferentDataTypes_willRenderThemAsJson() // NOPMD: Test method name format
	{
        Map<String,Object> properties = new Map<String,Object>{
            'stringProperty' => 'string',
			'integerProperty' => 1,
			'decimalProperty' => 1.2,
			'booleanProperty' => true
        };

		String expected = 'stringProperty=%22string%22&integerProperty=1&decimalProperty=1.2&booleanProperty=true';

		Test.startTest();
	        String got = UriUtils.buildUriFragment( properties );
		Test.stopTest();

		System.assertEquals( expected, got, 'buildUriFragment, when given nested maps, will flatten and then encode them' );
	}

	@isTest
	private static void buildUriFragment_whenPassedANullProperties_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				UriUtils.buildUriFragment( null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'buildUriFragment called with a null properties', exceptionMessage, 'buildUriFragment, when passed a null properties, will throw an exception' );
	}

	@isTest
	private static void addUriFragment_whenGivenProperties_willSetThemAsTheAnchor() // NOPMD: Test method name format
	{
        Map<String,Object> properties = new Map<String,Object>{
            'property1' => 'value1',
            'property2' => 'value2'
        };

		String expected = UriUtils.buildUriFragment( properties );

		PageReference reference = new PageReference( '/lightning/n/sometab' );

		Test.startTest();
			UriUtils.addUriFragment( reference, properties );
	        String got = reference.getAnchor();
		Test.stopTest();

		System.assertEquals( expected, got, 'addUriFragment, when given a page reference and properties, will set them on the PageReference as the "anchor"' );
	}

	@isTest
	private static void addUriFragment_whenPassedANullPageReference_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				UriUtils.addUriFragment( null, new Map<String,Object>() );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'addUriFragment called with a null pageReference', exceptionMessage, 'addUriFragment, when passed a null pageReference, will throw an exception' );
	}

	@isTest
	private static void addUriFragment_whenPassedANullProperties_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				UriUtils.addUriFragment( new PageReference( 'lightning/n/sometab' ), null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'addUriFragment called with a null properties', exceptionMessage, 'addUriFragment, when passed a null properties, will throw an exception' );
	}
}