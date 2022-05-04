@isTest
private without sharing class LoggerServiceImplTest
{
	//
	// Note that these tests call the Impl directly since the static wrapper is
	// not guaranteed to call the child because of configuration
	//
	@isTest
	private static void getDefaultLoggingEnabled_returnsTrue() // NOPMD: Test method name format
	{
		ILoggerService loggerServiceImpl = new LoggerServiceImpl();

		System.assertEquals( true, loggerServiceImpl.getDefaultLoggingEnabled( LoggerService.Level.ERROR ), 'getDefaultLoggingEnabled, when called with ERROR, returns true' );
		System.assertEquals( true, loggerServiceImpl.getDefaultLoggingEnabled( LoggerService.Level.WARN ), 'getDefaultLoggingEnabled, when called with WARN, returns true' );
		System.assertEquals( true, loggerServiceImpl.getDefaultLoggingEnabled( LoggerService.Level.INFO ), 'getDefaultLoggingEnabled, when called with INFO, returns true' );
	}

	@isTest
	private static void log_whenGivenLogLevelAndMessage_willLog() // NOPMD: Test method name format
	{
		LoggerService.Level logLevel = LoggerService.Level.INFO;
		String message = 'a message';

		Test.startTest();
			new LoggerServiceImpl().log( logLevel, message );
		Test.stopTest();

		System.assert( true, 'log, when given a log level and message, will log using system debug - which is not testable' );
	}

	@isTest
	private static void log_whenGivenNullLogLevelAndMessage_willNotThrowAnException() // NOPMD: Test method name format
	{
		LoggerService.Level logLevel = null;
		String message = null;

		Test.startTest();
			new LoggerServiceImpl().log( logLevel, message );
		Test.stopTest();

		System.assert( true, 'log, when given a null log level and message, will not throw an exception' );
	}

	@isTest
	private static void log_whenGivenLogLevelMessageAndId_willLog() // NOPMD: Test method name format
	{
		LoggerService.Level logLevel = LoggerService.Level.WARN;
		String message = 'message';
		Id sobjectId = TestIdUtils.generateId( Contact.sobjectType );

		Test.startTest();
			new LoggerServiceImpl().log( logLevel, message, sobjectId );
		Test.stopTest();

		System.assert( true, 'log, when given a log level, message and sobject Id, will log using system debug - which is not testable' );
	}

	@isTest
	private static void log_whenGivenLogLevelMessageAndNullId_willLog() // NOPMD: Test method name format
	{
		LoggerService.Level logLevel = LoggerService.Level.WARN;
		String message = 'message';
		Id sobjectId = null;

		Test.startTest();
			new LoggerServiceImpl().log( logLevel, message, sobjectId );
		Test.stopTest();

		System.assert( true, 'log, when given a log level, message and null sobject Id, will log using system debug - which is not testable' );
	}

	@isTest
	private static void log_whenGivenNullLogLevelMessageAndId_willNotThrowAnException() // NOPMD: Test method name format
	{
		LoggerService.Level logLevel = null;
		String message = null;
		Id sobjectId = null;

		Test.startTest();
			new LoggerServiceImpl().log( logLevel, message, sobjectId );
		Test.stopTest();

		System.assert( true, 'log, when given a log level, message and sobject Id, will not throw an exception' );
	}

	@isTest
	private static void log_whenGivenAnException_willLog() // NOPMD: Test method name format
	{
		Exception e = new LocalException( 'message' );

		Test.startTest();
			new LoggerServiceImpl().log( e );
		Test.stopTest();

		System.assert( true, 'log, when given an exception, will log using system debug - which is not testable' );
	}

	@isTest
	private static void log_whenGivenANullException_willNotThrowAnException() // NOPMD: Test method name format
	{
		Exception e = null;

		Test.startTest();
			new LoggerServiceImpl().log( e );
		Test.stopTest();

		System.assert( true, 'log, when given a null exception, will not throw an exception' );
	}

	@isTest
	private static void log_whenGivenAnExceptionAndAnId_willLog() // NOPMD: Test method name format
	{
		Exception causedBy = new LocalException( 'causedBy' );
		Exception e = new LocalException( 'message', causedBy );
		Id sobjectId = TestIdUtils.generateId( Contact.sobjectType );

		Test.startTest();
			new LoggerServiceImpl().log( e, sobjectId );
		Test.stopTest();

		System.assert( true, 'log, when given an exception and an sobject Id, will log using system debug - which is not testable' );
	}

	@isTest
	private static void log_whenGivenAnExceptionAndAnId_willNotThrowAnException() // NOPMD: Test method name format
	{
		Exception e = null;
		Id sobjectId = null;

		Test.startTest();
			new LoggerServiceImpl().log( e, sobjectId );
		Test.stopTest();

		System.assert( true, 'log, when given an exception and an sobject Id, will not throw an exception' );
	}

	@isTest
	private static void log_whenGivenANullDmlException_willNotThrowAnException() // NOPMD: Test method name format
	{
		DmlException e = null;

		Test.startTest();
			new LoggerServiceImpl().log( e );
		Test.stopTest();

		System.assert( true, 'log, when given a null dml exception, will not throw an exception' );
	}

	// Note we cannot test the logging of the DmlException since we cannot set up the DML Ids, etc, and any call to these methods
	// will cause uncatchable exceptions if they are not set up.

	@isTest
	private static void log_whenGivenAnOrtooException_willLog() // NOPMD: Test method name format
	{
		Exception causedBy = new ortoo_Exception( 'caused by message' );
		ortoo_Exception e = new ortoo_Exception( 'message', causedBy );
		e.addContext('context', 'some context');
		e.setMessageDetails( new List<MessageDetail>{
			new MessageDetail( 'detail content')
		});
		Id sobjectId = null;

		Test.startTest();
			new LoggerServiceImpl().log( e );
		Test.stopTest();

		System.assert( true, 'log, when given an ortoo exception, will log using system debug - which is not testable' );
	}

	@isTest
	private static void log_whenGivenANullOrtooException_willNotThrowAnException() // NOPMD: Test method name format
	{
		ortoo_Exception e = null;

		Test.startTest();
			new LoggerServiceImpl().log( e );
		Test.stopTest();

		System.assert( true, 'log, when given a null ortoo exception, will not throw an exception' );
	}

	class LocalException extends Exception {}
}