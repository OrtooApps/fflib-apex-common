@isTest
private without sharing class ortoo_SelectorFactoryTest
{
    @isTest
    private static void getSelectorType_whenGivenARegisteredSobjectType_willReturnTheRegisteredClassTypeForIt() // NOPMD: Test method name format
    {
        ortoo_SelectorFactory factory = new ortoo_SelectorFactory( new Map<SObjectType,Type>
        {
            Contact.SobjectType => RegisterableType.class
        });

        Test.startTest();
            Type registeredType = factory.getSelectorType( Contact.SobjectType );
        Test.stopTest();

        System.assertEquals( RegisterableType.class, registeredType, 'getSelectorType, when given a registered SObject type, will return the registered class type for it' );
    }

    @isTest
    private static void getSelectorType_whenGivenAnUnregisteredSobjectType_willReturnNull() // NOPMD: Test method name format
    {
        ortoo_SelectorFactory factory = new ortoo_SelectorFactory( new Map<SObjectType,Type>
        {
            Contact.SobjectType => RegisterableType.class
        });

        Test.startTest();
            Type registeredType = factory.getSelectorType( Account.SobjectType );
        Test.stopTest();

        System.assertEquals( null, registeredType, 'getSelectorType, when given an unregistered SObject type, will return null' );
    }

    @isTest
    private static void getDomainType_whenCalledWithNull_willThrowAnException() // NOPMD: Test method name format
    {
        ortoo_SelectorFactory factory = new ortoo_SelectorFactory( new Map<SObjectType,Type>() );

        Test.startTest();
            String exceptionMessage;
            try
            {
                SobjectType type = null;
                factory.getSelectorType( type );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'getSelectorType called with a null sobjectType', exceptionMessage, 'getSelectorType, when called with null, will throw an exception' );
    }

    public inherited sharing class RegisterableType {}
}