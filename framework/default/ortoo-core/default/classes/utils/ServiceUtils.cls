/**
 * Utility class that provides core capabilities related to Services
 *
 * @group Utils
 */
public class ServiceUtils
{
	/**
	 * Logs the given exception using the LoggerService, strips the context (if it's an Ortoo Exception)
	 * and then rethrows the exception.
	 *
	 * Note: will not log Exceptions.ValidationException
	 *
	 * @param	Exception	The exception to log
	 */
	public static void logAndRethrow( Exception exceptionToLog )
	{
		Contract.requires( exceptionToLog != null, 'logAndRethrow called with a null exceptionToLog' );

		if ( shouldBeLogged( exceptionToLog ) )
		{
			LoggerService.log( exceptionToLog );
		}

		stripContexts( exceptionToLog );
		throw exceptionToLog;
	}

	private static Boolean shouldBeLogged( Exception exceptionToLog )
	{
		return ! (exceptionToLog instanceOf Exceptions.ValidationException);
	}

	private static void stripContexts( Exception exceptionToLog )
	{
		if ( exceptionToLog instanceOf ortoo_Exception )
		{
			((ortoo_Exception)exceptionToLog).stripContexts();
		}
	}
}