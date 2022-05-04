@isTest
public without sharing class ortoo_TestDomain extends ortoo_SobjectDomain
{
    public ortoo_TestDomain( List<Sobject> sObjectList )
    {
        super( sObjectList );
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable
    {
        public fflib_SObjectDomain construct( List<SObject> sObjectList )
        {
            return new ortoo_TestDomain( sObjectList );
        }
    }
}