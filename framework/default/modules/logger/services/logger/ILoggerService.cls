public interface ILoggerService
{
    void log( LoggerService.LEVEL logLevel, String reference, String message );
    void log( LoggerService.LEVEL logLevel, String reference, Id relatedSobjectId, String message );
	void log( String reference, Exception exceptionToLog );
	void log( String reference, Id relatedSobject, Exception exceptionToLog );
	void log( String reference, DmlException exceptionToLog );
	void log( String reference, ortoo_Exception exceptionToLog );
}