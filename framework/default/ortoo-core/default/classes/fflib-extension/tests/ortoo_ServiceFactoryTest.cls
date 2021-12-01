@isTest
public without sharing class ortoo_ServiceFactoryTest
{
    private static String THIS_CLASS_NAMESPACE = PackageUtils.getNamespace( ortoo_ServiceFactoryTest.class );

    @isTest
    private static void isRegisteredAsAnImplementation_whenGivenTheFullyQualifiedNameOfAClassThatIsRegistered_willReturnTrue() // NOPMD: Test method name format
    {
        ortoo_ServiceFactory factory = new ortoo_ServiceFactory( new Map<Type,Type>
        {
            IRegisterableType.class => RegisterableType.class
        });

        Test.startTest();
            Boolean returnedIsRegistered = factory.isRegisteredAsAnImplementation( THIS_CLASS_NAMESPACE + '.ortoo_ServiceFactoryTest.RegisterableType' );
        Test.stopTest();

        System.assertEquals( true, returnedIsRegistered, 'isRegisteredAsAnImplementation, when given the fully qualified name of a class that is registered as an implementation, will return true' );
    }

    @isTest
    private static void isRegisteredAsAnImplementation_whenGivenShortNameOfAClassThatIsRegistered_willReturnTrue() // NOPMD: Test method name format
    {
        ortoo_ServiceFactory factory = new ortoo_ServiceFactory( new Map<Type,Type>
        {
            IRegisterableType.class => RegisterableType.class
        });

        Test.startTest();
            Boolean returnedIsRegistered = factory.isRegisteredAsAnImplementation( 'ortoo_ServiceFactoryTest.RegisterableType' );
        Test.stopTest();

        System.assertEquals( true, returnedIsRegistered, 'isRegisteredAsAnImplementation, when given the name of a local class with a namespace that is registered as an implementation, will return true' );
    }

    @isTest
    private static void isRegisteredAsAnImplementation_whenAnInvalidClassName_willReturnFalse() // NOPMD: Test method name format
    {
        ortoo_ServiceFactory factory = new ortoo_ServiceFactory( new Map<Type,Type>
        {
            IRegisterableType.class => RegisterableType.class
        });

        Test.startTest();
            Boolean returnedIsRegistered = factory.isRegisteredAsAnImplementation( 'Not a valid class' );
        Test.stopTest();

        System.assertEquals( false, returnedIsRegistered, 'isRegisteredAsAnImplementation, when given an invalid class name, will return false' );
    }

    @isTest
    private static void isRegisteredAsAnImplementation_whenAClassThatIsNotRegistered_willReturnFalse() // NOPMD: Test method name format
    {
        ortoo_ServiceFactory factory = new ortoo_ServiceFactory( new Map<Type,Type>() );

        Test.startTest();
            Boolean returnedIsRegistered = factory.isRegisteredAsAnImplementation( THIS_CLASS_NAMESPACE + '.ortoo_ServiceFactoryTest.RegisterableType'  );
        Test.stopTest();

        System.assertEquals( false, returnedIsRegistered, 'isRegisteredAsAnImplementation, when given an invalid class name, will return false' );
    }

    @isTest
    private static void isRegisteredAsAnImplementation_whenAMockHasBeenRegistered_willReturnTrue() // NOPMD: Test method name format
    {
        ortoo_ServiceFactory factory = new ortoo_ServiceFactory( new Map<Type,Type>() );

        Test.startTest();
            factory.mockRegisterAsImplementation( 'ortoo_ServiceFactoryTest.RegisterableType' );
            Boolean returnedIsRegistered = factory.isRegisteredAsAnImplementation( 'ortoo_ServiceFactoryTest.RegisterableType'  );
        Test.stopTest();

        System.assertEquals( true, returnedIsRegistered, 'isRegisteredAsAnImplementation, when given an class name that has been registered via the mock method, will return true' );
    }

    @isTest
    private static void isRegisteredAsAnImplementation_whenCalledWithNull_willThrowAnException() // NOPMD: Test method name format
    {
        ortoo_ServiceFactory factory = new ortoo_ServiceFactory( new Map<Type,Type>() );

        Test.startTest();
            String exceptionMessage;
            try
            {
                factory.isRegisteredAsAnImplementation( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'isRegisteredAsAnImplementation called with a null className', exceptionMessage, 'isRegisteredAsAnImplementation, when called with null, will throw an exception' );
    }

    public inherited sharing class RegisterableType implements IRegisterableType {}
    public interface IRegisterableType {}
}