@isTest
private without sharing class ortoo_DynamicUnitOfWorkFactoryTest // NOPMD: mini-namespace to distinguich from fflib version
{
    @isTest
    private static void newInstance_whenGivenNoIdml_willReturnAnInstanceWithASecureDml() // NOPMD: Test method name format
    {
        ortoo_DynamicUnitOfWorkFactory factory = new ortoo_DynamicUnitOfWorkFactory();
        ortoo_DynamicSobjectUnitOfWork uow = (ortoo_DynamicSobjectUnitOfWork)factory.newInstance();

        System.assert( uow.getIdml() instanceOf SecureDml, 'newInstance, when given no dml, will create an instance with a secure dml' );
    }

    @isTest
    private static void newInstance_whenGivenAnIdml_willCreateAnInstanceWithThatIdml() // NOPMD: Test method name format
    {
        ortoo_DynamicUnitOfWorkFactory factory = new ortoo_DynamicUnitOfWorkFactory();

        RegisterableIdml IDml = new RegisterableIdml();
        ortoo_DynamicSobjectUnitOfWork uow = (ortoo_DynamicSobjectUnitOfWork)factory.newInstance( IDml );

        System.assertEquals( IDml, uow.getIdml(), 'newInstance, when given no object order and an IDml, will create an instance with the IDml' );
    }

    @isTest
    private static void setMock_whenNewInstanceIsCalledWithoutAnIdml_willReturnTheMock() // NOPMD: Test method name format
    {
        ortoo_DynamicSobjectUnitOfWork mockUow = (ortoo_DynamicSobjectUnitOfWork)new Amoss_Instance( ortoo_DynamicSobjectUnitOfWork.class ).getDouble();
        ortoo_DynamicUnitOfWorkFactory factory = new ortoo_DynamicUnitOfWorkFactory();

        Test.startTest();
            factory.setMock( mockUow );
            ortoo_DynamicSobjectUnitOfWork returnedUow = (ortoo_DynamicSobjectUnitOfWork)factory.newInstance();
        Test.stopTest();

        System.assertEquals( mockUow, returnedUow, 'setMock, when new instance is called without a DML, will return the mock' );
    }

    @isTest
    private static void setMock_whenNewInstanceIsCalledWithAnIdml_willReturnTheMock() // NOPMD: Test method name format
    {
        ortoo_DynamicSobjectUnitOfWork mockUow = (ortoo_DynamicSobjectUnitOfWork)new Amoss_Instance( ortoo_DynamicSobjectUnitOfWork.class ).getDouble();
        ortoo_DynamicUnitOfWorkFactory factory = new ortoo_DynamicUnitOfWorkFactory();

        Test.startTest();
            factory.setMock( mockUow );
            RegisterableIdml IDml = new RegisterableIdml();
            ortoo_DynamicSobjectUnitOfWork returnedUow = (ortoo_DynamicSobjectUnitOfWork)factory.newInstance( IDml );
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