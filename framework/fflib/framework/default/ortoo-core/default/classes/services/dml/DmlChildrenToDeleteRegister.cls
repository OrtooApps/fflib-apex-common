/**
 * Provides a register of the child records that should be deleted when the DML operation is performed.
 *
 * Operates by:
 * 	Registering 'IChildRecordFinder's with the lists of Parent Ids for which the records should be removed.
 * 	Adding records that should be kept, as they are discovered
 *  Once completely configured, asking it to delete the children
 *
 * Should not be called directly, is public for access within this library
 *
 * @group Services/Dml
 */
public inherited sharing class DmlChildrenToDeleteRegister
{
	Map<Type,Set<Id>> childFinderParentIdRegister = new Map<Type,Set<Id>>();
	Map<Type,IChildRecordFinder> childFinderRegister = new Map<Type,IChildRecordFinder>();

	Set<Id> idsOfRecordsToKeep = new Set<Id>();

	/**
	 * Register a Child Record Finder and a Parent Id, stating that:
	 * 	Children of this parent should deleted - use this finder to get those children
	 *
	 * Should not be called directly, is public for access within this library
	 *
	 * @param	Type	The Type of the class that should be used to find the children.  Should implement IChildRecordFinder
	 * @param	Id		The Parent for which this finder should find the children
	 * @return	DmlChildrenToDeleteRegister	Itself, allowing for a fluent interface
	 */
	public DmlChildrenToDeleteRegister registerChildContextAndParent( DmlChildContext childContext, Id parentId )
	{
		Contract.requires( childContext != null, 'registerChildContextAndParent called with a null childContext' );
		if ( parentId == null )
		{
			return this;
		}

		Type childFinderType = childContext.getChildFinderType();
		Contract.assert( childFinderType != null, 'registerChildContextAndParent called with a DmlChildContext that returns a null Child Finder Type' );

		IChildRecordFinder childFinder = childContext.getChildFinder();
		Contract.assert( childFinder != null, 'registerChildContextAndParent called with a DmlChildContext that returns a null Child Finder' );

		if ( ! childFinderParentIdRegister.keySet().contains( childFinderType ) )
		{
			childFinderParentIdRegister.put( childFinderType, new Set<Id>() );
			childFinderRegister.put( childFinderType, childFinder );
		}
		childFinderParentIdRegister.get( childFinderType ).add( parentId );
		return this;
	}

	/**
	 * Register that the child record with the given Id should be kept, and not deleted.
	 *
	 * Should not be called directly, is public for access within this library
	 *
	 * @param	Id	The Id of the record to keep
	 * @return	DmlChildrenToDeleteRegister	Itself, allowing for a fluent interface
	 */
	public DmlChildrenToDeleteRegister addRecordToKeep( Id id )
	{
		if ( id != null )
		{
			idsOfRecordsToKeep.add( id );
		}
		return this;
	}

	/**
	 * Delete the children of the registered parents, leaving behind any records that
	 * have been specified as needing to be kept
	 *
	 * Should not be called directly, is public for access within this library
	 *
	 * @param	fflib_ISObjectUnitOfWork	The Unit of Work that should be used to register the delete operations
	 * @return	DmlChildrenToDeleteRegister	Itself, allowing for a fluent interface
	 */
	public DmlChildrenToDeleteRegister deleteChildren( fflib_ISObjectUnitOfWork uow )
	{
		Map<Id,Sobject> recordsToDeleteById = new Map<Id,Sobject>();

		for ( Type thisChildFinderType : childFinderParentIdRegister.keySet() )
		{
			IChildRecordFinder finder = childFinderRegister.get( thisChildFinderType );
			List<Sobject> newRecordsToDelete = finder.findRecords( childFinderParentIdRegister.get( thisChildFinderType ) );
			recordsToDeleteById.putAll( newRecordsToDelete );
		}

		if ( recordsToDeleteById.isEmpty() )
		{
			return this;
		}

		MapUtils.remove( recordsToDeleteById, idsOfRecordsToKeep );

		if ( recordsToDeleteById.isEmpty() )
		{
			return this;
		}

		uow.registerDeleted( recordsToDeleteById.values() );
		return this;
	}

	@testVisible
	private Set<Id> getIdsOfRecordsToKeep()
	{
		return idsOfRecordsToKeep;
	}

	@testVisible
	private Map<Type,Set<Id>> getChildFinderParentIdRegister()
	{
		return childFinderParentIdRegister;
	}

	@testVisible
	private Map<Type,IChildRecordFinder> getChildFinderRegister()
	{
		return childFinderRegister;
	}
}