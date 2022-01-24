/**
 * Interface that defines the ability to create an instance of ISearchCriteria
 * based on a Map of properties
 */
public interface ISearchCriteriaFactory
{
    ISearchCriteriaFactory setProperties( Map<String,Object> properties );
    ISearchCriteria build();
}