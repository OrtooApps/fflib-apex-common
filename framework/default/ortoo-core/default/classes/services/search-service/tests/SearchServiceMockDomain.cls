/**
 * Class exists purely to allow an instance of ISearchResultBuilder to be mocked and registered as a fflib_ISObjectDomain
 * in the application framework.  Can't think of another way of doing this, but if it's possible without a class
 * then that solution is welcomed.
 */
@isTest
public inherited sharing class SearchServiceMockDomain implements fflib_ISObjectDomain, ISearchResultBuilder
{
	public Object getType()
	{
		return null;
	}
	public List<Object> getObjects()
	{
		return null;
	}
	public List<ortoo_qra.ISearchResult> buildSearchResults( ISearchConfiguration searchConfiguration )
	{
		return null;
	}
	public Schema.SObjectType sObjectType()
	{
		return null;
	}
	public List<SObject> getRecords()
	{
		return null;
	}
}