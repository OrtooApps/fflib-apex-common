@isTest
private without sharing class LoggerServiceTest
{
	private class TestException extends Exception {}

	@isTest
	private static void log_whenGivenALevelAndAMessageAndLoggingIsEnabledForThatLevel_callsToLog() // NOPMD: Test method name format
	{
		LoggerService.Level level = LoggerService.Level.INFO;
		String message = 'the message';

		TestLoggerService fakeLogger = new TestLoggerService();
		Application.SERVICE.setMock( ILoggerService.class, fakeLogger );

		TestLoggerUtils.setLoggingLevels( new List<LoggerService.Level>{ LoggerService.Level.INFO } );

		Test.startTest();
			LoggerService.log( level, message );
		Test.stopTest();

		System.assertEquals( 'log', fakeLogger.methods[0], 'log, when given a level and a message, and logging is enabled for that level, calls the service to log' );
		System.assertEquals( new List<Object>{ level, message }, fakeLogger.parameters[0], 'log, when given a level and a message, and logging is enabled for that level, calls the service to log, passing parameters' );
	}

	@isTest
	private static void log_whenGivenALevelAndAMessageAndLoggingIsDisabledForThatLevel_doesNotCallToLog() // NOPMD: Test method name format
	{
		LoggerService.Level level = LoggerService.Level.INFO;
		String message = 'the message';

		TestLoggerService fakeLogger = new TestLoggerService();
		Application.SERVICE.setMock( ILoggerService.class, fakeLogger );

		TestLoggerUtils.setLoggingLevels( new List<LoggerService.Level>{ LoggerService.Level.ERROR, LoggerService.Level.WARN } );

		Test.startTest();
			LoggerService.log( level, message );
		Test.stopTest();

		System.assert( fakeLogger.methods.isEmpty(), 'log, when given a level and a message, and logging is disabled for that level, does not call against the service' );
	}

	@isTest
	private static void log_whenGivenALevelAndAMessageAndLoggingAndNoConfig_asksServiceIfItShouldLog() // NOPMD: Test method name format
	{
		LoggerService.Level level = LoggerService.Level.INFO;
		String message = 'the message';

		TestLoggerService fakeLogger = new TestLoggerService().setDefaultLoggingEnabledReturns( true );
		Application.SERVICE.setMock( ILoggerService.class, fakeLogger );

		TestLoggerUtils.setConfigurationMissing();

		Test.startTest();
			LoggerService.log( level, message );
		Test.stopTest();

		System.assertEquals( 'getDefaultLoggingEnabled', fakeLogger.methods[0], 'log, when given a level and a message, and config is missing, asks the service if it should log' );
		System.assertEquals( LoggerService.Level.INFO, fakeLogger.parameters[0][0], 'log, when given a level and a message, and config is missing, and config is missing, asks the service if it should log' );

		System.assertEquals( 'log', fakeLogger.methods[1], 'log, when given a level and a message, and config is missing, asks the service if it should log, and calls the service if it should' );
	}

	@isTest
	private static void log_whenGivenALevelAndAMessageAndLoggerThrowsException_doesNotThrow() // NOPMD: Test method name format
	{
		LoggerService.Level level = LoggerService.Level.INFO;
		String message = 'the message';

		TestLoggerService fakeLogger = new TestLoggerService().loggingThrowsException();
		Application.SERVICE.setMock( ILoggerService.class, fakeLogger );

		TestLoggerUtils.setLoggingLevels( new List<LoggerService.Level>{ LoggerService.Level.INFO } );

		Test.startTest();
			LoggerService.log( level, message );
		Test.stopTest();

		System.assertEquals( 'log', fakeLogger.methods[0], 'log, when given a level and a message, and the logger throws an exception, does not throw' );
	}

	@isTest
	private static void log_whenGivenALevelAndAMessageAndIdAndLoggingIsEnabledForThatLevel_callsToLog() // NOPMD: Test method name format
	{
		LoggerService.Level level = LoggerService.Level.WARN;
		String message = 'the message';
		Id relatedSobjectId = TestIdUtils.generateId( Contact.SobjectType );

		TestLoggerService fakeLogger = new TestLoggerService();
		Application.SERVICE.setMock( ILoggerService.class, fakeLogger );

		TestLoggerUtils.setLoggingLevels( new List<LoggerService.Level>{ LoggerService.Level.WARN } );

		Test.startTest();
			LoggerService.log( level, message, relatedSobjectId );
		Test.stopTest();

		System.assertEquals( 'log', fakeLogger.methods[0], 'log, when given a level and a message and sobject id, and logging is enabled for that level, calls the service to log' );
		System.assertEquals( new List<Object>{ level, message, relatedSobjectId }, fakeLogger.parameters[0], 'log, when given a level and a message, and sobject id and logging is enabled for that level, calls the service to log, passing parameters' );
	}

	@isTest
	private static void log_whenGivenALevelAndAMessageAndIdAndLoggingIsDisabledForThatLevel_doesNotCallToLog() // NOPMD: Test method name format
	{
		LoggerService.Level level = LoggerService.Level.WARN;
		String message = 'the message';
		Id relatedSobjectId = TestIdUtils.generateId( Contact.SobjectType );

		TestLoggerService fakeLogger = new TestLoggerService();
		Application.SERVICE.setMock( ILoggerService.class, fakeLogger );

		TestLoggerUtils.setLoggingLevels( new List<LoggerService.Level>{ LoggerService.Level.ERROR, LoggerService.Level.INFO } );

		Test.startTest();
			LoggerService.log( level, message, relatedSobjectId );
		Test.stopTest();

		System.assert( fakeLogger.methods.isEmpty(), 'log, when given a level and a message and sobject id, and logging is disabled for that level, does not call against the service' );
	}

	@isTest
	private static void log_whenGivenALevelAndAMessageAndIdAndLoggingAndNoConfig_asksServiceIfItShouldLog() // NOPMD: Test method name format
	{
		LoggerService.Level level = LoggerService.Level.WARN;
		String message = 'the message';
		Id relatedSobjectId = TestIdUtils.generateId( Contact.SobjectType );

		TestLoggerService fakeLogger = new TestLoggerService().setDefaultLoggingEnabledReturns( true );
		Application.SERVICE.setMock( ILoggerService.class, fakeLogger );

		TestLoggerUtils.setConfigurationMissing();

		Test.startTest();
			LoggerService.log( level, message, relatedSobjectId );
		Test.stopTest();

		System.assertEquals( 'getDefaultLoggingEnabled', fakeLogger.methods[0], 'log, when given a level and a message and sobject id, and config is missing, asks the service if it should log' );
		System.assertEquals( LoggerService.Level.WARN, fakeLogger.parameters[0][0], 'log, when given a level and a message and sobject id, and config is missing, and config is missing, asks the service if it should log' );

		System.assertEquals( 'log', fakeLogger.methods[1], 'log, when given a level and a message and sobject id, and config is missing, asks the service if it should log, and calls the service if it should' );
	}

	@isTest
	private static void log_whenGivenALevelAndAMessageAndIdAndLoggerThrowsException_doesNotThrow() // NOPMD: Test method name format
	{
		LoggerService.Level level = LoggerService.Level.WARN;
		String message = 'the message';
		Id relatedSobjectId = TestIdUtils.generateId( Contact.SobjectType );

		TestLoggerService fakeLogger = new TestLoggerService().loggingThrowsException();
		Application.SERVICE.setMock( ILoggerService.class, fakeLogger );

		TestLoggerUtils.setLoggingLevels( new List<LoggerService.Level>{ LoggerService.Level.WARN } );

		Test.startTest();
			LoggerService.log( level, message, relatedSobjectId );
		Test.stopTest();

		System.assertEquals( 'log', fakeLogger.methods[0], 'log, when given a level and a message and sobject id, and the logger throws an exception, does not throw' );
	}

	@isTest
	private static void log_whenGivenExceptionAndLoggingIsEnabledForThatLevel_callsToLog() // NOPMD: Test method name format
	{
		Exception exceptionToLog = new TestException( 'message' );

		TestLoggerService fakeLogger = new TestLoggerService();
		Application.SERVICE.setMock( ILoggerService.class, fakeLogger );

		TestLoggerUtils.setLoggingLevels( new List<LoggerService.Level>{ LoggerService.Level.ERROR } );

		Test.startTest();
			LoggerService.log( exceptionToLog );
		Test.stopTest();

		System.assertEquals( 'log', fakeLogger.methods[0], 'log, when given an exception, and logging is enabled for that level, calls the service to log' );
	}

	@isTest
	private static void log_whenGivenExceptionAndLoggingIsDisabledForErrors_doesNotCallToLog() // NOPMD: Test method name format
	{
		Exception exceptionToLog = new TestException( 'message' );

		TestLoggerService fakeLogger = new TestLoggerService();
		Application.SERVICE.setMock( ILoggerService.class, fakeLogger );

		TestLoggerUtils.setLoggingLevels( new List<LoggerService.Level>{ LoggerService.Level.INFO, LoggerService.Level.WARN } );

		Test.startTest();
			LoggerService.log( exceptionToLog );
		Test.stopTest();

		System.assert( fakeLogger.methods.isEmpty(), 'log, when given an exception, and logging is disabled for errors, does not call against the service' );
	}

	@isTest
	private static void log_whenGivenExceptionAndLoggingAndNoConfig_asksServiceIfItShouldLog() // NOPMD: Test method name format
	{
		Exception exceptionToLog = new TestException( 'message' );

		TestLoggerService fakeLogger = new TestLoggerService().setDefaultLoggingEnabledReturns( true );
		Application.SERVICE.setMock( ILoggerService.class, fakeLogger );

		TestLoggerUtils.setConfigurationMissing();

		Test.startTest();
			LoggerService.log( exceptionToLog );
		Test.stopTest();

		System.assertEquals( 'getDefaultLoggingEnabled', fakeLogger.methods[0], 'log, when given an exception, and config is missing, asks the service if it should log' );
		System.assertEquals( LoggerService.Level.ERROR, fakeLogger.parameters[0][0], 'log, when given an exception, and config is missing, asks the service if it should log' );

		System.assertEquals( 'log', fakeLogger.methods[1], 'log, when given an exception, and config is missing, asks the service if it should log, and calls the service if it should' );
	}

	@isTest
	private static void log_whenGivenExceptionAndLoggerThrowsException_doesNotThrow() // NOPMD: Test method name format
	{
		Exception exceptionToLog = new TestException( 'message' );

		TestLoggerService fakeLogger = new TestLoggerService().loggingThrowsException();
		Application.SERVICE.setMock( ILoggerService.class, fakeLogger );

		TestLoggerUtils.setLoggingLevels( new List<LoggerService.Level>{ LoggerService.Level.ERROR } );

		Test.startTest();
			LoggerService.log( exceptionToLog );
		Test.stopTest();

		System.assertEquals( 'log', fakeLogger.methods[0], 'log, when given an exception, and the logger throws an exception, does not throw' );
	}

	@isTest
	private static void log_whenGivenExceptionAndIdAndLoggingIsEnabledForThatLevel_callsToLog() // NOPMD: Test method name format
	{
		Exception exceptionToLog = new TestException( 'message' );
		Id relatedSobjectId = TestIdUtils.generateId( Contact.SobjectType );

		TestLoggerService fakeLogger = new TestLoggerService();
		Application.SERVICE.setMock( ILoggerService.class, fakeLogger );

		TestLoggerUtils.setLoggingLevels( new List<LoggerService.Level>{ LoggerService.Level.ERROR } );

		Test.startTest();
			LoggerService.log( exceptionToLog, relatedSobjectId );
		Test.stopTest();

		System.assertEquals( 'log', fakeLogger.methods[0], 'log, when given an exception and an id, and logging is enabled for that level, calls the service to log' );
	}

	@isTest
	private static void log_whenGivenExceptionAndIdAndLoggingIsDisabledForErrors_doesNotCallToLog() // NOPMD: Test method name format
	{
		Exception exceptionToLog = new TestException( 'message' );
		Id relatedSobjectId = TestIdUtils.generateId( Contact.SobjectType );

		TestLoggerService fakeLogger = new TestLoggerService();
		Application.SERVICE.setMock( ILoggerService.class, fakeLogger );

		TestLoggerUtils.setLoggingLevels( new List<LoggerService.Level>{ LoggerService.Level.INFO, LoggerService.Level.WARN } );

		Test.startTest();
			LoggerService.log( exceptionToLog, relatedSobjectId );
		Test.stopTest();

		System.assert( fakeLogger.methods.isEmpty(), 'log, when given an exception and an id, and logging is disabled for errors, does not call against the service' );
	}

	@isTest
	private static void log_whenGivenExceptionAndIdAndLoggingAndNoConfig_asksServiceIfItShouldLog() // NOPMD: Test method name format
	{
		Exception exceptionToLog = new TestException( 'message' );
		Id relatedSobjectId = TestIdUtils.generateId( Contact.SobjectType );

		TestLoggerService fakeLogger = new TestLoggerService().setDefaultLoggingEnabledReturns( true );
		Application.SERVICE.setMock( ILoggerService.class, fakeLogger );

		TestLoggerUtils.setConfigurationMissing();

		Test.startTest();
			LoggerService.log( exceptionToLog, relatedSobjectId );
		Test.stopTest();

		System.assertEquals( 'getDefaultLoggingEnabled', fakeLogger.methods[0], 'log, when given an exception and an id, and config is missing, asks the service if it should log' );
		System.assertEquals( LoggerService.Level.ERROR, fakeLogger.parameters[0][0], 'log, when given an exception and an id, and config is missing, asks the service if it should log' );

		System.assertEquals( 'log', fakeLogger.methods[1], 'log, when given an exception and an id, and config is missing, asks the service if it should log, and calls the service if it should' );
	}

	@isTest
	private static void log_whenGivenExceptionAndIdAndLoggerThrowsException_doesNotThrow() // NOPMD: Test method name format
	{
		Exception exceptionToLog = new TestException( 'message' );
		Id relatedSobjectId = TestIdUtils.generateId( Contact.SobjectType );

		TestLoggerService fakeLogger = new TestLoggerService().loggingThrowsException();
		Application.SERVICE.setMock( ILoggerService.class, fakeLogger );

		TestLoggerUtils.setLoggingLevels( new List<LoggerService.Level>{ LoggerService.Level.ERROR } );

		Test.startTest();
			LoggerService.log( exceptionToLog, relatedSobjectId );
		Test.stopTest();

		System.assertEquals( 'log', fakeLogger.methods[0], 'log, when given an exception and an id, and the logger throws an exception, does not throw' );
	}

	@isTest
	private static void log_whenTheLoggerCannotBeFound_usesANullLogger() // NOPMD: Test method name format
	{
		Application.SERVICE.setMock( ILoggerService.class, null );
		TestLoggerUtils.setLoggingLevels( new List<LoggerService.Level>{ LoggerService.Level.ERROR } );

		Test.startTest();
			LoggerService.log( LoggerService.Level.INFO, 'message' );
		Test.stopTest();

		System.assert( true, 'log, when the logger service implementation cannot be found, will use a null logger and no exception is thrown' );
	}
}