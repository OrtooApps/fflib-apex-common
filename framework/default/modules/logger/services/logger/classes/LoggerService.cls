public inherited sharing class LoggerService
{
	public enum Level { INFO, WARNING, ERROR }

	public static final Level EXCEPTION_LOG_LEVEL = Level.ERROR;

    public static void log( LoggerService.Level logLevel, String message )
	{
		if ( ! shouldLog( logLevel ) )
		{
			return;
		}

		service().log( logLevel, message );
	}

    public static void log( LoggerService.Level logLevel, String message, Id relatedSobjectId )
	{
		if ( ! shouldLog( logLevel ) )
		{
			return;
		}

		service().log( logLevel, message, relatedSobjectId );
	}

	public static void log( Exception exceptionToLog )
	{
		if ( ! shouldLogExceptions() )
		{
			return;
		}

		if ( exceptionToLog instanceOf DmlException )
		{
			service().log( (DmlException)exceptionToLog );
		}
		if ( exceptionToLog instanceOf ortoo_Exception )
		{
			service().log( (ortoo_Exception)exceptionToLog );
		}
		service().log( exceptionToLog );
	}

	public static void log( DmlException exceptionToLog )
	{
		if ( ! shouldLogExceptions() )
		{
			return;
		}

		service().log( exceptionToLog );
	}

	public static void log( ortoo_Exception exceptionToLog )
	{
		if ( ! shouldLogExceptions() )
		{
			return;
		}

		service().log( exceptionToLog );
	}

	public static void log( Exception exceptionToLog, Id relatedSobjectId )
	{
		if ( ! shouldLogExceptions() )
		{
			return;
		}

		service().log( exceptionToLog, relatedSobjectId );
	}

	private static Boolean shouldLog( LoggerService.Level logLevel )
	{
		Logging_Configuration__c config = Logging_Configuration__c.getInstance();

		switch on logLevel {
			when INFO {
				return config.Id != null ? config.Log_INFO_Level_Messages__c : false; // if no config record exists, do not log INFO
			}
			when WARNING {
				return config.Id != null ? config.Log_WARNING_Level_Messages__c : false; // if no config record exists, do not log WARNING
			}
		}
		return config.Id != null ? config.Log_ERROR_Level_Messages__c : true; // if no config record exists, still log ERROR
	}

	private static Boolean shouldLogExceptions()
	{
		return shouldLog( EXCEPTION_LOG_LEVEL );
	}

    private static ILoggerService service()
	{
        return (ILoggerService)Application.SERVICE.newInstance( ILoggerService.class );
    }
}