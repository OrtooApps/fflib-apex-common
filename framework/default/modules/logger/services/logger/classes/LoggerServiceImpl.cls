/**
 * A simple logger that output all logs to System.debug.
 *
 * Provides a more thorough and structured output in the log.
 *
 */
public with sharing class LoggerServiceImpl implements ILoggerService
{
	// TODO: what can we output in the UI?  Flag on custom settings to decide
	// TODO: notes on testing if the logger is used - you have to set up the custom metadata first - create a test utils for it
	// TODO: implement Exception.clearContext
	// TODO: add entry point to the ortoo_Exception log
	// TODO: and use the new registerTestLoggerService in the logger test


	private static final String BLANK_LINE = '';

	public Boolean getDefaultLoggingEnabled( LoggerService.Level logLevel )
	{
		return true;
	}

	public void log( LoggerService.Level logLevel, String message )
	{
		logMessage( logLevel, message );
	}

    public void log( LoggerService.Level logLevel, String message, Id relatedSobjectId )
	{
		logMessage( logLevel, 'On ' + relatedSobjectId + ': ' + message );
	}

	public void log( Exception exceptionToLog )
	{
		log( exceptionToLog, null );
	}

	public void log( Exception exceptionToLog, Id relatedSobjectId )
	{
		if ( exceptionToLog == null )
		{
			return;
		}

		String message = String.join( genericBuildExceptionMessages( exceptionToLog, relatedSobjectId ), '\n' );

		logMessage( LoggerService.EXCEPTION_LOG_LEVEL, message );
	}

	private List<String> genericBuildExceptionMessages( Exception exceptionToLog )
	{
		return genericBuildExceptionMessages( exceptionToLog, null );
	}

	private List<String> genericBuildExceptionMessages( Exception exceptionToLog, Id relatedSobjectId )
	{
		if ( exceptionToLog instanceOf ortoo_Exception )
		{
			return buildExceptionMessages( (ortoo_Exception)exceptionToLog, relatedSobjectId );
		}
		if ( exceptionToLog instanceOf DmlException )
		{
			return buildExceptionMessages( (DmlException)exceptionToLog, relatedSobjectId );
		}
		return buildExceptionMessages( exceptionToLog, relatedSobjectId );
	}

	private List<String> buildExceptionMessages( Exception exceptionToLog, Id relatedSobjectId )
	{
		String exceptionName = exceptionToLog.getTypeName();

		List<String> messages = new List<String>{ exceptionName + ': ' + exceptionToLog.getMessage() };
		if ( relatedSobjectId != null )
		{
			messages.add( 'Against Id: ' + relatedSobjectId );
		}
		messages.addAll( buildStackTraceMessages( exceptionToLog ) );
		messages.addAll( buildCausedByMessages( exceptionToLog ) );
		return messages;
	}

	private List<String> buildExceptionMessages( DmlException exceptionToLog, Id relatedSobjectId )
	{
		String exceptionName = exceptionToLog.getTypeName();

		List<String> messages = new List<String>{ exceptionName + ': ' + exceptionToLog.getMessage() };

		if ( relatedSobjectId != null )
		{
			messages.add( 'Against Id: ' + relatedSobjectId );
		}

		Integer numberOfDmlErrors = exceptionToLog.getNumDml();
		for ( Integer i=0; i<numberOfDmlErrors; i++ )
		{
			if ( i==0 )
			{
				messages.add( BLANK_LINE );
				messages.add( 'Row details:' );
			}

			String rowMessage = i + ' - ' + exceptionToLog.getDmlType( i ) + ': ';
			if (  exceptionToLog.getDmlId( i ) != null )
			{
				rowMessage += ' Id = ' + exceptionToLog.getDmlId( i ) + ' - ';
			}
			rowMessage += exceptionToLog.getDmlMessage( i );
			messages.add( rowMessage );
		}

		messages.addAll( buildStackTraceMessages( exceptionToLog ) );
		messages.addAll( buildCausedByMessages( exceptionToLog ) );
		return messages;
	}

	private List<String> buildExceptionMessages( ortoo_Exception exceptionToLog, Id relatedSobjectId )
	{
		String exceptionName = exceptionToLog.getTypeName() + ' (' + exceptionToLog.getErrorCode() + '): ';

		List<String> messages = new List<String>{ exceptionName + exceptionToLog.getMessage() };

		if ( relatedSobjectId != null )
		{
			messages.add( 'Against Id: ' + relatedSobjectId );
		}

		ortoo_Exception.Contexts contexts = exceptionToLog.getContexts();

		Boolean first = true;
		while ( contexts.hasNext() )
		{
			if ( first )
			{
				messages.add( BLANK_LINE );
				messages.add( 'Context: ' );
				first = false;
			}
			ortoo_Exception.Context thisContext = contexts.next();
			messages.add( thisContext.getName() + ' = ' + thisContext.getValue() + ' @ ' + thisContext.getRecordPoint() );
		}

		first = true;
		for ( MessageDetail thisMessageDetail : exceptionToLog.getMessageDetails() )
		{
			if ( first )
			{
				messages.add( BLANK_LINE );
				messages.add( 'Message Detail: ' );
				first = false;
			}
			messages.add( thisMessageDetail.getFieldContext() + ' => "' + thisMessageDetail.getContent() + '" on ' + thisMessageDetail.getObjectContext() );
		}

		messages.add( BLANK_LINE );
		messages.addAll( buildStackTraceMessages( exceptionToLog ) );
		messages.addAll( buildCausedByMessages( exceptionToLog ) );
		return messages;
	}

	private List<String> buildCausedByMessages( Exception mainException )
	{
		if ( mainException.getCause() == null )
		{
			return new List<String>();
		}

		List<String> messages = new List<String>{
			BLANK_LINE,
			'Caused By:'
		};
		messages.addAll( genericBuildExceptionMessages( mainException.getCause() ) );
		return messages;
	}

	private List<String> buildStackTraceMessages( Exception exceptionToLog )
	{
		return new List<String>{
			BLANK_LINE,
			'Stack Trace:',
			exceptionToLog.getStackTraceString()
		};
	}

	private void logMessage( LoggerService.Level logLevel, String message )
	{
		System.debug( translateDebugLevel( logLevel ), message );
	}

	private LoggingLevel translateDebugLevel( LoggerService.Level logLevel )
	{
		switch on logLevel
		{
			when INFO
			{
				return LoggingLevel.INFO;
			}
			when WARN
			{
				return LoggingLevel.WARN;
			}
		}
		return LoggingLevel.ERROR;
	}
}