/**
 * Provides a mechanism for performing a windowed, ordered search against an object as
 * defined by the passed searchConfigurationType.
 */
public with sharing class SimpleLoggerServiceImpl implements ILoggerService
{
	// TODO: should we have a custom metadata record?  Or should this be LoggerServiceImpl?
	// TODO: should we output more from the standard exceptions?
	// TODO: what can we output in the UI?  Flag on custom settings to decide
	// TODO: check limits for shipping custom settings in managed package
	//
    public void log( LoggerService.Level logLevel, String message )
	{
		logMessage( logLevel, message );
	}

    public void log( LoggerService.Level logLevel, String message, Id relatedSobjectId )
	{
		logMessage( logLevel, relatedSObjectId, message );
	}

	public void log( Exception exceptionToLog )
	{
		String exceptionName = exceptionToLog.getTypeName();
		logMessage( LoggerService.EXCEPTION_LOG_LEVEL, exceptionName, exceptionToLog.getMessage() );
		logMessage( LoggerService.EXCEPTION_LOG_LEVEL, exceptionName + '.stackTrace', exceptionToLog.getStackTraceString() );
		logCausedByFor( exceptionToLog );
	}

	public void log( DmlException exceptionToLog )
	{
		String exceptionName = exceptionToLog.getTypeName();
		logMessage( LoggerService.EXCEPTION_LOG_LEVEL, exceptionName, exceptionToLog.getDmlId(0), exceptionToLog.getMessage() );
		logMessage( LoggerService.EXCEPTION_LOG_LEVEL, exceptionName + '.stackTrace', exceptionToLog.getStackTraceString() );
		logCausedByFor( exceptionToLog );
	}

	public void log( ortoo_Exception exceptionToLog )
	{
		String exceptionName = exceptionToLog.getTypeName() + ' (' + exceptionToLog.getErrorCode() + ')';
		logMessage( LoggerService.EXCEPTION_LOG_LEVEL, exceptionName, exceptionToLog.getMessage() );

		ortoo_Exception.Contexts contexts = exceptionToLog.getContexts();
		while ( contexts.hasNext() )
		{
			ortoo_Exception.Context thisContext = contexts.next();
			// Put this into toString on Context?
			logMessage( LoggerService.EXCEPTION_LOG_LEVEL, exceptionName + '.context', thisContext.getName() + ' = ' + thisContext.getValue() + ' @ ' + thisContext.getRecordPoint() );
		}

		for ( MessageDetail thisMessageDetail : exceptionToLog.getMessageDetails() )
		{
			// Put this into toString on MessageDetail?
			logMessage( LoggerService.EXCEPTION_LOG_LEVEL, exceptionName + '.messageDetail', thisMessageDetail.getFieldContext() + ' => "' + thisMessageDetail.getContent() + '" on ' + thisMessageDetail.getObjectContext() );
		}

		logMessage( LoggerService.EXCEPTION_LOG_LEVEL, exceptionName + '.stackTrace', exceptionToLog.getStackTraceString() );
		logCausedByFor( exceptionToLog );
	}

	public void log( Exception exceptionToLog, Id relatedSobjectId )
	{
		String exceptionName = ObjectUtils.getClassName( exceptionToLog );
		logMessage( LoggerService.EXCEPTION_LOG_LEVEL, exceptionName, relatedSobjectId, exceptionToLog.getMessage() );
		logMessage( LoggerService.EXCEPTION_LOG_LEVEL, exceptionName + '.stackTrace', exceptionToLog.getStackTraceString() );
		logCausedByFor( exceptionToLog );
	}

	private void logMessage( LoggerService.Level logLevel, String message )
	{
		System.debug( translateDebugLevel( logLevel ), message );
	}

	private void logMessage( LoggerService.Level logLevel, Id relatedSobjectId, String message )
	{
		logMessage( logLevel, 'On ' + relatedSobjectId, message );
	}

	private void logMessage( LoggerService.Level logLevel, String reference, String message )
	{
		logMessage( logLevel, reference + ': ' + message );
	}

	private void logMessage( LoggerService.Level logLevel, String reference, Id relatedSobjectId, String message )
	{
		if ( relatedSobjectId != null )
		{
			logMessage( logLevel, reference +  ' on ' + relatedSobjectId, message );
		}
		else
		{
			logMessage( logLevel, reference, message );
		}
	}

	private void logCausedByFor( Exception mainException )
	{
		String exceptionName = mainException.getTypeName();
		if ( mainException.getCause() != null )
		{
			logMessage( LoggerService.EXCEPTION_LOG_LEVEL, exceptionName, 'Caused By' );
			log( mainException.getCause() );
		}
	}

	private LoggingLevel translateDebugLevel( LoggerService.Level logLevel )
	{
		switch on logLevel
		{
			when INFO
			{
				return LoggingLevel.INFO;
			}
			when WARNING
			{
				return LoggingLevel.WARN;
			}
		}
		return LoggingLevel.ERROR;
	}
}