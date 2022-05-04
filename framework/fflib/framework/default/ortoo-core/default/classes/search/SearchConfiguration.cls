/**
 * Parent class for the definition of a Search, being a mechanism for calling 'selectBySearchCriteria' against a selector.
 * This allows for a windowed and ordered result set to be returned based on an arbitrary set of search criteria.
 */
public abstract inherited sharing class SearchConfiguration implements ISearchConfiguration
{
	protected Map<String,String> fieldMapping = new Map<String,String>();
	private SobjectType baseSobjectType;

	/**
	 * Constructor, defining the Base SObject type that each resulting record represents
	 *
	 * @param	SobjectType The SObject Type that each record represents
	 */
	public SearchConfiguration( SobjectType baseSobjectType )
	{
		Contract.requires( baseSobjectType != null, 'constructor called with a null baseSobjectType' );

		this.baseSobjectType = baseSobjectType;
	}

	/**
	 * Returns a list of the result object's fields that are regarded as 'sortable' in the result set.
	 * By default, the implementation states that all mapped fields are sortable.
	 * This can be overridden at the concrete class level.
	 *
	 * @return	List<String>	The result object's fields that can be sorted
	 */
	public virtual List<String> getSortableFields()
	{
		Contract.assert( fieldMapping != null, 'getSortableFields when fieldMapping was null' );

		return new List<String>( fieldMapping.keySet() );
	}

	/**
	 * Returns a list of the fields that are required on the SObject in order for the results to
	 * be rendered correctly.
	 *
	 * @return	List<String>	The source SObject's fields that are needed to build the results
	 */
	public List<String> getRequiredFields()
	{
		Contract.assert( fieldMapping != null, 'getRequiredFields when fieldMapping was null' );

		return fieldMapping.values();
	}

	/**
	 * Given a field on the result object, returns the name of the SObject field on the base object
	 * that the it represents
	 *
	 * @param	String	The name of the field on the result object
	 * @return	String	The name of the field on the SObject
	 */
	public String getMappedSobjectField( String resultField )
	{
		Contract.requires( String.isNotBlank( resultField ), 'getMappedSobjectField called with a blank resultField' );
		Contract.assert( fieldMapping != null, 'getMappedSobjectField when fieldMapping was null' );

		return fieldMapping.get( resultField );
	}

	/**
	 * The SObject Type that is the basis of the result objects for this search type.
	 *
	 * @return	SObjectType	The SObject Type that is the basis of the result records
	 */
	public SObjectType getBaseSobjectType()
	{
		return this.baseSobjectType;
	}

	/**
	 * Add a mapping between a field on the result object and the SObject.
	 *
	 * @return	SearchConfiguration	Itself, allowing for a fluent implementation
	 */
	@testVisible
	protected SearchConfiguration addFieldMapping( String resultField, String sobjectField )
	{
		Contract.requires( String.isNotBlank( resultField ), 'addFieldMapping called with a blank resultField' );
		Contract.requires( String.isNotBlank( sobjectField ), 'addFieldMapping called with a blank sobjectField' );
		Contract.assert( fieldMapping != null, 'addFieldMapping when fieldMapping was null' );

		this.fieldMapping.put( resultField, sobjectField );
		return this;
	}
}