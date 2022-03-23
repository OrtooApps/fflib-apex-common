/**
 * Exists as a mechanism for passing complex DML statements via the service.
 *
 * Allows us to create parent / child structures, and on the structure state that
 * a given set of children are the only records that should exist once the transaction is
 * complete.
 *
 * Should only ever be used within a parameter into a service method named 'saveRecords'
 *
 * @group Services/Dml
 */
public inherited sharing class DmlDefiner
{
	@testVisible
	List<DmlRecord>   recordsToDml;
	DmlDefinerOptions options;

	List<IDmlRecordAction> preSaveActions = new List<IDmlRecordAction>();

	/**
	 * Constructor, creating a DmlDefiner with no DmlRecords to perform the DML against
	 */
	public DmlDefiner()
	{
		this( new List<DmlRecord>() );
	}

	/**
	 * Constructor, creating a DmlDefiner with a single DmlRecord to perform the DML against
	 *
	 * @param DmlRecord The record to perform the DML against
	 */
	public DmlDefiner( DmlRecord recordToDml )
	{
		this( new List<DmlRecord>{ recordToDml } );
	}

	/**
	 * Constructor, creating a DmlDefiner with a list of DmlRecords to perform the DML against
	 *
	 * @param List<DmlRecord> The records to perform the DML against
	 */
	public DmlDefiner( List<DmlRecord> recordsToDml )
	{
		this.recordsToDml = recordsToDml;
		this.options	  = DmlDefinerOptions.default();
	}

	/**
	 * Add the given DmlRecord to the list of DmlRecords to perform the DML against
	 *
	 * @param	DmlRecord	The additional record to perform the DML against
	 * @return	DmlDefiner	Itself, allowing for a fluent interface
	 */
	public DmlDefiner addRecord( DmlRecord recordToDml )
	{
		Contract.requires( recordToDml != null, 'addRecord called with a null record' );

		this.recordsToDml.add( recordToDml );
		return this;
	}

	/**
	 * Add the given list of DmlRecords to the list of DmlRecords to perform the DML against
	 *
	 * @param	List<DmlRecord>	The list of additional records to perform the DML against
	 * @return	DmlDefiner  	Itself, allowing for a fluent interface
	 */
	public DmlDefiner addRecords( List<DmlRecord> recordsToDml )
	{
		Contract.requires( recordsToDml != null, 'addRecords called with a null list of records' );

		this.recordsToDml.addAll( recordsToDml );
		return this;
	}

	/**
	 * Specify the options for this DmlDefiner's DML operations
	 *
	 * @param	DmlDefinerOptions	The options for this DmlDefiner's operations
	 * @return	DmlDefiner  		Itself, allowing for a fluent interface
	 */
	public DmlDefiner setOptions( DmlDefinerOptions options )
	{
		Contract.requires( options != null, 'setOptions called with a null options' );

		this.options = options;
		return this;
	}

	/**
	 * Get the options for this DmlDefiner's DML operations
	 *
	 * Should not be called directly, is public for access within this library
	 *
	 * @param	DmlDefinerOptions	The options for this DmlDefiner's operations
	 */
	public DmlDefinerOptions getOptions()
	{
		return this.options;
	}

	/**
	 * Adds a pre-save action that should be performed against all records prior to
	 * them being saved.
	 *
	 * Is generally used for defining deep validation of objects that requires reference to
	 * child records and therefore is not possible in a trigger
	 *
	 * @param	IDmlRecordAction	The action to perform against the records prior to the save
	 */
	public DmlDefiner addPreSaveAction( IDmlRecordAction action )
	{
		Contract.requires( action != null, 'addPreSaveAction called with a null action' );

		this.preSaveActions.add( action );
		return this;
	}

	/**
	 * Stores the currently configured DmlRecords, in line with the specified options, performing
	 * any pre-save operatations that have been defined.
	 *
	 * Will delete any child records that should be deleted, as per the specified options.
	 *
	 * @param	fflib_ISObjectUnitOfWork	The Unit of Work that should be used to register the DML operations
	 */
	public void saveSobjects( fflib_ISObjectUnitOfWork uow )
	{
		DmlChildrenToDeleteRegister register = new DmlChildrenToDeleteRegister();
		registerChildrenToDelete( register );
		register.deleteChildren( uow );

		saveSobjects( uow, null );
	}

	/**
	 * Stores the currently configured DmlRecords, performing any pre-save operatations that have been defined.
	 *
	 * Should not be called directly, is public for access within this library
	 *
	 * @param	fflib_ISObjectUnitOfWork	The Unit of Work that should be used to register the DML operations
	 */
	public void saveSobjects( fflib_ISObjectUnitOfWork uow, DmlChildContext context )
	{
		for ( DmlRecord thisRecord : recordsToDml )
		{
			for ( IDmlRecordAction thisAction : preSaveActions )
			{
				thisAction.actUpon( thisRecord );
			}
			thisRecord.saveSobject( uow, context );
		}
	}

	/**
	 * Ensures that any child records that should be deleted (as per the configured options) are
	 * reported into the specified DmlChildrenToDeleteRegister
	 *
	 * Should not be called directly, is public for access within this library
	 *
	 * @param	DmlChildrenToDeleteRegister	The register into which the children to delete should be sent
	 * @return	DmlDefiner  				Itself, allowing for a fluent interface
	 */
	public DmlDefiner registerChildrenToDelete( DmlChildrenToDeleteRegister register )
	{
		for ( DmlRecord thisRecord : recordsToDml )
		{
			thisRecord.registerChildrenToDelete( register );
		}
		return this;
	}

	/**
	 * Returns the SObjects that are registered with this DmlDefiner to be updated.
	 * Does not include any child records.
	 *
	 * @return	List<Sobject>	The list of SObjects that this DmlDefiner will perform DML against
	 */
	public List<Sobject> getSobjects()
	{
		List<Sobject> sobjects = new List<Sobject>();

		for ( DmlRecord thisRecord : recordsToDml )
		{
			sobjects.add( thisRecord.getSobject() );
		}
		return sobjects;
	}

	/**
	 * States if this definer is configured to ensure that other records are deleted
	 *
	 * @return	Boolean	Will other records be deleted
	 */
	public Boolean getWillDeleteOtherRecords() {
		Contract.assert( options != null, 'getWillDeleteOtherRecords was called when options was null' );
		return options.getWillDeleteOtherRecords();
	}

	@testVisible
	private List<DmlRecord> getDmlRecords() {
		return recordsToDml;
	}

	@testVisible
	private List<IDmlRecordAction> getPreSaveActions() {
		return preSaveActions;
	}
}