/**
 * Representation of a StackTrace that provides the capability to interrogate it for more structured information.
 * @group Exceptions/Utils
 */
public class StackTrace {

	String stackTraceString = '';
	List<StackTraceEntry> stackTraceEntries = new List<StackTraceEntry>();

	/**
	 * Constructor - builds a Stack Trace based on the context of the point in the code at which the call to construct was made.
	 */
	public StackTrace()
	{
		this( 1 ); // we skip a single level since this constructor will add a line to the stack
	}

	/**
	 * Constructor - builds a Stack Trace based on the current context, skipping the specified number of levels at the top of the stack trace.
	 *
	 * @param	Integer	The number of levels to skip at the top of the stack trace
	 */
	public StackTrace( Integer skipLevels )
	{
		this( new DmlException(), ( skipLevels == null  || skipLevels < 0 ) ? 1 : skipLevels + 1 ); // Add 1 on to the number of levels being skipped to take into account this method, which will add a line to the stack
	}

	/**
	 * Constructor - builds a Stack Trace based on the exception passed in.  Will take the stack from that exception, in its entirety.
	 *
	 * @param	Exception	The Exception to retrieve the stack trace string from
	 */
	public StackTrace( Exception exceptionForTrace )
	{
		this( exceptionForTrace, 0 );
	}

	/**
	 * Constructor - builds a Stack Trace based on the exception passed in, skipping the specified number of levels from the top of the stack.
	 *
	 * @param	Exception	The Exception to retrieve the stack trace string from
	 * @param	Integer		The number of levels to skip at the top of the stack trace
	 */
	public StackTrace( Exception exceptionForTrace, Integer skipLevels )
	{
		this( exceptionForTrace?.getStackTraceString(), skipLevels );
	}

	/**
	 * Constructor - builds a Stack Trace based on the raw stack trace string, skipping the specified number of levels from the top of the stack.
	 *
	 * @param	String		The raw stack trace that should be used for building that StackTrace
	 * @param	Integer		The number of levels to skip at the top of the stack trace
	 */
	@testVisible
	private StackTrace( String rawStackTraceString, Integer skipLevels )
	{
		if (  skipLevels == null || skipLevels < 0 )
		{
			skipLevels = 0;
		}
		stackTraceString = trimStackTraceString( rawStackTraceString, skipLevels );
		buildStackTraceEntries();
	}

	/**
	 * Returns the full stack trace string, as is appropriate for this Stack Trace
	 *
	 * @return	String	The full stack trace string
	 */
	public String getFullStackTraceString()
	{
		return stackTraceString;
	}

	/**
	 * Returns the name of the class that the innermost method call was made against
	 * Usually, the class that the call stack was constructed in, or for.
	 *
	 * @return	String	The name of the innermost class
	 */
	public String getInnermostClassName()
	{
		return getInnermostStackTraceEntry()?.getClassName();
	}

	/**
	 * Returns the name of the innermost method call on the call stack.
	 * Usually, the method that the call stack was constructed in, or for.
	 *
	 * @return	String	The name of the innermost method call
	 */
	public String getInnermostMethodName()
	{
		return getInnermostStackTraceEntry()?.getMethodName();
	}

	/**
	 * Returns the line number of the innermost method call on the call stack.
	 * Usually, the method that the call stack was constructed in, or for.
	 *
	 * @return	String	The line number of the innermost method call
	 */
	public Integer getInnermostLineNumber()
	{
		return getInnermostStackTraceEntry()?.getLineNumber();
	}

	/**
	 * Returns the column number of the innermost method call on the call stack.
	 * Usually, the method that the call stack was constructed in, or for.
	 *
	 * @return	String	The column number of the innermost method call
	 */
	public Integer getInnermostColumnNumber()
	{
		return getInnermostStackTraceEntry()?.getColumnNumber();
	}

	/**
	 * Returns the name of the class that the outermost method call was made against
	 * AKA, the entry point into Apex
	 *
	 * @return	String	The name of the entry class
	 */
	public String getEntryClassName()
	{
		return getEntryStackTraceEntry()?.getClassName();
	}

	/**
	 * Returns the name of that the outermost method call was made against
	 * AKA, the entry point into Apex
	 *
	 * @return	String	The name of the entry method
	 */
	public String getEntryMethodName()
	{
		return getEntryStackTraceEntry()?.getMethodName();
	}

	/**
	 * Returns the name of the service class that the outermost service method call was made against
	 * AKA, the entry point into the Services layer
	 *
	 * @return	String	The name of the entry service class
	 */
	public String getEntryServiceClassName()
	{
		return getEntryServiceStackTraceEntry()?.getClassName();
	}

	/**
	 * Returns the name of that the outermost method call was made against
	 * AKA, the entry point into the Services layer
	 *
	 * @return	String	The name of the entry service method
	 */
	public String getEntryServiceMethodName()
	{
		return getEntryServiceStackTraceEntry()?.getMethodName();
	}

	/**
	 * Returns the stack trace entry for the innermost method call on the call stack.
	 * Usually, the point in the code that the call stack was constructed in, or for.
	 *
	 * @return	StackTraceEntry	The Stack Trace Entry
	 */
	public StackTraceEntry getInnermostStackTraceEntry()
	{
		if ( stackTraceEntries.isEmpty() )
		{
			return new StackTraceEntry();
		}
		return stackTraceEntries[0];
	}

	@testVisible
	private StackTraceEntry getEntryStackTraceEntry()
	{
		if ( stackTraceEntries.isEmpty() )
		{
			return new StackTraceEntry();
		}
		return stackTraceEntries[ stackTraceEntries.size() - 1 ];
	}

	private StackTraceEntry getEntryServiceStackTraceEntry()
	{
		for ( Integer i = stackTraceEntries.size()-1; i>=0; i-- )
		{
			if ( stackTraceEntries[ i ].getIsCallingAService() )
			{
				return stackTraceEntries[ i ];
			}
		}
		return new StackTraceEntry();
	}

	/**
	 * Given a Stack Trace String and a number of levels to skip, will return a reduced version of it
	 * with the correct number of levels having been skipped.
	 *
	 * @param	String	The original, raw stack trace string that should be tidied
	 * @param	Integer	The number of levels to skip at the start of the stack trace
	 * @return	String	The tidied Stack Trace String
	 */
	private static String trimStackTraceString( String stackTraceString, Integer skipLevels )
	{
		Integer i = 0;
		while ( i < skipLevels )
		{
			if ( isLastLineOfAStack( stackTraceString ) )
			{
				stackTraceString = '';
				break;
			}
			stackTraceString = stackTraceString.substringAfter( '\n' );
			i++;
		}

		if ( stackTraceString.startsWith( 'External entry point\n' ) )
		{
			stackTraceString = stackTraceString.substringAfter( '\n' );
		}
		return stackTraceString;
	}

	private void buildStackTraceEntries()
	{
		List<String> traceLines = stackTraceString.split( '\n' );
		for ( String thisLine : traceLines )
		{
			if ( isAStackTraceCallLine( thisLine ) )
			{
				stackTraceEntries.add( new StackTraceEntry( thisLine ) );
			}
		}
	}

	/**
	 * Examines the given stack trace string to see if it is the last line of a stack
	 *
	 * @param	String	The stack trace text to examine
	 * @return	Boolean	States if the given string represents the last line of a stack trace
	 */
	private static Boolean isLastLineOfAStack( String stackTraceString )
	{
		return stackTraceString.countMatches( '\n' ) == 0;
	}

	// would be on StackTraceEntry if Apex allowed it
	private static Boolean isAStackTraceCallLine( String lineToTest )
	{
		return lineToTest.startsWith( 'Class.' );
	}

	public class StackTraceEntry
	{
		String stackTraceLine;

		public StackTraceEntry()
		{
			this( null );
		}

		public StackTraceEntry( String stackTraceLine )
		{
			this.stackTraceLine = stackTraceLine;
		}

		public String getMethodName()
		{
			if ( stackTraceLine == null )
			{
				return 'Unknown';
			}
			return stackTraceLine.substringBefore( ':' ).substringAfterLast( '.' );
		}

		public String getClassName()
		{
			if ( stackTraceLine == null )
			{
				return 'Unknown';
			}
			return stackTraceLine.substringAfter( 'Class.' ).substringBefore( ':' ).substringBeforeLast( '.' );
		}

		public Integer getLineNumber()
		{
			if ( stackTraceLine == null )
			{
				return null;
			}
			return Integer.valueOf( stackTraceLine.substringAfter( ': line ').substringBefore( ',' ) );
		}

		public Integer getColumnNumber()
		{
			if ( stackTraceLine == null )
			{
				return null;
			}
			return Integer.valueOf( stackTraceLine.substringAfter( ', column ') );
		}

		public Boolean getIsCallingAService()
		{
			return Application.SERVICE.isRegisteredAsAnImplementation( getClassName() );
		}
	}
}