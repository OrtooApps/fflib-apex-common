@isTest
public with sharing class ortoo_ExceptionTest {

    class SubclassedException extends ortoo_Exception {}

	@isTest
	private static void setErrorCode_willSetTheErrorCode() // NOPMD: Test method name format
	{
		Test.startTest();
			ortoo_Exception e = new ortoo_Exception();
			e.setErrorCode( 'ErrorCode' );
		Test.stopTest();

		System.assertEquals( 'ErrorCode', e.getErrorCode(), 'setErrorCode, will set the error code that is returned by getErrorCode' );
	}

	@isTest
	private static void getStackTrace_whenCalled_willReturnAStackTraceObjectBasedOnWhenTheExceptionWasConstructed() // NOPMD: Test method name format
	{
		Test.startTest();
			ortoo_Exception e = new ortoo_Exception();
			StackTrace trace = e.getStackTrace();
		Test.stopTest();

		System.assertEquals( 'getStackTrace_whenCalled_willReturnAStackTraceObjectBasedOnWhenTheExceptionWasConstructed', trace.getInnermostMethodName(), 'getStackTrace, when called, will return a stack trace based on when the exception was constructed (method name)' );
		Amoss_Asserts.assertEndsWith( 'ortoo_ExceptionTest', trace.getInnermostClassName(), 'getStackTrace, when called, will return a stack trace based on when the exception was constructed (class name)' );
	}

    @isTest
    private static void getStackTraceString_willReturnTheStackTrace()
	{
        String stackTrace;
        Test.startTest();
            try
			{
                throw new ortoo_Exception();
            }
			catch ( ortoo_Exception e )
			{
                stackTrace = e.getStackTraceString();
            }
        Test.stopTest();

        Amoss_Asserts.assertDoesNotContain( '<init>', stackTrace, 'getStackTraceString, will return the Stack Trace based on where the exception was constructed (but not the exception constructor)' );
        Amoss_Asserts.assertContains( 'ortoo_ExceptionTest.getStackTraceString_willReturnTheStackTrace', stackTrace, 'getStackTraceString, will return the Stack Trace based on where the exception was constructed' );
    }

    @isTest
    private static void getStackTraceString_whenSubclassed_willReturnTheStackTrace()
	{
        String stackTrace;
        Test.startTest();
            try
			{
                throw new SubclassedException();
            }
			catch ( SubclassedException e )
			{
                stackTrace = e.getStackTraceString();
            }
        Test.stopTest();

        Amoss_Asserts.assertDoesNotContain( '<init>', stackTrace, 'getStackTraceString, when the exception is subclassed, will return the Stack Trace based on where the exception was constructed (but not the exception constructor)' );
        Amoss_Asserts.assertContains( 'ortoo_ExceptionTest.getStackTraceString_whenSubclassed_willReturnTheStackTrace', stackTrace, 'getStackTraceString, when the exception is subclassed, will return the Stack Trace based on where the exception was constructed' );
    }

    @isTest
    private static void getStackTraceString_whenConstructionIsInsideMultipleLayers_willReturnTheStackTrace()
	{
        String stackTrace;
        Test.startTest();
            try
			{
                throwAnOrtooException();
            }
			catch ( ortoo_Exception e )
			{
                stackTrace = e.getStackTraceString();
            }
        Test.stopTest();

        Amoss_Asserts.assertDoesNotContain( '<init>', stackTrace, 'getStackTraceString, when construction is inside multiple layers of methods, will return the Stack Trace based on where the exception was raised - with each level (not the exception constructor)' );
        Amoss_Asserts.assertContains( 'ortoo_ExceptionTest.throwAnOrtooExceptionInnerMethodCall', stackTrace, 'getStackTraceString, when construction is inside multiple layers of methods, will return the Stack Trace based on where the exception was raised - with each level (method 1)' );
        Amoss_Asserts.assertContains( 'ortoo_ExceptionTest.throwAnOrtooException', stackTrace, 'getStackTraceString, when construction is inside multiple layers of methods, will return the Stack Trace based on where the exception was raised - with each level (method 2)' );
        Amoss_Asserts.assertContains( 'ortoo_ExceptionTest.getStackTraceString_whenConstructionIsInsideMultipleLayers_willReturnTheStackTrace', stackTrace, 'getStackTraceString, when construction is inside multiple layers of methods, will return the Stack Trace based on where the exception was raised - with each level (method 3)' );
    }

    @isTest
    private static void getStackTraceString_whenSubclassedAndMultipleMethods_willReturnTheStackTrace()
	{
        String stackTrace;
        Test.startTest();
            try
			{
                throwASubclassedException();
            }
			catch ( SubclassedException e )
			{
                stackTrace = e.getStackTraceString();
            }
        Test.stopTest();

        Amoss_Asserts.assertDoesNotContain( '<init>', stackTrace, 'getStackTraceString, when the exception is subclassed and there are multiple layers of methods, will return the Stack Trace based on where the exception was raised - with each level (not the exception constructor)' );
        Amoss_Asserts.assertContains( 'ortoo_ExceptionTest.throwASubclassedExceptionInnerMethodCall', stackTrace, 'getStackTraceString, when the exception is subclassed and there are multiple layers of methods, will return the Stack Trace based on where the exception was raised - with each level (method 1)' );
        Amoss_Asserts.assertContains( 'ortoo_ExceptionTest.throwASubclassedException', stackTrace, 'getStackTraceString, when the exception is subclassed and when construction is inside multiple layers of methods, will return the Stack Trace based on where the exception was raised - with each level (method 2)' );
        Amoss_Asserts.assertContains( 'ortoo_ExceptionTest.getStackTraceString_whenSubclassedAndMultipleMethods_willReturnTheStackTrace', stackTrace, 'getStackTraceString, when the exception is subclassed and there are multiple layers of methods, will return the Stack Trace based on where the exception was raised - with each level (method 3)' );
    }

    @isTest
    private static void addContext_whenCalled_willAddItToTheExceptionWithStackInfo() // NOPMD: Test method name format
    {
        ortoo_Exception e = new ortoo_Exception( 'message' );

        Test.startTest();
            e.addContext( 'ParameterName', 'ParameterValue' );
        Test.stopTest();

        ortoo_Exception.Contexts contexts = e.getContexts();

        System.assertEquals( 1, contexts.size(), 'addContext, when called, will add it to the exception with stack info' );

        ortoo_Exception.Context returnedContext = contexts.next();

        System.assertEquals( 'ParameterName' , returnedContext.getName() , 'addContext, when called, will add it to the exception, setting the name' );
        System.assertEquals( 'ParameterValue', returnedContext.getValue(), 'addContext, when called, will add it to the exception, setting the value' );

        StackTrace.StackTraceEntry contextRecordPoint = returnedContext.getRecordPoint();

        System.assertEquals( 'addContext_whenCalled_willAddItToTheExceptionWithStackInfo', contextRecordPoint.getMethodName(), 'addContext, when called, will add it to the exception, setting the record point to the method that called addContext' );
        System.assertEquals( getClassName(), contextRecordPoint.getClassName(), 'addContext, when called, will add it to the exception, setting the record point to the class that called addContext' );
    }

    @isTest
    private static void addContext_whenCalledInAnInnerClass_willAddItToTheExceptionWithStackInfo() // NOPMD: Test method name format
    {
        ortoo_Exception e = new ortoo_Exception( 'message' );

        Test.startTest();
            new ContextAdder().addContext( e, 'ParameterName', 'ParameterValue' );
        Test.stopTest();

        ortoo_Exception.Contexts contexts = e.getContexts();

        System.assertEquals( 1, contexts.size(), 'addContext, when called, will add it to the exception with stack info' );

        ortoo_Exception.Context returnedContext = contexts.next();
        StackTrace.StackTraceEntry contextRecordPoint = returnedContext.getRecordPoint();

        System.assertEquals( 'addContext', contextRecordPoint.getMethodName(), 'addContext, when called in an inner class, will add it to the exception, setting the record point to the method that called addContext' );
        System.assertEquals( new ContextAdder().getClassName(), contextRecordPoint.getClassName(), 'addContext, when called in an inner class, will add it to the exception, setting the record point to the class that called addContext' );
    }

    @isTest
    private static void contextsIteratorMethods_behaveAsAnIteratorShould() // NOPMD: Test method name format
    {
        ortoo_Exception exceptionUnderTest = new ortoo_Exception( 'message' );
        new ContextAdder().addContext( exceptionUnderTest, 'Context1', 'ParameterValue' );
        new ContextAdder().addContext( exceptionUnderTest, 'Context2', 'ParameterValue' );
        new ContextAdder().addContext( exceptionUnderTest, 'Context3', 'ParameterValue' );

        ortoo_Exception.Contexts contexts = exceptionUnderTest.getContexts();

        Boolean hasNextReturn;
        ortoo_Exception.Context returnedContext;

        hasNextReturn = contexts.hasNext();
        System.assertEquals( true, hasNextReturn, 'hasNext, where there are more in the list, will return true (1)' );

        returnedContext = contexts.next();
        System.assertEquals( 'Context1', returnedContext.getName(), 'next, when there are more in the list, will return the next one and then move to the next (1)' );

        hasNextReturn = contexts.hasNext();
        System.assertEquals( true, hasNextReturn, 'hasNext, where there are more in the list, will return true (2)' );

        returnedContext = contexts.next();
        System.assertEquals( 'Context2', returnedContext.getName(), 'next, when there are more in the list, will return the next one and then move to the next (2)' );

        hasNextReturn = contexts.hasNext();
        System.assertEquals( true, hasNextReturn, 'hasNext, where there are more in the list, will return true (3)' );

        returnedContext = contexts.next();
        System.assertEquals( 'Context3', returnedContext.getName(), 'next, when there are more in the list, will return the next one and then move to the next (3)' );

        hasNextReturn = contexts.hasNext();
        System.assertEquals( false, hasNextReturn, 'hasNext, where there are no more in the list, will return false' );

        Boolean exceptionCaught = false;
        try
        {
            contexts.next();
        } catch ( NoSuchElementException e )
        {
            exceptionCaught = true;
        }

        System.assertEquals( true, exceptionCaught, 'next, when there are no more in the list, will throw a NoSuchElementException exception' );
    }

    @isTest
    private static void contextsResetIndex_willReturnTheIndexToTheStart() // NOPMD: Test method name format
    {
        ortoo_Exception exceptionUnderTest = new ortoo_Exception( 'message' );
        new ContextAdder().addContext( exceptionUnderTest, 'Context1', 'ParameterValue' );
        new ContextAdder().addContext( exceptionUnderTest, 'Context2', 'ParameterValue' );
        new ContextAdder().addContext( exceptionUnderTest, 'Context3', 'ParameterValue' );

        ortoo_Exception.Contexts contexts = exceptionUnderTest.getContexts();

        Boolean hasNextReturn;
        ortoo_Exception.Context returnedContext;

        contexts.next();
        contexts.next();
        contexts.next();

        hasNextReturn = contexts.hasNext();
        System.assertEquals( false, hasNextReturn, 'hasNext, when there are no more in the list, will return false' );

        contexts.resetIndex();
        hasNextReturn = contexts.hasNext();

        System.assertEquals( true, hasNextReturn, 'resetIndex, when called, will return the index to the start - so hasNext will return true on a non-empty list' );

        returnedContext = contexts.next();
        System.assertEquals( 'Context1', returnedContext.getName(), 'resetIndex, when called, will return the index to the start - so next will return the first element in the list' );
    }

    @isTest
    private static void contextsIteratorMethods_behaveAsAnIteratorShould_onAnEmptyList() // NOPMD: Test method name format
    {
        ortoo_Exception exceptionUnderTest = new ortoo_Exception( 'message' );
        ortoo_Exception.Contexts contexts = exceptionUnderTest.getContexts();

        Boolean hasNextReturn;
        ortoo_Exception.Context returnedContext;

        hasNextReturn = contexts.hasNext();
        System.assertEquals( false, hasNextReturn, 'hasNext, where there are no entries in the list, will return false' );

        Boolean exceptionCaught = false;
        try
        {
            contexts.next();
        } catch ( NoSuchElementException e )
        {
            exceptionCaught = true;
        }

        System.assertEquals( true, exceptionCaught, 'next, when there are no entries in the list, will throw a NoSuchElementException exception' );
    }

    private class ContextAdder
    {
        private void addContext( ortoo_Exception e, String name, String value )
        {
            e.addContext( name, value );
        }
        private String getClassName()
        {
            return String.valueOf( ortoo_ExceptionTest.ContextAdder.class );
        }
    }

    private static void throwAnOrtooExceptionInnerMethodCall()
	{
        throw new ortoo_Exception();
    }

    private static void throwAnOrtooException()
	{
        throwAnOrtooExceptionInnerMethodCall();
    }

    private static void throwASubclassedExceptionInnerMethodCall()
	{
        throw new SubclassedException();
    }

    private static void throwASubclassedException()
	{
        throwASubclassedExceptionInnerMethodCall();
    }

    private static String getClassName()
    {
        return String.valueOf( ortoo_ExceptionTest.class );
    }
}