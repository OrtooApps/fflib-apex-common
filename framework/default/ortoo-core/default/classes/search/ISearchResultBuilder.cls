/**
 * Interface that defines the ability to build a list of search result objects
 * based on the current state of that instance (e.g. by a Domain object)
 */
public interface ISearchResultBuilder
{
    List<ISearchResult> buildSearchResults( ISearchConfiguration searchConfiguration );
}