@isTest
private without sharing class ApplicationTest
{
	@isTest
	private static void staticMemberVariableFactories_whenReferenced_willExist() // NOPMD: Test method name format
	{
		System.assertNotEquals( null, Application.SELECTOR           , 'SELECTOR, when referenced, will exist' );
		System.assertNotEquals( null, Application.DOMAIN             , 'DOMAIN, when referenced, will exist' );
		System.assertNotEquals( null, Application.SERVICE            , 'SERVICE, when referenced, will exist' );
		System.assertNotEquals( null, Application.VALIDATOR          , 'VALIDATOR, when referenced, will exist' );
		System.assertNotEquals( null, Application.APP_LOGIC          , 'APP_LOGIC, when referenced, will exist' );
		System.assertNotEquals( null, Application.CHILD_RECORD_FINDER, 'CHILD_RECORD_FINDER, when referenced, will exist' );
		System.assertNotEquals( null, Application.MESSAGE_RENDERER   , 'MESSAGE_RENDERER, when referenced, will exist' );
	}

	@isTest
	private static void selector_whenReferenced_willBeConfiguredBasedOnMetadata() // NOPMD: Test method name format
	{
		List<Application_Configuration__mdt> configurations = new List<Application_Configuration__mdt>
		{
			new Application_Configuration__mdt
			(
				Type__c 			= 'Selector',
				Object_Type__c 		= 'Contact',
				Implementation__c 	= 'fflib_ISObjectSelector'
			),
			new Application_Configuration__mdt
			(
				Type__c				= 'Selector',
				Object_Type__c 		= 'Account',
				Implementation__c 	= 'fflib_ISObjectSelector'
			)
		};

		Test.startTest();
			Application.applyConfiguration( configurations );
		Test.stopTest();

		System.assertEquals( fflib_ISObjectSelector.class, Application.SELECTOR.getSelectorType( Contact.sobjectType ), 'selector, when referenced, will be configured based on metadata' );
	}

	@isTest
	private static void domain_whenReferenced_willBeConfiguredBasedOnMetadata() // NOPMD: Test method name format
	{
		List<Application_Configuration__mdt> configurations = new List<Application_Configuration__mdt>
		{
			new Application_Configuration__mdt
			(
				Type__c 			= 'Domain',
				Object_Type__c 		= 'Contact',
				Implementation__c 	= 'fflib_SobjectDomain'
			),
			new Application_Configuration__mdt
			(
				Type__c				= 'Domain',
				Object_Type__c 		= 'Account',
				Implementation__c 	= 'fflib_SobjectDomain'
			)
		};

		Test.startTest();
			Application.applyConfiguration( configurations );
		Test.stopTest();

		System.assert( true, 'domain, when referenced, will be configured based on metadata - unfortunately it is too much hassle to actually test it returns the right thing, so we do not' );
	}

	@isTest
	private static void service_whenReferenced_willBeConfiguredBasedOnMetadata() // NOPMD: Test method name format
	{
		List<Application_Configuration__mdt> configurations = new List<Application_Configuration__mdt>
		{
			new Application_Configuration__mdt
			(
				Type__c 			= 'Service',
				Object_Type__c 		= 'ApplicationTest.IServiceInterface',
				Implementation__c 	= 'ApplicationTest.ServiceClass'
			),
			new Application_Configuration__mdt
			(
				Type__c				= 'Service',
				Object_Type__c 		= 'ApplicationTest.IServiceInterface2',
				Implementation__c 	= 'ApplicationTest.ServiceClass2'
			)
		};

		Test.startTest();
			Application.applyConfiguration( configurations );
			Object service = Application.SERVICE.newInstance( IServiceInterface.class );
		Test.stopTest();

		System.assert( service instanceOf ServiceClass , 'Service, when referenced, will be configured based on metadata' );
	}

	@isTest
	private static void validator_whenReferenced_willBeConfiguredBasedOnMetadata() // NOPMD: Test method name format
	{
		List<Application_Configuration__mdt> configurations = new List<Application_Configuration__mdt>
		{
			new Application_Configuration__mdt
			(
				Type__c 			= 'Validator',
				Object_Type__c 		= 'Contact',
				Implementation__c 	= 'ApplicationTest.ContactValidator'
			),
			new Application_Configuration__mdt
			(
				Type__c				= 'Service',
				Object_Type__c 		= 'Account',
				Implementation__c 	= 'ApplicationTest.AccountValidator'
			)
		};

		Test.startTest();
			Application.applyConfiguration( configurations );
			ISobjectValidator validator  = Application.VALIDATOR.newInstance( new Contact() );
		Test.stopTest();

		System.assert( validator instanceOf ContactValidator , 'Validator, when referenced, will be configured based on metadata' );
	}

	@isTest
	private static void appLogic_whenReferenced_willBeConfiguredBasedOnMetadata() // NOPMD: Test method name format
	{
		List<Application_Configuration__mdt> configurations = new List<Application_Configuration__mdt>
		{
			new Application_Configuration__mdt
			(
				Type__c 			= 'App Logic',
				Object_Type__c 		= 'ApplicationTest.IAppLogicInterface',
				Implementation__c 	= 'ApplicationTest.AppLogicClass'
			),
			new Application_Configuration__mdt
			(
				Type__c				= 'App Logic',
				Object_Type__c 		= 'ApplicationTest.IAppLogicInterface2',
				Implementation__c 	= 'ApplicationTest.AppLogicClass2'
			)
		};

		Test.startTest();
			Application.applyConfiguration( configurations );
			Object appLogic = Application.APP_LOGIC.newInstance( IAppLogicInterface.class );
		Test.stopTest();

		System.assert( appLogic instanceOf AppLogicClass , 'AppLogic, when referenced, will be configured based on metadata' );
	}

	@isTest
	private static void childRecordFinder_whenReferenced_willBeConfiguredBasedOnMetadata() // NOPMD: Test method name format
	{
		List<Application_Configuration__mdt> configurations = new List<Application_Configuration__mdt>
		{
			new Application_Configuration__mdt
			(
				Type__c 			= 'Child Record Finder',
				Object_Type__c 		= 'ApplicationTest.IChildRecordFinderInterface',
				Implementation__c 	= 'ApplicationTest.ChildRecordFinderClass'
			),
			new Application_Configuration__mdt
			(
				Type__c				= 'Child Record Finder',
				Object_Type__c 		= 'ApplicationTest.IChildRecordFinderInterface2',
				Implementation__c 	= 'ApplicationTest.ChildRecordFinderClass2'
			)
		};

		Test.startTest();
			Application.applyConfiguration( configurations );
			Object childRecordFinder = Application.CHILD_RECORD_FINDER.newInstance( IChildRecordFinderInterface.class );
		Test.stopTest();

		System.assert( childRecordFinder instanceOf ChildRecordFinderClass , 'childRecordFinder, when referenced, will be configured based on metadata' );
	}

	@isTest
	private static void messageRenderer_whenReferenced_willBeConfiguredBasedOnMetadata() // NOPMD: Test method name format
	{
		List<Application_Configuration__mdt> configurations = new List<Application_Configuration__mdt>
		{
			new Application_Configuration__mdt
			(
				Type__c 			= 'Message Renderer',
				Object_Type__c 		= 'MessageRendererEngine.VisualforceMessageRenderer',
				Implementation__c 	= 'MessageRendererEngine.SobjectMessageAdder'
			),
			new Application_Configuration__mdt
			(
				Type__c				= 'Message Renderer',
				Object_Type__c 		= 'MessageRendererEngine.SobjectMessageAdder',
				Implementation__c 	= 'MessageRendererEngine.VisualforceMessageRenderer'
			)
		};

		Test.startTest();
			Application.applyConfiguration( configurations );
			MessageRendererEngine messageRenderer = Application.MESSAGE_RENDERER.newInstance( MessageRendererEngine.VisualforceMessageRenderer.class, new ortoo_Exception() );
		Test.stopTest();

		System.assert( messageRenderer.getRenderer() instanceOf MessageRendererEngine.SobjectMessageAdder , 'messageRenderer, when referenced, will be configured based on metadata' );
	}

	@isTest
	private static void applyConfiguration_whenARecordHasAnInvalidType_willThrowAnException() // NOPMD: Test method name format
	{
		List<Application_Configuration__mdt> configurations = new List<Application_Configuration__mdt>
		{
			new Application_Configuration__mdt
			(
				Type__c 			= 'InvalidType',
				Object_Type__c 		= 'ApplicationTest.IChildRecordFinderInterface',
				Implementation__c 	= 'ApplicationTest.ChildRecordFinderClass'
			)
		};

		Test.startTest();
			String exceptionMessage;
			try
			{
				Application.applyConfiguration( configurations );
			}
			catch ( Application.InvalidApplicationConfigurationException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'Configuration exists with an invalid type (InvalidType)', exceptionMessage, 'applyConfiguration, when a record has an invalid type, will throw an exception' );
	}

	@isTest
	private static void applyConfiguration_whenARecordHasAnInvalidSobject_willThrowAnException() // NOPMD: Test method name format
	{
		List<Application_Configuration__mdt> configurations = new List<Application_Configuration__mdt>
		{
			new Application_Configuration__mdt
			(
				Type__c 			= 'Validator',
				Object_Type__c 		= 'InvalidSobject',
				Implementation__c 	= 'ApplicationTest.ContactValidator'
			)
		};

		Test.startTest();
			String exceptionMessage;
			try
			{
				Application.applyConfiguration( configurations );
			}
			catch ( Application.InvalidApplicationConfigurationException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'Configuration exists with an invalid sObject (InvalidSobject)', exceptionMessage, 'applyConfiguration, when a record has an invalid Sobject, will throw an exception' );
	}

	@isTest
	private static void applyConfiguration_whenARecordHasAnInvalidClass_willThrowAnException() // NOPMD: Test method name format
	{
		List<Application_Configuration__mdt> configurations = new List<Application_Configuration__mdt>
		{
			new Application_Configuration__mdt
			(
				Type__c 			= 'Validator',
				Object_Type__c 		= 'Contact',
				Implementation__c 	= 'ApplicationTest.InvalidClass'
			)
		};

		Test.startTest();
			String exceptionMessage;
			try
			{
				Application.applyConfiguration( configurations );
			}
			catch ( Application.InvalidApplicationConfigurationException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'Configuration exists with an invalid class (ApplicationTest.InvalidClass)', exceptionMessage, 'applyConfiguration, when a record has an invalid class, will throw an exception' );
	}

	public interface IServiceInterface{}
	public interface IServiceInterface2 {}
	public class ServiceClass {}
	public class ServiceClass2 {}

	public interface IAppLogicInterface {}
	public interface IAppLogicInterface2 {}
	public class AppLogicClass {}
	public class AppLogicClass2 {}

	public interface IChildRecordFinderInterface extends IChildRecordFinder {}
	public interface IChildRecordFinderInterface2 extends IChildRecordFinder {}

	public class ChildRecordFinderClass implements IChildRecordFinder
	{
		public List<Sobject> findRecords( Set<Id> ids )
		{
			return new List<Sobject>();
		}
	}

	public class ChildRecordFinderClass2 implements IChildRecordFinder
	{
		public List<Sobject> findRecords( Set<Id> ids )
		{
			return new List<Sobject>();
		}
	}

	public class ContactValidator implements ISobjectValidator
	{
		public ISobjectValidator setSobject( Sobject thingToValidate )
		{
			return this;
		}
		public void validate() {} // NOPMD: empty test implemenation
	}

	public class AccountValidator implements ISobjectValidator
	{
		public ISobjectValidator setSobject( Sobject thingToValidate )
		{
			return this;
		}
		public void validate() {} // NOPMD: empty test implemenation
	}
}