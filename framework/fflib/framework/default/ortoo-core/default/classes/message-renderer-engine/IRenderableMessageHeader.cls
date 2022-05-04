/**
 * The required interface that the header of the Message should implement in order
 * to be renderable.
 * Every method should return a non-null value even if not appropriate for that instance.
 */
public interface IRenderableMessageHeader
{
	List<Sobject> getObjectContexts();
	String getMessage();
	String getCode();
	StackTrace getStackTrace();
	ortoo_Exception.Contexts getContexts();  // should reference an interface
	List<IRenderableMessageDetail> getMessageDetails();
	MessageRendererEngine.Severity getSeverity();
}