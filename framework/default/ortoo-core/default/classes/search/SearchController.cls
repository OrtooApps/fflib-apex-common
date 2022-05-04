/**
 * A base controller that can be used for a given implementation for a given LWC (for example)
 *
 * A consumer implementation should instantiate an instance passing a 'searchConfigurationType' that defines the search's behaviour.
 *
 * In addition, before calling 'search', it should instantiate an instance of a ISearchCriteriaFactory that is used to convert the raw
 * criteria into an ISearchCriteria instance.  This class is likely to be defined as an inner class.
 */
public inherited sharing class SearchController
{
	private Type searchConfigurationType;

	/**
	 * Instructs the SearchController to be configured via the given searchConfigurationType.
	 *
	 * @param	Type	The type of the ISearchConfigration implementation that this search is configured by
	 * @return	SearchController	Itself, allowing for a fluent interface
	 */
	public SearchController setSearchConfigurationType( Type searchConfigurationType )
	{
		Contract.requires( searchConfigurationType != null, 'setSearchConfigurationType called with a null searchConfigurationType' );

		this.searchConfigurationType = searchConfigurationType;
		return this;
	}

	/**
	 * Performs a search using the SearchService, convering raw property based parameters into the appropriate objects.
	 *
	 * @param	ISearchCriteriaFactory	The factory that should be used to build the ISearchCriteria instance that will define
	 * 									the result set to return.
	 * @param	Map<String,Object>		The raw criteria that is used to define the search.  This is used by the ISearchCriteriaFactory
	 * 									to configure the resulting ISearchCriteria
	 * @param	Map<String,Object>		The raw result set's window representation
	 * @param	Map<String,Object>		The raw result set's orderBy representation
	 * @return	SearchResults			The results of the given search, as returned by the service
	 */
	public SearchResults search( ISearchCriteriaFactory searchCriteriaFactory, Map<String,Object> criteria, Map<String,Object> window, Map<String,Object> orderBy )
	{
		Contract.requires( searchCriteriaFactory != null, 'search called with a null searchCriteriaFactory' );
		Contract.requires( criteria != null, 'search called with a null criteria' );
		Contract.requires( window != null, 'search called with a null window' );
		Contract.requires( orderBy != null, 'search called with a null orderBy' );

		Contract.assert( searchConfigurationType != null, 'search called when searchConfigurationType was null' );

		ISearchCriteria criteriaObject = searchCriteriaFactory.setProperties( criteria ).build();

		SearchWindow windowObject = ((SearchWindow)Application.APP_LOGIC.newInstance( SearchWindow.class ) )
										.configure( window );

		SearchOrderBy orderByObject = ((SearchOrderBy)Application.APP_LOGIC.newInstance( SearchOrderBy.class ) )
											.configure( orderBy, searchConfigurationType );

		return SearchService.search( searchConfigurationType, criteriaObject, windowObject, orderByObject );
	}

	/**
	 * Returns the list of sortable fields in the result set.  Does so by asking the SearchService to discover it via the configuration
	 *
	 * @return	List<String>	The list of fields that are searchable
	 */
	public List<String> getSortableFields()
	{
		Contract.assert( searchConfigurationType != null, 'getSortableFields called when searchConfigurationType was null' );

		return SearchService.getSortableFields( searchConfigurationType );
	}
}
