@isTest
private without sharing class StringUtilsTest
{
	@isTest
	private static void formatLabel_whenGivenAStringWithReplacements_willReplaceThemAndReturnTheFormattedString() // NOPMD: Test method name format
	{
		String formattedString = StringUtils.formatLabel( 'this {0} is {1} formatted {2}', new List<String>{ 'string', 'a', 'one' } );
		System.assertEquals( 'this string is a formatted one', formattedString, 'formatLabel, when given a String with replacements, will replace them and return the formatted string' );
	}

	@isTest
	private static void formatLabel_whenGivenAStringWithAnApostrophe_willReplaceThemAndReturnTheFormattedString() // NOPMD: Test method name format
	{
		String formattedString = StringUtils.formatLabel( 'this \'{0}\' is {1} form\'ted {2}', new List<String>{ 'string', 'a', 'one' } );
		System.assertEquals( 'this \'string\' is a form\'ted one', formattedString, 'formatLabel, when given a String with replacements and an apostrophe, will replace them and return the formatted string' );
	}

	@isTest
	private static void formatLabel_whenGivenTooFewReplacements_willReplaceWhatItCan() // NOPMD: Test method name format
	{
		String formattedString = StringUtils.formatLabel( 'this {0} is {1} formatted {2}', new List<String>{ 'string' } );
		System.assertEquals( 'this string is {1} formatted {2}', formattedString, 'formatLabel, when given too few replacements, will replace what it can' );
	}

	@isTest
	private static void formatLabel_whenGivenTooManyReplacements_willReplaceWhatItCan() // NOPMD: Test method name format
	{
		String formattedString = StringUtils.formatLabel( 'this {0} is {1} formatted {2}', new List<String>{ 'string', 'a', 'one', 'two' } );
		System.assertEquals( 'this string is a formatted one', formattedString, 'formatLabel, when given too few replacements, will replace what it can' );
	}

	@isTest
	private static void formatLabel_whenGivenNoReplacements_willReturnTheOriginalString() // NOPMD: Test method name format
	{
		String formattedString = StringUtils.formatLabel( 'this {0} is {1} formatted {2}', new List<String>{} );
		System.assertEquals( 'this {0} is {1} formatted {2}', formattedString, 'formatLabel, when given no replacements, will return the original string' );
	}

	@isTest
	private static void formatLabel_whenGivenNullReplacements_willReturnTheOriginalString() // NOPMD: Test method name format
	{
		String formattedString = StringUtils.formatLabel( 'this {0} is {1} formatted {2}', null );
		System.assertEquals( 'this {0} is {1} formatted {2}', formattedString, 'formatLabel, when given null replacements, will return the original string' );
	}

	@isTest
	private static void formatLabel_whenGivenAnEmptyString_willReturnAnEmptyString() // NOPMD: Test method name format
	{
		String formattedString = StringUtils.formatLabel( '', new List<String>{ 'string' } );
		System.assertEquals( '', formattedString, 'formatLabel, when given an empty string, will return an empty string' );
	}

	@isTest
	private static void formatLabel_whenGivenANullString_willReturnAnEmptyString() // NOPMD: Test method name format
	{
		String formattedString = StringUtils.formatLabel( null, new List<String>{ 'string' } );
		System.assertEquals( '', formattedString, 'formatLabel, when given a null string, will return an empty string' );
	}

	@isTest
	private static void unNull_whenGivenAStringThatIsNotNull_returnsThatString() // NOPMD: Test method name format
	{
		String originalString = 'not null string';
		String got = StringUtils.unNull( originalString );
		System.assertEquals( originalString, got, 'unNull, when given a String that is not null, will return that String' );
	}

	@isTest
	private static void unNull_whenGivenAStringThatIsNull_returnsAnEmptyString() // NOPMD: Test method name format
	{
		String got = StringUtils.unNull( null );
		System.assertEquals( '', got, 'unNull, when given a String that is null, will return an empty String' );
	}

	@isTest
	private static void convertDelimitedStringToList_whenGivenAStringAndADelimiter_willSplitTheStringOnTheDelimiter() // NOPMD: Test method name format
	{
		String originalString = 'one,two,three';
		List<String> expectedList = new List<String>{ 'one', 'two', 'three' };

		Test.startTest();
			List<String> returnedList = StringUtils.convertDelimitedStringToList( originalString, ',' );
		Test.stopTest();

		System.assertEquals( expectedList, returnedList, 'convertDelimitedStringToList, when given a string and a delimiter, will split the string' );
	}

	@isTest
	private static void convertDelimitedStringToList_whenGivenAStringWithDuplicateEntries_willAListWithTheDuplicates() // NOPMD: Test method name format
	{
		String originalString = 'one,two,three,one,two';
		List<String> expectedList = new List<String>{ 'one', 'two', 'three', 'one', 'two' };

		Test.startTest();
			List<String> returnedList = StringUtils.convertDelimitedStringToList( originalString, ',' );
		Test.stopTest();

		System.assertEquals( expectedList, returnedList, 'convertDelimitedStringToList, when given a string with duplicates, will return the duplicates' );
	}

	@isTest
	private static void convertDelimitedStringToList_whenGivenAStringWithSpacesAndADelimiter_willSplitTheStringOnTheDelimiter() // NOPMD: Test method name format
	{
		String originalString = '  one	,	t w o , three';
		List<String> expectedList = new List<String>{ 'one', 't w o', 'three' };

		Test.startTest();
			List<String> returnedList = StringUtils.convertDelimitedStringToList( originalString, ',' );
		Test.stopTest();

		System.assertEquals( expectedList, returnedList, 'convertDelimitedStringToList, when given a string with spaces and a delimiter, will split the string' );
	}

	@isTest
	private static void convertDelimitedStringToList_whenGivenAStringWithoutTheDelimited_willTrimAndReturnTheString() // NOPMD: Test method name format
	{
		String originalString = '  one	';
		List<String> expectedList = new List<String>{ 'one' };

		Test.startTest();
			List<String> returnedList = StringUtils.convertDelimitedStringToList( originalString, ',' );
		Test.stopTest();

		System.assertEquals( expectedList, returnedList, 'convertDelimitedStringToList, when given a string with no delimiter, will return a list with just the trimmed string' );
	}

	@isTest
	private static void convertDelimitedStringToList_whenGivenAnEmptyString_willReturnAnEmptyList() // NOPMD: Test method name format
	{
		String originalString = '  		';
		List<String> expectedList = new List<String>();

		Test.startTest();
			List<String> returnedList = StringUtils.convertDelimitedStringToList( originalString, ',' );
		Test.stopTest();

		System.assertEquals( expectedList, returnedList, 'convertDelimitedStringToList, when given an empty string , will return an empty list' );
	}

	@isTest
	private static void convertDelimitedStringToList_whenGivenNull_willReturnAnEmptyList() // NOPMD: Test method name format
	{
		String originalString = null;
		List<String> expectedList = new List<String>();

		Test.startTest();
			List<String> returnedList = StringUtils.convertDelimitedStringToList( originalString, ',' );
		Test.stopTest();

		System.assertEquals( expectedList, returnedList, 'convertDelimitedStringToList, when given an null string , will return an empty String' );
	}

	@isTest
	private static void convertDelimitedStringToList_whenPassedANullDelimiter_willThrowAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				StringUtils.convertDelimitedStringToList( 'unimportant', null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'convertDelimitedStringToList called with an empty delimiter', exceptionMessage, 'convertDelimitedStringToList, when passed a null delimiter, will throw an exception' );
	}

	@isTest
	private static void convertDelimitedStringToList_whenPassedAnEmptyDelimiter_willThrowAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				StringUtils.convertDelimitedStringToList( 'unimportant', '' );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'convertDelimitedStringToList called with an empty delimiter', exceptionMessage, 'convertDelimitedStringToList, when passed an empty delimiter, will throw an exception' );
	}

	@isTest
	private static void convertDelimitedStringToList_whenUsingTheDefaultDelimiter_willSplitTheStringOnSemiColon() // NOPMD: Test method name format
	{
		String originalString = 'one;two;three,notsplit';
		List<String> expectedList = new List<String>{ 'one', 'two', 'three,notsplit' };

		Test.startTest();
			List<String> returnedList = StringUtils.convertDelimitedStringToList( originalString );
		Test.stopTest();

		System.assertEquals( expectedList, returnedList, 'convertDelimitedStringToList, when using the default delimiter will split the string on semi-colon' );
	}

	@isTest
	private static void convertListToDelimitedString_whenGivenAListOfStrings_willJoinThemWithASemiColon() // NOPMD: Test method name format
	{
		List<String> originalList = new List<String>{ 'one', 'two', 'three' };
		String expectedString = 'one;two;three';

		Test.startTest();
			String returnedString = StringUtils.convertListToDelimitedString( originalList );
		Test.stopTest();

		System.assertEquals( expectedString, returnedString, 'convertListToDelimitedString, when given a list of strings, will join them with a semi-colon' );
	}

	@isTest
	private static void convertListToDelimitedString_whenGivenAnEmptyListOfStrings_willReturnAnEmptyString() // NOPMD: Test method name format
	{
		List<String> originalList = new List<String>();
		String expectedString = '';

		Test.startTest();
			String returnedString = StringUtils.convertListToDelimitedString( originalList );
		Test.stopTest();

		System.assertEquals( expectedString, returnedString, 'convertListToDelimitedString, when given an empty list of strings, will return an empty list' );
	}

	@isTest
	private static void convertListToDelimitedString_whenPassedANullListOfStrings_willThrowAnException() // NOPMD: Test method name format
	{
		List<String> nullListOfStrings;

		Test.startTest();
			String exceptionMessage;
			try
			{
				StringUtils.convertListToDelimitedString( nullListOfStrings );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'convertListToDelimitedString called with a null listOfStrings', exceptionMessage, 'convertListToDelimitedString, when passed a null listOfStrings, will throw an exception' );
	}

	@isTest
	private static void convertListToDelimitedString_whenGivenAListOfObjects_willJoinThemWithASemiColon() // NOPMD: Test method name format
	{
		List<Object> originalList = new List<Object>{ new StringableThing( 'one' ), new StringableThing( 'two' ), new StringableThing( 'three' ) };
		String expectedString = 'one;two;three';

		Test.startTest();
			String returnedString = StringUtils.convertListToDelimitedString( originalList );
		Test.stopTest();

		System.assertEquals( expectedString, returnedString, 'convertListToDelimitedString, when given a list of strings, will join them with a semi-colon' );
	}

	@isTest
	private static void convertListToDelimitedString_whenGivenAnEmptyListOfObjects_willReturnAnEmptyString() // NOPMD: Test method name format
	{
		List<Object> originalList = new List<Object>();
		String expectedString = '';

		Test.startTest();
			String returnedString = StringUtils.convertListToDelimitedString( originalList );
		Test.stopTest();

		System.assertEquals( expectedString, returnedString, 'convertListToDelimitedString, when given an empty list of Objects, will return an empty list' );
	}

	@isTest
	private static void convertListToDelimitedString_whenPassedANullListOfObjects_willThrowAnException() // NOPMD: Test method name format
	{
		List<Object> nullListOfObjects;

		Test.startTest();
			String exceptionMessage;
			try
			{
				StringUtils.convertListToDelimitedString( nullListOfObjects );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'convertListToDelimitedString called with a null listOfObjects', exceptionMessage, 'convertListToDelimitedString, when passed a null listOfObjects, will throw an exception' );
	}

	@isTest
	private static void convertListToDelimitedString_whenGivenAListOfObjectsAndADelimiter_willJoinThemWithTheDelimiter() // NOPMD: Test method name format
	{
		List<Object> originalList = new List<Object>{ new StringableThing( 'one' ), new StringableThing( 'two' ), new StringableThing( 'three' ) };
		String expectedString = 'one,two,three';

		Test.startTest();
			String returnedString = StringUtils.convertListToDelimitedString( originalList, ',' );
		Test.stopTest();

		System.assertEquals( expectedString, returnedString, 'convertListToDelimitedString, when given a list of strings and a delimiter, will join them with a semi-colon' );
	}

	@isTest
	private static void convertListToDelimitedString_whenGivenAnEmptyListOfObjectsAndADelimiter_willReturnAnEmptyString() // NOPMD: Test method name format
	{
		List<Object> originalList = new List<Object>();
		String expectedString = '';

		Test.startTest();
			String returnedString = StringUtils.convertListToDelimitedString( originalList, ',' );
		Test.stopTest();

		System.assertEquals( expectedString, returnedString, 'convertListToDelimitedString, when given an empty list of Objects and a delimiter, will return an empty list' );
	}

	@isTest
	private static void convertListToDelimitedString_whenPassedANullListOfObjectsAndADelimiter_willThrowAnException() // NOPMD: Test method name format
	{
		List<Object> nullListOfObjects;

		Test.startTest();
			String exceptionMessage;
			try
			{
				StringUtils.convertListToDelimitedString( nullListOfObjects, ',' );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'convertListToDelimitedString called with a null listOfObjects', exceptionMessage, 'convertListToDelimitedString, when passed a null listOfObjects and a delimiter, will throw an exception' );
	}

	@isTest
	private static void convertListToDelimitedString_whenPassedANullDelimiter_willThrowAnException() // NOPMD: Test method name format
	{
		List<Object> originalList = new List<Object>();

		Test.startTest();
			String exceptionMessage;
			try
			{
				StringUtils.convertListToDelimitedString( originalList, null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'convertListToDelimitedString called with an empty delimiter', exceptionMessage, 'convertListToDelimitedString, when passed a null delimiter, will throw an exception' );
	}

	@isTest
	private static void convertListToDelimitedString_whenPassedAnEmptyDelimiter_willThrowAnException() // NOPMD: Test method name format
	{
		List<Object> originalList = new List<Object>();

		Test.startTest();
			String exceptionMessage;
			try
			{
				StringUtils.convertListToDelimitedString( originalList, '' );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'convertListToDelimitedString called with an empty delimiter', exceptionMessage, 'convertListToDelimitedString, when passed an empty delimiter, will throw an exception' );
	}

	@isTest
	private static void cut_whenGivenALongString_cutsItToTheDesiredLength() // NOPMD: Test method name format
	{
		String got = StringUtils.cut( 'theoriginalstring', 5 );
		System.assertEquals( 'theor', got, 'cut, when given a string longer than the desired length, will cut it to the specified length' );
	}

	@isTest
	private static void cut_whenGivenAShortString_returnsTheOriginal() // NOPMD: Test method name format
	{
		String got = StringUtils.cut( 'short', 10 );
		System.assertEquals( 'short', got, 'cut, when given a string shorter than the desired length, will return the original string' );
	}

	@isTest
	private static void cut_whenPassedANullString_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				StringUtils.cut( null, 5 );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'cut called with a null originalString', exceptionMessage, 'cut, when passed a null string, will throw an exception' );
	}

	@isTest
	private static void cut_whenPassedANullLength_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				StringUtils.cut( 'string', null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'cut called with a null length', exceptionMessage, 'cut, when passed a null length, will throw an exception' );
	}

	@isTest
	private static void cut_whenPassedANegativeLength_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				StringUtils.cut( 'string', -3 );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'cut called with a negative length', exceptionMessage, 'cut, when passed a negative length, will throw an exception' );
	}

	private inherited sharing class StringableThing {
		String name;
		public StringableThing( String name )
		{
			this.name = name;
		}
		 public override String toString()
		 {
			 return this.name;
		 }
	}
}