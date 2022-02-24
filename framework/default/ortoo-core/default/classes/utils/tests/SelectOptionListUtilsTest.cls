@isTest
private without sharing class SelectOptionListUtilsTest
{
	/**
	 * @method	trimToManageableLength( List<SelectOption> input )
	 * @case  	When given a list of select options greater than a manageable length
	 * @result	Will return a list shortened to a more manageable length
	 */
	@isTest
	private static void trimToManageableLength_whenGivenALongList_willShortenIt() // NOPMD: Test method name format
	{
		Integer manageableLength = SelectOptionListUtils.MANAGEABLE_SELECT_LIST_LENGTH;

		List<SelectOption> originalList = new List<SelectOption>();
		for ( Integer i = 0; i < manageableLength + 10; i++ ) {
			originalList.add( new SelectOption( String.valueOf( i ), String.valueOf( i ) ) );
		}

		List<SelectOption> trimmedList = SelectOptionListUtils.trimToManageableLength( originalList );

		System.assertEquals( manageableLength, trimmedList.size(), 'trimeToManageableLength, when given a list that is longer, will return a list that is trimmed to the manageable length' );
		System.assertEquals( originalList[0], trimmedList[0], 'trimeToManageableLength, when given a list that is longer, will return a list with the original first element' );
		System.assertEquals( originalList[manageableLength-1], trimmedList[manageableLength-1], 'trimeToManageableLength, when given a list that is longer, will return a list with the original element at the maximium length point' );
	}

	/**
	 * @method	trimToManageableLength( List<SelectOption> input )
	 * @case  	When given a list of select options smaller than a manageable length
	 * @result	Will return a list containing the same as the original
	 */
	@isTest
	private static void trimToManageableLength_whenGivenAShortList_willCloneAndReturnIt() // NOPMD: Test method name format
	{
		List<SelectOption> originalList = new List<SelectOption>();
		for ( Integer i = 0; i < 5; i++ ) {
			originalList.add( new SelectOption( String.valueOf( i ), String.valueOf( i ) ) );
		}

		List<SelectOption> trimmedList = SelectOptionListUtils.trimToManageableLength( originalList );

		System.assertEquals( originalList, trimmedList, 'trimeToManageableLength, when given a list that is short, will return a clone of the original list' );
	}

	/**
	 * @method	trimToManageableLength( List<SelectOption> input )
	 * @case  	When given an empty list
	 * @result	Will return an empty list
	 */
	@isTest
	private static void trimToManageableLength_whenGivenAEmptyList_willReturnAnEmptyList() // NOPMD: Test method name format
	{
		List<SelectOption> originalList = new List<SelectOption>();

		List<SelectOption> trimmedList = SelectOptionListUtils.trimToManageableLength( originalList );

		System.assertEquals( 0, trimmedList.size(), 'trimeToManageableLength, when given an empty list, will return an empty list' );
	}

	/**
	 * @method	trimToManageableLength( List<SelectOption> input )
	 * @case  	When given null
	 * @result	Will throw an exception
	 */
	@isTest
	private static void trimToManageableLength_whenGivenNull_willThrowAnException() // NOPMD: Test method name format
	{
		String exceptionMessage;
		try {
			List<SelectOption> trimmedList = SelectOptionListUtils.trimToManageableLength( null );
		} catch ( Contract.RequiresException e ) {
			exceptionMessage = e.getMessage();
		}

		ortoo_Asserts.assertContains( 'trimToManageableLength called with a null List', exceptionMessage, 'trimToManageableLength, when given a null list, will throw an exception' );
	}
}