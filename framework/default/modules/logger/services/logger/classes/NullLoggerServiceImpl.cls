/**
 * An implementation of a logger that does nothing.
 * This is the fallback logger that is used if the default or configured logger cannot be instantiated
 */
public inherited sharing class NullLoggerServiceImpl implements ILoggerService
{
    public void log( LoggerService.Level logLevel, String message ) {} // NOPMD: is a null implementation
    public void log( LoggerService.Level logLevel, String message, Id relatedSobjectId ) {} // NOPMD: is a null implementation
	public void log( Exception exceptionToLog ) {} // NOPMD: is a null implementation
	public void log( Exception exceptionToLog, Id relatedSobject ) {} // NOPMD: is a null implementation
	public void log( DmlException exceptionToLog ) {} // NOPMD: is a null implementation
	public void log( ortoo_Exception exceptionToLog ) {} // NOPMD: is a null implementation
}