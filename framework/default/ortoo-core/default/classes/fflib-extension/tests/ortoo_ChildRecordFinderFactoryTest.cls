@isTest
private without sharing class ortoo_ChildRecordFinderFactoryTest
{
    @isTest
    private static void newInstance_whenNoMappingsAreDefined_willReturnThePassedType() // NOPMD: Test method name format
    {
        ortoo_ChildRecordFinderFactory factory = new ortoo_ChildRecordFinderFactory();

        Test.startTest();
            IChildRecordFinder returnedInstance = factory.newInstance( RegisterableType.class );
        Test.stopTest();

        System.assertNotEquals( null, returnedInstance, 'newInstance, when no mappings are defined, will return an instantiated object' );
        System.assert( returnedInstance instanceof RegisterableType, 'newInstance, when no mappings are defined, will return the passed type' );
    }

    @isTest
    private static void newInstance_whenMappingsAreDefined_willReturnTheMappedType() // NOPMD: Test method name format
    {
        ortoo_ChildRecordFinderFactory factory = new ortoo_ChildRecordFinderFactory(
            new Map<Type,Type>
            {
                Object.class => RegisterableType.class
            }
        );

        Test.startTest();
            IChildRecordFinder returnedInstance = factory.newInstance( Object.class );
        Test.stopTest();

        System.assertNotEquals( null, returnedInstance, 'newInstance, when mappings are defined and a mapped type is mapped, will return an instantiated object' );
        System.assert( returnedInstance instanceof RegisterableType, 'newInstance, when mappings are defined and a mapped type is mapped, will return the passed type' );
    }

    @isTest
    private static void newInstance_whenCalledForATypeThatHasAMockSet_willReturnTheRegisteredMock() // NOPMD: Test method name format
    {
        ortoo_ChildRecordFinderFactory factory = new ortoo_ChildRecordFinderFactory();

        RegisterableType mockInstance = new RegisterableType( 'mockone' );

        Test.startTest();
            factory.setMock( Object.class, mockInstance );
            IChildRecordFinder returnedInstance = factory.newInstance( Object.class );
        Test.stopTest();

        System.assertEquals( mockInstance, returnedInstance, 'newInstance, when called for a type that has a mock set, will return the registered mock' );
    }

    @isTest
    private static void newInstance_whenCalledForAnUnmappedTypeThatIsNotAChildFinder_willThrowAnException() // NOPMD: Test method name format
    {
        ortoo_ChildRecordFinderFactory factory = new ortoo_ChildRecordFinderFactory();

        Test.startTest();
            String exceptionMessage;
            try
            {
                factory.newInstance( NonRegisterableType.class );
            }
            catch ( Exception e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'ChildRecordFinderFactoryTest.NonRegisterableType does not implement IChildRecordFinder', exceptionMessage, 'newInstance, when called for an unmapped type that does not implement IChildRecordFinder, will throw an exception' );
    }

    @isTest
    private static void newInstance_whenCalledForAnMappedTypeThatIsNotAChildFinder_willThrowAnException() // NOPMD: Test method name format
    {
        ortoo_ChildRecordFinderFactory factory = new ortoo_ChildRecordFinderFactory(
            new Map<Type,Type>
            {
                Object.class => NonRegisterableType.class
            }
        );

        Test.startTest();
            String exceptionMessage;
            try
            {
                factory.newInstance( Object.class );
            }
            catch ( Exception e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'Object does not implement IChildRecordFinder', exceptionMessage, 'newInstance, when called for a mapped type that does not implement IChildRecordFinder, will throw an exception' );
    }

    @isTest
    private static void newInstance_whenCalledWithNull_willThrowAnException() // NOPMD: Test method name format
    {
        ortoo_ChildRecordFinderFactory factory = new ortoo_ChildRecordFinderFactory();

        Test.startTest();
            String exceptionMessage;
            try
            {
                factory.newInstance( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'newInstance called with a null requestedType', exceptionMessage, 'newInstance, when called with null, will throw an exception' );
    }

    @isTest
    private static void constructor_whenCalledWithNull_willThrowAnException() // NOPMD: Test method name format
    {
        Test.startTest();
            String exceptionMessage;
            try
            {
                ortoo_ChildRecordFinderFactory factory = new ortoo_ChildRecordFinderFactory( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'ortoo_ChildRecordFinderFactory instantiated with a null childRecordFinderPerType', exceptionMessage, 'constructor, when called with null, will throw an exception' );
    }

    private without sharing class RegisterableType implements IChildRecordFinder
    {
        String name;
        public RegisterableType()
        {
            this( 'realOne' );
        }

        public RegisterableType( String name )
        {
            this.name = name;
        }

        public List<Sobject> findRecords( Set<Id> recordIds )
        {
            return null;
        }
    }

    private without sharing class NonRegisterableType {}
}