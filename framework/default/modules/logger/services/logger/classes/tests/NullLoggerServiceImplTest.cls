@isTest
private without sharing class NullLoggerServiceImplTest
{
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
		Application.SERVICE.setMock( ILoggerService.class, new NullLoggerServiceImpl() );

		LoggerService.Level logLevel = null;
		String message = null;

		Test.startTest();
			LoggerService.log( logLevel, message );
		Test.stopTest();

		System.assert( true, 'log, when given a log level and message, will do nothing' );
	}

	@isTest
	private static void log_whenGivenLogLevelMessageAndId_doNothing() // NOPMD: Test method name format
	{
		Application.SERVICE.setMock( ILoggerService.class, new NullLoggerServiceImpl() );

		LoggerService.Level logLevel = null;
		String message = null;
		Id sobjectId = null;

		Test.startTest();
			LoggerService.log( logLevel, message, sobjectId );
		Test.stopTest();

		System.assert( true, 'log, when given a log level, message and sobject Id, will do nothing' );
	}

	@isTest
	private static void log_whenGivenAnException_doNothing() // NOPMD: Test method name format
	{
		Application.SERVICE.setMock( ILoggerService.class, new NullLoggerServiceImpl() );

		Exception e = null;

		Test.startTest();
			LoggerService.log( e );
		Test.stopTest();

		System.assert( true, 'log, when given an exception, will do nothing' );
	}

	@isTest
	private static void log_whenGivenAnExceptionAndAnId_doNothing() // NOPMD: Test method name format
	{
		Application.SERVICE.setMock( ILoggerService.class, new NullLoggerServiceImpl() );

		Exception e = null;
		Id sobjectId = null;

		Test.startTest();
			LoggerService.log( e, sobjectId );
		Test.stopTest();

		System.assert( true, 'log, when given an exception and an sobject Id, will do nothing' );
	}

	@isTest
	private static void log_whenGivenADmlExceptionAndAnId_doNothing() // NOPMD: Test method name format
	{
		Application.SERVICE.setMock( ILoggerService.class, new NullLoggerServiceImpl() );

		DmlException e = null;
		Id sobjectId = null;

		Test.startTest();
			LoggerService.log( e, sobjectId );
		Test.stopTest();

		System.assert( true, 'log, when given a dml exception and an sobject Id, will do nothing' );
	}

	@isTest
	private static void log_whenGivenAnOrtooExceptionAndAnId_doNothing() // NOPMD: Test method name format
	{
		Application.SERVICE.setMock( ILoggerService.class, new NullLoggerServiceImpl() );

		ortoo_Exception e = null;
		Id sobjectId = null;

		Test.startTest();
			LoggerService.log( e, sobjectId );
		Test.stopTest();

		System.assert( true, 'log, when given an ortoo exception and an sobject Id, will do nothing' );
	}
}