/**
 * Is an extension of the provided fflib version of SobjectSelector.
 *
 * Reverses the default secruity setup for FLS, being that it defaults to enforcing FLS.
 *
 * @group fflib Extension
 */
public abstract inherited sharing class ortoo_SobjectSelector extends fflib_SobjectSelector implements ISearchSelector // NOPMD: specified a mini-namespace to differentiate from fflib versions
{
	public class UnboundCountQueryException extends Exceptions.SelectorException {}

	public ortoo_SobjectSelector()
	{
		super();
		enforceFLS();
	}

	/**
	 * Configure this instance to ignore FLS when selecting data.
	 *
	 * @return  fflib_SObjectSelector   Itself, allowing for a fluent interface.
	 */
	public fflib_SObjectSelector ignoreFls()
	{
		m_enforceFLS = false;
		return this;
	}

	/**
	 * Given a configuration, search criteria, a window and an order by, will perform the defined search.
	 *
	 * The results includes a total record count as well as the windowed search results.
	 *
	 * WIll perform a maximum of 2 SOQL queries.
	 *
	 * @param	ISearchConfiguration	The configuration defining the additional fields that should be returned.
	 * @param	ISearchCriteria			The criteria defining the records that should be returned.
	 * @param	SearchWindow			Defines the subset of the full result set that should be returned.
	 * @param	SearchOrderBy			The order in which the records should be returned (is applied prior to the window).
	 * @return	SearchResults			The resulting total record count and result set.
	 */
	public SearchResults selectBySearchCriteria( ISearchConfiguration searchConfiguration, ISearchCriteria criteria, SearchWindow window, SearchOrderBy orderBy )
	{
		Contract.requires( searchConfiguration != null, 'selectBySearchCriteria called with a null searchConfiguration' );
		Contract.requires( criteria != null, 'selectBySearchCriteria called with a null criteria' );
		Contract.requires( window != null, 'selectBySearchCriteria called with a null window' );
		Contract.requires( orderBy != null, 'selectBySearchCriteria called with a null orderBy' );

		Integer countOfRecords = getCountOfRecords( criteria );

		List<Sobject> resultsRecords = new List<Sobject>();

		if ( countOfRecords > 0 )
		{
			fflib_QueryFactory queryFactory = newQueryFactory().setCondition( criteria );

			queryFactory.selectFields( searchConfiguration.getRequiredFields() );
			queryFactory.setOffset( window.offset );
			queryFactory.setLimit( window.length );

			if ( orderBy.isConfigured() )
			{
				queryFactory.setOrdering( orderBy.fieldName , orderBy.direction == 'desc' ? fflib_QueryFactory.SortOrder.DESCENDING : fflib_QueryFactory.SortOrder.ASCENDING );
			}

			resultsRecords = Database.query( queryFactory.toSOQL() );
		}

		return new SearchResults( countOfRecords, resultsRecords );
	}

	/**
	 * Given a set of search criteria, will return the number of records that meet that criteria
	 *
	 * Will perform a maximum of 1 SOQL query
	 *
	 * @param	ISearchCriteria	The criteria defining the records that should be returned.
	 * @return	Integer			The total number of records that match the criteria
	 */
	protected Integer getCountOfRecords( ISearchCriteria criteria )
	{
		Contract.requires( criteria != null, 'getCountOfRecords called with a null criteria' );

		String whereClause = criteria.toSOQL();

		if ( String.isBlank( whereClause ) )
		{
			throw new UnboundCountQueryException( 'Attempted to perform the count of an unbound query against ' + getSObjectName() )
						.setErrorCode( FrameworkErrorCodes.SELECTOR_UNBOUND_COUNT_QUERY )
						.addContext( 'SObjectType', getSObjectName() );
		}

		if ( isEnforcingCRUD() && ! SobjectUtils.isAccessible( sObjectType() ) )
		{
			throw new fflib_SObjectDomain.DomainException( 'Permission to access ' + getSObjectName() + ' denied.' ); // to match the exception thrown by fflib
		}

		String query = 'SELECT COUNT(Id) recordCount FROM ' + getSObjectName() + ' WHERE ' + whereClause;

		AggregateResult result = (AggregateResult)Database.query( query ); // NOPMD: variables come from a trusted source

		return (Integer)result.get( 'recordCount' );
	}
}