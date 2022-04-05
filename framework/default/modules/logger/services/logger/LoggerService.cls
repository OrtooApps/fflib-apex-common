public inherited sharing class LoggerService
{
	public enum Level { INFO, WARNING, ERROR }

    public static void log( LoggerService.Level logLevel, String message )
	{
		service().log( logLevel, message );
	}

    public static void log( LoggerService.Level logLevel, String message, Id relatedSobjectId )
	{
		service().log( logLevel, message, relatedSobjectId );
	}

	public static void log( Exception exceptionToLog )
	{
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
		service().log( exceptionToLog );
	}

	public static void log( ortoo_Exception exceptionToLog )
	{
		service().log( exceptionToLog );
	}

	public static void log( Exception exceptionToLog, Id relatedSobjectId )
	{
		service().log( exceptionToLog, relatedSobjectId );
	}

    private static ILoggerService service()
	{
        return (ILoggerService)Application.SERVICE.newInstance( ILoggerService.class );
    }
}