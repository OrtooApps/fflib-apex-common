/**
 * Class exists purely to allow an instance of ISearchSelector to be mocked and registered as a fflib_SobjectSelector.
 * In theory we should be able to mock ortoo_SobjectSelector, since that implements ISearchSelector, but the mock
 * generation fails inside the StubProvider as of API 52.
 * Can't think of another way of doing this, but if it's possible without a class being defined then that solution is welcomed.
 */
@isTest
public inherited sharing class SearchServiceMockSearchSelector extends fflib_SobjectSelector implements ISearchSelector
{
	public SObjectType getSObjectType()
	{
		return null;
	}

	public List<SObjectField> getSObjectFieldList()
	{
		return null;
	}

    public SearchResults selectBySearchCriteria( ISearchConfiguration searchConfiguration, ISearchCriteria criteria, SearchWindow window, SearchOrderBy orderBy )
    {
		return null;
	}
}