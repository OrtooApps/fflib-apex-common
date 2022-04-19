@isTest
private without sharing class NullLoggerServiceImplTest
{
	//
	// Note that these tests call the Impl directly since the static wrapper is
	// not guaranteed to call the child because of configuration
	//
	@isTest
	private static void getDefaultLoggingEnabled_returnsFalse() // NOPMD: Test method name format
	{
		ILoggerService loggerServiceImpl = new NullLoggerServiceImpl();

		System.assertEquals( false, loggerServiceImpl.getDefaultLoggingEnabled( LoggerService.Level.ERROR ), 'getDefaultLoggingEnabled, when called with ERROR, returns false' );
		System.assertEquals( false, loggerServiceImpl.getDefaultLoggingEnabled( LoggerService.Level.WARN ), 'getDefaultLoggingEnabled, when called with WARN, returns false' );
		System.assertEquals( false, loggerServiceImpl.getDefaultLoggingEnabled( LoggerService.Level.INFO ), 'getDefaultLoggingEnabled, when called with INFO, returns false' );
	}

	@isTest
	private static void log_whenGivenLogLevelAndMessage_doNothing() // NOPMD: Test method name format
	{
		LoggerService.Level logLevel = null;
		String message = null;

		Test.startTest();
			new NullLoggerServiceImpl().log( logLevel, message );
		Test.stopTest();

		System.assert( true, 'log, when given a log level and message, will do nothing' );
	}

	@isTest
	private static void log_whenGivenLogLevelMessageAndId_doNothing() // NOPMD: Test method name format
	{
		LoggerService.Level logLevel = null;
		String message = null;
		Id sobjectId = null;

		Test.startTest();
			new NullLoggerServiceImpl().log( logLevel, message, sobjectId );
		Test.stopTest();

		System.assert( true, 'log, when given a log level, message and sobject Id, will do nothing' );
	}

	@isTest
	private static void log_whenGivenAnException_doNothing() // NOPMD: Test method name format
	{
		Exception e = null;

		Test.startTest();
			new NullLoggerServiceImpl().log( e );
		Test.stopTest();

		System.assert( true, 'log, when given an exception, will do nothing' );
	}

	@isTest
	private static void log_whenGivenAnExceptionAndAnId_doNothing() // NOPMD: Test method name format
	{
		Exception e = null;
		Id sobjectId = null;

		Test.startTest();
			new NullLoggerServiceImpl().log( e, sobjectId );
		Test.stopTest();

		System.assert( true, 'log, when given an exception and an sobject Id, will do nothing' );
	}

	@isTest
	private static void log_whenGivenADmlException_doNothing() // NOPMD: Test method name format
	{
		DmlException e = null;

		Test.startTest();
			new NullLoggerServiceImpl().log( e );
		Test.stopTest();

		System.assert( true, 'log, when given a dml exception, will do nothing' );
	}

	@isTest
	private static void log_whenGivenAnOrtooException_doNothing() // NOPMD: Test method name format
	{
		ortoo_Exception e = null;

		Test.startTest();
			new NullLoggerServiceImpl().log( e );
		Test.stopTest();

		System.assert( true, 'log, when given an ortoo exception, will do nothing' );
	}
}