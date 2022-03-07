/**
 * Provides the ability to dynamically create a selector based on configuration.
 *
 * Should not be used in order to retrieve configuration of the managed app, but rather is for driving SOQL statements
 * from that configuration - for example:
 *      The system contains configurations for how to match an email to a record in the system.
 *      That class can be used to turn that configuration into a SOQL statement that will retrieve that record.
 *
 * @group fflib Extension
 */
public inherited sharing class ortoo_DynamicSobjectSelector extends ortoo_SobjectSelector // NOPMD: specified a mini-namespace to differentiate from fflib versions
{
	List<String> fieldList = new List<String>();
	Schema.SObjectType sobjectType;

	// TODO: add the ability to add sub-queries

	/**
	 * Define the SObject Type that this selector will retrieve the data for.
	 *
	 * @param	Schema.SObjectType				The SObject Type that this instance will retrieve
	 * @return	ortoo_DynamicSobjectSelector	Itself, allowing for a fluent interface
	 */
	public ortoo_DynamicSobjectSelector setSobjectType( Schema.SObjectType sobjectType )
	{
		Contract.requires( sobjectType != null, 'setSobjectType called with a null sobjectType' );
		this.sobjectType = sobjectType;
		return this;
	}

	/**
	 * Define the SObject Type that this selector will retrieve the data for, stated by the String representation.
	 *
	 * @param	String							The SObject Type that this instance will retrieve
	 * @return	ortoo_DynamicSobjectSelector	Itself, allowing for a fluent interface
	 */
	public ortoo_DynamicSobjectSelector setSobjectType( String sobjectTypeName )
	{
		Contract.requires( sobjectTypeName != null, 'setSobjectType called with a null sobjectTypeName' );

		Schema.SObjectType sobjectType = SobjectUtils.getSobjectType( sobjectTypeName );

		Contract.requires( sobjectType != null, 'setSobjectType called with an sobjectTypeName that does not represent a valid SObject Type' );

		return setSobjectType( sobjectType );
	}

	/**
	 * Add a field to be returned by the generated SOQL
	 *
	 * @param	String
	 * @return	ortoo_DynamicSobjectSelector	Itself, allowing for a fluent interface
	 */
	public ortoo_DynamicSobjectSelector addField( String fieldToAdd )
	{
		Contract.requires( fieldToAdd != null, 'addField called with a null fieldToAdd' );
		// could we check if the field is valid?  May be hard with things like parent relationships
		fieldList.add( fieldToAdd );
		return this;
	}

	/**
	 * Retrieve the records that match the passed criteria.
	 *
	 * @param	ortoo_Criteria	The criteria that should be used to derive the records to return
	 * @return	List<Sobject>	The result of the Selection
	 */
	public List<Sobject> selectByCriteria( ortoo_Criteria criteria )
	{
		return selectByCriteria( criteria, false );
	}

	/**
	 * Retrieve the records that match the passed criteria, optionally via the Org Level SOQL Cache
	 *
	 * @param	ortoo_Criteria	The criteria that should be used to derive the records to return
	 * @param	Boolean			Should the query go via the Org Level SOQL Cache?
	 * @return	List<Sobject>	The result of the Selection
	 */
	public List<Sobject> selectByCriteria( ortoo_Criteria criteria, Boolean cached )
	{
		Contract.requires( criteria != null, 'selectByCriteria called with a null criteria' );
		Contract.requires( cached != null, 'selectByCriteria called with a null cached' );
		Contract.assert( sobjectType != null, 'selectByCriteria called when sobjectType has not been set' );

		String soql = generateSoqlByCriteria( criteria );
		if ( cached )
		{
			return ((OrgCachedSoqlExecutor)Application.APP_LOGIC.newInstance( OrgCachedSoqlExecutor.class ))
						.query( soql );
		}
		return  Database.query( soql );
	}

	/**
	 * Request that the cached results for the given criteria be cleared.
	 * Assumes that the fields are set up correctly.
	 *
	 * @param	ortoo_Criteria	The criteria that should be used to derive the SOQL results to clear
	 */
	public ortoo_DynamicSobjectSelector clearCacheFor( ortoo_Criteria criteria )
	{
		Contract.requires( criteria != null, 'clearCacheFor called with a null criteria' );

		((OrgCachedSoqlExecutor)Application.APP_LOGIC.newInstance( OrgCachedSoqlExecutor.class ))
						.clearCacheFor( generateSoqlByCriteria( criteria ) );
		return this;
	}

	/**
	 * Required overload in order to make this a concrete class.
	 * Never returns any fields as the fields are added from the text representation instead, at the point of query.
	 *
	 * @return	List<Schema.SObjectField>	The configured fields
	 */
	public List<Schema.SObjectField> getSObjectFieldList()
	{
		return new List<Schema.SObjectField>();
	}

	/**
	 * Return the SObject Type that this selector will return.
	 *
	 * @return	Schema.SObjectType	The configured SObject Type
	 */
	public Schema.SObjectType getSObjectType()
	{
		return sobjectType;
	}

	@testVisible
	private String generateSoqlByCriteria( ortoo_Criteria criteria )
	{
		return newQueryFactory().selectFields( fieldList ).setCondition( criteria.toSOQL() ).toSOQL();
	}
}