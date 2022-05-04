@isTest
private without sharing class ortoo_DomainFactoryTest
{
    private static final ortoo_SelectorFactory NULL_SELECTOR_FACTORY;

    @isTest
    private static void getDomainType_whenGivenARegisteredSobjectTypeWithAConstructorType_willReturnTheRegisteredClassTypeForIt() // NOPMD: Test method name format
    {
        ortoo_DomainFactory factory = new ortoo_DomainFactory(
            NULL_SELECTOR_FACTORY,
            new Map<SObjectType,Type>
                {
                    Contact.SobjectType => ortoo_TestDomain.Constructor.class
                });

        Test.startTest();
            Type registeredType = factory.getDomainType( Contact.SobjectType );
        Test.stopTest();

        System.assertEquals( ortoo_TestDomain.class, registeredType, 'getDomainType, when given a registered SObject type linked to a constructor type, will return the registered class type for it with the constructor stripped from it' );
    }

    @isTest
    private static void getDomainType_whenGivenARegisteredSobjectTypeWithANonConstructorType_willReturnTheRegisteredClassTypeForIt() // NOPMD: Test method name format
    {
        ortoo_DomainFactory factory = new ortoo_DomainFactory(
            NULL_SELECTOR_FACTORY,
            new Map<SObjectType,Type>
                {
                    Contact.SobjectType => ortoo_TestDomain.class
                });

        Test.startTest();
            Type registeredType = factory.getDomainType( Contact.SobjectType );
        Test.stopTest();

        System.assertEquals( ortoo_TestDomain.class, registeredType, 'getDomainType, when given a registered SObject type linked to a non constructor type, will return the registered class type for it' );
    }

    @isTest
    private static void getDomainType_whenGivenAnUnregisteredSobjectType_willReturnNull() // NOPMD: Test method name format
    {
        ortoo_DomainFactory factory = new ortoo_DomainFactory(
            NULL_SELECTOR_FACTORY,
            new Map<SObjectType,Type>
                {
                    Contact.SobjectType => RegisterableType.class
                });

        Test.startTest();
            Type registeredType = factory.getDomainType( Account.SobjectType );
        Test.stopTest();

        System.assertEquals( null, registeredType, 'getDomainType, when given an unregistered SObject type, will return null' );
    }

    @isTest
    private static void getDomainType_whenCalledWithNull_willThrowAnException() // NOPMD: Test method name format
    {
        ortoo_DomainFactory factory = new ortoo_DomainFactory( NULL_SELECTOR_FACTORY, new Map<SObjectType,Type>() );

        Test.startTest();
            String exceptionMessage;
            try
            {
                SobjectType type = null;
                factory.getDomainType( type );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'getDomainType called with a null sobjectType', exceptionMessage, 'getDomainType, when called with null, will throw an exception' );
    }

    public inherited sharing class RegisterableType {}
}