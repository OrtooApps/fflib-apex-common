public inherited sharing class LoggerService
{
	public enum LEVEL { Info, Warning, Error }

    public static void log( LoggerService.LEVEL logLevel, String reference, String message )
	{
		service().log( logLevel, reference, message );
	}

    public static void log( LoggerService.LEVEL logLevel, String reference, Id relatedSobjectId, String message )
	{
		service().log( logLevel, reference, relatedSobjectId, message );
	}

	public static void log( String reference, Exception exceptionToLog )
	{
		if ( exceptionToLog instanceOf DmlException )
		{
			service().log( reference, (DmlException) exceptionToLog );
		}
		if ( exceptionToLog instanceOf ortoo_Exception )
		{
			service().log( reference, (ortoo_Exception)exceptionToLog );
		}
		service().log( reference, exceptionToLog );
	}

	public static void log( String reference, DmlException exceptionToLog )
	{
		service().log( reference, exceptionToLog );
	}

	public static void log( String reference, ortoo_Exception exceptionToLog )
	{
		service().log( reference, exceptionToLog );
	}

	public static void log( String reference, Id relatedSobjectId, Exception exceptionToLog )
	{
		service().log( reference, relatedSobjectId, exceptionToLog );
	}

    private static ILoggerService service()
	{
        return (ILoggerService)Application.SERVICE.newInstance( ILoggerService.class );
    }
}