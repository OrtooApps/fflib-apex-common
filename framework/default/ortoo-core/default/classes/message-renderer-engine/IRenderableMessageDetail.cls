	/**
	 * The required interface that the details of the Message should implement in order
	 * to be renderable.
	 * Every method should return a non-null value even if not appropriate for that instance.
	 */
	public interface IRenderableMessageDetail
	{
		Sobject getObjectContext();
		SobjectField getFieldContext();
		String getContent();
		MessageRendererEngine.Severity getSeverity();
	}