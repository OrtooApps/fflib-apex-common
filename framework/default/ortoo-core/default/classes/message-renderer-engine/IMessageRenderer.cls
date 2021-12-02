/**
 * The required interface that the renderer of a message should implement.
 */
public interface IMessageRenderer
{
	Boolean render( IRenderableMessageHeader message );
}