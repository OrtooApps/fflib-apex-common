/**
 * Utility class that provides core capabilities related to Services
 *
 * @group Utils
 */
 // TODO: test
public class ServiceUtils
{
	/**
	 * Logs the given exception using the LoggerService, strips the context (if it's an Ortoo Exception)
	 * and then rethrows the exception
	 *
	 * @param	Exception	The exception to log
	 */
	public static void logAndRethrow( Exception exceptionToLog )
	{
		Contract.requires( exceptionToLog != null, 'logAndRethrow called with a null exceptionToLog' );

		LoggerService.log( exceptionToLog );

		if ( exceptionToLog instanceOf ortoo_Exception )
		{
			((ortoo_Exception)exceptionToLog).stripContexts();
		}
		throw exceptionToLog;
	}
}