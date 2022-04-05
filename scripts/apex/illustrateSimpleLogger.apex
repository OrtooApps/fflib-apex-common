System.debug( 'Simple log messages' );
System.debug( '' );
LoggerService.log( LoggerService.LEVEL.Info, 'SimpleLog', 'This is an info message' );
LoggerService.log( LoggerService.LEVEL.Warning, 'SimpleLog', 'This is a warning message' );
LoggerService.log( LoggerService.LEVEL.Error, 'SimpleLog', 'This is an error message' );

System.debug( '' );
System.debug( 'Log messages with a related SObject' );
System.debug( '' );
LoggerService.log( LoggerService.LEVEL.Info, 'LogWSobj', '0032D00000WOOux', 'This is an info message' );
LoggerService.log( LoggerService.LEVEL.Warning, 'LogWSobj', '0032D00000WOOux', 'This is a warning message' );
LoggerService.log( LoggerService.LEVEL.Error, 'LogWSobj', '0032D00000WOOux', 'This is an error message' );

System.debug( '' );
System.debug( 'Log of DML Exception with an Id' );
System.debug( '' );
try
{
	update new Contact( Id = '0032D00000WOOux' );
}
catch ( DmlException e )
{
	LoggerService.log( 'DmlExLog', e );
}

System.debug( '' );
System.debug( 'Log of DML Exceptionm, handled with Exception with an Id' );
System.debug( '' );
try
{
	update new Contact( Id = '0032D00000WOOux' );
}
catch ( Exception e )
{
	LoggerService.log( 'DmlExAsExLog', e );
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
	LoggerService.log( 'DmlExLogNoId', e );
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
	LoggerService.log( 'DmlExAsExLogNoId', e );
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
	LoggerService.log( 'SystemEx', e );
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
	LoggerService.log( 'SystemExWithId', '0032D00000WOOux', e );
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
	LoggerService.log( 'OrtooEx', e );
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
	LoggerService.log( 'OrtooExAsEx', e );
}

class OrtooExceptionThrower
{
	public void throwException()
	{
		throw new Exceptions.DeveloperException( 'This is a developer exception' )
			.setErrorCode( '12345' )
			.addContext( 'id', '0032D00000WOOux' )
			.addContext( 'otherThing', 'thingvalue' )
			.setMessageDetails( new List<MessageDetail>{
				new MessageDetail( new Contact( LastName = 'thingthatwentwrong' ), Contact.LastName, 'The last name went wrong' )
			});
	}
}