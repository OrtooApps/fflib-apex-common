@isTest
private without sharing class ortoo_UnitOfWorkFactoryTest // NOPMD: mini-namespace to distinguich from fflib version
{
    @isTest
    private static void newInstance_whenGivenNoObjectOrder_willCreateAnInstanceWithTheDefaultOrder() // NOPMD: Test method name format
    {
        List<SobjectType> defaultOrder = new List<SobjectType>{ Account.sobjectType, Contact.sobjectType };
        ortoo_UnitOfWorkFactory factory = new ortoo_UnitOfWorkFactory( defaultOrder );
        ortoo_SobjectUnitOfWork uow = (ortoo_SobjectUnitOfWork)factory.newInstance();

        System.assertEquals( defaultOrder, uow.getSobjectOrder(), 'newInstance, when given no object order, will create an instance with the default order' );
    }

    @isTest
    private static void newInstance_whenGivenAnObjectOrder_willCreateAnInstanceWithThatOrder() // NOPMD: Test method name format
    {
        List<SobjectType> defaultOrder = new List<SobjectType>{ Account.sobjectType, Contact.sobjectType };
        List<SobjectType> passedOrder  = new List<SobjectType>{ Contact.sobjectType, Account.sobjectType };
        ortoo_UnitOfWorkFactory factory = new ortoo_UnitOfWorkFactory( defaultOrder );

        ortoo_SobjectUnitOfWork uow = (ortoo_SobjectUnitOfWork)factory.newInstance( passedOrder );

        System.assertEquals( passedOrder, uow.getSobjectOrder(), 'newInstance, when given an object order, will create an instance with that order' );
    }

    @isTest
    private static void newInstance_whenGivenAnIdml_willCreateAnInstanceWithTheDefaultOrder() // NOPMD: Test method name format
    {
        List<SobjectType> defaultOrder = new List<SobjectType>{ Account.sobjectType, Contact.sobjectType };
        ortoo_UnitOfWorkFactory factory = new ortoo_UnitOfWorkFactory( defaultOrder );

        RegisterableIdml idml = new RegisterableIdml();
        ortoo_SobjectUnitOfWork uow = (ortoo_SobjectUnitOfWork)factory.newInstance( idml );

        System.assertEquals( defaultOrder, uow.getSobjectOrder(), 'newInstance, when given no object order and an idml, will create an instance with the default order' );
        System.assertEquals( idml, uow.getIdml(), 'newInstance, when given no object order and an idml, will create an instance with the idml' );
    }

    @isTest
    private static void newInstance_whenGivenAnObjectOrderAndAnIdml_willCreateAnInstanceWithThatOrderAndIdml() // NOPMD: Test method name format
    {
        List<SobjectType> defaultOrder = new List<SobjectType>{ Account.sobjectType, Contact.sobjectType };
        List<SobjectType> passedOrder  = new List<SobjectType>{ Contact.sobjectType, Account.sobjectType };
        ortoo_UnitOfWorkFactory factory = new ortoo_UnitOfWorkFactory( defaultOrder );

        RegisterableIdml idml = new RegisterableIdml();
        ortoo_SobjectUnitOfWork uow = (ortoo_SobjectUnitOfWork)factory.newInstance( passedOrder, idml );

        System.assertEquals( passedOrder, uow.getSobjectOrder(), 'newInstance, when given an idml and object order, will create an instance with that order' );
        System.assertEquals( idml, uow.getIdml(), 'newInstance, when given an idml and object order and an idml, will create an instance with the idml' );
    }

    @isTest
    private static void newInstance_whenGivenNoParameters_willCreateAVersionWithNoDefaultObjectOrder() // NOPMD: Test method name format
    {
        ortoo_UnitOfWorkFactory factory = new ortoo_UnitOfWorkFactory();

        RegisterableIdml idml = new RegisterableIdml();
        ortoo_SobjectUnitOfWork uow = (ortoo_SobjectUnitOfWork)factory.newInstance( idml );

        System.assertEquals( 0, uow.getSobjectOrder().size(), 'newInstance, when given no parameters, will create a version with no object order' );
    }

    @isTest
    private static void setMock_whenNewInstanceIsCalledWithoutAnOrder_willReturnTheMock() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork mockUow = (ortoo_SobjectUnitOfWork)new Amoss_Instance( ortoo_SobjectUnitOfWork.class ).getDouble();
        ortoo_UnitOfWorkFactory factory = new ortoo_UnitOfWorkFactory();

        Test.startTest();
            factory.setMock( mockUow );
            ortoo_SobjectUnitOfWork returnedUow = (ortoo_SobjectUnitOfWork)factory.newInstance();
        Test.stopTest();

        System.assertEquals( mockUow, returnedUow, 'setMock, when new instance is called without an order, will return the mock' );
    }

    @isTest
    private static void setMock_whenNewInstanceIsCalledWithAnOrder_willReturnTheMock() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork mockUow = (ortoo_SobjectUnitOfWork)new Amoss_Instance( ortoo_SobjectUnitOfWork.class ).getDouble();
        ortoo_UnitOfWorkFactory factory = new ortoo_UnitOfWorkFactory();

        Test.startTest();
            factory.setMock( mockUow );
            ortoo_SobjectUnitOfWork returnedUow = (ortoo_SobjectUnitOfWork)factory.newInstance( new List<SobjectType>{ Contact.sobjectType } );
        Test.stopTest();

        System.assertEquals( mockUow, returnedUow, 'setMock, when new instance is called without an order, will return the mock' );
    }

    @isTest
    private static void setMock_whenNewInstanceIsCalledWithAnIdml_willReturnTheMock() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork mockUow = (ortoo_SobjectUnitOfWork)new Amoss_Instance( ortoo_SobjectUnitOfWork.class ).getDouble();
        ortoo_UnitOfWorkFactory factory = new ortoo_UnitOfWorkFactory();

        Test.startTest();
            factory.setMock( mockUow );
            RegisterableIdml idml = new RegisterableIdml();
            ortoo_SobjectUnitOfWork returnedUow = (ortoo_SobjectUnitOfWork)factory.newInstance( idml );
        Test.stopTest();

        System.assertEquals( mockUow, returnedUow, 'setMock, when new instance is called without an order, will return the mock' );
    }

    @isTest
    private static void setMock_whenNewInstanceIsCalledWithAnIdmlAndOrder_willReturnTheMock() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork mockUow = (ortoo_SobjectUnitOfWork)new Amoss_Instance( ortoo_SobjectUnitOfWork.class ).getDouble();
        ortoo_UnitOfWorkFactory factory = new ortoo_UnitOfWorkFactory();

        Test.startTest();
            factory.setMock( mockUow );
            RegisterableIdml idml = new RegisterableIdml();
            ortoo_SobjectUnitOfWork returnedUow = (ortoo_SobjectUnitOfWork)factory.newInstance( new List<SobjectType>{ Contact.sobjectType }, idml );
        Test.stopTest();

        System.assertEquals( mockUow, returnedUow, 'setMock, when new instance is called without an order, will return the mock' );
    }

    private without sharing class RegisterableIdml implements fflib_SObjectUnitOfWork.IDML
    {
        public void dmlInsert(List<SObject> objList) {} // NOPMD: empty implementation for tests
        public void dmlUpdate(List<SObject> objList) {} // NOPMD: empty implementation for tests
        public void dmlDelete(List<SObject> objList) {} // NOPMD: empty implementation for tests
        public void eventPublish(List<SObject> objList) {} // NOPMD: empty implementation for tests
	    public void emptyRecycleBin(List<SObject> objList) {} // NOPMD: empty implementation for tests
    }
}