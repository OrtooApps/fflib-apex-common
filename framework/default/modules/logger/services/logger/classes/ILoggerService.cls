public interface ILoggerService
{
    void log( LoggerService.Level logLevel, String message );
    void log( LoggerService.Level logLevel, String message, Id relatedSobjectId );
	void log( Exception exceptionToLog );
	void log( Exception exceptionToLog, Id relatedSobject );
	void log( DmlException exceptionToLog );
	void log( ortoo_Exception exceptionToLog );
}