	/**
	 * Class that represents a the detail of a message, potentially about a given record / field.
	 *
	 * Used, for example, to provide detail to Exceptions.
	 * Can be rendered by the MessageRendererEngine.
	 */
	public inherited sharing class MessageDetail implements IRenderableMessageDetail
	{
		MessageRendererEngine.Severity	severity = MessageRendererEngine.Severity.Error; // Assume that a message is an error unless told otherwise
		Sobject      					record;
		SobjectField 					field;
		String       					messageContent;

		/**
		 * Constructor - stating a given message
		 *
		 * @param	String	The message content - generally should be specified as a label.
		 */
		public MessageDetail( String messageContent )
		{
			this.messageContent = messageContent;
		}

		/**
		 * Constructor - stating that a given message is appropriate for the entirety of a record
		 *
		 * @param	Sobject	The Sobject that the message is about
		 * @param	String	The message content - generally should be specified as a label.
		 */
		public MessageDetail( Sobject record, String messageContent )
		{
			this( messageContent );
			this.record = record;
		}

		/**
		 * Constructor - stating that a given message is appropriate for a given field of the given record
		 *
		 * @param	Sobject			The Sobject that the message is about
		 * @param	SobjectField	The SobjectField that the message is about
		 * @param	String			The message content - generally should be specified as a label.
		 */
		public MessageDetail( Sobject record, SobjectField field, String messageContent )
		{
			this( record, messageContent );
			this.field = field;
		}

		/**
		 * Sets the severity of the current message detail
		 *
		 * @param	MessageRendererEngine.Severity	The severity of this message
		 * @return	MessageDetail Itself, allowing for a fluent interface
		 */
		public MessageDetail setSeverity( MessageRendererEngine.Severity severity )
		{
			Contract.requires( severity != null, 'setSeverity called with a null severity' );

			this.severity = severity;
			return this;
		}

		/**
		 * Returns the object that this message is about.
		 *
		 * @return	Sobject	The object that message is about.
		 */
		public Sobject getObjectContext()
		{
			return this.record;
		}

		/**
		 * Returns the field that this message is about.
		 *
		 * @return	SobjectField	The field that message is about.
		 */
		public SobjectField getFieldContext()
		{
			return this.field;
		}

		/**
		 * Returns the content of this message
		 *
		 * @return	String	The content of this message
		 */
		public String getContent()
		{
			return this.messageContent;
		}

		/**
		 * Returns the severity of this message
		 *
		 * @return	MessageRendererEngine.Severity	The severity of this message
		 */
		public MessageRendererEngine.Severity getSeverity()
		{
			return severity;
		}
	}