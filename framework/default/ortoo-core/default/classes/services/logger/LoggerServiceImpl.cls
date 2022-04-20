/**
 * A simple logger that output all logs to System.debug.
 *
 * Provides a more thorough and structured output in the log.
 *
 */
public with sharing class LoggerServiceImpl implements ILoggerService
{
	private static final String BLANK_LINE = '';

	Map<LoggerService.Level,LoggingLevel> debugLogLevels = new Map<LoggerService.Level,LoggingLevel>{
		LoggerService.Level.INFO => LoggingLevel.INFO,
		LoggerService.Level.WARN => LoggingLevel.WARN,
		LoggerService.Level.ERROR => LoggingLevel.ERROR
	};

	public Boolean getDefaultLoggingEnabled( LoggerService.Level logLevel )
	{
		return true;
	}

	public void log( LoggerService.Level logLevel, String message )
	{
		System.debug( debugLogLevels.get( logLevel ), message );
	}

    public void log( LoggerService.Level logLevel, String message, Id relatedSobjectId )
	{
		System.debug( debugLogLevels.get( logLevel ), 'On ' + relatedSobjectId + ': ' + message );
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

		System.debug( debugLogLevels.get( LoggerService.EXCEPTION_LOG_LEVEL ), message );
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

		StackTrace stackTrace = exceptionToLog.getStackTrace();

		StackTrace.StackTraceEntry entryPoint = stackTrace.getEntryStackTraceEntry();

		if ( entryPoint.isValid() )
		{
			messages.add( 'Apex Entry Point: ' + String.valueOf( entryPoint ) );
		}

		StackTrace.StackTraceEntry serviceEntryPoint = stackTrace.getEntryServiceStackTraceEntry();

		if ( serviceEntryPoint.isValid() )
		{
			messages.add( 'Service Entry Point: ' + String.valueOf( serviceEntryPoint ) );
		}

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
}