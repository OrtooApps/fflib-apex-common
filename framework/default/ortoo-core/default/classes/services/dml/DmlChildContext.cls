/**
 * Defines a relationship between a parent SObject and children of it.
 *
 * In defining this relationship, it allows the following to be possible:
 *      Children to have their relationship with the parent registered with a Unit of Work
 *      A IChildRecordFinder type to be defined, which allows children of
 *          a given set of parents via this relationship to be found
 *
 * The relationship to the parent is transient, and used in order to be able to reuse this
 *   child context for multiple objects.
 *
 * @group Services/Dml
 */
public inherited sharing class DmlChildContext
{
	Sobject      parent;
	Type         childFinderType;
	SobjectField relatedByField;

	private IChildRecordFinder childFinder
	{
		get
		{
			if ( childFinder == null )
			{
				childFinder = Application.CHILD_RECORD_FINDER.newInstance( childFinderType );
			}
			return childFinder;
		}
		set;
	}

	/**
	 * Constructor, defining the field on the child that relates one to the parent
	 * as well as the Class type for the appropriate Child Record Finder
	 *
	 * @param	SobjectField	The field that relates the child to the parent
	 * @param	Type			The Class type of the appropriate Child Record Finder
	 */
	public DmlChildContext( SobjectField relatedByField, Type childFinderType )
	{
		Contract.requires( relatedByField != null, 'DmlChildContext was constructed with a null relatedByField' );
		Contract.requires( childFinderType != null, 'DmlChildContext was constructed with a null childFinderType' );

		this.relatedByField  = relatedByField;
		this.childFinderType = childFinderType;
	}

	/**
	 * Sets the parent that this child context temporarily relates to.
	 *
	 * @param	Sobject			The parent SObject
	 * @return	DmlChildContext	Itself, allowing for a fluent interface
	 */
	public DmlChildContext setParent( Sobject parent )
	{
		Contract.requires( parent != null, 'setParent was called with a null parent' );

		this.parent = parent;
		return this;
	}

	/**
	 * Gets the Child Finder Type that this context uses to find children
	 *
	 * @return	Type	The type of the Child Finder
	 */
	public Type getChildFinderType()
	{
		return childFinderType;
	}

	/**
	 * Gets the Child Finder Object that this context uses to find children
	 *
	 * @return  IChildRecordFinder	The Child Finder
	 */
	public IChildRecordFinder getChildFinder()
	{
		return childFinder;
	}

	/**
	 * Instructs the child context to register the current parent as related to the given child
	 *
	 * @param	fflib_ISObjectUnitOfWork	The Unit of Work to perform the registration with
	 * @param	Sobject						The child SObject
	 */
	public void registerRelationship( fflib_ISObjectUnitOfWork uow, Sobject child )
	{
		Contract.requires( uow != null, 'registerRelationship was called with a null unit of work' );
		Contract.requires( child != null, 'registerRelationship was called with a null child' );
		Contract.requires( this.parent != null, 'registerRelationship was called before a parent was set' );

		if ( parent.Id != null && child.get( relatedByField ) == parent.Id ) { // no need to register the relationship if it's already set
			return;
		}

		// Stops us trying to update a non-updateable master relationship when we don't have the Id on the child
		// I feel like there's an ambush here, but can't work it out
		// If we always set it, then we get a problem trying to save records where it can't change, even if we're not trying to change it
		// But this will effectively swallow impossible re-parents, since it will simply not try to do them.
		if ( child.Id == null || relatedByField.getDescribe().isUpdateable() )
		{
			uow.registerRelationship( child, relatedByField, parent );
		}
	}
}