public inherited sharing class SearchService
{
    public static SearchResults search( Type searchResultType, ISearchCriteria criteria, SearchWindow window, SearchOrderBy orderBy )
    {
        return service().search( searchResultType, criteria, window, orderBy );
    }

    public static List<String> getSortableFields( Type searchResultType )
    {
        return service().getSortableFields( searchResultType );
    }

    private static ISearchService service()
    {
        return (ISearchService)Application.SERVICE.newInstance( ISearchService.class );
    }
}