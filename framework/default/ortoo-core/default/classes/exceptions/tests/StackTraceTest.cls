@isTest
private without sharing class StackTraceTest
{
	@isTest
	private static void constructor_whenGivenNoParameters_willBuildAStackTraceForWhereItWasConstructed() // NOPMD: Test method name format
	{
		Test.startTest();
			StackTrace trace = constructWithNoParameters();
		Test.stopTest();

		System.assertEquals( 'constructWithNoParameters', trace.getInnermostMethodName(), 'constructor, when constructed with no parameters, will set its context as the place it was constructed' );
	}

	@isTest
	private static void constructor_whenGivenASkipLevels_willBuildAStackTraceForWhereItWasConstructedButRemovingTheSpecifiedNumberOfLevels() // NOPMD: Test method name format
	{
		Test.startTest();
			StackTrace trace = constructWithSkipLevels( 1 );
		Test.stopTest();

		System.assertEquals( 'constructor_whenGivenASkipLevels_willBuildAStackTraceForWhereItWasConstructedButRemovingTheSpecifiedNumberOfLevels', trace.getInnermostMethodName(), 'constructor, when constructed with a skip levels set, will set its content based on where it was constructed, but removing the specified number of levels' );
	}

	@isTest
	private static void constructor_whenGivenAZeroSkipLevels_willBuildAStackTraceForWhereItWasConstructed() // NOPMD: Test method name format
	{
		Test.startTest();
			StackTrace trace = constructWithSkipLevels( 0 );
		Test.stopTest();

		System.assertEquals( 'constructWithSkipLevels', trace.getInnermostMethodName(), 'constructor, when constructed with a skip levels set to zero, will set its content based on where it was constructed' );
	}

	@isTest
	private static void constructor_whenGivenANegativeSkipLevels_willBuildAStackTraceForWhereItWasConstructed() // NOPMD: Test method name format
	{
		Test.startTest();
			StackTrace trace = constructWithSkipLevels( -1 );
		Test.stopTest();

		System.assertEquals( 'constructWithSkipLevels', trace.getInnermostMethodName(), 'constructor, when constructed with a skip levels set to negative, will set its content based on where it was constructed' );
	}

	@isTest
	private static void constructor_whenGivenANullSkipLevels_willBuildAStackTraceForWhereItWasConstructed() // NOPMD: Test method name format
	{
		Integer nullSkipLevels;

		Test.startTest();
			StackTrace trace = constructWithSkipLevels( nullSkipLevels );
		Test.stopTest();

		System.assertEquals( 'constructWithSkipLevels', trace.getInnermostMethodName(), 'constructor, when constructed with a skip levels set to null, will set its content based on where it was constructed' );
	}

	@isTest
	private static void constructor_whenGivenASkipLevelsGreaterThanTheNumberOfLevels_willReturnUnknown() // NOPMD: Test method name format
	{
		Test.startTest();
			StackTrace trace = constructWithSkipLevels( 10 );
		Test.stopTest();

		System.assertEquals( 'Unknown', trace.getInnermostMethodName(), 'constructor, when given skip levels greater than the number of levels, will return Unknown' );
	}

	@isTest
	private static void constructor_whenGivenAnException_willBuildBasedOnThePassedException() // NOPMD: Test method name format
	{
		Test.startTest();
			StackTrace trace = constructWithException( new DmlException() );
		Test.stopTest();

		System.assertEquals( 'constructor_whenGivenAnException_willBuildBasedOnThePassedException', trace.getInnermostMethodName(), 'constructor, when given an exception, will build the stack trace based on the context in the passed exception' );
	}

	@isTest
	private static void constructor_whenGivenAnExceptionAndSkipLevels_willBuildBasedOnThePassedException() // NOPMD: Test method name format
	{
		Test.startTest();
			StackTrace trace = constructWithExceptionAndSkipLevels( buildException(), 1 );
		Test.stopTest();

		System.assertEquals( 'constructor_whenGivenAnExceptionAndSkipLevels_willBuildBasedOnThePassedException', trace.getInnermostMethodName(), 'constructor, when given an exception and skip levels, will build based on the passed exception, skipping the number of levels' );
	}

	@isTest
	private static void constructor_whenGivenAnExceptionAndZeroSkipLevels_willBuildBasedOnThePassedException() // NOPMD: Test method name format
	{

		Test.startTest();
			StackTrace trace = constructWithExceptionAndSkipLevels( buildException(), 0 );
		Test.stopTest();

		System.assertEquals( 'buildException', trace.getInnermostMethodName(), 'constructor, when given an exception and skip zero levels, will build based on the passed exception' );
	}

	@isTest
	private static void constructor_whenGivenAnExceptionAndNegativeSkipLevels_willBuildBasedOnThePassedException() // NOPMD: Test method name format
	{

		Test.startTest();
			StackTrace trace = constructWithExceptionAndSkipLevels( buildException(), -1 );
		Test.stopTest();

		System.assertEquals( 'buildException', trace.getInnermostMethodName(), 'constructor, when given an exception and skip zero levels, will build based on the passed exception' );
	}

	@isTest
	private static void constructor_whenGivenAnExceptionAndNullSkipLevels_willBuildBasedOnThePassedException() // NOPMD: Test method name format
	{

		Test.startTest();
			StackTrace trace = constructWithExceptionAndSkipLevels( buildException(), null );
		Test.stopTest();

		System.assertEquals( 'buildException', trace.getInnermostMethodName(), 'constructor, when given an exception and skip null levels, will build based on the passed exception' );
	}

	@isTest
	private static void getInnermostMethodName_whenCalledAgainstAnEmptyStack_willReturnUnknown() // NOPMD: Test method name format
	{
		Test.startTest();
			StackTrace trace = new StackTrace( '', 0 );
		Test.stopTest();

		System.assertEquals( 'Unknown', trace.getInnermostMethodName(), 'getInnermostMethodName, when called against an empty stack, will return Unknown' );
	}

	@isTest
	private static void getInnermostClassName_whenThereIsAStack_willReturnTheInnermostClassNameFromTheStack() // NOPMD: Test method name format
	{
		Test.startTest();
			StackTrace trace = new InnerClass().constructStackTrace();
		Test.stopTest();

		System.assertEquals( new InnerClass().className(), trace.getInnermostClassName(), 'getInnermostClassName, when there is a stack, will return the innermost class name from the stack' );
	}

	@isTest
	private static void getInnermostClassName_whenCalledAgainstAnEmptyStack_willReturnUnknown() // NOPMD: Test method name format
	{
		Test.startTest();
			StackTrace trace = new StackTrace( '', 0 );
		Test.stopTest();

		System.assertEquals( 'Unknown', trace.getInnermostClassName(), 'getInnermostClassName, when called against an empty stack, will return Unknown' );
	}

	@isTest
	private static void getInnermostLineNumber_whenThereIsAStack_willReturnTheInnermostClassNameFromTheStack() // NOPMD: Test method name format
	{
		String stackTraceString =
			  'Class.InnermostClass.aMethod: line 7, column 1\n'
			+ 'Class.MiddlingClass.anotherMethod: line 17, column 6\n'
			+ 'Class.EntryClass.entryMethod: line 27, column 11\n';

		Test.startTest();
			StackTrace trace = new StackTrace( stackTraceString, 0 );
		Test.stopTest();

		System.assertEquals( 7, trace.getInnermostLineNumber(), 'getInnermostLineNumber, when there is a stack, will return the innermost class name from the stack' );
	}

	@isTest
	private static void getInnermostLineNumber_whenCalledAgainstAnEmptyStack_willReturnNull() // NOPMD: Test method name format
	{
		Test.startTest();
			StackTrace trace = new StackTrace( '', 0 );
		Test.stopTest();

		System.assertEquals( null, trace.getInnermostLineNumber(), 'getInnermostLineNumber, when called against an empty stack, will return null' );
	}

	@isTest
	private static void getInnermostStackTraceEntry_whenThereIsAStack_willReturnTheInnermostEntryFromTheStack() // NOPMD: Test method name format
	{
		String stackTraceString =
			  'Class.InnermostClass.aMethod: line 7, column 1\n'
			+ 'Class.MiddlingClass.anotherMethod: line 17, column 6\n'
			+ 'Class.EntryClass.entryMethod: line 27, column 11\n';

		Test.startTest();
			StackTrace trace = new StackTrace( stackTraceString, 0 );
		Test.stopTest();

		StackTrace.StackTraceEntry entry = trace.getInnermostStackTraceEntry();

		System.assertEquals( trace.getInnermostClassName()   , entry.getClassName()   , 'getInnermostStackTraceEntry, when there is a stack, will return the entry for the innermost method call (checking class)' );
		System.assertEquals( trace.getInnermostMethodName()  , entry.getMethodName()  , 'getInnermostStackTraceEntry, when there is a stack, will return the entry for the innermost method call (checking method)' );
		System.assertEquals( trace.getInnermostColumnNumber(), entry.getColumnNumber(), 'getInnermostStackTraceEntry, when there is a stack, will return the entry for the innermost method call (checking column)' );
		System.assertEquals( trace.getInnermostLineNumber()  , entry.getLineNumber()  , 'getInnermostStackTraceEntry, when there is a stack, will return the entry for the innermost method call (checking line)' );
	}

	@isTest
	private static void getInnermostStackTraceEntry_whenThereIsANoStack_willReturnAnEmptyEntry() // NOPMD: Test method name format
	{
		String stackTraceString = '';

		Test.startTest();
			StackTrace trace = new StackTrace( stackTraceString, 0 );
		Test.stopTest();

		StackTrace.StackTraceEntry entry = trace.getInnermostStackTraceEntry();

		System.assertEquals( 'Unknown', entry.getClassName()   , 'getInnermostStackTraceEntry, when there is no stack, will return an empty entry (checking class)' );
		System.assertEquals( 'Unknown', entry.getMethodName()  , 'getInnermostStackTraceEntry, when there is no stack, will return an empty entry (checking method)' );
		System.assertEquals( null     , entry.getColumnNumber(), 'getInnermostStackTraceEntry, when there is no stack, will return an empty entry (checking column)' );
		System.assertEquals( null     , entry.getLineNumber()  , 'getInnermostStackTraceEntry, when there is no stack, will return an empty entry (checking line)' );
	}

	@isTest
	private static void getInnermostColumnNumber_whenThereIsAStack_willReturnTheInnermostClassNameFromTheStack() // NOPMD: Test method name format
	{
		String stackTraceString =
			  'Class.InnermostClass.aMethod: line 7, column 1\n'
			+ 'Class.MiddlingClass.anotherMethod: line 17, column 6\n'
			+ 'Class.EntryClass.entryMethod: line 27, column 11\n';

		Test.startTest();
			StackTrace trace = new StackTrace( stackTraceString, 0 );
		Test.stopTest();

		System.assertEquals( 1, trace.getInnermostColumnNumber(), 'getInnermostColumnNumber, when there is a stack, will return the innermost class name from the stack' );
	}

	@isTest
	private static void getInnermostColumnNumber_whenCalledAgainstAnEmptyStack_willReturnNull() // NOPMD: Test method name format
	{
		Test.startTest();
			StackTrace trace = new StackTrace( '', 0 );
		Test.stopTest();

		System.assertEquals( null, trace.getInnermostColumnNumber(), 'getInnermostColumnNumber, when called against an empty stack, will return null' );
	}

	@isTest
	private static void getEntryClassName_whenThereIsAStack_willReturnTheOutermostmostClassNameFromTheStack() // NOPMD: Test method name format
	{
		Test.startTest();
			StackTrace trace = new InnerClass().constructStackTrace();
		Test.stopTest();

		System.assertEquals( new StackTraceTest().className(), trace.getEntryClassName(), 'getEntryClassName, when there is a stack, will return the outermost class name from the stack' );
	}

	@isTest
	private static void getEntryClassName_whenCalledAgainstAnEmptyStack_willReturnUnknown() // NOPMD: Test method name format
	{
		Test.startTest();
			StackTrace trace = new StackTrace( '', 0 );
		Test.stopTest();

		System.assertEquals( 'Unknown', trace.getEntryClassName(), 'getEntryClassName, when called against an empty stack, will return Unknown' );
	}

	@isTest
	private static void getEntryMethodName_whenThereIsAStack_willReturnTheOutermostmostMethodNameFromTheStack() // NOPMD: Test method name format
	{
		Test.startTest();
			StackTrace trace = new InnerClass().constructStackTrace();
		Test.stopTest();

		System.assertEquals( 'getEntryMethodName_whenThereIsAStack_willReturnTheOutermostmostMethodNameFromTheStack', trace.getEntryMethodName(), 'getEntryMethodName, when there is a stack, will return the outermost method name from the stack' );
	}

	@isTest
	private static void getEntryMethodName_whenCalledAgainstAnEmptyStack_willReturnNull() // NOPMD: Test method name format
	{
		Test.startTest();
			StackTrace trace = new StackTrace( '', 0 );
		Test.stopTest();

		System.assertEquals( 'Unknown', trace.getEntryMethodName(), 'getEntryMethodName, when called against an empty stack, will return Unknown' );
	}

	@isTest
	private static void getEntryServiceClassName_whenCalledAgainstAStackWithServiceCallInIt_willReturnTheOutermostmostServiceClassNameFromTheStack() // NOPMD: Test method name format
	{
		String stackTraceString =
			  'Class.NotAServiceClass.notAServiceMethod: line 7, column 1\n'
			+ 'Class.InnerServiceClass.innerServiceMethod: line 7, column 1\n'
			+ 'Class.NotAServiceClass.notAServiceMethod: line 7, column 1\n'
			+ 'Class.OuterServiceClass.innerServiceMethod: line 7, column 1\n'
			+ 'Class.OuterServiceClass.outerServiceMethod: line 7, column 1\n'
			+ 'Class.NotAServiceClass.notAServiceMethod: line 7, column 1\n';

		Application.SERVICE
			.mockRegisterAsImplementation( 'InnerServiceClass' )
			.mockRegisterAsImplementation( 'OuterServiceClass' );

		Test.startTest();
			StackTrace trace = new StackTrace( stackTraceString, 0 );
		Test.stopTest();

		System.assertEquals( 'OuterServiceClass', trace.getEntryServiceClassName(), 'getEntryServiceClassName, when called with stack that has a service call in it, will return the outermost service class name from the stack' );
	}

	@isTest
	private static void getEntryServiceClassName_whenCalledAgainstAStackWithoutAServiceCallInIt_willReturnUnknown() // NOPMD: Test method name format
	{
		String stackTraceString =
			  'Class.NotAServiceClass.notAServiceMethod: line 7, column 1\n'
			+ 'Class.NotAServiceClass.notAServiceMethod: line 7, column 1\n'
			+ 'Class.NotAServiceClass.notAServiceMethod: line 7, column 1\n';

		Application.SERVICE
			.mockRegisterAsImplementation( 'InnerServiceClass' )
			.mockRegisterAsImplementation( 'OuterServiceClass' );

		Test.startTest();
			StackTrace trace = new StackTrace( stackTraceString, 0 );
		Test.stopTest();

		System.assertEquals( 'Unknown', trace.getEntryServiceClassName(), 'getEntryServiceClassName, when called with stack that has no service call in it, will return Unknown' );
	}

	@isTest
	private static void getEntryServiceClassName_whenCalledAgainstAnEmptyStack_willReturnNull() // NOPMD: Test method name format
	{
		String stackTraceString = '';

		Application.SERVICE
			.mockRegisterAsImplementation( 'InnerServiceClass' )
			.mockRegisterAsImplementation( 'OuterServiceClass' );

		Test.startTest();
			StackTrace trace = new StackTrace( stackTraceString, 0 );
		Test.stopTest();

		System.assertEquals( 'Unknown', trace.getEntryServiceClassName(), 'getEntryServiceClassName, when called with an empty stack, will return Unknown' );
	}

	@isTest
	private static void getEntryServiceMethodName_whenCalledAgainstAStackWithServiceCallInIt_willReturnTheOutermostmostServiceMethodNameFromTheStack() // NOPMD: Test method name format
	{
		String stackTraceString =
			  'Class.NotAServiceClass.notAServiceMethod: line 7, column 1\n'
			+ 'Class.InnerServiceClass.innerServiceMethod: line 7, column 1\n'
			+ 'Class.NotAServiceClass.notAServiceMethod: line 7, column 1\n'
			+ 'Class.OuterServiceClass.innerServiceMethod: line 7, column 1\n'
			+ 'Class.OuterServiceClass.outerServiceMethod: line 7, column 1\n'
			+ 'Class.NotAServiceClass.notAServiceMethod: line 7, column 1\n';

		Application.SERVICE
			.mockRegisterAsImplementation( 'InnerServiceClass' )
			.mockRegisterAsImplementation( 'OuterServiceClass' );

		Test.startTest();
			StackTrace trace = new StackTrace( stackTraceString, 0 );
		Test.stopTest();

		System.assertEquals( 'outerServiceMethod', trace.getEntryServiceMethodName(), 'getEntryServiceMethodName, when called with stack that has a service call in it, will return the outermost service method name from the stack' );
	}

	@isTest
	private static void getEntryServiceMethodName_whenCalledAgainstAStackWithoutAServiceCallInIt_willReturnUnknown() // NOPMD: Test method name format
	{
		String stackTraceString =
			  'Class.NotAServiceClass.notAServiceMethod: line 7, column 1\n'
			+ 'Class.NotAServiceClass.notAServiceMethod: line 7, column 1\n'
			+ 'Class.NotAServiceClass.notAServiceMethod: line 7, column 1\n';

		Application.SERVICE
			.mockRegisterAsImplementation( 'InnerServiceClass' )
			.mockRegisterAsImplementation( 'OuterServiceClass' );

		Test.startTest();
			StackTrace trace = new StackTrace( stackTraceString, 0 );
		Test.stopTest();

		System.assertEquals( 'Unknown', trace.getEntryServiceMethodName(), 'getEntryServiceMethodName, when called with stack that has no service call in it, will return Unknown' );
	}

	@isTest
	private static void getEntryServiceMethodName_whenCalledAgainstAnEmptyStack_willReturnUnknown() // NOPMD: Test method name format
	{
		String stackTraceString = '';

		Application.SERVICE
			.mockRegisterAsImplementation( 'InnerServiceClass' )
			.mockRegisterAsImplementation( 'OuterServiceClass' );

		Test.startTest();
			StackTrace trace = new StackTrace( stackTraceString, 0 );
		Test.stopTest();

		System.assertEquals( 'Unknown', trace.getEntryServiceMethodName(), 'getEntryServiceMethodName, when called with an empty stack, will return Unknown' );
	}

	private String className() {
		return String.valueOf( StackTraceTest.class );
	}

	public class StackTraceTestException extends ortoo_Exception {}

	public static StackTrace constructWithNoParameters()
	{
		return new StackTrace();
	}

	public static StackTrace constructWithSkipLevels( Integer skipLevels )
	{
		return new StackTrace( skipLevels );
	}

	public static StackTrace constructWithException( Exception stackException )
	{
		return new StackTrace( stackException );
	}

	public static StackTrace constructWithExceptionAndSkipLevels( Exception stackException, Integer skipLevels )
	{
		return new StackTrace( stackException, skipLevels );
	}

	public static StackTraceTestException buildException()
	{
		return new StackTraceTestException();
	}

	public class InnerClass {
		public StackTrace constructStackTrace()
		{
			return new StackTrace();
		}

		public String className() {
			return String.valueOf( InnerClass.class );
		}
	}
}