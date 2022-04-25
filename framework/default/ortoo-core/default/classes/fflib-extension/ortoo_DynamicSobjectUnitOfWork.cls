/**
 * An extension of ortoo fflib SobjectUnitOfWork, adding the ability to dynamically work out the
 * order in which the operations should take place.
 *
 * I.E. the construction does not require the specification of the supported SObjects and the order in
 * which they are sent to the database.  As the work is queued, the instance will register the types
 * and then calculate the order of operations based on a directed graph.
 *
 * Does not support circular references and will throw an exception if one is detected.
 *
 * Note: this will not perform as well as a pre-configured ortoo_SobjectUnitOfWork and so should only
 * be used when the order of operations is not known at compile time.
 *
 * @group fflib Extension
 */
public inherited sharing class ortoo_DynamicSobjectUnitOfWork extends ortoo_SobjectUnitOfWork
{
	DirectedGraph graph = new DirectedGraph();
	Set<Schema.SObjectType> registeredTypes = new Set<Schema.SObjectType>();

	/**
	 * Default parameterless constructor
	 *
	 */
	public ortoo_DynamicSobjectUnitOfWork()
	{
		super( new List<Schema.SObjectType>() );
	}

	/**
	 * Constructor, allowing a custom DML interface to be defined
	 *
	 * @param	IDML	The custom DML instance
	 */
	public ortoo_DynamicSobjectUnitOfWork( IDML dml )
	{
		super( new List<Schema.SObjectType>(), dml );
	}

	/**
	 * Register an deleted record to be removed from the recycle bin during the commitWork method
	 *
	 * @param record An deleted record
	 **/
	public override void registerEmptyRecycleBin( SObject record )
	{
		registerType( record );
		super.registerEmptyRecycleBin( record );
	}

	/**
	 * Register deleted records to be removed from the recycle bin during the commitWork method
	 *
	 * @param records Deleted records
	 **/
	public override void registerEmptyRecycleBin( List<SObject> records )
	{
		registerTypes( records );
		super.registerEmptyRecycleBin( records );
	}

    /**
     * Register a newly created SObject instance to be inserted when commitWork is called
     *
     * @param record A newly created SObject instance to be inserted during commitWork
     **/
    public override void registerNew( SObject record )
    {
		registerType( record );
		super.registerNew( record );
    }

    /**
     * Register a list of newly created SObject instances to be inserted when commitWork is called
     *
     * @param records A list of newly created SObject instances to be inserted during commitWork
     **/
    public override void registerNew( List<SObject> records )
    {
		registerTypes( records );
		super.registerNew( records );
    }

    /**
     * Register a newly created SObject instance to be inserted when commitWork is called,
     *   you may also provide a reference to the parent record instance (should also be registered as new separately)
     *
     * @param record A newly created SObject instance to be inserted during commitWork
     * @param relatedToParentField A SObjectField reference to the child field that associates the child record with its parent
     * @param relatedToParentRecord A SObject instance of the parent record (should also be registered as new separately)
     **/
    public override void registerNew( SObject record, Schema.SObjectField relatedToParentField, SObject relatedToParentRecord )
    {
		registerType( record );
		if ( relatedToParentRecord != null )
		{
			registerTypeRelationship( record, relatedToParentRecord );
		}
		super.registerNew( record, relatedToParentField, relatedToParentRecord );
    }

    /**
     * Register a relationship between two records that have yet to be inserted to the database. This information will be
     *  used during the commitWork phase to make the references only when related records have been inserted to the database.
     *
     * @param record An existing or newly created record
     * @param relatedToField A SObjectField reference to the lookup field that relates the two records together
     * @param relatedTo A SObject instance (yet to be committed to the database)
     */
    public override void registerRelationship( SObject record, Schema.SObjectField relatedToField, SObject relatedTo )
    {
		if ( relatedTo != null )
		{
			registerTypeRelationship( record, relatedTo );
		}

		super.registerRelationship( record, relatedToField, relatedTo );
	}

    /**
     * Register an existing record to be updated during the commitWork method
     *
     * @param record An existing record
     **/
    public override void registerDirty( SObject record )
    {
		registerType( record );
        super.registerDirty( record );
    }

    /**
     * Registers the entire records as dirty or just only the dirty fields if the record was already registered
     *
     * @param records SObjects to register as dirty
     * @param dirtyFields A list of modified fields
     */
    public override void registerDirty( List<SObject> records, List<SObjectField> dirtyFields )
    {
		registerTypes( records );
        super.registerDirty( records, dirtyFields );
    }

	/**
	 * Registers the entire record as dirty or just only the dirty fields if the record was already registered
	 *
	 * @param record SObject to register as dirty
	 * @param dirtyFields A list of modified fields
	 */
    public override void registerDirty( SObject record, List<SObjectField> dirtyFields )
    {
		registerType( record );
        super.registerDirty( record, dirtyFields );
    }

    /**
     * Register an existing record to be updated when commitWork is called,
     *   you may also provide a reference to the parent record instance (should also be registered as new separately)
     *
     * @param record A newly created SObject instance to be inserted during commitWork
     * @param relatedToParentField A SObjectField reference to the child field that associates the child record with its parent
     * @param relatedToParentRecord A SObject instance of the parent record (should also be registered as new separately)
     **/
    public override void registerDirty( SObject record, Schema.SObjectField relatedToParentField, SObject relatedToParentRecord )
    {
		registerType( record );

		if ( relatedToParentRecord != null )
		{
			registerTypeRelationship( record, relatedToParentRecord );
		}

        super.registerDirty( record, relatedToParentField, relatedToParentRecord );
    }

    /**
     * Register a list of existing records to be updated during the commitWork method
     *
     * @param records A list of existing records
     **/
    public override void registerDirty( List<SObject> records )
    {
		registerTypes( records );
        super.registerDirty( records );
    }

    /**
     * Register a new or existing record to be inserted/updated during the commitWork method
     *
     * @param record A new or existing record
     **/
    public override void registerUpsert( SObject record )
    {
		registerType( record );
		super.registerUpsert( record );
    }

    /**
     * Register a list of mix of new and existing records to be inserted updated during the commitWork method
     *
     * @param records A list of mix of new and existing records
     **/
    public override void registerUpsert( List<SObject> records )
    {
		registerTypes( records );
		super.registerUpsert( records );
    }

    /**
     * Register an existing record to be deleted during the commitWork method
     *
     * @param record An existing record
     **/
    public override void registerDeleted( SObject record )
    {
		registerType( record );
		super.registerDeleted( record );
    }

    /**
     * Register a list of existing records to be deleted during the commitWork method
     *
     * @param records A list of existing records
     **/
    public override void registerDeleted( List<SObject> records )
    {
		registerTypes( records );
		super.registerDeleted( records );
    }

	/**
     * Register a list of existing records to be deleted and removed from the recycle bin during the commitWork method
     *
     * @param records A list of existing records
     **/
    public override void registerPermanentlyDeleted( List<SObject> records )
    {
		registerTypes( records );
		super.registerPermanentlyDeleted( records );
    }

	/**
     * Register a list of existing records to be deleted and removed from the recycle bin during the commitWork method
     *
     * @param record A list of existing records
     **/
    public override void registerPermanentlyDeleted( SObject record )
    {
		registerType( record );
		super.registerPermanentlyDeleted( record );
    }

    /**
     * Register a newly created SObject (Platform Event) instance to be published when commitWork is called
     *
     * @param record A newly created SObject (Platform Event) instance to be inserted during commitWork
     **/
    public override void registerPublishBeforeTransaction( SObject record )
    {
		registerType( record );
		super.registerPublishBeforeTransaction( record );
    }

    /**
     * Register a list of newly created SObject (Platform Event) instance to be published when commitWork is called
     *
     * @param records A list of existing records
     **/
    public override void registerPublishBeforeTransaction( List<SObject> records )
    {
		registerTypes( records );
		super.registerPublishBeforeTransaction( records );
    }

    /**
     * Register a newly created SObject (Platform Event) instance to be published when commitWork is called
     *
     * @param record A newly created SObject (Platform Event) instance to be inserted during commitWork
     **/
    public override void registerPublishAfterSuccessTransaction( SObject record )
    {
		registerType( record );
		super.registerPublishAfterSuccessTransaction( record );
    }

    /**
     * Register a list of newly created SObject (Platform Event) instance to be published when commitWork is called
     *
     * @param records A list of existing records
     **/
    public override void registerPublishAfterSuccessTransaction( List<SObject> records )
    {
		registerTypes( records );
		super.registerPublishAfterSuccessTransaction( records );
    }
    /**
     * Register a newly created SObject (Platform Event) instance to be published when commitWork is called
     *
     * @param record A newly created SObject (Platform Event) instance to be inserted during commitWork
     **/
    public override void registerPublishAfterFailureTransaction( SObject record )
    {
		registerType( record );
		super.registerPublishAfterFailureTransaction( record );
    }

    /**
     * Register a list of newly created SObject (Platform Event) instance to be published when commitWork is called
     *
     * @param records A list of existing records
     **/
    public override void registerPublishAfterFailureTransaction( List<SObject> records )
    {
		registerTypes( records );
		super.registerPublishAfterFailureTransaction( records );
    }

	public override void onCommitWorkStarting()
	{
		setOrderOfOperations( generateOrderOfOperations() );
	}

	private void setOrderOfOperations( List<Schema.SObjectType> orderOfOperations )
	{
		m_sObjectTypes = orderOfOperations.clone();
	}

	private void registerType( Sobject record )
	{
		registerType( SobjectUtils.getSobjectType( record ) );
	}

	private void registerTypes( List<Sobject> records )
	{
		Set<Schema.SObjectType> types = SobjectUtils.getSobjectTypes( records );
		for ( Schema.SObjectType thisType : types )
		{
			registerType( thisType );
		}
	}

	private void registerType( Schema.SObjectType typeToRegister )
	{
		if ( registeredTypes.contains( typeToRegister ) )
		{
			return;
		}

		registeredTypes.add( typeToRegister );
		graph.addNode( typeToRegister );
		handleRegisterType( typeToRegister );
	}

	private void registerTypeRelationship( Sobject child, Sobject parent )
	{
		registerTypeRelationship( SobjectUtils.getSobjectType( child ), SobjectUtils.getSobjectType( parent ) );
	}

	private void registerTypeRelationship( Schema.SObjectType child, Schema.SObjectType parent )
	{
		graph.addRelationship( child, parent );
	}

	private List<SobjectType> generateOrderOfOperations()
	{
		List<Object> childToParentTypes;
		try
		{
			childToParentTypes = graph.generateSorted();
		}
		catch ( DirectedGraph.GraphContainsCircularReferenceException e )
		{

			throw new Exceptions.ConfigurationException( 'Cannot resolve the order of work to be done for the commit, there is a circular reference in the data\n' + graph.toString(), e );
		}

		List<SobjectType> parentToChildTypes = new List<SobjectType>();
		for( Integer i = childToParentTypes.size() - 1; i >= 0; i-- )
		{
			parentToChildTypes.add( (SobjectType)childToParentTypes[i] );
		}
		return parentToChildTypes;
	}
}