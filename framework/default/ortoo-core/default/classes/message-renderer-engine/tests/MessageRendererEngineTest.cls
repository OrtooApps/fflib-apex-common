@isTest
private without sharing class MessageRendererEngineTest
{
	@isTest
	private static void render_whenNoRendererHasBeenSet_willThrowAnException() // NOPMD: Test method name format
	{
		IRenderableMessageHeader message = (IRenderableMessageHeader)new Amoss_Instance( IRenderableMessageHeader.class ).generateDouble();

		Test.startTest();
			String exceptionMessage;
			try
			{
				new MessageRendererEngine()
						.setMessage( message )
						.render();
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'render called before the renderer was set', exceptionMessage, 'render, when no renderer has been set, will throw an exception' );
	}

	@isTest
	private static void render_whenNoMessageHasBeenSet_willThrowAnException() // NOPMD: Test method name format
	{
		IMessageRenderer renderer = (IMessageRenderer)new Amoss_Instance( IMessageRenderer.class ).generateDouble();

		Test.startTest();
			String exceptionMessage;
			try
			{
				new MessageRendererEngine()
						.setRenderer( renderer )
						.render();
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'render called before the message was set', exceptionMessage, 'render, when no message has been set, will throw an exception' );
	}

	@isTest
	private static void render_whenCalledAgainstAConfiguredEngine_willCallRenderAgainstTheRenderer() // NOPMD: Test method name format
	{
		Amoss_Instance messageController = new Amoss_Instance( IRenderableMessageHeader.class );
		IRenderableMessageHeader message = (IRenderableMessageHeader)messageController.generateDouble();

		Amoss_Instance rendererController = new Amoss_Instance( IMessageRenderer.class );
		IMessageRenderer renderer = (IMessageRenderer)rendererController.generateDouble();

		rendererController
			.expects( 'render' )
			.withParameter( message )
			.returning( true );

		Test.startTest();
			new MessageRendererEngine()
					.setMessage( message )
					.setRenderer( renderer )
					.render();
		Test.stopTest();

		messageController.verify();
	}

	@isTest
	private static void render_whenRendererReturnsFalse_willThrowAnException() // NOPMD: Test method name format
	{
		Amoss_Instance messageController = new Amoss_Instance( IRenderableMessageHeader.class );
		IRenderableMessageHeader message = (IRenderableMessageHeader)messageController.generateDouble();

		Amoss_Instance rendererController = new Amoss_Instance( IMessageRenderer.class );
		IMessageRenderer renderer = (IMessageRenderer)rendererController.generateDouble();

		rendererController
			.expects( 'render' )
			.withParameter( message )
			.returning( false );

		Test.startTest();
			ortoo_Exception thrownException;
			try
			{
				new MessageRendererEngine()
						.setMessage( message )
						.setRenderer( renderer )
						.render();
			}
			catch ( MessageRendererEngine.NoMessageRenderedException e )
			{
				thrownException = e;
			}
		Test.stopTest();

		messageController.verify();

		Amoss_Asserts.assertContains( 'Call to render messages was called, but no message was rendered', thrownException.getMessage(), 'render, when the renderer returns false, will throw an exception' );

		ortoo_Exception.Contexts contexts = thrownException.getContexts();
		ortoo_Exception.Context context;

		context = contexts.next();
		System.assertEquals( 'message', context.getName(), 'render, when the renderer returns false, will throw an exception with a context named message' );
		System.assertEquals( message, context.getValue(), 'render, when the renderer returns false, will throw an exception with a context named message set to the message' );

		context = contexts.next();
		System.assertEquals( 'renderer', context.getName(), 'render, when the renderer returns false, will throw an exception with a context named renderer' );
		System.assertEquals( renderer, context.getValue(), 'render, when the renderer returns false, will throw an exception with a context named renderer set to the renderer' );
	}

	@isTest
	private static void VisualforceMessageRenderer_whenRenderIsCalled_willAddMessagesToTheCurrentApexPage() // NOPMD: Test method name format
	{
		Amoss_Instance messageController = new Amoss_Instance( IRenderableMessageHeader.class );
		IRenderableMessageHeader message = (IRenderableMessageHeader)messageController.generateDouble();

		Amoss_Instance nonFieldDetailController = new Amoss_Instance( IRenderableMessageDetail.class );
		IRenderableMessageDetail nonFieldDetail = (IRenderableMessageDetail)nonFieldDetailController.generateDouble();

		Amoss_Instance fieldDetailController = new Amoss_Instance( IRenderableMessageDetail.class );
		IRenderableMessageDetail fieldDetail = (IRenderableMessageDetail)fieldDetailController.generateDouble();

		messageController
			.when( 'getSeverity' )
			.returns( MessageRendererEngine.Severity.Info )
		.also()
			.when( 'getMessage' )
			.returns( 'The message' )
		.also()
			.when( 'getMessageDetails' )
			.returns( new List<IRenderableMessageDetail>{ nonFieldDetail, fieldDetail } );

		nonFieldDetailController
			.when( 'getContent' )
			.returns( 'Non field detail content' )
		.also()
			.when( 'getFieldContext' )
			.returns( null )
		.also()
			.when( 'getSeverity' )
			.returns( MessageRendererEngine.Severity.Warning );

		fieldDetailController
			.when( 'getContent' )
			.returns( 'Field detail content' )
		.also()
			.when( 'getFieldContext' )
			.returns( Contact.FirstName )
		.also()
			.when( 'getSeverity' )
			.returns( MessageRendererEngine.Severity.Error );

		MessageRendererEngine.VisualforceMessageRenderer renderer = new MessageRendererEngine.VisualforceMessageRenderer();

		Test.startTest();
			Boolean messageRendered = renderer.render( message );
		Test.stopTest();

		System.assert( messageRendered, 'VisualforceMessageRenderer, when render is called, will return true' );

		List<ApexPages.Message> messages = ApexPages.getMessages();
		System.assertEquals( 3, messages.size(), 'VisualforceMessageRenderer, when render is called, will add messages to the current ApexPage - 1 for the header and 1 each for the details' );

		ApexPages.Message headerMessage = messages[0];
		System.assertEquals( 'The message', headerMessage.getSummary(), 'VisualforceMessageRenderer, when render is called, will add messages to the current ApexPage - 1 for the header, setting the summary to the content' );
		System.assertEquals( ApexPages.Severity.INFO, headerMessage.getSeverity(), 'VisualforceMessageRenderer, when render is called, will add messages to the current ApexPage - 1 for the header, setting the severity' );

		ApexPages.Message noFieldMessage = messages[1];
		System.assertEquals( 'Non field detail content', noFieldMessage.getSummary(), 'VisualforceMessageRenderer, when render is called, will add messages to the current ApexPage - 1 each for the details - no field will just add the content as a summary' );
		System.assertEquals( ApexPages.Severity.WARNING, noFieldMessage.getSeverity(), 'VisualforceMessageRenderer, when render is called, will add messages to the current ApexPage - 1 each for the details - no field will add the severity of the detail' );

		ApexPages.Message fieldMessage = messages[2];
		System.assertEquals( Contact.FirstName.getDescribe().getLabel() + ': Field detail content', fieldMessage.getSummary(), 'VisualforceMessageRenderer, when render is called, will add messages to the current ApexPage - 1 each for the details - field will add content as a summary prefixed with the field label' );
		System.assertEquals( ApexPages.Severity.ERROR, fieldMessage.getSeverity(), 'VisualforceMessageRenderer, when render is called, will add messages to the current ApexPage - 1 each for the details - no field will add the severity of the detail' );
	}

	@isTest
	private static void SobjectMessageAdder_whenRenderIsCalled_willAddMessagesToTheSpecifiedObjects() // NOPMD: Test method name format
	{
		Amoss_Instance messageController = new Amoss_Instance( IRenderableMessageHeader.class );
		IRenderableMessageHeader message = (IRenderableMessageHeader)messageController.generateDouble();

		Amoss_Instance nonObjectDetailController = new Amoss_Instance( IRenderableMessageDetail.class );
		IRenderableMessageDetail nonObjectDetail = (IRenderableMessageDetail)nonObjectDetailController.generateDouble();

		Amoss_Instance nonFieldDetailController = new Amoss_Instance( IRenderableMessageDetail.class );
		IRenderableMessageDetail nonFieldDetail = (IRenderableMessageDetail)nonFieldDetailController.generateDouble();

		Amoss_Instance fieldDetailController = new Amoss_Instance( IRenderableMessageDetail.class );
		IRenderableMessageDetail fieldDetail = (IRenderableMessageDetail)fieldDetailController.generateDouble();

		List<Sobject> objectContexts = new List<Sobject> {
			new Contact(),
			new Contact()
		};

		messageController
			.when( 'getSeverity' )
			.returns( MessageRendererEngine.Severity.Error )
		.also()
			.when( 'getObjectContexts' )
			.returns( objectContexts )
		.also()
			.when( 'getMessage' )
			.returns( 'The header message' )
		.also()
			.when( 'getMessageDetails' )
			.returns( new List<IRenderableMessageDetail>{ nonObjectDetail, nonFieldDetail, fieldDetail } );

		nonObjectDetailController
			.when( 'getContent' )
			.returns( 'Non object detail content' )
		.also()
			.when( 'getObjectContext' )
			.returns( null )
		.also()
			.when( 'getFieldContext' )
			.returns( null )
		.also()
			.when( 'getSeverity' )
			.returns( MessageRendererEngine.Severity.Error );

		nonFieldDetailController
			.when( 'getContent' )
			.returns( 'Non field detail content' )
		.also()
			.when( 'getObjectContext' )
			.returns( objectContexts[0] )
		.also()
			.when( 'getFieldContext' )
			.returns( null )
		.also()
			.when( 'getSeverity' )
			.returns( MessageRendererEngine.Severity.Error );

		fieldDetailController
			.when( 'getContent' )
			.returns( 'Field detail content' )
		.also()
			.when( 'getObjectContext' )
			.returns( objectContexts[1] )
		.also()
			.when( 'getFieldContext' )
			.returns( Contact.FirstName )
		.also()
			.when( 'getSeverity' )
			.returns( MessageRendererEngine.Severity.Error );

		MessageRendererEngine.SobjectMessageAdder renderer = new MessageRendererEngine.SobjectMessageAdder();

		Test.startTest();
			Boolean messageRendered = renderer.render( message );
		Test.stopTest();

		System.assert( messageRendered, 'SobjectMessageAdder, when render is called with error messages, will return true' );

		List<Database.Error> errors;
		errors = objectContexts[0].getErrors();
		System.assertEquals( 1, errors.size(), 'SobjectMessageAdder, when render is called, will add messages of severity error to the related SObjects - it tries to add 2, but 1 is discounted because you cannot have two errors on an sobject without a field specified' );

		Database.Error detailError = errors[0];
		System.assertEquals( 0, detailError.getFields().size(), 'SobjectMessageAdder, when render is called, will add messages of severity error to the related SObjects - not relating a field for a detail message with no field' );
		System.assertEquals( 'Non field detail content', detailError.getMessage(), 'SobjectMessageAdder, when render is called, will add messages of severity error to the related SObjects - setting the content a the detail error with no field' );


		errors = objectContexts[1].getErrors();
		System.assertEquals( 2, errors.size(), 'SobjectMessageAdder, when render is called, will add messages of severity error to the related SObjects' );

		Database.Error headerError = errors[0];
		System.assertEquals( 0, headerError.getFields().size(), 'SobjectMessageAdder, when render is called, will add messages of severity error to the related SObjects - not relating a field for the header message' );
		System.assertEquals( 'The header message', headerError.getMessage(), 'SobjectMessageAdder, when render is called, will add messages of severity error to the related SObjects - setting the content on the header error' );

		detailError = errors[1];
		System.assertEquals( 1, detailError.getFields().size(), 'SobjectMessageAdder, when render is called, will add messages of severity error to the related SObjects - relating a field for a detail message with a field' );
		System.assertEquals( 'Name', detailError.getFields()[0], 'SobjectMessageAdder, when render is called, will add messages of severity error to the related SObjects - relating a field for a detail message with a field - checking the field' );
		System.assertEquals( 'Field detail content', detailError.getMessage(), 'SobjectMessageAdder, when render is called, will add messages of severity error to the related SObjects - setting the content a the detail error with a field' );
	}

	@isTest
	private static void SobjectMessageAdder_whenRenderIsCalled_willNotAddInfoOrWarnAsErrors() // NOPMD: Test method name format
	{
		Amoss_Instance messageController = new Amoss_Instance( IRenderableMessageHeader.class );
		IRenderableMessageHeader message = (IRenderableMessageHeader)messageController.generateDouble();

		Amoss_Instance fieldDetailController = new Amoss_Instance( IRenderableMessageDetail.class );
		IRenderableMessageDetail fieldDetail = (IRenderableMessageDetail)fieldDetailController.generateDouble();

		List<Sobject> objectContexts = new List<Sobject> {
			new Contact()
		};

		messageController
			.when( 'getSeverity' )
			.returns( MessageRendererEngine.Severity.Info )
		.also()
			.when( 'getObjectContexts' )
			.returns( objectContexts )
		.also()
			.when( 'getMessage' )
			.returns( 'The header message' )
		.also()
			.when( 'getMessageDetails' )
			.returns( new List<IRenderableMessageDetail>{ fieldDetail } );

		fieldDetailController
			.when( 'getContent' )
			.returns( 'Field detail content' )
		.also()
			.when( 'getObjectContext' )
			.returns( objectContexts[0] )
		.also()
			.when( 'getFieldContext' )
			.returns( Contact.FirstName )
		.also()
			.when( 'getSeverity' )
			.returns( MessageRendererEngine.Severity.Error );

		MessageRendererEngine.SobjectMessageAdder renderer = new MessageRendererEngine.SobjectMessageAdder();

		Test.startTest();
			Boolean messageRendered = renderer.render( message );
		Test.stopTest();

		System.assert( ! messageRendered, 'SobjectMessageAdder, when render is called with an info or warning header message, will return false' );

		List<Database.Error> errors;
		errors = objectContexts[0].getErrors();
		System.assertEquals( 0, errors.size(), 'SobjectMessageAdder, when render is called with an info or warning header message, will not add any messages to the sobjects' );
	}

	@isTest
	private static void SobjectMessageAdder_whenRenderIsCalled_willNotAddInfoOrWarnDetailsAsErrors() // NOPMD: Test method name format
	{
		Amoss_Instance messageController = new Amoss_Instance( IRenderableMessageHeader.class );
		IRenderableMessageHeader message = (IRenderableMessageHeader)messageController.generateDouble();

		Amoss_Instance infoDetailController = new Amoss_Instance( IRenderableMessageDetail.class );
		IRenderableMessageDetail infoDetail = (IRenderableMessageDetail)infoDetailController.generateDouble();

		Amoss_Instance warningDetailController = new Amoss_Instance( IRenderableMessageDetail.class );
		IRenderableMessageDetail warningDetail = (IRenderableMessageDetail)warningDetailController.generateDouble();

		List<Sobject> objectContexts = new List<Sobject> {
			new Contact()
		};

		messageController
			.when( 'getSeverity' )
			.returns( MessageRendererEngine.Severity.Error )
		.also()
			.when( 'getObjectContexts' )
			.returns( objectContexts )
		.also()
			.when( 'getMessage' )
			.returns( 'The header message' )
		.also()
			.when( 'getMessageDetails' )
			.returns( new List<IRenderableMessageDetail>{ infoDetail, warningDetail } );

		infoDetailController
			.when( 'getContent' )
			.returns( 'will not add this one' )
		.also()
			.when( 'getObjectContext' )
			.returns( objectContexts[0] )
		.also()
			.when( 'getFieldContext' )
			.returns( Contact.FirstName )
		.also()
			.when( 'getSeverity' )
			.returns( MessageRendererEngine.Severity.Info );

		warningDetailController
			.when( 'getContent' )
			.returns( 'will not add this one' )
		.also()
			.when( 'getObjectContext' )
			.returns( objectContexts[0] )
		.also()
			.when( 'getFieldContext' )
			.returns( Contact.FirstName )
		.also()
			.when( 'getSeverity' )
			.returns( MessageRendererEngine.Severity.Warning );

		MessageRendererEngine.SobjectMessageAdder renderer = new MessageRendererEngine.SobjectMessageAdder();

		Test.startTest();
			Boolean messageRendered = renderer.render( message );
		Test.stopTest();

		System.assert( messageRendered, 'SobjectMessageAdder, when render is called with an error message that has no error details, will return true' );

		List<Database.Error> errors;
		errors = objectContexts[0].getErrors();
		System.assertEquals( 1, errors.size(), 'SobjectMessageAdder, when render is called with an error message that has no error details, will add the header message to the sobjects' );

		System.assertEquals( 'The header message', errors[0].getMessage(), 'SobjectMessageAdder, when render is called with an error message that has no error details, will add the header message to the sobjects - checking the content' );
	}
}