/**
 * Interface that defines the ability to provide a WHERE clause for a search to be performed with.
 */
public interface ISearchCriteria
{
	String toSOQL();
}