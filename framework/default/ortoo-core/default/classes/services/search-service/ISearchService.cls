public interface ISearchService
{
    SearchResults search( Type searchConfigurationType, ISearchCriteria criteria, SearchWindow window, SearchOrderBy orderBy );
    List<String> getSortableFields( Type searchConfigurationType );
}