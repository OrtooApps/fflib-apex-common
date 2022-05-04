/**
 * Represents a window of data, being the results of a search.  Is defined by the properties:
 *
 *      * totalNumberOfRecords - The total number of records for which these results are a subset.
 *                              Is always at least as large as the list of records
 *      * records - The subset of the total result record set that are being returned.
 *
 * The properties are public and AuraEnabled, allowing them to be viewed in Aura Components / LWCs
 */
public inherited sharing class SearchResults
{
	@AuraEnabled public Integer totalNumberOfRecords;
	@AuraEnabled public List<Object> records;

	/**
	 * Constructor, defining the dataset
	 *
	 * @param	Integer         The total nmumber of records of which these records are a subset
	 * @param   List<Object>    The subset of records
	 */
	public SearchResults( Integer totalNumberOfRecords, List<Object> records )
	{
		Contract.requires( totalNumberOfRecords != null, 'constructor called with a null totalNumberOfRecords' );
		Contract.requires( totalNumberOfRecords >= 0, 'constructor called with a negative totalNumberOfRecords' );
		Contract.requires( records != null, 'constructor called with a null records' );

		Contract.requires( totalNumberOfRecords >= records.size(), 'constructor called with a totalNumberOfRecords that is lower than the size of records' );

		this.totalNumberOfRecords = totalNumberOfRecords;
		this.records = records;
	}

	/**
	 * States if there are currently records in this result set
	 *
	 * @return  Boolean	States if there are currently records in this result set
	 */
	public Boolean hasRecords()
	{
		return !records.isEmpty();
	}
}
