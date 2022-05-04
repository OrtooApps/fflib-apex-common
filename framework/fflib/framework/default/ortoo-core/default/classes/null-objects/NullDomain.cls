/**
 * Is a Domain object that does nothing other than track that certain overridden methods have been called
 */
public inherited sharing class NullDomain extends ortoo_SobjectDomain
{
    public static Set<String> methodsCalled = new Set<String>();

    public NullDomain( List<Sobject> sObjectList )
    {
        super( sObjectList );
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable
    {
        public fflib_SObjectDomain construct( List<SObject> sObjectList )
        {
            return new NullDomain( sObjectList );
        }
    }

    public override void onBeforeInsert()
    {
        methodsCalled.add( getCalledMethodName() );
    }
    public override void onBeforeUpdate(Map<Id,SObject> existingRecords)
    {
        methodsCalled.add( getCalledMethodName() );
    }
    public override void onBeforeDelete()
    {
        methodsCalled.add( getCalledMethodName() );
    }
    public override void onAfterInsert()
    {
        methodsCalled.add( getCalledMethodName() );
    }
    public override void onAfterUpdate(Map<Id,SObject> existingRecords)
    {
        methodsCalled.add( getCalledMethodName() );
    }
    public override void onAfterDelete()
    {
        methodsCalled.add( getCalledMethodName() );
    }
    public override void onAfterUndelete()
    {
        methodsCalled.add( getCalledMethodName() );
    }
    private String getCalledMethodName() {
        return new StackTrace( 1 ).getInnermostMethodName();
    }
}