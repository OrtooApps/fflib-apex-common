/**
 * Provides a mechanism for performing a windowed, ordered search against an object as
 * defined by the passed searchConfigurationType.
 */
public with sharing class SimpleLoggerServiceImpl implements ILoggerService
{
	// TODO: add logging level to custom settings - implement choice of log into static methods
	// TODO: should we have a custom metadata record?  Or should this be LoggerServiceImpl?
	// TODO: should we output more from the standard exceptions?
	// TODO: what can we output in the UI?  Flag on custom settings to decide
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
		String exceptionName = ObjectUtils.getClassName( exceptionToLog );
		logMessage( LoggerService.Level.ERROR, exceptionName, exceptionToLog.getMessage() );
		logMessage( LoggerService.Level.ERROR, exceptionName + '.stackTrace', exceptionToLog.getStackTraceString() );
	}

	public void log( DmlException exceptionToLog )
	{
		String exceptionName = ObjectUtils.getClassName( exceptionToLog );
		logMessage( LoggerService.Level.ERROR, exceptionName, exceptionToLog.getDmlId(0), exceptionToLog.getMessage() );
		logMessage( LoggerService.Level.ERROR, exceptionName + '.stackTrace', exceptionToLog.getStackTraceString() );
	}

	public void log( ortoo_Exception exceptionToLog )
	{
		String exceptionName = ObjectUtils.getClassName( exceptionToLog ) + ' (' + exceptionToLog.getErrorCode() + ')';
		logMessage( LoggerService.Level.ERROR, exceptionName, exceptionToLog.getMessage() );

		ortoo_Exception.Contexts contexts = exceptionToLog.getContexts();
		while ( contexts.hasNext() )
		{
			ortoo_Exception.Context thisContext = contexts.next();
			// Put this into toString on Context?
			logMessage( LoggerService.Level.ERROR, exceptionName + '.context', thisContext.getName() + ' = ' + thisContext.getValue() + ' @ ' + thisContext.getRecordPoint() );
		}

		for ( MessageDetail thisMessageDetail : exceptionToLog.getMessageDetails() )
		{
			// Put this into toString on MessageDetail?
			logMessage( LoggerService.Level.ERROR, exceptionName + '.messageDetail', thisMessageDetail.getFieldContext() + ' => "' + thisMessageDetail.getContent() + '" on ' + thisMessageDetail.getObjectContext() );
		}

		logMessage( LoggerService.Level.ERROR, exceptionName + '.stackTrace', exceptionToLog.getStackTraceString() );
	}

	public void log( Exception exceptionToLog, Id relatedSobjectId )
	{
		String exceptionName = ObjectUtils.getClassName( exceptionToLog );
		logMessage( LoggerService.Level.ERROR, exceptionName, relatedSobjectId, exceptionToLog.getMessage() );
		logMessage( LoggerService.Level.ERROR, exceptionName + '.stackTrace', exceptionToLog.getStackTraceString() );
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