/**
 * Provides a series of factories for the implementation of Selectors / Domains / etc.
 *
 * Drives the configuration via Custom Metadata, which each consumer module should provide.
 */
public inherited sharing class Application {

	public class InvalidApplicationConfigurationException extends Exceptions.DeveloperException {}

	public final static ortoo_UnitOfWorkFactory UNIT_OF_WORK
	{
		get
		{
			if ( UNIT_OF_WORK == null )
			{
				UNIT_OF_WORK = new ortoo_UnitOfWorkFactory(); // is created with no default since that needs to be defined by the consumer
			}
			return UNIT_OF_WORK;
		}
		set;
	}

	public final static ortoo_DynamicUnitOfWorkFactory DYNAMIC_UNIT_OF_WORK
	{
		get
		{
			if ( DYNAMIC_UNIT_OF_WORK == null )
			{
				DYNAMIC_UNIT_OF_WORK = new ortoo_DynamicUnitOfWorkFactory();
			}
			return DYNAMIC_UNIT_OF_WORK;
		}
		set;
	}

	public static ortoo_SelectorFactory				SELECTOR; // NOPMD: want to give the impression that this is final, even though it isn't.
	public static ortoo_DomainFactory				DOMAIN; // NOPMD: want to give the impression that this is final, even though it isn't.
	public static ortoo_ServiceFactory				SERVICE; // NOPMD: want to give the impression that this is final, even though it isn't.
	public static ortoo_SobjectValidatorFactory		VALIDATOR; // NOPMD: want to give the impression that this is final, even though it isn't.
	public static ortoo_AppLogicFactory				APP_LOGIC; // NOPMD: want to give the impression that this is final, even though it isn't.
	public static ortoo_ChildRecordFinderFactory	CHILD_RECORD_FINDER; // NOPMD: want to give the impression that this is final, even though it isn't.
	public static ortoo_MessageRendererFactory		MESSAGE_RENDERER; // NOPMD: want to give the impression that this is final, even though it isn't.

	/**
	 * Static configuration of Application will load the configuration of the application from the Custom Metadata
	 * and then register those configurations so the rest of the system can use it.
	 */
	static
	{
		applyConfiguration( Application_Configuration__mdt.getAll().values() );
	}

	// Note, is test visible in order to be able to test this class
	// Tests of other classes should use the ApplicationMockRegistrar to change the configuration of the factories.
	@testVisible
	private static void applyConfiguration( List<Application_Configuration__mdt> configurations )
	{
		Map<String,TypeConfiguration> configurationsByType = new Map<String,TypeConfiguration>
		{
			'Service'				=> new ServiceConfiguration(),
			'Selector'				=> new SelectorConfiguration(),
			'Domain'				=> new DomainConfiguration(),
			'Validator'				=> new ValidatorConfiguration(),
			'App Logic'				=> new AppLogicConfiguration(),
			'Child Record Finder'	=> new ChildRecordFinderConfiguration(),
			'Message Renderer'		=> new MessageRendererConfiguration()
		};

		for ( Application_Configuration__mdt thisConfiguration : configurations )
		{
			if ( ! configurationsByType.containsKey( thisConfiguration.Type__c ) )
			{
				throw new InvalidApplicationConfigurationException( 'Configuration exists with an invalid type (' + thisConfiguration.Type__c + ')' )
							.setErrorCode( FrameworkErrorCodes.CONFIGURATION_WITH_INVALID_TYPE )
							.addContext( 'type', thisConfiguration.Type__c );
			}
			configurationsByType.get( thisConfiguration.Type__c ).put( thisConfiguration );
		}

		for ( TypeConfiguration thisConfiguration : configurationsByType.values() )
		{
			thisConfiguration.register();
		}
	}

	/**
	 * Provides a mechanism for building a Type based on a String representation of it.
	 */
	private inherited sharing class ClassTypeBuilder
	{
		public Type build( String typeName )
		{
			Type returnType = Type.forName( typeName );
			if ( returnType == null )
			{
				throw new InvalidApplicationConfigurationException( 'Configuration exists with an invalid class (' + typeName + ')' )
							.setErrorCode( FrameworkErrorCodes.CONFIGURATION_WITH_INVALID_CLASS )
							.addContext( 'typeName', typeName );
			}
			return returnType;
		}
	}

	/**
	 * Provides a mechanism for building an SObjectType based on a String representation of it.
	 */
	private inherited sharing class SobjectTypeBuilder
	{
		public SobjectType build( String typeName )
		{
			SobjectType sobjectType = SobjectUtils.getSobjectType( typeName );
			if ( sobjectType == null )
			{
				throw new InvalidApplicationConfigurationException( 'Configuration exists with an invalid sObject (' + typeName + ')' )
							.setErrorCode( FrameworkErrorCodes.CONFIGURATION_WITH_INVALID_SOBJECT_TYPE )
							.addContext( 'typeName', typeName );
			}
			return sobjectType;
		}
	}

	/**
	 * Defines a mechanism for stating a configuration of a type and the ability to register it with the correct factory.
	 */
	private interface TypeConfiguration
	{
		void put( Application_Configuration__mdt thisConfiguration );
		void register();
	}

	/**
	 * Provides a default mechanism for defining a 'Class Type Configuration', being a mapping between two Classes (or an interface and a class).
	 */
	private abstract inherited sharing class ClassTypeConfiguration implements TypeConfiguration
	{
		Map<Type,Type> configuration = new Map<Type,Type>();
		ClassTypeBuilder classTypeBuilder = new ClassTypeBuilder();

		public void put( Application_Configuration__mdt thisConfiguration )
		{
			Type objectType = classTypeBuilder.build( thisConfiguration.Object_Type__c );
			Type implementation = classTypeBuilder.build( thisConfiguration.Implementation__c );

			if ( configuration.containsKey( objectType ) )
			{
				throw new InvalidApplicationConfigurationException( 'Duplicate configuration exists for ' + thisConfiguration.Type__c + ' - ' + thisConfiguration.Object_Type__c )
							.setErrorCode( FrameworkErrorCodes.CONFIGURATION_WITH_DUPLICATE_TYPE )
							.addContext( 'typeName', thisConfiguration.Type__c )
							.addContext( 'objectType', thisConfiguration.Object_Type__c );
			}

			configuration.put( objectType, implementation );
		}

		public Map<Type,Type> getConfiguration()
		{
			return configuration;
		}
	}

	/**
	 * Provides a default mechanism for defining a 'Raw Type Configuration', being a mapping between two String names
	 *
	 * Can be used by a factory to map between Class and Sobject, or Class and Class, for example.
	 */
	private abstract inherited sharing class RawTypeConfiguration implements TypeConfiguration
	{
		Map<String,String> configuration = new Map<String,String>();

		public void put( Application_Configuration__mdt thisConfiguration )
		{
			if ( configuration.containsKey( thisConfiguration.Object_Type__c ) )
			{
				throw new InvalidApplicationConfigurationException( 'Duplicate configuration exists for ' + thisConfiguration.Type__c + ' - ' + thisConfiguration.Object_Type__c )
							.setErrorCode( FrameworkErrorCodes.CONFIGURATION_WITH_DUPLICATE_TYPE )
							.addContext( 'typeName', thisConfiguration.Type__c )
							.addContext( 'objectType', thisConfiguration.Object_Type__c );
			}

			configuration.put( thisConfiguration.Object_Type__c, thisConfiguration.Implementation__c );
		}

		public Map<String,String> getConfiguration()
		{
			return configuration;
		}
	}

	/**
	 * Provides a default mechanism for defining an 'SObject Type Configuration', being a mapping between an SObject Type and a Class.
	 */
	private abstract inherited sharing class SobjectTypeConfiguration implements TypeConfiguration
	{
		Map<SobjectType,Type> configuration = new Map<SobjectType,Type>();
		ClassTypeBuilder classTypeBuilder = new ClassTypeBuilder();
		SobjectTypeBuilder sobjectTypeBuilder = new SobjectTypeBuilder();

		public void put( Application_Configuration__mdt thisConfiguration )
		{
			SobjectType objectType = sobjectTypeBuilder.build( thisConfiguration.Object_Type__c );
			Type implementation = classTypeBuilder.build( thisConfiguration.Implementation__c );

			if ( configuration.containsKey( objectType ) )
			{
				throw new InvalidApplicationConfigurationException( 'Duplicate configuration exists for ' + thisConfiguration.Type__c + ' - ' + thisConfiguration.Object_Type__c )
							.setErrorCode( FrameworkErrorCodes.CONFIGURATION_WITH_DUPLICATE_TYPE )
							.addContext( 'typeName', thisConfiguration.Type__c )
							.addContext( 'objectType', thisConfiguration.Object_Type__c );
			}

			configuration.put( objectType, implementation );
		}

		public Map<SobjectType,Type> getConfiguration()
		{
			return configuration;
		}
	}

	/**
	 * Provides a mechanism for configuring and registering the Services Configuration
	 */
	private inherited sharing class ServiceConfiguration extends ClassTypeConfiguration
	{
		public void register()
		{
			SERVICE = new ortoo_ServiceFactory( getConfiguration() );
		}
	}

	/**
	 * Provides a mechanism for configuring and registering the Domain Objects Configuration
	 */
	private inherited sharing class DomainConfiguration extends SobjectTypeConfiguration
	{
		public void register()
		{
			if ( SELECTOR == null )
			{
				throw new Exceptions.DeveloperException( 'Attempted to construct the Domain Factory prior to construction of the Selector Factory.' )
							.setErrorCode( FrameworkErrorCodes.CONSTRUCTED_DOMAIN_FACTORY_BEFORE_SELECTOR );
			}
			DOMAIN = new ortoo_DomainFactory( SELECTOR, getConfiguration() );
		}
	}

	/**
	 * Provides a mechanism for configuring and registering the Validators Configuration
	 */
	private inherited sharing class ValidatorConfiguration extends SobjectTypeConfiguration
	{
		public void register()
		{
			VALIDATOR = new ortoo_SobjectValidatorFactory( getConfiguration() );
		}
	}

	/**
	 * Provides a mechanism for configuring and registering the Selectors Configuration
	 */
	private inherited sharing class SelectorConfiguration extends RawTypeConfiguration
	{
		public void register()
		{
			SELECTOR = new ortoo_SelectorFactory( getConfiguration() );
		}
	}

	/**
	 * Provides a mechanism for configuring and registering the App Logic Configuration
	 */
	private inherited sharing class AppLogicConfiguration extends RawTypeConfiguration
	{
		public void register()
		{
			APP_LOGIC = new ortoo_AppLogicFactory( getConfiguration() );
		}
	}

	/**
	 * Provides a mechanism for configuring and registering the Child Record Finders Configuration
	 */
	private inherited sharing class ChildRecordFinderConfiguration extends RawTypeConfiguration
	{
		public void register()
		{
			CHILD_RECORD_FINDER = new ortoo_ChildRecordFinderFactory( getConfiguration() );
		}
	}

	/**
	 * Provides a mechanism for configuring and registering the Child Record Finders Configuration
	 */
	private inherited sharing class MessageRendererConfiguration extends RawTypeConfiguration
	{
		public void register()
		{
			MESSAGE_RENDERER = new ortoo_MessageRendererFactory( getConfiguration() );
		}
	}
}