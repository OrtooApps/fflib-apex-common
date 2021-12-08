// TODO: document
// TODO: test
public inherited sharing class SecureDml extends fflib_SobjectUnitOfWork.SimpleDML implements fflib_SobjectUnitOfWork.IDml
{
	public inherited sharing class SecureDmlException extends ortoo_Exception {} // TODO: add error code prefix

	public interface UnableToDmlHandler
	{
		void handleUnableToInsertRecords( List<SObject> objList );
		void handleUnableToUpdateRecords( List<SObject> objList );
		void handleUnableToDeleteRecords( List<SObject> objList );
		void handleUnableToPublishEvents( List<SObject> objList );
	}

	public interface InaccessibleFieldsHandler
	{
		void handleInaccessibleFields( String operation, String sobjectTypeName, Set<String> removedFields );
	}

	InaccessibleFieldsHandler inaccessibleFieldsHandler;
	UnableToDmlHandler unableToDmlHandler;

	Boolean ignoreCud = false;
	Set<SobjectType> ignoreCudForSobjectTypes = new Set<SobjectType>();

	Boolean ignoreFls = false;
	Set<SobjectType> ignoreFlsForSobjectTypes = new Set<SobjectType>();
	Map<SobjectType,Set<String>> ignoreFlsForFields = new Map<SobjectType,Set<String>>();

	public SecureDml()
	{
		setInaccessibleFieldsHandler( new ErrorOnInaccessibleFieldsHandler() );
		setUnableToDmlHandler( new ErrorOnUnableToDmlHandler() );
	}

	public SecureDml setInaccessibleFieldsHandler( InaccessibleFieldsHandler inaccessibleFieldsHandler )
	{
		this.inaccessibleFieldsHandler = inaccessibleFieldsHandler;
		return this;
	}

	public SecureDml setUnableToDmlHandler( UnableToDmlHandler unableToDmlHandler )
	{
		this.unableToDmlHandler = unableToDmlHandler;
		return this;
	}

	public SecureDml ignoreFls()
	{
		ignoreFls = true;
		return this;
	}

	public SecureDml ignoreFlsFor( SobjectType type )
	{
		Contract.requires( type != null, 'ignoreFlsFor called with a null type' );

		ignoreFlsForSobjectTypes.add( type );
		return this;
	}

	public SecureDml ignoreFlsFor( SobjectType type, SobjectField field )
	{
		Contract.requires( type != null, 'ignoreFlsFor called with a null type' );
		Contract.requires( field != null, 'ignoreFlsFor called with a null field' );

		if ( ! ignoreFlsForFields.containsKey( type ) )
		{
			ignoreFlsForFields.put( type, new Set<String>() );
		}
		ignoreFlsForFields.get( type ).add( field.getDescribe().getName() ); // SobjectUtils?
		return this;
	}

	public override void dmlInsert( List<SObject> objList )
	{
		if ( objList.isEmpty() )
		{
			return;
		}

		if ( shouldCheckCud( objList[0] ) && ! SobjectUtils.isCreateable( objList[0] ) ) // TODO: probably don't need this
		{
			unableToDmlHandler.handleUnableToInsertRecords( objList );
			return;
		}

		if ( shouldCheckFls( objList[0] ) )
		{
			checkFls( objList, AccessType.CREATABLE, 'insert' );
		}

		insert objList;
	}

	public override void dmlUpdate( List<SObject> objList )
	{
		if ( objList.isEmpty() )
		{
			return;
		}

		if ( shouldCheckCud( objList[0] ) && ! SobjectUtils.isUpdateable( objList[0] ) )
		{
			unableToDmlHandler.handleUnableToUpdateRecords( objList );
			return;
		}

		if ( shouldCheckFls( objList[0] ) )
		{
			checkFls( objList, AccessType.UPDATABLE, 'update' );
		}
		update objList;
	}

	public override void dmlDelete( List<SObject> objList )
	{
		if ( objList.isEmpty() )
		{
			return;
		}

		if ( shouldCheckCud( objList[0] ) && ! SobjectUtils.isDeletable( objList[0] ) )
		{
			unableToDmlHandler.handleUnableToDeleteRecords( objList );
			return;
		}
		delete objList;
	}

	// TODO: is this needed?
	public override void eventPublish( List<SObject> objList )
	{
		if ( objList.isEmpty() )
		{
			return;
		}

		if ( shouldCheckCud( objList[0] ) && ! SobjectUtils.isCreateable( objList[0] ) ) // SobjectUtils.isCreateable( objList[0] )
		{
			unableToDmlHandler.handleUnableToPublishEvents( objList );
			return;
		}

		if ( shouldCheckFls( objList[0] ) )
		{
			checkFls( objList, AccessType.CREATABLE, 'piblish' );
		}

		EventBus.publish( objList );
	}

	private void checkFls( List<Sobject> objList, AccessType mode, String modeName )
	{
		String sobjectTypeName = SobjectUtils.getSobjectName( objList[0] );
		SObjectAccessDecision securityDecision = Security.stripInaccessible( mode, objList );
		Set<String> removedFields = securityDecision.getRemovedFields().get( sobjectTypeName );

		if ( ! removedFields.isEmpty() )
		{
			List<Sobject> strippedRecords = securityDecision.getRecords();
			removedFields = unstripAccessible( removedFields, objList, strippedRecords );

			if ( ! removedFields.isEmpty() )
			{
				inaccessibleFieldsHandler.handleInaccessibleFields( modeName, sobjectTypeName, removedFields );
				replaceList( objList, strippedRecords );
			}
		}
	}

	private static void replaceList( List<Sobject> originalList, List<Sobject> newList )
	{
		Contract.requires( originalList != null, 'replaceList called with a null originalList' );
		Contract.requires( newList != null, 'replaceList called with a null newList' );
		Contract.requires( originalList.size() == newList.size(), 'replaceList called with lists that are different sizes' );

		for ( Integer i; i < originalList.size(); i++ )
		{
			originalList[i] = newList[i];
		}
	}

	private Set<String> unstripAccessible(Set<String> removedFields, List<Sobject> originalRecords, List<Sobject> strippedRecords )
	{
		Set<String> ignoredFlsFields = getIgnoredFlsFieldsForSobject( originalRecords[0] );

		Set<String> fieldsToUnstrip = removedFields.clone();
		fieldsToUnstrip.retainAll( ignoredFlsFields );
		System.debug( 'fieldsToUnstrip: ' + fieldsToUnstrip );

		Set<String> remainingRemovedFields = removedFields.clone();
		remainingRemovedFields.removeAll( fieldsToUnstrip );
		System.debug( 'remainingRemovedFields: ' + remainingRemovedFields );

		if ( remainingRemovedFields.isEmpty() ) // nothing should have been stripped, so the original records are OK
		{
			replaceList( strippedRecords, originalRecords );
			return remainingRemovedFields;
		}

		if ( fieldsToUnstrip.isEmpty() ) // nothing needs to be put back, so the original stripped records are OK
		{
			return remainingRemovedFields;
		}

		// We need to put the ignored, but stripped, fields back
		List<Sobject> unstrippedRecords = new List<Sobject>();
		for ( Integer i=0; i < originalRecords.size(); i++ )
		{
			Sobject thisOriginalRecord = originalRecords[i];
			Sobject thisStrippedRecord = strippedRecords[i];

			System.debug( 'thisOriginalRecord: ' + thisOriginalRecord );
			System.debug( 'thisStrippedRecord: ' + thisStrippedRecord );

			Map<String,Object> populatedFields = thisOriginalRecord.getPopulatedFieldsAsMap();

			for ( String thisFieldToUnstrip : fieldsToUnstrip )
			{
				if ( populatedFields.containsKey( thisFieldToUnstrip ) )
				{
					thisStrippedRecord.put( thisFieldToUnstrip, thisOriginalRecord.get( thisFieldToUnstrip ) );
				}
			}
			System.debug( 'unstripped: ' + thisStrippedRecord );

			unstrippedRecords.add( thisStrippedRecord );
		}

		replaceList( strippedRecords, unstrippedRecords );
		return remainingRemovedFields;
	}

	private Boolean shouldCheckCud( Sobject record )
	{
		if ( ignoreCud )
		{
			return false;
		}
		if ( ignoreCudForSobjectTypes.isEmpty() )
		{
			return true;
		}
		return ! ignoreCudForSobjectTypes.contains( SobjectUtils.getSobjectType( record ) );
	}

	private Boolean shouldCheckFls( Sobject record )
	{
		if ( ignoreFls )
		{
			return false;
		}
		if ( ignoreFlsForSobjectTypes.isEmpty() )
		{
			return true;
		}
		return ! ignoreFlsForSobjectTypes.contains( SobjectUtils.getSobjectType( record ) );
	}

	private Set<String> getIgnoredFlsFieldsForSobject( Sobject record )
	{
		System.debug( 'record: ' + record );

		Set<String> fieldsToIgnore = ignoreFlsForFields.get( SobjectUtils.getSobjectType( record ) );
		System.debug( 'fieldsToIgnore: ' + fieldsToIgnore );
		if ( fieldsToIgnore == null )
		{
			fieldsToIgnore = new Set<String>();
		}
		return fieldsToIgnore;
	}

	public inherited sharing virtual class ErrorOnUnableToDmlHandler implements UnableToDmlHandler
	{
		public void handleUnableToInsertRecords( List<SObject> objList )
		{
			throwUnableException( '00001', 'Attempted to insert {0} records without the required permission', objList );
		}
		public void handleUnableToUpdateRecords( List<SObject> objList )
		{
			throwUnableException( '00002', 'Attempted to update {0} records without the required permission', objList );
		}
		public void handleUnableToDeleteRecords( List<SObject> objList )
		{
			throwUnableException( '00003', 'Attempted to delete {0} records without the required permission', objList );
		}
		public void handleUnableToPublishEvents( List<SObject> objList )
		{
			throwUnableException( '00004', 'Attempted to publish {0} events without the required permission', objList );
		}

		private void throwUnableException( String errorCode, String label, List<SObject> objList )
		{
			String sobjectTypeName = SobjectUtils.getSobjectName( objList[0] );
			throw new SecureDmlException( StringUtils.formatLabel( label, new List<String>{ sobjectTypeName } ) )
						.setErrorCode( '0000' )
						.addContext( 'sobjectTypeName', sobjectTypeName )
						.addContext( 'records', objList );
		}
	}

	public inherited sharing virtual class ErrorOnInaccessibleFieldsHandler implements InaccessibleFieldsHandler
	{
		public void handleInaccessibleFields( String operation, String sobjectTypeName, Set<String> removedFields )
		{
			String label = 'Attempted to {0} {1} with fields that are not accessible: {2}';

			throw new SecureDmlException( StringUtils.formatLabel( label, new List<String>{ operation, sobjectTypeName, removedFields.toString() } ) )
						.setErrorCode( '0000' )
						.addContext( 'sobjectTypeName', sobjectTypeName )
						.addContext( 'removedFields', removedFields );
		}
	}
}