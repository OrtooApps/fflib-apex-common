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
		System.assertEquals( 'ErrorCode', e.getCode(), 'setErrorCode, will set the error code that is returned by getCode' );
	}

	@isTest
	private static void getSeverity_willReturnError() // NOPMD: Test method name format
	{
		Test.startTest();
			ortoo_Exception e = new ortoo_Exception();
            MessageRendererEngine.Severity severity = e.getSeverity();
		Test.stopTest();

		System.assertEquals( MessageRendererEngine.Severity.Error, severity, 'getSeverity, will return error' );
	}

	@isTest
	private static void getStackTrace_whenCalled_willReturnAStackBasedOnConstruct() // NOPMD: Test method name format
	{
		Test.startTest();
			ortoo_Exception e = new ortoo_Exception();
			StackTrace trace = e.getStackTrace();
		Test.stopTest();

		System.assertEquals( 'getStackTrace_whenCalled_willReturnAStackBasedOnConstruct', trace.getInnermostMethodName(), 'getStackTrace, when called, will return a stack trace based on when the exception was constructed (method name)' );
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

        ortoo_Asserts.assertDoesNotContain( '<init>', stackTrace, 'getStackTraceString, will return the Stack Trace based on where the exception was constructed (but not the exception constructor)' );
        ortoo_Asserts.assertContains( 'ortoo_ExceptionTest.getStackTraceString_willReturnTheStackTrace', stackTrace, 'getStackTraceString, will return the Stack Trace based on where the exception was constructed' );
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

        ortoo_Asserts.assertDoesNotContain( '<init>', stackTrace, 'getStackTraceString, when the exception is subclassed, will return the Stack Trace based on where the exception was constructed (but not the exception constructor)' );
        ortoo_Asserts.assertContains( 'ortoo_ExceptionTest.getStackTraceString_whenSubclassed_willReturnTheStackTrace', stackTrace, 'getStackTraceString, when the exception is subclassed, will return the Stack Trace based on where the exception was constructed' );
    }

    @isTest
    private static void getStackTraceString_whenBuiltInsideLayers_willReturnTheStackTrace()
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

        ortoo_Asserts.assertDoesNotContain( '<init>', stackTrace, 'getStackTraceString, when construction is inside multiple layers of methods, will return the Stack Trace based on where the exception was raised - with each level (not the exception constructor)' );
        ortoo_Asserts.assertContains( 'ortoo_ExceptionTest.throwAnOrtooExceptionInnerMethodCall', stackTrace, 'getStackTraceString, when construction is inside multiple layers of methods, will return the Stack Trace based on where the exception was raised - with each level (method 1)' );
        ortoo_Asserts.assertContains( 'ortoo_ExceptionTest.throwAnOrtooException', stackTrace, 'getStackTraceString, when construction is inside multiple layers of methods, will return the Stack Trace based on where the exception was raised - with each level (method 2)' );
        ortoo_Asserts.assertContains( 'ortoo_ExceptionTest.getStackTraceString_whenBuiltInsideLayers_willReturnTheStackTrace', stackTrace, 'getStackTraceString, when construction is inside multiple layers of methods, will return the Stack Trace based on where the exception was raised - with each level (method 3)' );
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

        ortoo_Asserts.assertDoesNotContain( '<init>', stackTrace, 'getStackTraceString, when the exception is subclassed and there are multiple layers of methods, will return the Stack Trace based on where the exception was raised - with each level (not the exception constructor)' );
        ortoo_Asserts.assertContains( 'ortoo_ExceptionTest.throwASubclassedExceptionInnerMethodCall', stackTrace, 'getStackTraceString, when the exception is subclassed and there are multiple layers of methods, will return the Stack Trace based on where the exception was raised - with each level (method 1)' );
        ortoo_Asserts.assertContains( 'ortoo_ExceptionTest.throwASubclassedException', stackTrace, 'getStackTraceString, when the exception is subclassed and when construction is inside multiple layers of methods, will return the Stack Trace based on where the exception was raised - with each level (method 2)' );
        ortoo_Asserts.assertContains( 'ortoo_ExceptionTest.getStackTraceString_whenSubclassedAndMultipleMethods_willReturnTheStackTrace', stackTrace, 'getStackTraceString, when the exception is subclassed and there are multiple layers of methods, will return the Stack Trace based on where the exception was raised - with each level (method 3)' );
    }

    @isTest
    private static void regenerateStackTraceString_willCreateANewStackTraceFromTheGivenPoint()
	{
        String stackTrace;
        Test.startTest();
            try
			{
                throwASubclassedException();
            }
			catch ( SubclassedException e )
			{
                e.regenerateStackTraceString( 0 );
                stackTrace = e.getStackTraceString();
            }
        Test.stopTest();

        ortoo_Asserts.assertDoesNotContain( '<init>', stackTrace, 'regenerateStackTraceString, when called, will create a new stack trace from the given point' );
        ortoo_Asserts.assertDoesNotContain( 'ortoo_ExceptionTest.throwASubclassedExceptionInnerMethodCall', stackTrace, 'regenerateStackTraceString, when called, will create a new stack trace from the given point (method 1)' );
        ortoo_Asserts.assertDoesNotContain( 'ortoo_ExceptionTest.throwASubclassedException', stackTrace, 'regenerateStackTraceString, when called, will create a new stack trace from the given point (method 2)' );
        ortoo_Asserts.assertContains( 'ortoo_ExceptionTest.regenerateStackTraceString_willCreateANewStackTraceFromTheGivenPoint', stackTrace, 'regenerateStackTraceString, when called, will create a new stack trace from the given point (actual spot called)' );
    }

    @isTest
    private static void regenerateStackTraceString_whenPassedANumber_willCreateANewStackTraceWithLevelsSkipped()
	{
        Integer levelsToSkip = 1;

        String stackTrace;
        Test.startTest();
            try
			{
                throwASubclassedException( levelsToSkip );
            }
			catch ( SubclassedException e )
			{
                stackTrace = e.getStackTraceString();
            }
        Test.stopTest();

        ortoo_Asserts.assertDoesNotContain( 'ortoo_ExceptionTest.throwASubclassedExceptionInnerMethodCall', stackTrace, 'regenerateStackTraceString, when called with a number of levels to skipp, will create a new stack trace from the given point, skipping the specified number of levels (1st level is skipped)' );
        ortoo_Asserts.assertContains( 'ortoo_ExceptionTest.throwASubclassedException', stackTrace, 'regenerateStackTraceString, when called with a number of levels to skipp, will create a new stack trace from the given point, skipping the specified number of levels (2nd level is not skipped)' );
        ortoo_Asserts.assertContains( 'ortoo_ExceptionTest.regenerateStackTraceString_whenPassedANumber_willCreateANewStackTraceWithLevelsSkipped', stackTrace, 'regenerateStackTraceString, when called with a number of levels to skipp, will create a new stack trace from the given point, skipping the specified number of levels (3rd level is not skipped)' );
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
    private static void addContext_whenCalledInInnerClass_willAddIncludeInStack() // NOPMD: Test method name format
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

    @isTest
    private static void getMessageDetails_whenMessageDetailsAdded_willReturnThoseDetails() // NOPMD: Test method name format
    {
        ortoo_Exception exceptionUnderTest = new ortoo_Exception( 'message' );

        List<Sobject> objectContexts = new List<Sobject>
        {
            new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ),
            new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ),
            new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) )
        };

        List<MessageDetail> messageDetails = new List<MessageDetail>
                                                {
                                                    new MessageDetail( objectContexts[0], 'message1' ),
                                                    new MessageDetail( objectContexts[1], 'message2' ),
                                                    new MessageDetail( objectContexts[1], 'message3' ),
                                                    new MessageDetail( objectContexts[0], 'message4' )
                                                };

        Test.startTest();
            exceptionUnderTest.setMessageDetails( messageDetails );
            List<MessageDetail> returnedMessageDetails = exceptionUnderTest.getMessageDetails();


        Test.stopTest();

        System.assertEquals( messageDetails, returnedMessageDetails, 'getMessageDetails, when some message details have been added, will return those details' );
    }

    @isTest
    private static void getMessageDetails_whenNoMessageDetailsAdded_willReturnAnEmptyList() // NOPMD: Test method name format
    {
        ortoo_Exception exceptionUnderTest = new ortoo_Exception( 'message' );

        Test.startTest();
            List<MessageDetail> returnedMessageDetails = exceptionUnderTest.getMessageDetails();
        Test.stopTest();

        System.assertEquals( 0, returnedMessageDetails.size(), 'getMessageDetails, when no message details have been added, will return an empty list' );
    }

    @isTest
    private static void getObjectContext_whenMessageDetailsAdded_willReturnTheSobjects() // NOPMD: Test method name format
    {
        ortoo_Exception exceptionUnderTest = new ortoo_Exception( 'message' );

        List<Sobject> objectContexts = new List<Sobject>
        {
            new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ),
            new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ),
            new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) )
        };

        Test.startTest();
            exceptionUnderTest.setMessageDetails(
                new List<MessageDetail>
                {
                    new MessageDetail( objectContexts[0], 'message1' ),
                    new MessageDetail( objectContexts[1], 'message2' ),
                    new MessageDetail( objectContexts[1], 'message3' ),
                    new MessageDetail( objectContexts[0], 'message4' )
                }
            );
            List<Sobject> returnedObjectContexts = exceptionUnderTest.getObjectContexts();

        Test.stopTest();

        List<Sobject> expectedObjectContexts = new List<Sobject>{ objectContexts[0], objectContexts[1] };

        System.assertEquals( expectedObjectContexts, returnedObjectContexts, 'getObjectContext, when some message details have been added, will return those objects' );
    }

    @isTest
    private static void getObjectContext_whenNoMessageDetails_willReturnEmptySet() // NOPMD: Test method name format
    {
        ortoo_Exception exceptionUnderTest = new ortoo_Exception( 'message' );

        Test.startTest();
        List<Sobject> returnedObjectContexts = exceptionUnderTest.getObjectContexts();
        Test.stopTest();

        List<Sobject> expectedObjectContexts = new List<Sobject>();

        System.assertEquals( expectedObjectContexts, returnedObjectContexts, 'getObjectContext, when no message details have been added, will return an empty set' );
    }

    @isTest
    private static void getObjectContext_whenSomeDetailsHaveNull_willNotReturnTheNulls() // NOPMD: Test method name format
    {
        ortoo_Exception exceptionUnderTest = new ortoo_Exception( 'message' );

        List<Sobject> objectContexts = new List<Sobject>
        {
            new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ),
            new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ),
            new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) )
        };

        Test.startTest();
            exceptionUnderTest.setMessageDetails(
                new List<MessageDetail>
                {
                    new MessageDetail( objectContexts[0], 'message1' ),
                    new MessageDetail( objectContexts[2], 'message2' ),
                    new MessageDetail( 'message3' ),
                    new MessageDetail( objectContexts[0], 'message4' )
                }
            );
            List<Sobject> returnedObjectContexts = exceptionUnderTest.getObjectContexts();

        Test.stopTest();

        List<Sobject> expectedObjectContexts = new List<Sobject>{ objectContexts[0], objectContexts[2] };

        System.assertEquals( expectedObjectContexts, returnedObjectContexts, 'getObjectContext, when some message details have been added with null objects, will not return the nulls' );
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

    private static void throwASubclassedExceptionInnerMethodCall( Integer levelsToSkip )
	{
        throw new SubclassedException().regenerateStackTraceString( levelsToSkip );
    }

    private static void throwASubclassedException()
	{
        throwASubclassedExceptionInnerMethodCall();
    }

    private static void throwASubclassedException( Integer levelsToSkip )
	{
        throwASubclassedExceptionInnerMethodCall( levelsToSkip);
    }

    private static String getClassName()
    {
        return String.valueOf( ortoo_ExceptionTest.class );
    }
}