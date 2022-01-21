/**
 * Is an extension of the provided fflib version of SobjectSelector.
 *
 * Reverses the default secruity setup for FLS, being that it defaults to enforcing FLS.
 *
 * @group fflib Extension
 */
public abstract inherited sharing class ortoo_SobjectSelector extends fflib_SobjectSelector implements ISearchSelector // NOPMD: specified a mini-namespace to differentiate from fflib versions
{
    class UnboundCountQueryException extends Exceptions.SelectorException {}

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

    // TODO: document
    // TODO: test
    // TODO: security
    public SearchResults selectBySearchCriteria( ISearchConfiguration searchConfiguration, ISearchCriteria criteria, SearchWindow window, SearchOrderBy orderBy )
    {
		Contract.requires( criteria != null, 'selectByCriteria called with a null criteria' );

        Integer countOfRecords = getCountOfRecords( criteria );

        List<Sobject> resultsRecords = new List<Sobject>();

        if ( countOfRecords > 0 )
        {
            fflib_QueryFactory queryFactory = newQueryFactory().setCondition( criteria.toSOQL() );

            queryFactory.selectFields( searchConfiguration.getRequiredFields() );
            queryFactory.setOffset( window.offset );
            queryFactory.setLimit( window.length );
            queryFactory.setOrdering( orderBy.fieldName , orderBy.direction == 'desc' ? fflib_QueryFactory.SortOrder.DESCENDING : fflib_QueryFactory.SortOrder.ASCENDING );

            resultsRecords = Database.query( queryFactory.toSOQL() );
        }

        return new SearchResults( countOfRecords, resultsRecords );
    }

    // TODO: document
    // TODO: test
    protected Integer getCountOfRecords( ISearchCriteria soqlCriteria )
    {
        // TODO: security
        String whereClause = soqlCriteria.toSOQL();

        if ( String.isBlank( whereClause ) )
        {
            throw new UnboundCountQueryException( 'Attempted to perform a count on an unbound query against ' + getSObjectName() )
                        .setErrorCode( FrameworkErrorCodes.SELECTOR_UNBOUND_COUNT_QUERY )
                        .addContext( 'SObjectType', getSObjectName() );
        }

        String query = 'SELECT COUNT(Id) recordCount FROM ' + getSObjectName() + ' WHERE ' + whereClause;

        AggregateResult result = (AggregateResult)Database.query( query ); // NOPMD: variables come from a trusted source

        return (Integer)result.get( 'recordCount' );
    }
}