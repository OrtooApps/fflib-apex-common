@isTest
public inherited sharing class SearchWindowTest
{
	@isTest
	private static void configure_whenCalledWithOffsetAndLengthProperties_storesThemAsMemberVariables() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'offset' => 10,
			'length' => 20
		};

		Test.startTest();
			SearchWindow searchWindow = new SearchWindow().configure( properties );
		Test.stopTest();

		System.assertEquals( 10, searchWindow.offset, 'configure, when called with offset and length properties, will store the offset as a member variable' );
		System.assertEquals( 20, searchWindow.length, 'configure, when called with offset and length properties, will store the length as a member variable' );
	}

	@isTest
	private static void configure_whenPassedANullProperties_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				new SearchWindow().configure( null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'configure called with a null properties', exceptionMessage, 'configure, when passed a null properties, will throw an exception' );
	}

	@isTest
	private static void configure_whenCalledWithOffsetProperty_storesThatAndLeaveLengthNull() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'offset' => 10
		};

		Test.startTest();
			SearchWindow searchWindow = new SearchWindow().configure( properties );
		Test.stopTest();

		System.assertEquals( 10, searchWindow.offset, 'configure, when called with offset and no length property, will store the offset as a member variable' );
		System.assertEquals( null, searchWindow.length, 'configure, when called with offset and no length property, will set the length to null' );
	}

	@isTest
	private static void configure_whenCalledWithDecimalOffsetProperty_roundsItDown() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'offset' => 15.1
		};

		Test.startTest();
			SearchWindow searchWindow = new SearchWindow().configure( properties );
		Test.stopTest();

		System.assertEquals( 15, searchWindow.offset, 'configure, when called with a decimal offset, will round it and store the offset as a member variable' );
	}

	@isTest
	private static void configure_whenCalledWithStringOffsetProperty_castsIt() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'offset' => '15'
		};

		Test.startTest();
			SearchWindow searchWindow = new SearchWindow().configure( properties );
		Test.stopTest();

		System.assertEquals( 15, searchWindow.offset, 'configure, when called with a string offset, will cast it and store the offset as a member variable' );
	}

	@isTest
	private static void configure_whenCalledWithEmptyLength_storesThatAsNull() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'offset' => 10,
			'length' => ''
		};

		Test.startTest();
			SearchWindow searchWindow = new SearchWindow().configure( properties );
		Test.stopTest();

		System.assertEquals( 10, searchWindow.offset, 'configure, when called with offset and empty length property, will store the offset as a member variable' );
		System.assertEquals( null, searchWindow.length, 'configure, when called with offset and empty length property, will set the length to null' );
	}

	@isTest
	private static void configure_whenCalledWithLengthProperty_storesThatAndLeaveOffsetNull() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'length' => 10
		};

		Test.startTest();
			SearchWindow searchWindow = new SearchWindow().configure( properties );
		Test.stopTest();

		System.assertEquals( 10, searchWindow.length, 'configure, when called with no offset and a length property, will store the length as a member variable' );
		System.assertEquals( null, searchWindow.offset, 'configure, when called with no offset and a length property, will set the offset to null' );
	}

	@isTest
	private static void configure_whenCalledWithDecimalLengthProperty_roundsItDown() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'length' => 15.1
		};

		Test.startTest();
			SearchWindow searchWindow = new SearchWindow().configure( properties );
		Test.stopTest();

		System.assertEquals( 15, searchWindow.length, 'configure, when called with a decimal length, will round it and store the length as a member variable' );
	}

	@isTest
	private static void configure_whenCalledWithStringLengthProperty_castsIt() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'length' => '15'
		};

		Test.startTest();
			SearchWindow searchWindow = new SearchWindow().configure( properties );
		Test.stopTest();

		System.assertEquals( 15, searchWindow.length, 'configure, when called with a string length, will cast it and store the length as a member variable' );
	}

	@isTest
	private static void configure_whenGivenANegativeOffset_throwsAnException() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'offset' => -10
		};

		Test.startTest();
			String exceptionMessage;
			try
			{
				SearchWindow searchWindow = new SearchWindow().configure( properties );
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'configure called with a negative offset', exceptionMessage, 'configure, when given a negative offset, will throw an exception' );
	}

	@isTest
	private static void configure_whenGivenANegativeStringOffset_throwsAnException() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'offset' => '-10'
		};

		Test.startTest();
			String exceptionMessage;
			try
			{
				SearchWindow searchWindow = new SearchWindow().configure( properties );
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'configure called with a negative offset', exceptionMessage, 'configure, when given a negative string offset, will throw an exception' );
	}

	@isTest
	private static void configure_whenGivenANegativeLength_throwsAnException() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'length' => -10
		};

		Test.startTest();
			String exceptionMessage;
			try
			{
				SearchWindow searchWindow = new SearchWindow().configure( properties );
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'configure called with a negative or zero length', exceptionMessage, 'configure, when given a negative length, will throw an exception' );
	}

	@isTest
	private static void configure_whenGivenANegativeStringLength_throwsAnException() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'length' => '-10'
		};

		Test.startTest();
			String exceptionMessage;
			try
			{
				SearchWindow searchWindow = new SearchWindow().configure( properties );
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'configure called with a negative or zero length', exceptionMessage, 'configure, when given a negative string length, will throw an exception' );
	}

	@isTest
	private static void configure_whenGivenAZeroLength_throwsAnException() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'length' => 0
		};

		Test.startTest();
			String exceptionMessage;
			try
			{
				SearchWindow searchWindow = new SearchWindow().configure( properties );
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'configure called with a negative or zero length', exceptionMessage, 'configure, when given a zero length, will throw an exception' );
	}

	@isTest
	private static void configure_whenGivenAZeroStringLength_throwsAnException() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'length' => '0'
		};

		Test.startTest();
			String exceptionMessage;
			try
			{
				SearchWindow searchWindow = new SearchWindow().configure( properties );
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'configure called with a negative or zero length', exceptionMessage, 'configure, when given a zero string length, will throw an exception' );
	}

	@isTest
	private static void configure_whenGivenANonNumberOffset_throwsAnException() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'offset' => 'notanumber'
		};

		Test.startTest();
			String exceptionMessage;
			try
			{
				SearchWindow searchWindow = new SearchWindow().configure( properties );
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'configure called with offset that could not be cast into an Integer', exceptionMessage, 'configure, when given a non numeric offset, will throw an exception' );
	}

	@isTest
	private static void configure_whenGivenAStringNumberThatCannotBeCastOffset_throwsAnException() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'offset' => '15.5' // cannot cast this
		};

		Test.startTest();
			String exceptionMessage;
			try
			{
				SearchWindow searchWindow = new SearchWindow().configure( properties );
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'configure called with offset that could not be cast into an Integer', exceptionMessage, 'configure, when given a numeric string offset that cannot be cast to an integer, will throw an exception' );
	}

	@isTest
	private static void configure_whenGivenANonNumberLength_throwsAnException() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'length' => 'notanumber'
		};

		Test.startTest();
			String exceptionMessage;
			try
			{
				SearchWindow searchWindow = new SearchWindow().configure( properties );
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'configure called with length that could not be cast into an Integer', exceptionMessage, 'configure, when given a non numeric length, will throw an exception' );
	}


	@isTest
	private static void configure_whenGivenAStringNumberThatCannotBeCastLength_throwsAnException() // NOPMD: Test method name format
	{
		Map<String,Object> properties = new Map<String,Object>{
			'length' => '15.5' // cannot cast this
		};

		Test.startTest();
			String exceptionMessage;
			try
			{
				SearchWindow searchWindow = new SearchWindow().configure( properties );
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'configure called with length that could not be cast into an Integer', exceptionMessage, 'configure, when given a numeric string length that cannot be cast to an integer, will throw an exception' );
	}
}