/**
 * Describes a record that should be processed when saving via a DmlDefiner.
 *
 * Allows the specification of child relationships (contexts) and the children that
 * relate to this record.
 *
 * Can be set up to either ignore other (unspecified) child records, or delete them.
 *
 * Should not be used without first sub-classing it.
 *
 * @group Services/Dml
 */
public virtual inherited sharing class DmlRecord
{
	Sobject recordToDml;
	Map<String,DmlDefiner>      childRecordsByType  = new Map<String,DmlDefiner>();
	Map<String,DmlChildContext> childContextsByType = new Map<String,DmlChildContext>();

	/**
	 * Constructor, defining the SObject to perform the DML against
	 *
	 * @param	Sobject	The SObject to perform the DML against
	 */
	@testVisible
	protected DmlRecord( Sobject recordToDml )
	{
		Contract.requires( recordToDml != null, 'DmlRecord constructor called with a null recordToDml' );

		this.recordToDml = recordToDml;
	}

	/**
	 * Returns the SObject this will perform the DML against
	 *
	 * @return	Sobject	The SObject this will perform the DML against
	 */
	public Sobject getSobject()
	{
		return this.recordToDml;
	}

	/**
	 * Returns the Id that is on the SObject this will perform the DML against.
	 * Is populated after an insert has been performed
	 *
	 * @return	Id	The Id on the SObject
	 */
	public Id getSobjectId()
	{
		return this.recordToDml.Id;
	}

	/**
	 * Defines the context of a 'type' of child, thus allowing children of that type to be added
	 *
	 * @param	String			The 'Type' that will identify this child relationship
	 * @param	DmlChildContext	The Context of this child relationship, defining how it behaves.
	 * @return	DmlRecord		Itself, allowing for a fluent interface
	 */
	@testVisible
	protected DmlRecord addChildContext( String childRecordType, DmlChildContext childContext )
	{
		Contract.requires( childRecordType != null, 'addChildContext called with a null childRecordType' );
		Contract.requires( childContext != null, 'addChildContext called with a null childContext' );

		childContextsByType.put( childRecordType, childContext );
		childRecordsByType.put( childRecordType, new DmlDefiner() );
		return this;
	}

	/**
	 * Adds a child record of the specified type to this DmlRecord
	 *
	 * @param	String		The 'Type' that will identify the appropriate child relationship
	 * @param	DmlRecord	The child record to add to this DmlRecord
	 * @return	DmlRecord	Itself, allowing for a fluent interface
	 */
	@testVisible
	protected DmlRecord addChild( String childRecordType, DmlRecord childRecord )
	{
		Contract.requires( childRecordType != null, 'addChild called with a null childRecordType' );
		Contract.requires( childRecord != null, 'addChild called with a null childRecord' );

		getChildDefiner( childRecordType ).addRecord( childRecord );
		return this;
	}

	/**
	 * Adds multiple child records of the specified type to this DmlRecord
	 *
	 * @param	String			The 'Type' that will identify the appropriate child relationship
	 * @param	List<DmlRecord>	The child records to add to this DmlRecord
	 * @return	DmlRecord		Itself, allowing for a fluent interface
	 */
	@testVisible
	protected DmlRecord addChildren( String childRecordType, List<DmlRecord> childRecords )
	{
		Contract.requires( childRecordType != null, 'addChildren called with a null childRecordType' );
		Contract.requires( childRecords != null, 'addChildren called with a null childRecords' );

		getChildDefiner( childRecordType ).addRecords( childRecords );
		return this;
	}

	/**
	 * Sets the given child relationship to consist solely of the given DmlRecord
	 *
	 * Use of 'set' implies that other existing records should be deleted on save.
	 *
	 * @param	String		The 'Type' that will identify the appropriate child relationship
	 * @param	DmlRecord	The child record to set on this DmlRecord
	 * @return	DmlRecord	Itself, allowing for a fluent interface
	 */
	@testVisible
	protected DmlRecord setChild( String childRecordType, DmlRecord childRecord )
	{
		Contract.requires( childRecordType != null, 'setChild called with a null childRecordType' );
		Contract.requires( childRecord != null, 'setChild called with a null childRecord' );

		setChildren( childRecordType, new DmlDefiner( childRecord ) );
		return this;
	}

	/**
	 * Sets the given child relationship to consist solely of the given list of DmlRecords
	 *
	 * Use of 'set' implies that other existing records should be deleted on save.
	 *
	 * @param	String			The 'Type' that will identify the appropriate child relationship
	 * @param	List<DmlRecord>	The child records to set on this DmlRecord
	 * @return	DmlRecord		Itself, allowing for a fluent interface
	 */
	@testVisible
	protected DmlRecord setChildren( String childRecordType, List<DmlRecord> childRecords )
	{
		Contract.requires( childRecordType != null, 'setChildren called with a null childRecordType' );
		Contract.requires( childRecords != null, 'setChildren called with a null childRecords' );

		setChildren( childRecordType, new DmlDefiner( childRecords ) );
		return this;
	}

	/**
	 * Sets the given child relationship to consist solely of the records represented by the given DmlDefiner
	 *
	 * Use of 'set' implies that other existing records should be deleted on save.
	 *
	 * @param	String		The 'Type' that will identify the appropriate child relationship
	 * @param	DmlDefiner	The DmlDefiner representing the child records to set on this DmlRecord
	 * @return	DmlRecord	Itself, allowing for a fluent interface
	 */
	@testVisible
	protected DmlRecord setChildren( String childRecordType, DmlDefiner childRecords )
	{
		Contract.requires( childRecordType != null, 'setChildren called with a null childRecordType' );
		Contract.requires( childRecords != null, 'setChildren called with a null childRecords' );

		checkTypeIsValid( childRecordType );
		childRecords.setOptions( new DmlDefinerOptions().setOtherRecordsMode( DmlDefinerOptions.OtherRecordsOption.DELETE_RECORDS ) );
		this.childRecordsByType.put( childRecordType, childRecords );
		return this;
	}

	/**
	 * Returns the DmlDefiner that represents the child records for the given relationship
	 *
	 * @param	String		The 'Type' that will identify the child relationship for which to return
	 * @return	DmlDefiner	The definer representing the child records currently on this DmlRecord
	 */
	@testVisible
	protected DmlDefiner getChildDefiner( String childRecordType )
	{
		Contract.requires( childRecordType != null, 'getChildDefiner called with a null childRecordType' );

		checkTypeIsValid( childRecordType );
		return this.childRecordsByType.get( childRecordType );
	}


	/**
	 * Returns the Sobjects that represent the child records for the given relationship
	 *
	 * @param	String			The 'Type' that will identify the child relationship for which to return
	 * @return	List<Sobject>	The List representing the child records currently on this DmlRecord
	 */
	@testVisible
	protected List<Sobject> getChildSobjects( String childRecordType )
	{
		Contract.requires( childRecordType != null, 'getChildSobjects called with a null childRecordType' );

		return getChildDefiner( childRecordType ).getSobjects();
	}

	/**
	 * Sets the DmlDefinerOptions for the given child relationship.
	 *
	 * Should rarely be required, since the distinction between 'add' and 'set' should generally be sufficient
	 *
	 * @param	String				The 'Type' that will identify the appropriate child relationship
	 * @param	DmlDefinerOptions	The Options to set for this child relationship
	 * @return	DmlRecord			Itself, allowing for a fluent interface
	 */
	@testVisible
	protected DmlRecord setChildDmlOptions( String childRecordType, DmlDefinerOptions options )
	{
		Contract.requires( childRecordType != null, 'setChildDmlOptions called with a null childRecordType' );
		Contract.requires( options != null, 'setChildDmlOptions called with a null options' );

		getChildDefiner( childRecordType ).setOptions( options );
		return this;
	}

	/**
	 * Adds a pre-save action that should occur immediately prior to saving the individual child records
	 *
	 * @param	String				The 'Type' that will identify the appropriate child relationship
	 * @param	IDmlRecordAction	The action to perform against the child records
	 * @return	DmlRecord			Itself, allowing for a fluent interface
	 */
	public DmlRecord addChildPreSaveAction( String childRecordType, IDmlRecordAction action )
	{
		Contract.requires( childRecordType != null, 'addChildPreSaveAction called with a null childRecordType' );
		Contract.requires( action != null, 'addChildPreSaveAction called with a null action' );

		getChildDefiner( childRecordType ).addPreSaveAction( action );
		return this;
	}

	/**
	 * Performs a 'save' of the current SObject and its children.
	 *
	 * Is given a child context that defines how *this* DmlRecord relates to its parent.
	 *
	 * Should not be called directly, is public for use within the scope of the library.
	 *
	 * @param	fflib_ISObjectUnitOfWork	The unit of work to use for registering the
	 * @param	DmlChildContext				The child context that represents *this* DmlRecord's relationship with a parent
	 * @return	DmlRecord					Itself, allowing for a fluent interface
	 */
	public DmlRecord saveSobject( fflib_ISObjectUnitOfWork uow, DmlChildContext context )
	{
		Contract.requires( uow != null, 'saveSobject called with a null uow' );

		context?.registerRelationship( uow, recordToDml );
		uow.registerUpsert( recordToDml );

		for ( String thisChildRecordType : childRecordsByType.keySet() )
		{
			getChildDefiner( thisChildRecordType ).saveSobjects( uow, getChildContext( thisChildRecordType ).setParent( recordToDml ) );
		}
		return this;
	}

	/**
	 * Asks the current DmlRecord to register the children that should be deleted when saving this record.
	 *
	 * That is, it will:
	 * 		Tell ths register which child contexts need to be considered for delete
	 * 		Not to delete the current record
	 * 		Ask the children to register their child delete requirements
	 *
	 * @param	DmlChildrenToDeleteRegister	The register to record the deletes with
	 * @return	DmlRecord					Itself, allowing for a fluent interface
	 */
	public DmlRecord registerChildrenToDelete( DmlChildrenToDeleteRegister register )
	{
		Contract.requires( register != null, 'registerChildrenToDelete called with a null register' );

		if ( recordToDml.Id != null )
		{
			register.addRecordToKeep( recordToDml.Id );
		}

		for ( String childType : childContextsByType.keySet() )
		{
			DmlDefiner childDefiner = getChildDefiner( childType );
			if ( childDefiner.getOptions().getOtherRecordsMode() == DmlDefinerOptions.OtherRecordsOption.DELETE_RECORDS )
			{
				register.registerChildContextAndParent( getChildContext( childType ), recordToDml.Id );
			}
			childDefiner.registerChildrenToDelete( register );
		}
		return this;
	}

	private void checkTypeIsValid( String childRecordType )
	{
		Contract.assert( childContextsByType.containsKey( childRecordType ), 'Child type "' + childRecordType + '" does not exist ' );
	}

	@testVisible
	private DmlChildContext getChildContext( String childRecordType )
	{
		checkTypeIsValid( childRecordType );
		return childContextsByType.get( childRecordType );
	}

	@testVisible
	private Boolean getWillDeleteOtherRecords( String childRecordType )
	{
		return getChildDefiner( childRecordType )?.getWillDeleteOtherRecords();
	}
}