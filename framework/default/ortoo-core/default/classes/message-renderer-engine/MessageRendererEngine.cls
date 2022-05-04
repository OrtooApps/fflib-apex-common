/**
 * Defines a mechanism for 'rendering' messages, as well as defining their shape.
 *
 * Allows, for example, standard ortoo_Exception instances to be rendered:
 * 		In Visualforce pages
 * 		Against SObjects (adding them as errors)
 * 		As AuraHandledExceptions (not yet implemented)
 *
 * Also allows the renderer to decide the level of detail that should be presented to the consumer.
 *
 * Notice that 'render' does not necesserily mean 'add to the user interface', in this context.
 * Rather is means 'present in a format that is appropriate for this delivery mechanism'.
 *
 * The class 'MessageRendererEngine' particularly, presents the ability to specify:
 * 		A message that requires rendering
 * 		A renderer that should be used
 * 		The ability to instruct the renderer to perform the renderring
 */
public inherited sharing class MessageRendererEngine
{
	public inherited sharing class NoMessageRenderedException extends Exceptions.DeveloperException {}

	/**
	 * The Severity that any message should return to define the level of the problem
	 */
	public enum Severity {
		Error, Warning, Info
	}

	IMessageRenderer renderer;
	IRenderableMessageHeader message;


	/**
	 * Render the configured message, using the given renderer.
	 *
	 * If the renderer returns false, will throw an exception to state that no message was rendered.
	 */
	public void render()
	{
		Contract.requires( renderer != null, 'render called before the renderer was set' );
		Contract.requires( message != null, 'render called before the message was set' );

		if ( ! renderer.render( message ) )
		{
			throw new NoMessageRenderedException( 'Call to render messages was called, but no message was rendered' )
				.addContext( 'message', message )
				.addContext( 'renderer', renderer );
		}
	}

	/**
	 * Sets the message that this render engine should render.
	 *
	 * @param	IRenderableMessageHeader	The message to render
	 * @return	MessageRendererEngine		Itself, allowing for a fluent interface
	 */
	public MessageRendererEngine setMessage( IRenderableMessageHeader message )
	{
		Contract.requires( message != null, 'setMessage called with a null message' );

		this.message = message;
		return this;
	}

	/**
	 * Sets the renderer that this render engine should use to perform the rendering.
	 *
	 * @param	IMessageRenderer		The renderer to use
	 * @return	MessageRendererEngine	Itself, allowing for a fluent interface
	 */
	public MessageRendererEngine setRenderer( IMessageRenderer renderer )
	{
		Contract.requires( renderer != null, 'setRenderer called with a null renderer' );

		this.renderer = renderer;
		return this;
	}

	public IMessageRenderer getRenderer()
	{
		return this.renderer;
	}

	@testVisible
	private IRenderableMessageHeader getMessage()
	{
		return this.message;
	}

	/**
	 * A renderer that will add messages to the current Apex Page.
	 *
	 * Does so with no significant level of detail.  Does not include any stack trace or context information.
	 */
	public inherited sharing class VisualforceMessageRenderer implements IMessageRenderer
	{
		Map<Severity, ApexPages.Severity> severityMap = new Map<Severity, ApexPages.Severity>{
			Severity.Error   => ApexPages.Severity.Error,
			Severity.Warning => ApexPages.Severity.Warning,
			Severity.Info    => ApexPages.Severity.Info
		};

		/**
		 * Render the passed in message, adding it to the current Apex Page.
		 *
		 * @param	IRenderableMessageHeader	The message to render
		 * @return	Boolean						States if a message was added to the page
		 */
		public Boolean render( IRenderableMessageHeader message )
		{
			ApexPages.addMessage( new ApexPages.Message( severityMap.get( message.getSeverity() ), message.getMessage() ) );

			// TODO: This could potentially add detail and form element ids as well.   Would need looking at by someone with more VF experience?

			for ( IRenderableMessageDetail messageDetail : message.getMessageDetails() )
			{
				String messageDetailContent = messageDetail.getContent();
				SobjectField field = messageDetail.getFieldContext();
				if ( field != null )
				{
					messageDetailContent = field.getDescribe().getLabel() + ': ' + messageDetailContent;
				}
				ApexPages.addMessage( new ApexPages.Message( severityMap.get( messageDetail.getSeverity() ), messageDetailContent ) );
			}
			return true;
		}
	}

	/**
	 * A renderer that will add messages to the SObjects that the message details relate to.
	 *
	 * Will:
	 * 		Only add messages if the Severity is 'Error'
	 * 		Add the messages as errors
	 *
	 * Does so with no significant level of detail.  Does not include any stack trace or context information.
	 */
	public inherited sharing class SobjectMessageAdder implements IMessageRenderer
	{
		public Boolean render( IRenderableMessageHeader message )
		{
			if ( message.getSeverity() != Severity.Error )
			{
				return false;
			}

			List<Sobject> objectContexts = message.getObjectContexts();
			if ( objectContexts.isEmpty() )
			{
				return false;
			}

			String headerMessage = message.getMessage();

			if ( String.isNotBlank( headerMessage ) )
			{
				for ( Sobject thisObjectContext : objectContexts )
				{
					thisObjectContext.addError( headerMessage );
				}
			}

			for ( IRenderableMessageDetail thisMessageDetail : message.getMessageDetails() )
			{
				Sobject objectContext = thisMessageDetail.getObjectContext();

				if ( objectContext != null && thisMessageDetail.getSeverity() == Severity.Error )
				{
					SobjectField fieldContext = thisMessageDetail.getFieldContext();
					String messageContent = thisMessageDetail.getContent();

					if ( fieldContext != null )
					{
						objectContext.addError( fieldContext, messageContent );
					}
					else
					{
						objectContext.addError( messageContent );
					}
				}
			}
			return true;
		}
	}
}