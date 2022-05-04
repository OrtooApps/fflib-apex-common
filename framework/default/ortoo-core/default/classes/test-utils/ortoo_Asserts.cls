@isTest
public with sharing class ortoo_Asserts
{
	/**
	 * Assert that the actualString contains the expectedString
	 *
	 * Provided as this is a common assertion case, and usually requires the building
	 * of an assertion message for clarity when the assertion fails.
	 *
	 * @param String - The string to search for (expected)
	 * @param String - The string to search within (actual)
	 * @param String - The assertion message
	 */
	public static void assertContains( String expectedString, String actualString, String assertionMessage )
	{
		if ( actualString == null && expectedString != null )
		{
			System.assert(false, assertionMessage + ' (looking for: ' + expectedString + ', got: ' + actualString + ')' );
		}
		System.assert( actualString.contains( expectedString ), assertionMessage + ' (looking for: ' + expectedString + ', got: ' + actualString + ')' );
	}

	/**
	 * Assert that the actualString does not contain the expectedString
	 *
	 * Provided as this is a common assertion case, and usually requires the building
	 * of an assertion message for clarity when the assertion fails.
	 *
	 * @param String - The string to search for (expected)
	 * @param String - The string to search within (actual)
	 * @param String - The assertion message
	 */
	public static void assertDoesNotContain( String expectedString, String actualString, String assertionMessage )
	{
		System.assert( ! actualString.contains( expectedString ), assertionMessage + ' (making sure does not contain: ' + expectedString + ', got: ' + actualString + ')' );
	}

	/**
	 * Assert that the listOfStrings contains the expectedString
	 *
	 * Provided as this is a common assertion case, and usually requires the building
	 * of an assertion message for clarity when the assertion fails.
	 *
	 * @param String - The string to search for (expected)
	 * @param List<String> - The list of strings to search within (actual)
	 * @param String - The assertion message
	 */
	public static void assertContains( String expectedString, List<String> listOfStrings, String assertionMessage )
	{
		if ( listOfStrings == null && expectedString != null )
		{
			System.assert(false, assertionMessage + ' (looking for: ' + expectedString + ' in the List, got: ' + listOfStrings + ' List)' );
		}
		System.assert( listOfStrings.contains( expectedString ), assertionMessage + ' (looking for: ' + expectedString + ' in the List, got: ' + listOfStrings + ' List)' );
	}

	/**
	 * Assert that the listOfStrings does not contain the expectedString
	 *
	 * Provided as this is a common assertion case, and usually requires the building
	 * of an assertion message for clarity when the assertion fails.
	 *
	 * @param String - The string to search for (expected)
	 * @param List<String> - The list of strings to search within (actual)
	 * @param String - The assertion message
	 */
	public static void assertDoesNotContain( String expectedString, List<String> listOfStrings, String assertionMessage )
	{
		System.assert( ! listOfStrings.contains( expectedString ), assertionMessage + ' (making sure does not contain: ' + expectedString + ', got: ' + listOfStrings + ')' );
	}

	/**
	 * Assert that the actualString ends with the expectedString
	 *
	 * Provided as this is a common assertion case, and usually requires the building
	 * of an assertion message for clarity when the assertion fails.
	 *
	 * @param String - The string to search for (expected)
	 * @param String - The string to search within (actual)
	 * @param String - The assertion message
	 */
	public static void assertEndsWith( String expectedString, String actualString, String assertionMessage )
	{
		if ( actualString == null && expectedString != null )
		{
			System.assert(false, assertionMessage + ' (looking for ending with: ' + expectedString + ', got: ' + actualString + ')' );
		}
		System.assert( actualString.endsWith( expectedString ), assertionMessage + ' (looking for ending with: ' + expectedString + ', got: ' + actualString + ')' );
	}

	/**
	 * Assert that the actualString starts with with the expectedString
	 *
	 * Provided as this is a common assertion case, and usually requires the building
	 * of an assertion message for clarity when the assertion fails.
	 *
	 * @param String - The string to search for (expected)
	 * @param String - The string to search within (actual)
	 * @param String - The assertion message
	 */
	public static void assertStartsWith( String expectedString, String actualString, String assertionMessage )
	{
		if ( actualString == null && expectedString != null )
		{
			System.assert(false, assertionMessage + ' (looking for starting with: ' + expectedString + ', got: ' + actualString + ')' );
		}
		System.assert( actualString.startsWith( expectedString ), assertionMessage + ' (looking for starting with: ' + expectedString + ', got: ' + actualString + ')' );
	}

	/**
	 * Assert that the actual date is between the earliestExpected and latestExpected
	 *
	 * Provided as this is a common assertion case, and usually requires the building
	 * of an assertion message for clarity when the assertion fails.
	 *
	 * @param	Date	- The earliest date that is expected
	 * @param	Date	- The latest date that is expected
	 * @param	Date	- The actual date to check
	 * @param	String	- The assertion message
	 */
	public static void assertBetweenInclusive( Date earliestExpected, Date latestExpected, Date actual, String assertionMessage )
	{
		Boolean inRange = actual >= earliestExpected && actual <= latestExpected;
		System.assert( inRange, assertionMessage + ' (looking for ' + earliestExpected + ' to ' + latestExpected + ', got ' + actual + ')' );
	}

	/**
	 * Assert that the given exceptions are the same.
	 *
	 * Takes care of the fact that exceptions can change object hash when they are rethrown
	 *
	 * @param	Exception - The expected Exception
	 * @param	Exception - The actual Exception
	 * @param	String	- The assertion message
	 */
	public static void assertEquals( Exception expected, Exception got, String assertionMessage )
	{
		System.assertEquals( String.valueOf( expected ), String.valueOf( got ), assertionMessage );
	}
}
