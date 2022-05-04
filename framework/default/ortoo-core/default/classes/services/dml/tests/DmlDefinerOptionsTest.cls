@isTest
private without sharing class DmlDefinerOptionsTest
{
    @isTest
    private static void default_whenCalled_willCreateADefaultedOptions() // NOPMD: Test method name format
    {
        DmlDefinerOptions defaultOptions = DmlDefinerOptions.default();
        System.assertEquals( DmlDefinerOptions.OtherRecordsOption.IGNORE_RECORDS, defaultOptions.getOtherRecordsMode(), 'default, when called, will create a defaulted options - ignore other records' );
    }

    @isTest
    private static void setOtherRecordsMode_whenCalled_willSetTheOtherRecordsMode() // NOPMD: Test method name format
    {
        DmlDefinerOptions options = new DmlDefinerOptions();

        Test.startTest();
            options.setOtherRecordsMode( DmlDefinerOptions.OtherRecordsOption.DELETE_RECORDS );
        Test.stopTest();

        System.assertEquals( DmlDefinerOptions.OtherRecordsOption.DELETE_RECORDS, options.getOtherRecordsMode(), 'setOtherRecordsMode, when called, will set the other records mode' );
    }

    @isTest
    private static void setOtherRecordsMode_whenCalledWithNull_willThrowAnException() // NOPMD: Test method name format
    {
        DmlDefinerOptions options = new DmlDefinerOptions();

        Test.startTest();
            String exceptionMessage;
            try
            {
                options.setOtherRecordsMode( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'setOtherRecordsMode called with a null otherRecordsMode', exceptionMessage, 'setOtherRecordsMode, when called with null, will throw an exception' );
    }

	@isTest
	private static void getWillDeleteOtherRecords_whenRecordModeIsDelete_returnsTrue() // NOPMD: Test method name format
	{
        DmlDefinerOptions options = new DmlDefinerOptions();

        Test.startTest();
            options.setOtherRecordsMode( DmlDefinerOptions.OtherRecordsOption.DELETE_RECORDS );
			Boolean got = options.getWillDeleteOtherRecords();
		Test.stopTest();
	 
		System.assertEquals( true, got, 'getWillDeleteOtherRecords, when the record mode is DELETE_RECORDS, will return true' );
	}

	@isTest
	private static void getWillDeleteOtherRecords_whenRecordModeIsIgnore_returnsFalse() // NOPMD: Test method name format
	{
        DmlDefinerOptions options = new DmlDefinerOptions();

        Test.startTest();
            options.setOtherRecordsMode( DmlDefinerOptions.OtherRecordsOption.IGNORE_RECORDS );
			Boolean got = options.getWillDeleteOtherRecords();
		Test.stopTest();
	 
		System.assertEquals( false, got, 'getWillDeleteOtherRecords, when the record mode is IGNORE_RECORDS, will return false' );
	}
}