@isTest
/**
 * This exists because StubProvider has difficulty creating a stub for ILoggerService
 * Potentially it's a problem with overloaded methods defined in an interface.
 * However, since it needs to exist, it gives us the opportunity to provide useful methods
 * for supporting testing.
 */
public class TestLoggerService implements ILoggerService
{
	class LoggerException extends Exception {}

	public List<String> methods = new List<String>();
	public List<List<Object>> parameters = new List<List<Object>>();
	Boolean defaultLoggingEnabledReturns = true;
	Boolean loggingThrowsException = false;

	public TestLoggerService clearLogHistory()
	{
		methods = new List<String>();
		parameters = new List<List<Object>>();
		return this;
	}

	public TestLoggerService loggingThrowsException()
	{
		loggingThrowsException = true;
		return this;
	}

	public TestLoggerService setDefaultLoggingEnabledReturns( Boolean returns )
	{
		defaultLoggingEnabledReturns = returns;
		return this;
	}

	public Boolean getDefaultLoggingEnabled( LoggerService.Level logLevel )
	{
		methods.add( 'getDefaultLoggingEnabled' );
		parameters.add( new List<Object>{ logLevel } );
		return defaultLoggingEnabledReturns;
	}

	public void log( LoggerService.Level logLevel, String message )
	{
		methods.add( 'log' );
		parameters.add( new List<Object>{ logLevel, message } );
		if ( loggingThrowsException )
		{
			throw new LoggerException( 'a message' );
		}
	}

	public void log( LoggerService.Level logLevel, String message, Id relatedSobjectId )
	{
		methods.add( 'log' );
		parameters.add( new List<Object>{ logLevel, message, relatedSobjectId } );
		if ( loggingThrowsException )
		{
			throw new LoggerException( 'a message' );
		}
	}

	public void log( Exception exceptionToLog )
	{
		methods.add( 'log' );
		parameters.add( new List<Object>{ exceptionToLog } );
		if ( loggingThrowsException )
		{
			throw new LoggerException( 'a message' );
		}
	}

	public void log( Exception exceptionToLog, Id relatedSobject )
	{
		methods.add( 'log' );
		parameters.add( new List<Object>{ exceptionToLog, relatedSobject });
		if ( loggingThrowsException )
		{
			throw new LoggerException( 'a message' );
		}
	}

	public void assertCallIsLog( Integer logCallNumber,  String assertionText )
	{
		System.assertEquals( 'log', methods[ logCallNumber ], assertionText );
	}

	public void assertNumberOfLogCalls( Integer expected, String assertionText )
	{
		Integer numberOfLogCalls = 0;
		for ( String methodCalled : methods )
		{
			numberOfLogCalls += ( methodCalled == 'log' ? 1 : 0 );
		}
		System.assertEquals( expected, numberOfLogCalls, assertionText );
	}

	public void assertLogLevelIs( Integer logCallNumber, LoggerService.Level expected, String assertionText )
	{
		System.assertEquals( expected, (LoggerService.Level)parameters[ logCallNumber ][0], assertionText );
	}

	public void assertLogEntryContains( Integer logCallNumber, String expected, String assertionText )
	{
		ortoo_Asserts.assertContains( expected, (String)parameters[ logCallNumber ][1], assertionText );
	}
}

