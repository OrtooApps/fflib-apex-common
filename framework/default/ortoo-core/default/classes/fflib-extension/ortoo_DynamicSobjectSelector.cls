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
		return selectByCriteria( criteria, CachedSoqlExecutor.CacheScope.NONE );
	}

	/**
	 * Retrieve the records that match the passed criteria, utilising the specified level of cache.
	 *
	 * @param	ortoo_Criteria					The criteria that should be used to derive the records to return
	 * @param	CachedSoqlExecutor.CacheScope	The scope of the cache that should be used
	 * @return	List<Sobject>					The result of the Selection
	 */
	public List<Sobject> selectByCriteria( ortoo_Criteria criteria, CachedSoqlExecutor.CacheScope cacheScope )
	{
		Contract.requires( criteria != null, 'selectByCriteria called with a null criteria' );
		Contract.requires( cacheScope != null, 'selectByCriteria called with a null cacheScope' );
		Contract.assert( sobjectType != null, 'selectByCriteria called when sobjectType has not been set' );

		String soql = generateSoqlByCriteria( criteria );

		return ((CachedSoqlExecutor)Application.APP_LOGIC.newInstance( CachedSoqlExecutor.class ))
					.setScope( cacheScope )
					.query( soql );
	}

	/**
	 * Retrieve the records that match the passed criteria, utilising the specified level of cache,
	 * only allowing data younger than the age specified to be retrieved from the cache.
	 *
	 * @param	ortoo_Criteria					The criteria that should be used to derive the records to return
	 * @param	CachedSoqlExecutor.CacheScope	The scope of the cache that should be used
	 * @param	Long							The maximum age, in seconds, that a cache entry is allowed to be before being discarded
	 * @return	List<Sobject>					The result of the Selection
	 */
	public List<Sobject> selectByCriteria( ortoo_Criteria criteria, CachedSoqlExecutor.CacheScope cacheScope, Long maximumAgeInSeconds )
	{
		Contract.requires( criteria != null, 'selectByCriteria called with a null criteria' );
		Contract.requires( cacheScope != null, 'selectByCriteria called with a null cacheScope' );
		Contract.requires( maximumAgeInSeconds != null, 'selectByCriteria called with a null maximumAgeInSeconds' );
		Contract.assert( sobjectType != null, 'selectByCriteria called when sobjectType has not been set' );

		String soql = generateSoqlByCriteria( criteria );

		return ((CachedSoqlExecutor)Application.APP_LOGIC.newInstance( CachedSoqlExecutor.class ))
					.setScope( cacheScope )
					.query( soql, maximumAgeInSeconds );
	}

	/**
	 * Retrieve the records that match the passed criteria, utilising the specified level of cache,
	 * only allowing data younger than the age specified to be retrieved from the cache.
	 *
	 * @param	ortoo_Criteria					The criteria that should be used to derive the records to return
	 * @param	CachedSoqlExecutor.CacheScope	The scope of the cache that should be used
	 * @param	DateTime						The minimum datetime (how recent) that a cache entry must have been created on to be used
	 * @return	List<Sobject>					The result of the Selection
	 */
	public List<Sobject> selectByCriteria( ortoo_Criteria criteria, CachedSoqlExecutor.CacheScope cacheScope, DateTime minimumDateTimeAdded )
	{
		Contract.requires( criteria != null, 'selectByCriteria called with a null criteria' );
		Contract.requires( cacheScope != null, 'selectByCriteria called with a null cacheScope' );
		Contract.requires( minimumDateTimeAdded != null, 'selectByCriteria called with a null minimumDateTimeAdded' );
		Contract.assert( sobjectType != null, 'selectByCriteria called when sobjectType has not been set' );

		String soql = generateSoqlByCriteria( criteria );

		return ((CachedSoqlExecutor)Application.APP_LOGIC.newInstance( CachedSoqlExecutor.class ))
					.setScope( cacheScope )
					.query( soql, minimumDateTimeAdded );
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

		((CachedSoqlExecutor)Application.APP_LOGIC.newInstance( CachedSoqlExecutor.class ))
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