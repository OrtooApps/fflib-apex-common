/**
 * Provides the ability to generate log entries.
 * The precise output of the logging will depend on the implementation that is configured.
 *
 * In all cases, whether a message or exception is sent to the logging implementation is governed by
 * the Custom Setting 'Logging Configuration'.
 *
 * All exceptions from this service are swallowed in order to ensure that a badly configured logger does not
 * result in a broken system.
 */
public inherited sharing class LoggerService
{
	public enum Level { INFO, WARN, ERROR }

	public static final Level EXCEPTION_LOG_LEVEL = Level.ERROR;

	@testVisible
	private static Logging_Configuration__c config
	{
		get
		{
			if ( config == null )
			{
				try
				{
					config = Logging_Configuration__c.getInstance();
				}
				catch ( Exception e ) // We swallow the exception and create an empty logging configuration because the logger should never throw
										// an exception.  We just want the default values to apply in the situation that the config can't be loaded
				{
					config = new Logging_Configuration__c();
				}
			}
			return config;
		}
		set;
	}

	/**
	 * Log the given message at the given level
	 *
	 * @param	LoggerService.Level	The level of the log
	 * @param	String				The message to log
	 */
    public static void log( LoggerService.Level logLevel, String message )
	{
		if ( ! shouldLog( logLevel ) )
		{
			return;
		}

		try
		{
			service.log( logLevel, message );
		}
		catch ( Exception e )
		{
			System.debug( LoggingLevel.ERROR, 'Exception when attempting to log ' + message + ' - ' + e );
		}
	}

	/**
	 * Log the given message at the given level
	 *
	 * @param	LoggerService.Level	The level of the log
	 * @param	String				The message to log
	 * @param	Id					The Id of the SObject that this log entry relates to.
	 */
    public static void log( LoggerService.Level logLevel, String message, Id relatedSobjectId )
	{
		if ( ! shouldLog( logLevel ) )
		{
			return;
		}

		try
		{
			service.log( logLevel, message, relatedSobjectId );
		}
		catch ( Exception e )
		{
			System.debug( LoggingLevel.ERROR, 'Exception when attempting to log ' + message + ' against ' + relatedSobjectId + ' - ' + e );
		}
	}

	/**
	 * Log the given exception.
	 *
	 * Will produce output specific to different types:
	 * 		DmlException
	 * 		ortoo_Exception
	 * 		all other Exceptions
	 *
	 * @param	Exception	The exception to log
	 */
	public static void log( Exception exceptionToLog )
	{
		if ( ! shouldLogExceptions() )
		{
			return;
		}

		try
		{
			service.log( exceptionToLog );
		}
		catch ( Exception e )
		{
			System.debug( LoggingLevel.ERROR, 'Exception when attempting to log ' + exceptionToLog + ' - ' + e );
		}
	}

	/**
	 * Log the given exception against the given SObject Id
	 *
	 * @param	Exception	The exception to log
	 * @param	Id			The SObject to relate this log to
	 */
	public static void log( Exception exceptionToLog, Id relatedSobjectId )
	{
		if ( ! shouldLogExceptions() )
		{
			return;
		}

		try
		{
			service.log( exceptionToLog, relatedSobjectId );
		}
		catch ( Exception e )
		{
			System.debug( LoggingLevel.ERROR, 'Exception when attempting to log ' + exceptionToLog + ' - ' + e );
		}
	}

	private static Boolean shouldLog( LoggerService.Level logLevel )
	{
		// If no config record exists, then get the whether the logging should be on from the service implementation
		switch on logLevel {
			when INFO {
				return config.Name != null ? config.Log_INFO_Level_Messages__c : service.getDefaultLoggingEnabled( logLevel );
			}
			when WARN {
				return config.Name != null ? config.Log_WARN_Level_Messages__c : service.getDefaultLoggingEnabled( logLevel );
			}
		}
		return config.Name != null ? config.Log_ERROR_Level_Messages__c : service.getDefaultLoggingEnabled( logLevel );
	}

	private static Boolean shouldLogExceptions()
	{
		return shouldLog( EXCEPTION_LOG_LEVEL );
	}

    private static ILoggerService service
	{
		get
		{
			if ( service == null )
			{
				try
				{
					service = (ILoggerService)Application.SERVICE?.newInstance( ILoggerService.class );
				}
				catch ( Exception e )
				{
					System.debug( LoggingLevel.ERROR, 'Exception when trying to instantiate the logger - ' + e ); // Logger failure should not stop the system,
																												// so with nothing else available, instantiate a logger that does nothing
				}

				if ( service == null )
				{
					System.debug( LoggingLevel.WARN, 'Service factory did not build a logger, so NullLoggerServiceImpl is being used - this will not output any logs' );
					service = new NullLoggerServiceImpl();
				}
			}

			return service;
		}
		set;
    }
}