@isTest
public with sharing class TestLoggerUtils
{
	public static void setLoggingLevels( List<LoggerService.Level> levelsToLog )
	{
		LoggerService.config = new Logging_Configuration__c(
			Name = 'Test configuration',
			Log_INFO_Level_Messages__c = levelsToLog.contains( LoggerService.Level.INFO ),
			Log_WARN_Level_Messages__c = levelsToLog.contains( LoggerService.Level.WARN ),
			Log_ERROR_Level_Messages__c = levelsToLog.contains( LoggerService.Level.ERROR )
		);
	}

	public static void switchLoggingToErrorOnly()
	{
		setLoggingLevels( new List<LoggerService.Level>{ LoggerService.Level.ERROR } );
	}

	public static void switchLoggingOff()
	{
		setLoggingLevels( new List<LoggerService.Level>() );
	}

	public static void switchLoggingOn()
	{
		setLoggingLevels( new List<LoggerService.Level>{ LoggerService.Level.INFO, LoggerService.Level.WARN, LoggerService.Level.ERROR } );
	}

	public static void setConfigurationMissing()
	{
		LoggerService.config = new Logging_Configuration__c();
	}

	/**
	 * Registers the test logger service and returns it.
	 *
	 * Also switches on logging at all levels.  If you require a different logging level, you can set it
	 * *after* registering the test logger
	 */
	public static TestLoggerService registerTestLoggerService()
	{
		switchLoggingOn();
		TestLoggerService testLogger = new TestLoggerService();
		Application.SERVICE.setMock( ILoggerService.class, testLogger );
		return testLogger;
	}
}
