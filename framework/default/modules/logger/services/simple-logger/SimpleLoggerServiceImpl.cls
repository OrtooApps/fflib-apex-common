/**
 * Provides a mechanism for performing a windowed, ordered search against an object as
 * defined by the passed searchConfigurationType.
 */
public with sharing class SimpleLoggerServiceImpl implements ILoggerService
{
	// TODO: add a stack trace in there
	// TODO: add logging level to custom settings - implement choice of log into static methods
	// TODO: should we have a custom metadata record?  Or should this be LoggerServiceImpl?
	// TODO: add resolving of the correct method to call in the static methods?
	// TODO: should we output more from the standard exceptions?
	// TODO: what can we output in the UI?  Flag on custom settings to decide
	//
    public void log( LoggerService.LEVEL logLevel, String reference, String message )
	{
		logMessage( logLevel, reference, message );
	}

    public void log( LoggerService.LEVEL logLevel, String reference, Id relatedSobjectId, String message )
	{
		logMessage( logLevel, reference, relatedSobjectId, message );
	}

	public void log( String reference, Exception exceptionToLog )
	{
		logMessage( LoggerService.LEVEL.Error, reference, ObjectUtils.getClassName( exceptionToLog ) + ': ' + exceptionToLog.getMessage() );
		logStackTrace( LoggerService.LEVEL.Error, reference, exceptionToLog.getStackTraceString() );
	}

	public void log( String reference, DmlException exceptionToLog )
	{
		logMessage( LoggerService.LEVEL.Error, reference, ObjectUtils.getClassName( exceptionToLog ) + ': ' + exceptionToLog.getDmlId(0), exceptionToLog.getMessage() );
		logStackTrace( LoggerService.LEVEL.Error, reference, exceptionToLog.getStackTraceString() );
	}

	public void log( String reference, ortoo_Exception exceptionToLog )
	{
		logMessage( LoggerService.LEVEL.Error, reference, ObjectUtils.getClassName( exceptionToLog ) + ' - ' + exceptionToLog.getErrorCode() + ': ' + exceptionToLog.getMessage() );

		ortoo_Exception.Contexts contexts = exceptionToLog.getContexts();
		while ( contexts.hasNext() )
		{
			ortoo_Exception.Context thisContext = contexts.next();
			// Put this into toString on Context?
			logMessage( LoggerService.LEVEL.Error, reference + '.context', thisContext.getName() + ' = ' + thisContext.getValue() + ' @ ' + thisContext.getRecordPoint() );
		}

		for ( MessageDetail thisMessageDetail : exceptionToLog.getMessageDetails() )
		{
			// Put this into toString on MessageDetail?
			logMessage( LoggerService.LEVEL.Error, reference + '.messageDetail', thisMessageDetail.getFieldContext() + ' => "' + thisMessageDetail.getContent() + '" on ' + thisMessageDetail.getObjectContext() );
		}

		logStackTrace( LoggerService.LEVEL.Error, reference, exceptionToLog.getStackTraceString() );
	}

	public void log( String reference, Id relatedSobjectId, Exception exceptionToLog )
	{
		logMessage( LoggerService.LEVEL.Error, reference, relatedSobjectId, ObjectUtils.getClassName( exceptionToLog ) + ' - ' + exceptionToLog.getMessage() );
		logStackTrace( LoggerService.LEVEL.Error, reference, exceptionToLog.getStackTraceString() );
	}

	private void logMessage( LoggerService.LEVEL logLevel, String reference, String message )
	{
		System.debug( logLevel + ' - ' + reference + ': ' + message );
	}

	private void logMessage( LoggerService.LEVEL logLevel, String reference, String relatedSobjectId, String message )
	{
		System.debug( logLevel + ' - ' + reference + ': ' + relatedSobjectId + ' - ' + message );
	}

	private void logStackTrace( LoggerService.LEVEL logLevel, String reference, String stackTraceString )
	{
		System.debug( logLevel + ' - ' + reference + '.stackTrace: ' + stackTraceString );
	}
}