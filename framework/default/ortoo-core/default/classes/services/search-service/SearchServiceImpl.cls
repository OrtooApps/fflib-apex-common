/**
 * Provides a mechanism for performing a windowed, ordered search against an object as
 * defined by the passed searchConfigurationType.
 */
public with sharing class SearchServiceImpl implements ISearchService
{
	/**
	 * Perform the search as defined in the given configuration type, using the specified criteria.
	 * A window of results will be returned, as defined in the passed SearchWindow.
	 * The results will be ordered as per the configured SearchOrderBy
	 *
	 * @param	Type			The type that defines the configuration of this search.
	 * @param	ISearchCriteria	The criteria that defines the required records.
	 * @param	SearchWindow	The window of the result set that is required (offset + length).
	 * @param	SearchOrderBy	The order in which the results should be returned.
	 * @return	SearchResults	The result of the search, being a combination of the total number of records
	 * 							that match the specified criteria and the requested results that fall in the
	 * 							specified window
	 */
	public SearchResults search( Type searchConfigurationType, ISearchCriteria criteria, SearchWindow window, SearchOrderBy orderBy )
	{
		Contract.requires( searchConfigurationType != null, 'search called with a null searchConfigurationType' );
		Contract.requires( criteria != null, 'search called with a null criteria' );
		Contract.requires( window != null, 'search called with a null window' );
		Contract.requires( orderBy != null, 'search called with a null orderBy' );

		SearchResults searchResults = null;
		try
		{
			ISearchConfiguration searchConfiguration = buildSearchConfiguration( searchConfigurationType );

			SobjectType sobjectType = searchConfiguration.getBaseSobjectType();

			searchResults = ((ISearchSelector)Application.SELECTOR.newInstance( sObjectType ) )
													.selectBySearchCriteria( searchConfiguration, criteria, window, orderBy );

			if ( searchResults.hasRecords() )
			{
				ISearchResultBuilder searchResultsBuilder = ((ISearchResultBuilder)Application.DOMAIN.newInstance( (List<Sobject>)searchResults.records ) );
				searchResults.records = searchResultsBuilder.buildSearchResults( searchConfiguration );
			}
		}
		catch ( Exception e )
		{
			ServiceUtils.logAndRethrow( e );
		}

		Contract.ensures( searchResults != null, 'search attempted to return with a null searchResults' );
		Contract.ensures( searchResults.records != null, 'search attempted to return with a null searchResults.records' );
		Contract.ensures( searchResults.totalNumberOfRecords != null, 'search attempted to return with a null searchResults.totalNumberOfRecords' );

		return searchResults;
	}

	public List<String> getSortableFields( Type searchConfigurationType )
	{
		Contract.requires( searchConfigurationType != null, 'getSortableFields called with a null searchConfigurationType' );

		List<String> sortableFields = new List<String>();
		try
		{
			return buildSearchConfiguration( searchConfigurationType ).getSortableFields();
		}
		catch ( Exception e )
		{
			ServiceUtils.logAndRethrow( e );
		}
		return sortableFields;
	}

	private ISearchConfiguration buildSearchConfiguration( Type searchConfigurationType )
	{
		return ((ISearchConfiguration)Application.APP_LOGIC.newInstance( searchConfigurationType ) );
	}
}