@isTest
private without sharing class ortoo_MessageRendererFactoryTest
{
    @isTest
    private static void newInstance_whenNoMappingsAreDefined_willReturnAnEngineWithThePassedType() // NOPMD: Test method name format
    {
        Amoss_Instance messageController = new Amoss_Instance( IRenderableMessageHeader.class );
        IRenderableMessageHeader message = (IRenderableMessageHeader)messageController.generateDouble();

        ortoo_MessageRendererFactory factory = new ortoo_MessageRendererFactory();

        Test.startTest();
            MessageRendererEngine returnedInstance = factory.newInstance( RegisterableType.class, message );
        Test.stopTest();

        System.assertNotEquals( null, returnedInstance, 'newInstance, when no mappings are defined, will return an instantiated MessageRendererEngine' );
        System.assert( returnedInstance.getRenderer() instanceof RegisterableType, 'newInstance, when no mappings are defined, configure the MessageRendererEngine with a renderer of the type passed in' );
        System.assertEquals( message, returnedInstance.getMessage(), 'newInstance, when no mappings are defined, configure the MessageRendererEngine with the passed in message' );
    }

    @isTest
    private static void newInstance_whenMappingsAreDefined_willReturnReturnAnEngineWithTheMappedType() // NOPMD: Test method name format
    {
        Amoss_Instance messageController = new Amoss_Instance( IRenderableMessageHeader.class );
        IRenderableMessageHeader message = (IRenderableMessageHeader)messageController.generateDouble();

        ortoo_MessageRendererFactory factory = new ortoo_MessageRendererFactory(
            new Map<String,String>
            {
                'ortoo_MessageRendererFactoryTest.ClassToRetrieveVia' => 'ortoo_MessageRendererFactoryTest.RegisterableType'
            }
        );

        Test.startTest();
            MessageRendererEngine returnedInstance = factory.newInstance( ClassToRetrieveVia.class, message );
        Test.stopTest();

        System.assertNotEquals( null, returnedInstance, 'newInstance, when mappings are defined and a mapped type is passed, will return an instantiated object' );
        System.assert( returnedInstance.getRenderer() instanceof RegisterableType, 'newInstance, when mappings are defined and a mapped type is passed, configure the MessageRendererEngine with a renderer of the type passed in' );
        System.assertEquals( message, returnedInstance.getMessage(), 'newInstance, when mappings are defined and a mapped type is passed, configure the MessageRendererEngine with the passed in message' );
    }

    @isTest
    private static void newInstance_whenCalledForATypeThatHasAMockSet_willReturnTheRegisteredMock() // NOPMD: Test method name format
    {
        Amoss_Instance messageController = new Amoss_Instance( IRenderableMessageHeader.class );
        IRenderableMessageHeader message = (IRenderableMessageHeader)messageController.generateDouble();

        Amoss_Instance rendererController = new Amoss_Instance( IMessageRenderer.class );
        IMessageRenderer mockRenderer = (IMessageRenderer)rendererController.generateDouble();

        rendererController
            .expectsNoCalls();

            ortoo_MessageRendererFactory factory = new ortoo_MessageRendererFactory();

        Test.startTest();
            factory.setMock( Object.class, mockRenderer );
            MessageRendererEngine returnedInstance = factory.newInstance( Object.class, message );
        Test.stopTest();

        rendererController.verify();

        System.assertEquals( mockRenderer, returnedInstance.getRenderer(), 'newInstance, when called for a type that has a mock set, will return the engine with the registered mock set as the renderer' );
        System.assertEquals( message, returnedInstance.getMessage(), 'newInstance, when called for a type that has a mock set, configure the MessageRendererEngine with the passed in message' );
    }

    @isTest
    private static void newInstance_whenCalledForAnUnmappedTypeThatIsNotARenderer_willThrowAnException() // NOPMD: Test method name format
    {
        Amoss_Instance messageController = new Amoss_Instance( IRenderableMessageHeader.class );
        IRenderableMessageHeader message = (IRenderableMessageHeader)messageController.generateDouble();

        ortoo_MessageRendererFactory factory = new ortoo_MessageRendererFactory();

        Test.startTest();
            String exceptionMessage;
            try
            {
                factory.newInstance( NonRegisterableType.class, message );
            }
            catch ( Exception e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'ortoo_MessageRendererFactoryTest.NonRegisterableType) does not implement MessageRendererEngine.IMessageRenderer', exceptionMessage, 'newInstance, when called for an unmapped type that does not implement IMessageRenderer, will throw an exception' );
    }

    @isTest
    private static void newInstance_whenCalledForAnMappedTypeThatIsNotARenderer_willThrowAnException() // NOPMD: Test method name format
    {
        Amoss_Instance messageController = new Amoss_Instance( IRenderableMessageHeader.class );
        IRenderableMessageHeader message = (IRenderableMessageHeader)messageController.generateDouble();

        ortoo_MessageRendererFactory factory = new ortoo_MessageRendererFactory(
            new Map<String,String>
            {
                'ortoo_MessageRendererFactoryTest.ClassToRetrieveVia' => 'ortoo_MessageRendererFactoryTest.NonRegisterableType'
            }
        );

        Test.startTest();
            String exceptionMessage;
            try
            {
                factory.newInstance( ClassToRetrieveVia.class, message );
            }
            catch ( Exception e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'NonRegisterableType) does not implement MessageRendererEngine.IMessageRenderer', exceptionMessage, 'newInstance, when called for a mapped type that does not implement IMessageRenderer, will throw an exception' );
    }

    @isTest
    private static void newInstance_whenCalledWithANullType_willThrowAnException() // NOPMD: Test method name format
    {
        Amoss_Instance messageController = new Amoss_Instance( IRenderableMessageHeader.class );
        IRenderableMessageHeader message = (IRenderableMessageHeader)messageController.generateDouble();

        ortoo_MessageRendererFactory factory = new ortoo_MessageRendererFactory();

        Test.startTest();
            String exceptionMessage;
            try
            {
                factory.newInstance( null, message );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'newInstance called with a null requestedType', exceptionMessage, 'newInstance, when called with null type, will throw an exception' );
    }
    @isTest
    private static void newInstance_whenCalledWithANullMessage_willThrowAnException() // NOPMD: Test method name format
    {
        ortoo_MessageRendererFactory factory = new ortoo_MessageRendererFactory();

        Test.startTest();
            String exceptionMessage;
            try
            {
                factory.newInstance( RegisterableType.class, null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'newInstance called with a null message', exceptionMessage, 'newInstance, when called with null message, will throw an exception' );
    }

    @isTest
    private static void constructor_whenCalledWithNull_willThrowAnException() // NOPMD: Test method name format
    {
        Amoss_Instance messageController = new Amoss_Instance( IRenderableMessageHeader.class );
        IRenderableMessageHeader message = (IRenderableMessageHeader)messageController.generateDouble();

        Test.startTest();
            String exceptionMessage;
            try
            {
                ortoo_MessageRendererFactory factory = new ortoo_MessageRendererFactory( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'ortoo_MessageRendererFactory instantiated with a null implementationPerType', exceptionMessage, 'constructor, when called with null, will throw an exception' );
    }

	public without sharing class ClassToRetrieveVia {}

    public without sharing class RegisterableType implements IMessageRenderer
    {
        public Boolean render( IRenderableMessageHeader message )
        {
            return true;
        }
    }

    public without sharing class NonRegisterableType {}
}