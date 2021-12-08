// TODO: document
// TODO: test
// TODO: ensure the default is constructed with one - potentially configure it
// TODO: split field level checking and object level checking?

public inherited sharing class SecureDml extends fflib_SobjectUnitOfWork.SimpleDML implements Idml
{
    public inherited sharing class SecureDmlException extends ortoo_Exception {} // TODO: add error code prefix

    public interface InaccessibleHandler
    {
        void handleUnableToInsertRecords( List<SObject> objList );
        void handleUnableToUpdateRecords( List<SObject> objList );
        void handleUnableToDeleteRecords( List<SObject> objList );
        void handleUnableToPublishEvents( List<SObject> objList );

        void handleInaccessibleFields( String operation, SObjectAccessDecision securityDecision );
    }

    InaccessibleHandler inaccessibleHandler;

    public SecureDml( InaccessibleHandler inaccessibleHandler )
    {
        this.inaccessibleHandler = inaccessibleHandler;
    }

    public override void dmlInsert( List<SObject> objList )
    {
        if ( objList.isEmpty() )
        {
            return;
        }
        if ( ! SobjectUtils.getSobjectDescribeResult( objList[0] ).isCreateable() ) // TODO: probably don't need this
        {
            inaccessibleHandler.handleUnableToInsertRecords( objList );
            return;
        }

        SObjectAccessDecision securityDecision = Security.stripInaccessible( AccessType.CREATABLE, objList );
        if ( ! securityDecision.getRemovedFields().isEmpty() )
        {
            inaccessibleHandler.handleInaccessibleFields( 'insert', securityDecision );
            replaceList( objList, securityDecision.getRecords() );
        }

        insert objList;
    }

    public override void dmlUpdate( List<SObject> objList )
    {
        if ( objList.isEmpty() )
        {
            return;
        }
        if ( ! SobjectUtils.getSobjectDescribeResult( objList[0] ).isUpdateable() )
        {
            inaccessibleHandler.handleUnableToUpdateRecords( objList );
            return;
        }

        SObjectAccessDecision securityDecision = Security.stripInaccessible( AccessType.UPDATABLE, objList );

        if ( ! securityDecision.getRemovedFields().isEmpty() )
        {
            inaccessibleHandler.handleInaccessibleFields( 'update', securityDecision );
            replaceList( objList, securityDecision.getRecords() );
        }
        update objList;
    }

    public override void dmlDelete( List<SObject> objList )
    {
        if ( objList.isEmpty() )
        {
            return;
        }
        if ( ! SobjectUtils.getSobjectDescribeResult( objList[0] ).isDeletable() )
        {
            inaccessibleHandler.handleUnableToDeleteRecords( objList );
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
        if ( ! SobjectUtils.getSobjectDescribeResult( objList[0] ).isCreateable() )
        {
            inaccessibleHandler.handleUnableToPublishEvents( objList );
            return;
        }
        SObjectAccessDecision securityDecision = Security.stripInaccessible( AccessType.CREATABLE, objList );

        if ( ! securityDecision.getRemovedFields().isEmpty() )
        {
            inaccessibleHandler.handleInaccessibleFields( 'publish', securityDecision );
            replaceList( objList, securityDecision.getRecords() );
        }
        EventBus.publish( objList );
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

    public inherited sharing class SwallowErrorOnInaccessibleHandler implements InaccessibleHandler
    {
        public void handleUnableToInsertRecords( List<SObject> objList ) {} // NOPMD: intentional 'null object' that does nothing
        public void handleUnableToUpdateRecords( List<SObject> objList ) {} // NOPMD: intentional 'null object' that does nothing
        public void handleUnableToDeleteRecords( List<SObject> objList ) {} // NOPMD: intentional 'null object' that does nothing
        public void handleUnableToPublishEvents( List<SObject> objList ) {} // NOPMD: intentional 'null object' that does nothing

        public void handleInaccessibleFields( String operation, SObjectAccessDecision securityDecision ) {} // NOPMD: intentional 'null object' that does nothing
    }

    public inherited sharing virtual class ErrorOnUnableToCudHandler implements InaccessibleHandler
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

        public virtual void handleInaccessibleFields( String operation, SObjectAccessDecision securityDecision ) {} // NOPMD: intentionally left empty

        private void throwUnableException( String errorCode, String label, List<SObject> objList )
        {
            String sobjectName = SobjectUtils.getSobjectName( objList[0] );
            throw new SecureDmlException( StringUtils.formatLabel( label, new List<String>{ sobjectName } ) )
                        .setErrorCode( '0000' )
                        .addContext( 'sobjectName', sobjectName )
                        .addContext( 'records', objList );
        }
    }

    public inherited sharing virtual class ErrorOnInaccessibleFieldsHandler extends ErrorOnUnableToCudHandler
    {
        public override void handleInaccessibleFields( String operation, SObjectAccessDecision securityDecision )
        {
            String label = 'Attempted to {0} with fields that are not accessible: {1}';
            Map<String,Set<String>> removedFields = securityDecision.getRemovedFields();

            throw new SecureDmlException( StringUtils.formatLabel( label, new List<String>{ operation, removedFields.toString() } ) )
                        .setErrorCode( '0000' )
                        .addContext( 'removedFields', removedFields )
                        .addContext( 'securityDecision', securityDecision );
        }
    }
}
