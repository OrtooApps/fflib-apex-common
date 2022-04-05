Id id = '0032D00000WOOux';

System.debug( 'Simple log messages' );
System.debug( '' );
LoggerService.log( LoggerService.Level.INFO, 'This is an info message' );
LoggerService.log( LoggerService.Level.WARNING, 'This is a warning message' );
LoggerService.log( LoggerService.Level.ERROR, 'This is an error message' );

System.debug( '' );
System.debug( 'Log messages with a related SObject' );
System.debug( '' );
LoggerService.log( LoggerService.Level.INFO, 'This is an info message', id );
LoggerService.log( LoggerService.Level.WARNING, 'This is a warning message', id );
LoggerService.log( LoggerService.Level.ERROR, 'This is an error message', id );

System.debug( '' );
System.debug( 'Log of DML Exception with an Id' );
System.debug( '' );
try
{
	update new Contact( Id = id );
}
catch ( DmlException e )
{
	LoggerService.log( e );
}

System.debug( '' );
System.debug( 'Log of DML Exceptionm, handled with Exception with an Id' );
System.debug( '' );
try
{
	update new Contact( Id = id );
}
catch ( Exception e )
{
	LoggerService.log( e );
}

System.debug( '' );
System.debug( 'Log of DML Exception without an Id' );
System.debug( '' );
try
{
	insert new Contact();
}
catch ( DmlException e )
{
	LoggerService.log( e );
}

System.debug( '' );
System.debug( 'Log of DML Exception as Exception without an Id' );
System.debug( '' );
try
{
	insert new Contact();
}
catch ( Exception e )
{
	LoggerService.log( e );
}

System.debug( '' );
System.debug( 'Log of System Exception without an Id' );
System.debug( '' );
try
{
	String value = new List<String>()[1];
}
catch ( Exception e )
{
	LoggerService.log( e );
}

System.debug( '' );
System.debug( 'Log of System Exception with an Id' );
System.debug( '' );
try
{
	String value = new List<String>()[1];
}
catch ( Exception e )
{
	LoggerService.log( e, id );
}

System.debug( '' );
System.debug( 'Log of Ortoo Exception' );
System.debug( '' );
try
{
	OrtooExceptionThrower thrower = new OrtooExceptionThrower();
	thrower.throwException();
}
catch ( ortoo_Exception e )
{
	LoggerService.log( e );
}

System.debug( '' );
System.debug( 'Log of Ortoo Exception as Exception' );
System.debug( '' );
try
{
	OrtooExceptionThrower thrower = new OrtooExceptionThrower();
	thrower.throwException();
}
catch ( Exception e )
{
	LoggerService.log( e );
}

class OrtooExceptionThrower
{
	public void throwException()
	{
		throw new Exceptions.DeveloperException( 'This is a developer exception' )
			.setErrorCode( '12345' )
			.addContext( 'id', id )
			.addContext( 'otherThing', 'thingvalue' )
			.setMessageDetails( new List<MessageDetail>{
				new MessageDetail( new Contact( LastName = 'thingthatwentwrong' ), Contact.LastName, 'The last name went wrong' )
			});
	}
}