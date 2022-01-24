/**
 * Defines the Order By for a given search request.
 * The request is qualified by the given search configuration type.
 *
 * The fieldName is mapped from the given result field name into the appropriate sobject
 * field name, if one is mapped in the configuration.
 */
public inherited sharing class SearchOrderBy
{
	private static final String DIRECTION_ASCENDING = 'asc';
	private static final String DIRECTION_DESCENDING = 'desc';

	public String fieldName {get; private set;}
	public String direction {get; private set;}

	/**
	 * Configures the order by, defining its properties.
	 *
	 * @param	Map<String,Object>	The properties of the window.  Should contain 'fieldName' and 'offset' properties as Strings
	 * @param   Type				The type of the SearchConfiguration object that should be used to determine the field mappings
	 * @return	SearchOrderBy		Itself, allowing for a fluent interface
	 */
	public SearchOrderBy configure( Map<String,Object> properties, Type searchConfigurationType )
	{
		Contract.requires( properties != null, 'configure called with a null properties' );
		Contract.requires( searchConfigurationType != null, 'configure called with a null searchConfigurationType' );

		ISearchConfiguration searchConfiguration;

		try
		{
			searchConfiguration = (ISearchConfiguration)Application.APP_LOGIC.newInstance( searchConfigurationType );
		} catch ( Exception e ) {
			Contract.assert( false, 'configure called with a searchConfigurationType ('+searchConfigurationType+') that does not implement ISearchConfiguration or does not have a parameterless constructor' );
		}

		String resultsFieldName = (String)properties.get( 'fieldName' );
		String direction = (String)properties.get( 'direction' );

		if ( String.isBlank( direction ) )
		{
			direction = DIRECTION_ASCENDING;
		}

		Contract.assert( direction == DIRECTION_ASCENDING || direction == DIRECTION_DESCENDING,
						'configure called with an invalid direction.  Was "'+direction+'", but should be one of ['+DIRECTION_ASCENDING+','+DIRECTION_DESCENDING+']' );

		if ( String.isNotBlank( resultsFieldName ) )
		{
			String mappedFieldName = searchConfiguration.getMappedSobjectField( resultsFieldName );

			if ( String.isNotBlank( mappedFieldName ) )
			{
				this.fieldName = mappedFieldName;
				this.direction = direction;
			}
		}
		return this;
	}

	/**
	 * States if the OrderBy object has been configured with a fieldName that makes sense.
	 *
	 * @return	Boolean	Is this object configured
	 */
	public Boolean isConfigured()
	{
		return String.isNotBlank( fieldName );
	}
}