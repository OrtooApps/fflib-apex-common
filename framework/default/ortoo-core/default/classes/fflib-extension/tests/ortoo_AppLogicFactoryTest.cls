@isTest
private without sharing class ortoo_AppLogicFactoryTest
{
    @isTest
    private static void newInstance_whenNoMappingsAreDefined_willReturnThePassedType() // NOPMD: Test method name format
    {
        ortoo_AppLogicFactory factory = new ortoo_AppLogicFactory();

        Test.startTest();
            Object returnedInstance = factory.newInstance( RegisterableType.class );
        Test.stopTest();

        System.assertNotEquals( null, returnedInstance, 'newInstance, when no mappings are defined, will return an instantiated object' );
        System.assert( returnedInstance instanceof RegisterableType, 'newInstance, when no mappings are defined, will return the passed type' );
    }

    @isTest
    private static void newInstance_whenMappingsAreDefined_willReturnTheMappedType() // NOPMD: Test method name format
    {
        ortoo_AppLogicFactory factory = new ortoo_AppLogicFactory(
            new Map<Type,Type>
            {
                Object.class => RegisterableType.class
            }
        );

        Test.startTest();
            Object returnedInstance = factory.newInstance( Object.class );
        Test.stopTest();

        System.assertNotEquals( null, returnedInstance, 'newInstance, when mappings are defined and a mapped type is mapped, will return an instantiated object' );
        System.assert( returnedInstance instanceof RegisterableType, 'newInstance, when mappings are defined and a mapped type is mapped, will return the passed type' );
    }

    @isTest
    private static void newInstance_whenCalledForATypeThatHasAMockSet_willReturnTheRegisteredMock() // NOPMD: Test method name format
    {
        ortoo_AppLogicFactory factory = new ortoo_AppLogicFactory();

        RegisterableType mockInstance = new RegisterableType( 'mockone' );

        Test.startTest();
            factory.setMock( Object.class, mockInstance );
            Object returnedInstance = factory.newInstance( Object.class );
        Test.stopTest();

        System.assertEquals( mockInstance, returnedInstance, 'newInstance, when called for a type that has a mock set, will return the registered mock' );
    }

    @isTest
    private static void newInstance_whenCalledWithNull_willThrowAnException() // NOPMD: Test method name format
    {
        ortoo_AppLogicFactory factory = new ortoo_AppLogicFactory();

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
                ortoo_AppLogicFactory factory = new ortoo_AppLogicFactory( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'ortoo_AppLogicFactory instantiated with a null appLogicPerType', exceptionMessage, 'constructor, when called with null, will throw an exception' );
    }

    private without sharing class RegisterableType
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
    }
}