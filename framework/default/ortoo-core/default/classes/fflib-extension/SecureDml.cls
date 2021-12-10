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
public inherited sharing virtual class SecureDml extends fflib_SobjectUnitOfWork.SimpleDML implements fflib_SobjectUnitOfWork.IDml
{
	public inherited sharing class SecureDmlException extends ortoo_Exception
	{
		protected virtual override String resolveErrorCode( String errorCode )
		{
			return 'DML-' + errorCode;
		}
	}

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

		if ( shouldCheckCud( type ) && ! userCanCreate( objList[0] ) )
		{
			cudViolationHandler.handleUnableToInsertRecords( objList );
			return;
		}

		if ( shouldCheckFls( type ) )
		{
			checkFls( objList, AccessType.CREATABLE );
		}

		doInsert( objList );
	}

	protected virtual void doInsert( List<SObject> objList )
	{
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

		if ( shouldCheckCud( type ) && ! userCanUpdate( objList[0] ) )
		{
			cudViolationHandler.handleUnableToUpdateRecords( objList );
			return;
		}

		if ( shouldCheckFls( type ) )
		{
			checkFls( objList, AccessType.UPDATABLE );
		}
		doUpdate( objList );
	}

	protected virtual void doUpdate( List<SObject> objList )
	{
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

		if ( shouldCheckCud( type ) && ! userCanDelete( objList[0] ) )
		{
			cudViolationHandler.handleUnableToDeleteRecords( objList );
			return;
		}
		doDelete( objList );
	}

	protected virtual void doDelete( List<SObject> objList )
	{
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

		if ( shouldCheckCud( type ) && ! userCanPublish( objList[0] ) )
		{
			cudViolationHandler.handleUnableToPublishEvents( objList );
			return;
		}

		doPublish( objList );
	}

	protected virtual void doPublish( List<SObject> objList )
	{
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
		SecurityDecision securityDecision = stripInaccessible( mode, objList );

		if ( securityDecision.fieldsWereRemoved( sobjectTypeName ) )
		{
			Set<String>	  removedFields   = securityDecision.getRemovedFieldsFor( sobjectTypeName );
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
	@testVisible
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
		}

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

		for ( Integer i=0; i < originalList.size(); i++ )
		{
			originalList[i] = newList[i];
		}
	}

	// This method cannot be reliably unit tested in a framework that does not inculde profiles and suchlike
	// Is implemented as virtual so tests can override it and drive behaviour
	protected virtual Boolean userCanCreate( Sobject record )
	{
		return SobjectUtils.isCreateable( record );
	}

	// This method cannot be reliably unit tested in a framework that does not inculde profiles and suchlike
	// Is implemented as virtual so tests can override it and drive behaviour
	protected virtual Boolean userCanPublish( Sobject event )
	{
		return SobjectUtils.isCreateable( event );
	}

	// This method cannot be reliably unit tested in a framework that does not inculde profiles and suchlike
	// Is implemented as virtual so tests can override it and drive behaviour
	protected virtual Boolean userCanUpdate( Sobject record )
	{
		return SobjectUtils.isUpdateable( record );
	}

	// This method cannot be reliably unit tested in a framework that does not inculde profiles and suchlike
	// Is implemented as virtual so tests can override it and drive behaviour
	protected virtual Boolean userCanDelete( Sobject record )
	{
		return SobjectUtils.isUpdateable( record );
	}

	// This method cannot be reliably unit tested in a framework that does not inculde profiles and suchlike.
	// Is implemented as virtual so tests can override it and drive behaviour
	protected virtual SecurityDecision stripInaccessible( AccessType mode, List<Sobject> objList )
	{
		return new SecurityDecision( Security.stripInaccessible( mode, objList, false ) );
	}

	/**
	 * Wrapper for SObjectAccessDecision, the result of a Security.stripInaccessible call.
	 * Allows tests to change the behaviour of the FLS call without requiring any FLS to be set up.
	 * That is, SObjectAccessDecision cannot be created and configured, but the SecurityDecision
	 * inner class can.
	 */
	@testVisible
	private inherited sharing class SecurityDecision
	{
		Map<String,Set<String>> removedFields;
		List<Sobject> records;

		/**
		 * Constructs the SecurityDecision with the result from a Security.stripInaccessible call.
		 *
		 * @param	SObjectAccessDecision	The decision to wrap
		 */
		public SecurityDecision( SObjectAccessDecision securityDecision )
		{
			this( securityDecision.getRemovedFields(), securityDecision.getRecords() );
		}

		/**
		 * Constructs explicitly defined remove field lists and transformed records
		 *
		 * @param	Map<String,Set<String>>	The fields that were removed, indexed by the SObject Name
		 * @param	List<Sobject>			The records with the specified fields removed
		 */
		@testVisible
		private SecurityDecision( Map<String,Set<String>> removedFields, List<Sobject> records )
		{
			this.removedFields = removedFields;
			this.records       = records;
		}

		/**
		 * States if fields were removed from the given Sobject Type
		 *
		 * @param	String	The Name of the Sobject Type to check
		 * @return	Boolean	Were fields removed
		 */
		public Boolean fieldsWereRemoved( String sobjectTypeName )
		{
			return !removedFields.isEmpty() && removedFields.containsKey( sobjectTypeName );
		}

		/**
		 * Returns the new version of the records with the inaccessible fields stripped
		 *
		 * @return	List<Sobject>	The new version of the records
		 */
		public List<Sobject> getRecords()
		{
			return records;
		}

		/**
		 * Returns the fields that were removed from the Sobjects of the given type
		 *
		 * @param	String		The Sobject Type name to get the removed fields for
		 * @return	Set<String>	The names of the removed fields
		 */
		public Set<String> getRemovedFieldsFor( String sobjectTypeName )
		{
			if ( removedFields.containsKey( sobjectTypeName ) )
			{
				return removedFields.get( sobjectTypeName );
			}
			return new Set<String>();
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
			throwUnableException( FrameworkErrorCodes.DML_INSERT_NOT_ALLOWED, Label.ortoo_core_crud_insert_violation, objList );
		}

		/**
		 * Throws an exception describing the update CUD violation
		 *
		 * @param	List<SObject>	The list of SObjects that caused the violation.
		 */
		public void handleUnableToUpdateRecords( List<SObject> objList )
		{
			throwUnableException( FrameworkErrorCodes.DML_UPDATE_NOT_ALLOWED, Label.ortoo_core_crud_update_violation, objList );
		}

		/**
		 * Throws an exception describing the delete CUD violation
		 *
		 * @param	List<SObject>	The list of SObjects that caused the violation.
		 */
		public void handleUnableToDeleteRecords( List<SObject> objList )
		{
			throwUnableException( FrameworkErrorCodes.DML_DELETE_NOT_ALLOWED, Label.ortoo_core_crud_delete_violation, objList );
		}

		/**
		 * Throws an exception describing the publish CUD violation
		 *
		 * @param	List<SObject>	The list of SObjects that caused the violation.
		 */
		public void handleUnableToPublishEvents( List<SObject> objList )
		{
			throwUnableException( FrameworkErrorCodes.DML_PUBLISH_NOT_ALLOWED, Label.ortoo_core_crud_publish_violation, objList );
		}

		private void throwUnableException( String errorCode, String label, List<SObject> objList )
		{
			String sobjectTypeName = SobjectUtils.getSobjectName( objList[0] );
			throw new SecureDmlException( StringUtils.formatLabel( label, new List<String>{ sobjectTypeName } ) )
						.setErrorCode( errorCode )
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
				AccessType.CREATABLE  => Label.ortoo_core_insert,
				AccessType.UPDATABLE  => Label.ortoo_core_update,
				AccessType.UPSERTABLE => Label.ortoo_core_upsert
			};

			String label = Label.ortoo_core_fls_violation;
			String modeDescription = descriptionByMode.get( mode );
			String sobjectTypeName = SobjectUtils.getSobjectName( sobjectType );

			throw new SecureDmlException( StringUtils.formatLabel( label, new List<String>{ modeDescription, sobjectTypeName, fieldsInViolation.toString() } ) )
						.setErrorCode( FrameworkErrorCodes.DML_ON_INACCESSIBLE_FIELDS )
						.addContext( 'sobjectTypeName', sobjectTypeName )
						.addContext( 'fieldsInViolation', fieldsInViolation )
						.regenerateStackTraceString( 2 ); // push the stack trace string into the point that called the hander, rather than the handler itself
		}
	}
}