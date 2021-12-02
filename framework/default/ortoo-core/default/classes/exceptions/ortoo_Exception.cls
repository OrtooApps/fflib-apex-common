/**
 * The standard generic exception that all exceptions in an implemented app should indirectly extend.
 * See the class library Exceptions.
 *
 * Provides standard functionality that takes into account the Ortoo standards, including:
 * 	* The ability to specify an Error Code against the exception.
 * 	* Ensuring that the Stack Trace string is always properly set.
 * 	* Ability to retrieve a StackTrace object in order to interrogate the Exception context.
 *
 * @group Exceptions
 */
public virtual class ortoo_Exception extends Exception implements IRenderableMessageHeader
{
	String errorCode;
	String stackTraceString = createStackTraceString( 1 ); // need to pass an extra level in since the first level is <init>
	Contexts contexts = new Contexts();
	List<MessageDetail> messageDetails = new List<MessageDetail>();

	/**
	 * Set the error code that represents this type of exception
	 *
	 * @param	String			The Error Code for this Exception
	 * @return	ortoo_Exception	Itself, allowing for a fluent interface
	 */
	public ortoo_Exception setErrorCode( String errorCode )
	{
		this.errorCode = resolveErrorCode( errorCode );
		return this;
	}

	/**
	 * Get the error code that represents this type of exception
	 *
	 * @return	String			The Error Code for this Exception
	 */
	public String getErrorCode()
	{
		return errorCode;
	}

	/**
	 * Overridden in order to further resolve an error code.
	 *
	 * For example, allows for a prefix to be added to an error code.
	 *
	 * Is essentially a template method that affects the behaviour of 'setErrorCode'
	 *
	 * @param	String	The Error Code to resolve
	 * @return	String	The resolved version of the Error Code
	 */
	protected virtual String resolveErrorCode( String errorCode )
	{
		return errorCode;
	}

	/**
	 * Get the error code.
	 *
	 * Presented as not specific to errors in order to conform to the IRenderableMessageHeader interface,
	 * which is not specific to exceptions / errors.
	 *
	 * @return	String			The Error Code for this Exception
	 */
	public String getCode()
	{
		return getErrorCode();
	}

	/**
	 * Get the severity of this 'message', which is always an Error.
	 *
	 * Implemented in order to conform to the IRenderableMessageHeader interface,
	 * which is not specific to exceptions / errors.
	 *
	 * @return	String			The Error Code for this Exception
	 */
	public MessageRendererEngine.Severity getSeverity()
	{
		return MessageRendererEngine.Severity.Error;
	}

	/**
	 * Override for returning the stack trace string for this exception.
	 *
	 * Ensures that the stack trace string is returned correctly in all contexts, working
	 * around a Salesforce bug, particularly related to anonymous apex.
	 *
	 * @return	String	The stack trace string for this exception
	 */
	public override String getStackTraceString()
	{
		return stackTraceString;
	}

	/**
	 * Returns an object that represents the stack trace for this exception
	 *
	 * @return	StackTrace	The stack trace for this exception
	 */
	public StackTrace getStackTrace()
	{
		return new StackTrace( this );
	}

	/**
	 * Add a name / value pair to the context of this Exception.
	 * Allows structured information to be added to the Exception as it propagates through the stack.
	 * When the context is added, a StackTraceEntry is added that pinpoints the place in the code that added that context.
	 *
	 * @param	String			The name of the property that is being added as context
	 * @param	Object			The value of the property to store
	 * @return	ortoo_Exception	Itself, allowing for a fluent interface
	 */
	public ortoo_Exception addContext( String name, Object value )
	{
		contexts.add( name, value, 1 );
		return this;
	}

	/**
	 * Returns the contexts that have been added to this exception
	 *
	 * @return	Contexts	The contexts
	 */
	public Contexts getContexts()
	{
		return contexts;
	}

	/**
	 * Sets the message details for this exception (e.g. validation errors)
	 *
	 * @param	List<MessageDetail>	The list of message details for this exception
	 * @return  ortoo_Exception		Itself, allowing for a fluent interface
	 */
	public ortoo_Exception setMessageDetails( List<MessageDetail> messageDetails )
	{
		Contract.requires( messageDetails != null, 'setMessageDetails called with a null messageDetails' );
		this.messageDetails = messageDetails;
		return this;
	}

	/**
	 * Returns the message details for this exception.
	 *
	 * @return	List<MessageDetail>	The list of message details for this exception
	 */
	public List<MessageDetail> getMessageDetails()
	{
		Contract.ensures( this.messageDetails != null, 'getMessageDetails returned with a null messageDetails' );
		return this.messageDetails;
	}

	/**
	 * Returns the object contexts this exception.
	 * That is, the object contexts that are defined against any MessageDetail objects.
	 *
	 * @return	List<MessageDetail>	The list of message details for this exception
	 */
	public List<Sobject> getObjectContexts()
	{
		Contract.requires( this.messageDetails != null, 'getObjectContexts called with when this.messageDetails was null' );

		Set<Sobject> objectContexts = new Set<Sobject>();
		for ( MessageDetail thisMessageDetail : messageDetails )
		{
			if ( thisMessageDetail.getObjectContext() != null )
			{
				objectContexts.add( thisMessageDetail.getObjectContext() );
			}
		}

		List<Sobject> returnList = new List<Sobject>( objectContexts );
		Contract.ensures( returnList != null, 'getObjectContexts returned with a null returnList' );
		return returnList;
	}

	private String createStackTraceString( Integer levelsToSkip )
	{
		return new StackTrace( levelsToSkip+1 ).getFullStackTraceString();	// Since custom exceptions have some problems getting their stack trace strings set,
																			// we need to get the Stack Trace string from the generic utility, stating that the top
																			// level method (this one) should be ignored.
	}

	/**
	 * Defines a list of Contexts, providing the ability to add new Contexts and retrieve them
	 */
	public inherited sharing class Contexts implements Iterable<Context>, Iterator<Context>
	{
		List<Context> contexts = new List<Context>();
		Integer currentIndex = 0;

		private Contexts add( String name, Object value, Integer skipStackLevels )
		{
			this.contexts.add( new Context( name, value, skipStackLevels + 1 ) );
			return this;
		}

		/**
		 * Implementation of the iterator / iterable interfaces
		 */
		public Iterator<Context> iterator()
		{
			return this;
		}

		/**
		 * Returns the number of context entries
		 *
		 * @return	Integer	The number of context entries
		 */
		public Integer size()
		{
			return contexts.size();
		}

		/**
		 * Resets the iterator index
		 *
		 * @return	Contexts	Itself, allowing for a fluent interface
		 */
		public Contexts resetIndex()
		{
			currentIndex = 0;
			return this;
		}

		/**
		 * States if there is another context entry at the current index
		 * Implementation of the iterator / iterable interfaces
		 *
		 * @return	Boolean	States if there is another context entry at the current index
		 */
		public Boolean hasNext()
		{
			return currentIndex < contexts.size();
		}

		/**
		 * Returns the entry at the current index and then moves the index onto the next entry
		 * Implementation of the iterator / iterable interfaces
		 *
		 * @return	Context	The Context at the current index's position
		 */
		public Context next()
		{
			if ( ! hasNext() )
			{
				throw new NoSuchElementException();
			}

			return contexts[ currentIndex++ ];
		}
	}

	/**
	 * Defines a single Context entry, describing a name / value pair and the point in the code where it was added
	 */
	public inherited sharing class Context
	{
		String name  { get; private set; }
		Object value { get; private set; }
		StackTrace.StackTraceEntry recordPoint { get; private set; }

		private Context( String name, Object value, Integer skipStackLevels )
		{
			Contract.requires( name != null, 'Context instantiated with a null name' );
			Contract.requires( skipStackLevels != null, 'Context instantiated with a null skipStackLevels' );

			this.name  = name;
			this.value = value;
			this.recordPoint = new StackTrace( skipStackLevels + 1 ).getInnermostStackTraceEntry();
		}

		/**
		 * Returns the name for this Context
		 *
		 * @return	String	The name for the context
		 */
		public String getName()
		{
			Contract.ensures( name != null, 'getName returned with a null name' );
			return name;
		}

		/**
		 * Returns the value for this Context
		 *
		 * @return	String	The value for the context
		 */
		public Object getValue()
		{
			return value;
		}

		/**
		 * Returns the point in the code that this context was added in
		 *
		 * @return	StackTrace.StackTraceEntry The point in the code that this context was added in
		 */
		public StackTrace.StackTraceEntry getRecordPoint()
		{
			Contract.ensures( recordPoint != null, 'getRecordPoint returned with a null recordPoint' );
			return recordPoint;
		}
	}
}