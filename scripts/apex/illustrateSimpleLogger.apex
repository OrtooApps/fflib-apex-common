List<Id> ids = new List<Id>{
	'0032D00000WOOuw',
	'0032D00000WOOux',
	'0032D00000WOOuy',
	'0032D00000WOOuz'
};

System.debug( 'Simple log messages' );
System.debug( '' );
LoggerService.log( LoggerService.Level.INFO, 'This is an info message' );
LoggerService.log( LoggerService.Level.WARN, 'This is a warning message' );
LoggerService.log( LoggerService.Level.ERROR, 'This is an error message' );

System.debug( '' );
System.debug( 'Log messages with a related SObject' );
System.debug( '' );
LoggerService.log( LoggerService.Level.INFO, 'This is an info message', ids[0] );
LoggerService.log( LoggerService.Level.WARN, 'This is a warning message', ids[0] );
LoggerService.log( LoggerService.Level.ERROR, 'This is an error message', ids[0] );

System.debug( '' );
System.debug( 'Log of DML Exception with an Id' );
System.debug( '' );
try
{
	update new Contact( Id = ids[0] );
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
	update new List<Contact>{
		new Contact( Id = ids[0] ),
		new Contact( Id = ids[1] ),
		new Contact( Id = ids[2] )
	};
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
	insert new List<Contact>{
		new Contact(),
		new Contact(),
		new Contact()
	};
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
	LoggerService.log( e, ids[0] );
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


System.debug( '' );
System.debug( 'Log of Ortoo Exception with causedBy' );
System.debug( '' );
try
{
	OrtooExceptionThrower thrower = new OrtooExceptionThrower();
	thrower.throwExceptionWithCausedBy();
}
catch ( ortoo_Exception e )
{
	LoggerService.log( e );
}

class OrtooExceptionThrower
{
	DmlException dmlExceptionThrown
	{
		get {
			try
			{
				update new List<Contact>{
					new Contact( Id = ids[0] ),
					new Contact( Id = ids[1] ),
					new Contact( Id = ids[2] ),
					new Contact( Id = ids[3] )
				};
			}
			catch ( DmlException e )
			{
				return e;
			}
			return null;
		}
	}

	public void throwException()
	{
		throw new Exceptions.DeveloperException( 'This is a developer exception' )
			.setErrorCode( '12345' )
			.addContext( 'id', ids[0] )
			.addContext( 'otherThing', 'thingvalue' )
			.setMessageDetails( new List<MessageDetail>{
				new MessageDetail( new Contact( LastName = 'thingthatwentwrong' ), Contact.LastName, 'The last name went wrong' )
			});
	}

	public void throwExceptionWithCausedBy()
	{
		throw new Exceptions.DeveloperException( 'This is a developer exception', dmlExceptionThrown )
			.setErrorCode( '12345' )
			.addContext( 'id', ids[0] )
			.addContext( 'otherThing', 'thingvalue' )
			.setMessageDetails( new List<MessageDetail>{
				new MessageDetail( new Contact( LastName = 'thingthatwentwrong' ), Contact.LastName, 'The last name went wrong' )
			});
	}
}