@isTest
private without sharing class ServiceUtilsTest
{
	@isTest
	private static void logAndRethrow_whenGivenAStandardException_logsItAndRethrowsIt() // NOPMD: Test method name format
	{
		TestLoggerUtils.switchLoggingOn();
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		DmlException exceptionToLog = new DmlException( 'The exception to log' );
		Exception exceptionCaught;

		Test.startTest();
			try
			{
				ServiceUtils.logAndRethrow( exceptionToLog );
			}
			catch( Exception e )
			{
				exceptionCaught = e;
			}
		Test.stopTest();

		logger.assertNumberOfLogCalls( 1, 'logAndRethrow, when given an exception, will log it with the logger service' );
		System.assertEquals( exceptionCaught, exceptionToLog, 'logAndRethrow, when given an exception, will rethrow it' );
	}

	@isTest
	private static void logAndRethrow_whenGivenAnOrtooException_logsItStripsItAndRethrowsIt() // NOPMD: Test method name format
	{
		TestLoggerUtils.switchLoggingOn();
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		Amoss_Instance exceptionController = new Amoss_Instance( ortoo_Exception.class );
		exceptionController
			.expects( 'stripContexts' );

		Exception exceptionToLog = (Exception)exceptionController.getDouble();
		Exception exceptionCaught;

		Test.startTest();
			try
			{
				ServiceUtils.logAndRethrow( exceptionToLog );
			}
			catch( Exception e )
			{
				exceptionCaught = e;
			}
		Test.stopTest();

		logger.assertNumberOfLogCalls( 1, 'logAndRethrow, when given an ortoo exception, will log it with the logger service' );
		System.assertEquals( String.valueOf( exceptionCaught ), String.valueOf( exceptionToLog ), 'logAndRethrow, when given an ortoo exception, will rethrow it' );

		exceptionController.verify();
	}

	@isTest
	private static void logAndRethrow_whenGivenAValidationException_willNotLogIt() // NOPMD: Test method name format
	{
		TestLoggerUtils.switchLoggingOn();
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		Exception exceptionToLog = new Exceptions.ValidationException( 'ValidationFailed' );
		Exception exceptionCaught;

		Test.startTest();
			try
			{
				ServiceUtils.logAndRethrow( exceptionToLog );
			}
			catch( Exception e )
			{
				exceptionCaught = e;
			}
		Test.stopTest();

		logger.assertNumberOfLogCalls( 0, 'logAndRethrow, when given an ortoo validation exception, will not log it' );
		System.assertEquals( String.valueOf( exceptionCaught ), String.valueOf( exceptionToLog ), 'logAndRethrow, when given an ortoo validation exception, will rethrow it' );
	}
}