// TODO: test
// TODO: error codes
// TODO: labels
/**
 * Is an implementation of the IDml interface used to manage the DML operations in an SObject Unit of Work.
 *
 * Implementation is secure by default, ensuring that FLS and CUD (CRUD without the Read) security is adhered to.
 *
 * Allows ther turning off of security at multiple levels:
 * 		FLS checking for a given field
 * 		FLS checking for a given SObject Type
 * 		FLS checking for all SObjects
 * 		CUD checking for a given SObject Type
 * 		CUD checking for all SObjects
 */
public inherited sharing class SecureDml extends fflib_SobjectUnitOfWork.SimpleDML implements fflib_SobjectUnitOfWork.IDml
{
	public inherited sharing class SecureDmlException extends ortoo_Exception {} // TODO: add error code prefix

	/**
	 * Interface that defines a handler for if and when a CUD violation occurs.
	 */
	public interface CudViolationHandler
	{
		void handleUnableToInsertRecords( List<SObject> objList );
		void handleUnableToUpdateRecords( List<SObject> objList );
		void handleUnableToDeleteRecords( List<SObject> objList );
		void handleUnableToPublishEvents( List<SObject> objList );
	}

	/**
	 * Interface that defines a handler for if and when an FLS violation occurs.
	 */
	public interface FlsViolationHandler
	{
		void handleInaccessibleFields( AccessType mode, SobjectType sobjectType, Set<String> fieldsInViolation );
	}

	FlsViolationHandler flsViolationHandler;
	CudViolationHandler cudViolationHandler;

	Boolean ignoreCud = false;
	Set<SobjectType> ignoreCudForSobjectTypes = new Set<SobjectType>();

	Boolean ignoreFls = false;
	Set<SobjectType> ignoreFlsForSobjectTypes = new Set<SobjectType>();
	Map<SobjectType,Set<String>> ignoreFlsForFields = new Map<SobjectType,Set<String>>();

	/**
	 * Default constructor that ensures that security violations result in Exceptions being thrown
	 */
	public SecureDml()
	{
		setFlsViolationHandler( new ErrorOnFlsViolationHandler() );
		setCudViolationHandler( new ErrorOnCudViolationHandler() );
	}

	/**
	 * Set the Handler that should be used when an FLS violoation occurs
	 *
	 * @param	FlsViolationHandler	The FLS violation handler to use
	 * @return	SecureDml			Itself, allowing for a fluent interface
	 */
	public SecureDml setFlsViolationHandler( FlsViolationHandler flsViolationHandler )
	{
		this.flsViolationHandler = flsViolationHandler;
		return this;
	}

	/**
	 * Set the Handler that should be used when an CUD violation occurs
	 *
	 * @param	FlsViolationHandler	The FLS violation handler to use
	 * @return	SecureDml					Itself, allowing for a fluent interface
	 */
	public SecureDml setCudViolationHandler( CudViolationHandler cudViolationHandler )
	{
		this.cudViolationHandler = cudViolationHandler;
		return this;
	}

	/**
	 * Disables FLS checking for this instance
	 *
	 * @return	SecureDml Itself, allowing for a fluent interface
	 */
	public SecureDml ignoreFls()
	{
		ignoreFls = true;
		return this;
	}

	/**
	 * Disables FLS checking for all records of the given SObject Type
	 *
	 * @param	SobjectType	The Sobject Type for which to disable FLS
	 * @return	SecureDml	Itself, allowing for a fluent interface
	 */
	public SecureDml ignoreFlsFor( SobjectType type )
	{
		Contract.requires( type != null, 'ignoreFlsFor called with a null type' );

		ignoreFlsForSobjectTypes.add( type );
		return this;
	}

	/**
	 * Disables FLS checking for all records of the given SObject Field
	 *
	 * @param	SobjectType		The Sobject Type for which to disable FLS
	 * @param	SobjectField	The Sobject Field for which to disable FLS
	 * @return	SecureDml		Itself, allowing for a fluent interface
	 */
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

	/**
	 * Disables CUD settings checking for this instance
	 *
	 * @return	SecureDml Itself, allowing for a fluent interface
	 */
	public SecureDml ignoreCudSettings()
	{
		ignoreCud = true;
		return this;
	}

	/**
	 * Disables CUD settings checking for all records of the given SObject Type
	 *
	 * @param	SobjectType	The Sobject Type for which to disable CUD checking
	 * @return	SecureDml	Itself, allowing for a fluent interface
	 */
	public SecureDml ignoreCudSettingsFor( SobjectType type )
	{
		Contract.requires( type != null, 'ignoreCudSettingsFor called with a null type' );

		ignoreCudForSobjectTypes.add( type );
		return this;
	}

	/**
	 * Performs the DML Insert, whilst also checking CUD and FLS rights, based on the configuration.
	 *
	 * @param	List<SObject>	The list of records to insert
	 */
	public override void dmlInsert( List<SObject> objList )
	{
		if ( objList.isEmpty() )
		{
			return;
		}

		SobjectType type = SobjectUtils.getSobjectType( objList[0] );

		if ( shouldCheckCud( type ) && ! SobjectUtils.isCreateable( objList[0] ) )
		{
			cudViolationHandler.handleUnableToInsertRecords( objList );
			return;
		}

		if ( shouldCheckFls( type ) )
		{
			checkFls( objList, AccessType.CREATABLE );
		}

		insert objList;
	}

	/**
	 * Performs the DML Update, whilst also checking CUD and FLS rights, based on the configuration.
	 *
	 * @param	List<SObject>	The list of records to update
	 */
	public override void dmlUpdate( List<SObject> objList )
	{
		if ( objList.isEmpty() )
		{
			return;
		}

		SobjectType type = SobjectUtils.getSobjectType( objList[0] );

		if ( shouldCheckCud( type ) && ! SobjectUtils.isUpdateable( objList[0] ) )
		{
			cudViolationHandler.handleUnableToUpdateRecords( objList );
			return;
		}

		if ( shouldCheckFls( type ) )
		{
			checkFls( objList, AccessType.UPDATABLE );
		}
		update objList;
	}

	/**
	 * Performs the DML Delete, whilst also checking CUD and FLS rights, based on the configuration.
	 *
	 * @param	List<SObject>	The list of records to insert
	 */
	public override void dmlDelete( List<SObject> objList )
	{
		if ( objList.isEmpty() )
		{
			return;
		}

		SobjectType type = SobjectUtils.getSobjectType( objList[0] );

		if ( shouldCheckCud( type ) && ! SobjectUtils.isDeletable( objList[0] ) )
		{
			cudViolationHandler.handleUnableToDeleteRecords( objList );
			return;
		}
		delete objList;
	}

	/**
	 * Performs the DML Publish, whilst also checking CUD and FLS rights, based on the configuration.
	 *
	 * @param	List<SObject>	The list of records to insert
	 */
	public override void eventPublish( List<SObject> objList )
	{
		if ( objList.isEmpty() )
		{
			return;
		}

		SobjectType type = SobjectUtils.getSobjectType( objList[0] );

		if ( shouldCheckCud( type ) && ! SobjectUtils.isCreateable( objList[0] ) ) // SobjectUtils.isCreateable( objList[0] )
		{
			cudViolationHandler.handleUnableToPublishEvents( objList );
			return;
		}

		if ( shouldCheckFls( type ) )
		{
			checkFls( objList, AccessType.CREATABLE );
		}

		EventBus.publish( objList );
	}

	/**
	 * Checks the FLS for the given Sobject, in the given mode.
	 * In the case of violation, report it to the flsViolationHandler.
	 *
	 * @param	List<SObject>	The list of records for which to to check the FLS
	 * @param	AccessType		The access type that needs to be checked
	 */
	private void checkFls( List<Sobject> objList, AccessType mode )
	{
		String sobjectTypeName = SobjectUtils.getSobjectName( objList[0] );
		SObjectAccessDecision securityDecision = Security.stripInaccessible( mode, objList );
		Set<String> removedFields = securityDecision.getRemovedFields().get( sobjectTypeName );

		if ( removedFields != null && !removedFields.isEmpty() )
		{
			List<Sobject> strippedRecords = securityDecision.getRecords();
			removedFields = unstripAccessible( removedFields, objList, strippedRecords );

			if ( ! removedFields.isEmpty() )
			{
				flsViolationHandler.handleInaccessibleFields( mode, SobjectUtils.getSobjectType( objList[0] ), removedFields );
				replaceList( objList, strippedRecords );
			}
		}
	}

	/**
	 * Reviews the configured 'ignoreFlsFor' fields for the given records and puts back any populated fields that should have been ignored.
	 *
	 * Is needed since we can't tell stripInaccessible to skip checking of certain fields.
	 *
	 * Will mutate the stripped records so that they now contain the specified field values again.
	 *
	 * @param	Set<String> 	The fields that were previously removed from the records
	 * @param	List<SObject>	The original list of records, prior to field values being stripped
	 * @param	List<SObject>	The new list of records, after the field values were stripped
	 * @return	Set<String>		The new, potentially reduced list of 'removed fields
	 */
	private Set<String> unstripAccessible( Set<String> removedFields, List<Sobject> originalRecords, List<Sobject> strippedRecords )
	{
		SobjectType type = SobjectUtils.getSobjectType( originalRecords[0] );

		Set<String> ignoredFlsFields = getIgnoredFlsFields( type );

		Set<String> fieldsToUnstrip = removedFields.clone();
		fieldsToUnstrip.retainAll( ignoredFlsFields );

		Set<String> remainingRemovedFields = removedFields.clone();
		remainingRemovedFields.removeAll( fieldsToUnstrip );

		if ( remainingRemovedFields.isEmpty() ) // nothing should have been stripped, so the original records are OK
		{
			replaceList( strippedRecords, originalRecords );
			return remainingRemovedFields;
		}

		if ( fieldsToUnstrip.isEmpty() ) // nothing needs to be put back, so the original stripped records are OK
		{
			return remainingRemovedFields;
		}

		// We need to put the ignored, but previously stripped, fields back
		List<Sobject> unstrippedRecords = new List<Sobject>();
		for ( Integer i=0; i < originalRecords.size(); i++ )
		{
			Sobject thisOriginalRecord = originalRecords[i];
			Sobject thisStrippedRecord = strippedRecords[i];

			Map<String,Object> populatedFields = thisOriginalRecord.getPopulatedFieldsAsMap();

			for ( String thisFieldToUnstrip : fieldsToUnstrip )
			{
				if ( populatedFields.containsKey( thisFieldToUnstrip ) )
				{
					thisStrippedRecord.put( thisFieldToUnstrip, thisOriginalRecord.get( thisFieldToUnstrip ) );
				}
			}
			unstrippedRecords.add( thisStrippedRecord );
		}

		replaceList( strippedRecords, unstrippedRecords );
		return remainingRemovedFields;
	}

	/**
	 * States if CUD settings should be checked for the given SObject type
	 *
	 * @param	SobjectType		The type for which to ascertain if CUD should be checked
	 * @return	Boolean			Should CUD be checked
	 */
	private Boolean shouldCheckCud( SobjectType type )
	{
		if ( ignoreCud )
		{
			return false;
		}
		if ( ignoreCudForSobjectTypes.isEmpty() )
		{
			return true;
		}
		return ! ignoreCudForSobjectTypes.contains( type );
	}

	/**
	 * States if FLS settings should be checked for the given SObject type
	 *
	 * @param	SobjectType		The type for which to ascertain if FLS should be checked
	 * @return	Boolean			Should FLS be checked
	 */
	private Boolean shouldCheckFls( SobjectType type )
	{
		if ( ignoreFls )
		{
			return false;
		}
		if ( ignoreFlsForSobjectTypes.isEmpty() )
		{
			return true;
		}
		return ! ignoreFlsForSobjectTypes.contains( type );
	}

	/**
	 * Returns the Set of fields that should have FLS ignored, for the given SObject type
	 *
	 * @param	SobjectType		The type for which the ignored fields should be returned
	 * @return	Set<String>		The fields to ignore the FLS of
	 */
	private Set<String> getIgnoredFlsFields( SobjectType type )
	{
		Set<String> fieldsToIgnore = ignoreFlsForFields.get( type );

		if ( fieldsToIgnore == null )
		{
			fieldsToIgnore = new Set<String>();
		}
		return fieldsToIgnore;
	}

	/**
	 * Given two lists, will update the first so that is contains the values in the second list.
	 *
	 * Allows parameters to be mutated with new values easily.
	 *
	 * Requires that the lists be of the same length.
	 *
	 * @param	List<Sobject>	The original list to be replaced
	 * @param	List<Sobject>	The new list to replace the original list with
	 */
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

	/**
	 * CudViolationHandler that ensures that exceptions are thrown when CUD violations occur
	 */
	public inherited sharing virtual class ErrorOnCudViolationHandler implements CudViolationHandler
	{
		/**
		 * Throws an exception describing the insert CUD violation
		 *
		 * @param	List<SObject>	The list of SObjects that caused the violation.
		 */
		public void handleUnableToInsertRecords( List<SObject> objList )
		{
			throwUnableException( '00001', 'Attempted to insert {0} records without the required permission', objList ); // TODO: label
		}

		/**
		 * Throws an exception describing the update CUD violation
		 *
		 * @param	List<SObject>	The list of SObjects that caused the violation.
		 */
		public void handleUnableToUpdateRecords( List<SObject> objList )
		{
			throwUnableException( '00002', 'Attempted to update {0} records without the required permission', objList ); // TODO: label
		}

		/**
		 * Throws an exception describing the delete CUD violation
		 *
		 * @param	List<SObject>	The list of SObjects that caused the violation.
		 */
		public void handleUnableToDeleteRecords( List<SObject> objList )
		{
			throwUnableException( '00003', 'Attempted to delete {0} records without the required permission', objList ); // TODO: label
		}

		/**
		 * Throws an exception describing the publish CUD violation
		 *
		 * @param	List<SObject>	The list of SObjects that caused the violation.
		 */
		public void handleUnableToPublishEvents( List<SObject> objList )
		{
			throwUnableException( '00004', 'Attempted to publish {0} events without the required permission', objList ); // TODO: label
		}

		private void throwUnableException( String errorCode, String label, List<SObject> objList )
		{
			String sobjectTypeName = SobjectUtils.getSobjectName( objList[0] );
			throw new SecureDmlException( StringUtils.formatLabel( label, new List<String>{ sobjectTypeName } ) )
						.setErrorCode( '0000' )
						.addContext( 'sobjectTypeName', sobjectTypeName )
						.addContext( 'records', objList )
						.regenerateStackTraceString( 2 ); // push the stack trace string into the point that called the hander, rather than the handler itself
		}
	}

	/**
	 * FlsViolationHandler that ensures that exceptions are thrown when FLS violations occur
	 */
	public inherited sharing virtual class ErrorOnFlsViolationHandler implements FlsViolationHandler
	{
		/**
		 * Throws an exception describing the FLS violation
		 *
		 * @param	AccessType		The mode of the operation that was being performed when the violation occurred
		 * @param	SobjectType		The Sobject Type that the violation occurred against
		 * @param	Set<String>		The names of the fields that violated FLS
		 */
		public void handleInaccessibleFields( AccessType mode, SobjectType sobjectType, Set<String> fieldsInViolation )
		{
			Map<AccessType,String> descriptionByMode = new Map<AccessType,String>{
				AccessType.CREATABLE  => 'insert', // TODO: label
				AccessType.UPDATABLE  => 'update', // TODO: label
				AccessType.UPSERTABLE => 'upsert'  // TODO: label
			};

			String label = 'Attempted to {0} {1} with fields that are not accessible: {2}'; // TODO: label
			String modeDescription = descriptionByMode.get( mode );
			String sobjectTypeName = SobjectUtils.getSobjectName( sobjectType );

			throw new SecureDmlException( StringUtils.formatLabel( label, new List<String>{ modeDescription, sobjectTypeName, fieldsInViolation.toString() } ) )
						.setErrorCode( '0000' )
						.addContext( 'sobjectTypeName', sobjectTypeName )
						.addContext( 'fieldsInViolation', fieldsInViolation )
						.regenerateStackTraceString( 2 ); // push the stack trace string into the point that called the hander, rather than the handler itself
		}
	}
}