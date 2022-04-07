@isTest
// This exists because StubProvider has difficulty creating a stub for ILoggerService
// Potentially it's a problem with overloaded methods defined in an interface.
public class TestLoggerService implements ILoggerService
{
	class LoggerException extends Exception {}

	public List<String> methods = new List<String>();
	public List<List<Object>> parameters = new List<List<Object>>();
	Boolean defaultLoggingEnabledReturns = false;
	Boolean loggingThrowsException = false;

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
}

