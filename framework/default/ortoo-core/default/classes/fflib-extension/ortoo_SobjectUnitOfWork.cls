/**
 * An extension of the base fflib SobjectUnitOfWork, allowing for the ability for a consumer to ask questions
 * regarding the outstanding DML work to be sent via this Unit of Work
 *
 * @group fflib Extension
 */
public virtual inherited sharing class ortoo_SobjectUnitOfWork extends fflib_SObjectUnitOfWork // NOPMD: specified a mini-namespace to differentiate from fflib versions
{
	// NOTE:
	//		If registration methods are added to this class, then they should probably also be added
	//		to ortoo_DynamicSobjectUnitOfWork
	//
	private static final Integer ROWS_OFFSET_FOR_LIBRARY		= 1; // exists because a call to commitWork will issue a savepoint, and this counds as a DML row
	private static final Integer STATEMENT_OFFSET_FOR_LIBRARY	= 1; // and a DML statement

	/**
	 * Constructor, allowing the order of Sobject DML to be defined
	 *
	 * @param	List<Schema.SObjectType>	The order of the DML operations required
	 */
	public ortoo_SobjectUnitOfWork( List<Schema.SObjectType> sObjectTypes )
	{
		super( sObjectTypes );
	}

	/**
	 * Constructor, allowing the order of Sobject DML and a custom DML interface to be defined
	 *
	 * @param	List<Schema.SObjectType>	The order of the DML operations required
	 * @param	IDML						The custom DML instance
	 */
	public ortoo_SobjectUnitOfWork( List<Schema.SObjectType> sObjectTypes, IDML dml )
	{
		super( sObjectTypes, dml );
	}

	/**
	 * Provides an elevated context for calls to the Unit of Work.
	 *
	 * Specifically, removes sharing from the call meaning that the Unit of Work can commit
	 * records that the current user would not normally have write access to.
	 *
	 * @return ortoo_SobjectUnitOfWork.ElevatedContext	The elevated context against which a commit can be issued
	 */
	public ElevatedContext elevatedContext()
	{
		return new ElevatedContext( this );
	}

	/**
	 * Provides the ability to remove sharing rules from the current context
	 */
	public without sharing class ElevatedContext
	{
		@testVisible
		ortoo_SobjectUnitOfWork uow;

		public ElevatedContext( ortoo_SobjectUnitOfWork uow )
		{
			this.uow = uow;
		}

		/**
		 * Commit the currently queued work, not applying sharing rules when that is done.
		 */
		public void commitWork()
		{
			uow.commitWork();
		}
	}

	/**
	 * Returns the number of DML rows that are pending for this Unit of Work
	 *
	 * @return	Integer	The number of rows that this Unit of Work will send for commit
	 */
	public Integer getNumberOfPendingDmlRows()
	{
		return getCountOfNewSobjectRows()
			+  getCountOfDirtySobjectRows()
			+  getCountOfDeletedSobjectRows()
			+  getCountOfEmptyRecyleBinRows()
			+  getCountOfPublishBeforeRows()
			+  getCountOfPublishAfterSuccessRows()
			+ ROWS_OFFSET_FOR_LIBRARY;
	}

	/**
	 * Returns the number of DML statements that are pending for this Unit of Work
	 *
	 * @return	Integer	The number of DML statements that this Unit of Work will issue on commit
	 */
	public Integer getNumberOfPendingDmlStatements()
	{
		return getCountOfNewSobjectStatements()
			+  getCountOfDirtySobjectStatements()
			+  getCountOfDeletedSobjectStatements()
			+  getCountOfEmptyRecyleBinStatements()
			+  getCountOfPublishBeforeStatements()
			+  getCountOfPublishAfterSuccessStatements()
			+ STATEMENT_OFFSET_FOR_LIBRARY;
	}

	private Integer getCountOfNewSobjectRows()
	{
		return getRecordCountFromMapOfLists( m_newListByType );
	}

	private Integer getCountOfNewSobjectStatements()
	{
		return getNonZeroCountFromMapOfLists( m_newListByType );
	}

	private Integer getCountOfDirtySobjectRows()
	{
		return getRecordCountFromMapOfMaps( m_dirtyMapByType );
	}

	private Integer getCountOfDirtySobjectStatements()
	{
		return getNonZeroCountFromMapOfMaps( m_dirtyMapByType );
	}

	private Integer getCountOfDeletedSobjectRows()
	{
		return getRecordCountFromMapOfMaps( m_deletedMapByType );
	}

	private Integer getCountOfDeletedSobjectStatements()
	{
		return getNonZeroCountFromMapOfMaps( m_deletedMapByType );
	}

	private Integer getCountOfEmptyRecyleBinRows()
	{
		return getRecordCountFromMapOfMaps( m_emptyRecycleBinMapByType );
	}

	private Integer getCountOfEmptyRecyleBinStatements()
	{
		return getNonZeroCountFromMapOfMaps( m_emptyRecycleBinMapByType );
	}

	private Integer getCountOfPublishBeforeRows()
	{
		return getRecordCountFromMapOfLists( m_publishBeforeListByType );
	}

	private Integer getCountOfPublishBeforeStatements()
	{
		return getNonZeroCountFromMapOfLists( m_publishBeforeListByType );
	}

	private Integer getCountOfPublishAfterSuccessRows()
	{
		return getRecordCountFromMapOfLists( m_publishAfterSuccessListByType );
	}

	private Integer getCountOfPublishAfterSuccessStatements()
	{
		return getRecordCountFromMapOfLists( m_publishAfterSuccessListByType );
	}

	private Integer getRecordCountFromMapOfMaps( Map<String,Map<Id,SObject>> mapOfMaps )
	{
		Integer count = 0;
		for ( String key : mapOfMaps.keySet() )
		{
			count += mapOfMaps.get( key ).size();
		}
		return count;
	}

	private Integer getNonZeroCountFromMapOfMaps( Map<String,Map<Id,SObject>> mapOfMaps )
	{
		Integer count = 0;
		for ( String key : mapOfMaps.keySet() )
		{
			count += mapOfMaps.get( key ).size() > 0 ? 1 : 0;
		}
		return count;
	}

	private Integer getRecordCountFromMapOfLists( Map<String,List<SObject>> mapOfLists )
	{
		Integer count = 0;
		for ( String key : mapOfLists.keySet() )
		{
			count += mapOfLists.get( key ).size();
		}
		return count;
	}

	private Integer getNonZeroCountFromMapOfLists( Map<String,List<SObject>> mapOfLists )
	{
		Integer count = 0;
		for ( String key : mapOfLists.keySet() )
		{
			count += mapOfLists.get( key ).size() > 0 ? 1 : 0;
		}
		return count;
	}

	@testVisible
	private List<SobjectType> getSobjectOrder()
	{
		return m_sObjectTypes;
	}

	@testVisible
	private IDML getIdml()
	{
		return m_dml;
	}
}