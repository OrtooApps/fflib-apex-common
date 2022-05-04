/**
 * Interface that defines the ability to retrieve a list of Search Results with a total number of records
 * based on:
 *      A Search Configuration that defines the minimum fields to return
 *      Search Criteria that define filters for the records to be returned
 *      Search Window defining which subset of the matching records should be returned
 *      Search Order By defining the order of the records prior to the result set being trimmed to the required window
 */
public interface ISearchSelector
{
    SearchResults selectBySearchCriteria( ISearchConfiguration searchConfiguration, ISearchCriteria criteria, SearchWindow window, SearchOrderBy orderBy );
}