@isTest
private without sharing class MessageDetailTest
{
	@isTest
	private static void getContent_whenCalled_willReturnTheContent() // NOPMD: Test method name format
	{
		String content = 'this is the content';

		Test.startTest();
			MessageDetail message = new MessageDetail( content );
			String returnedContent = message.getContent();
		Test.stopTest();

		System.assertEquals( content, returnedContent, 'getContent, when called, will return the content' );
	}

	@isTest
	private static void getContent_whenCalledAgainstA2ParamConstructor_willReturnTheContent() // NOPMD: Test method name format
	{
		String  content = 'this is the content';
		Sobject record  = new Contact();

		Test.startTest();
			MessageDetail message = new MessageDetail( record, content );
			String returnedContent = message.getContent();
		Test.stopTest();

		System.assertEquals( content, returnedContent, 'getContent, when called against a message built with a 2 param constructor, will return the content' );
	}

	@isTest
	private static void getContent_whenCalledAgainstA3ParamConstructor_willReturnTheContent() // NOPMD: Test method name format
	{
		String       content = 'this is the content';
		Sobject      record  = new Contact();
		SobjectField field   = Contact.FirstName;

		Test.startTest();
			MessageDetail message = new MessageDetail( record, field, content );
			String returnedContent = message.getContent();
		Test.stopTest();

		System.assertEquals( content, returnedContent, 'getContent, when called against a message built with a 3 param constructor, will return the content' );
	}

	@isTest
	private static void getObjectContext_whenCalledAgainstA1ParamConstructor_willReturnNull() // NOPMD: Test method name format
	{
		String  content = 'this is the content';

		Test.startTest();
			MessageDetail message = new MessageDetail( content );
			Sobject returnedRecord = message.getObjectContext();
		Test.stopTest();

		System.assertEquals( null, returnedRecord, 'getObjectContext, when called against a message built with a 1 param constructor, will return null' );
	}

	@isTest
	private static void getObjectContext_whenCalledAgainstA2ParamConstructor_willReturnTheRecord() // NOPMD: Test method name format
	{
		String  content = 'this is the content';
		Sobject record  = new Contact();

		Test.startTest();
			MessageDetail message = new MessageDetail( record, content );
			Sobject returnedRecord = message.getObjectContext();
		Test.stopTest();

		System.assertEquals( record, returnedRecord, 'getObjectContext, when called against a message built with a 2 param constructor, will return the record' );
	}

	@isTest
	private static void getObjectContext_whenCalledAgainstA3ParamConstructor_willReturnTheRecord() // NOPMD: Test method name format
	{
		String  content 	= 'this is the content';
		Sobject record  	= new Contact();
		SobjectField field	= Contact.FirstName;

		Test.startTest();
			MessageDetail message = new MessageDetail( record, field, content );
			Sobject returnedRecord = message.getObjectContext();
		Test.stopTest();

		System.assertEquals( record, returnedRecord, 'getObjectContext, when called against a message built with a 3 param constructor, will return the record' );
	}

	@isTest
	private static void getFieldContext_whenCalledAgainstA1ParamConstructor_willReturnNull() // NOPMD: Test method name format
	{
		String  content = 'this is the content';

		Test.startTest();
			MessageDetail message = new MessageDetail( content );
			SobjectField returnedField = message.getFieldContext();
		Test.stopTest();

		System.assertEquals( null, returnedField, 'getFieldContext, when called against a message built with a 1 param constructor, will return null' );
	}

	@isTest
	private static void getFieldContext_whenCalledAgainstA2ParamConstructor_willReturnNull() // NOPMD: Test method name format
	{
		String  content = 'this is the content';
		Sobject record  = new Contact();

		Test.startTest();
			MessageDetail message = new MessageDetail( record, content );
			SobjectField returnedField = message.getFieldContext();
		Test.stopTest();

		System.assertEquals( null, returnedField, 'getFieldContext, when called against a message built with a 2 param constructor, will return null' );
	}

	@isTest
	private static void getFieldContext_whenCalledAgainstA3ParamConstructor_willReturnTheField() // NOPMD: Test method name format
	{
		String  content 	= 'this is the content';
		Sobject record  	= new Contact();
		SobjectField field	= Contact.FirstName;

		Test.startTest();
			MessageDetail message = new MessageDetail( record, field, content );
			SobjectField returnedField = message.getFieldContext();
		Test.stopTest();

		System.assertEquals( field, returnedField, 'getFieldContext, when called against a message built with a 3 param constructor, will return the field' );
	}

	@isTest
	private static void getSeverity_whenNoSeverityHasBeenSert_willReturnErrorSeverity() // NOPMD: Test method name format
	{
		MessageDetail message = new MessageDetail( 'content'  );

		System.assertEquals( MessageRendererEngine.Severity.Error, message.getSeverity(), 'getSeverity, when no severity has been set, will return error' );
	}

	@isTest
	private static void getSeverity_whenSeverityHasBeenSert_willReturnTheSeverity() // NOPMD: Test method name format
	{
		MessageDetail message = new MessageDetail( 'content'  );

		Test.startTest();
			message.setSeverity( MessageRendererEngine.Severity.Info );
		Test.stopTest();

		System.assertEquals( MessageRendererEngine.Severity.Info, message.getSeverity(), 'getSeverity, when severity has been set, will return the severity' );
	}

	@isTest
	private static void setSeverity_whenPassedNull_willThrowAnException() // NOPMD: Test method name format
	{
		MessageDetail message = new MessageDetail( 'content'  );

		Test.startTest();
			String exceptionMessage;
			try
			{
				message.setSeverity( null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'setSeverity called with a null severity', exceptionMessage, 'setSeverity, when passed null, will throw an exception' );
	}
}