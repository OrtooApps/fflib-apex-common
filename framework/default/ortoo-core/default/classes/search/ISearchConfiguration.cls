/**
 * Interface that defines classes that describe the configuration of searches.
 *
 * This includes the ability to define:
 *      * The fields that should be included in the result set
 *      * Which fields are sortable
 *      * How to map from the result set fields to internal SObject fields
 *      * Which Base SObject is used to derive a record in the result set
 */
public interface ISearchConfiguration
{
    List<String> getRequiredFields();
    List<String> getSortableFields();
    String getMappedSobjectField( String resultField );
    SobjectType getBaseSobjectType();
}