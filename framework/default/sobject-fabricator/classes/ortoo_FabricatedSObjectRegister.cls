/**
 * Provides the ability for the FabricatedSobject class to register objects so that they then can be persisted.
 *
 * Is an extension to sfab_FabricatedSobject, which does not provide persistence.
 *
 */
public class ortoo_FabricatedSObjectRegister {

	/**
	 * Fabricate and persist all Sobjects that have been registered.
	 */
	public static void persist()
	{
		instance.persist();
	}

	/**
	 * Fabricate and persist all Sobjects that have been registered.
	 */
	public static void persist( ortoo_SobjectUnitOfWork uow )
	{
		instance.persist( uow );
	}

	/**
	 * Register the given fabricated SObject so it is eligible to be persisted.
	 *
	 * Note, this method is internal to the fabricator library and should not be called directly.
	 *
	 * @param	sfab_FabricatedSObject	The object to register
	 */
	public static void registerObject( sfab_FabricatedSObject objectToRegister )
	{
		instance.registerObject( objectToRegister );
	}

	/**
	 * Register a relationship between a child and a parent fabricated SObject by stating the relationship
	 * from the child's perspective.
	 * E.g.	contact, 'Account', account
	 *
	 * Note, this method is internal to the fabricator library and should not be called directly.
	 *
	 * @param	sfab_FabricatedSObject	The child object
	 * @param	String					The name of the relationship from the child's perspective
	 * @param	sfab_FabricatedSObject	The parent object
	 */
	public static void registerChildOfRelationship( sfab_FabricatedSObject child, String relationship, sfab_FabricatedSObject parent )
	{
		instance.registerChildOfRelationship( child, relationship, parent );
	}

	/**
	 * Register a relationship between a child and a parent fabricated SObject by stating the relationship
	 * from the parent's perspective.
	 * E.g.	account, 'Contacts', contact
	 *
	 * Note, this method is internal to the fabricator library and should not be called directly.
	 *
	 * @param	sfab_FabricatedSObject	The parent object
	 * @param	String					The name of the relationship from the parent's perspective
	 * @param	sfab_FabricatedSObject	The child object
	 */
	public static void registerParentOfRelationship( sfab_FabricatedSObject parent, String relationship, sfab_FabricatedSObject child )
	{
		instance.registerParentOfRelationship( parent, relationship, child );
	}

	@testVisible
	private static RegisterInstance instance
	{
		get
		{
			if ( instance == null )
			{
				instance = new RegisterInstance();
			}
			return instance;
		}
		set;
	}

	@testVisible
	private inherited sharing class RegisterInstance
	{
		private List<sfab_FabricatedSObject> objectRegister = new List<sfab_FabricatedSObject>();
		private List<Relationship> relationships = new List<Relationship>();
		private Map<sfab_FabricatedSObject,Sobject> sobjectsByFabricated;
		private DirectedGraph graph = new DirectedGraph();

		public void registerObject( sfab_FabricatedSObject objectToRegister )
		{
			objectRegister.add( objectToRegister );
			graph.addNode( objectToRegister.getSobjectType() );
		}

		public void registerChildOfRelationship( sfab_FabricatedSObject child, String relationship, sfab_FabricatedSObject parent )
		{
			relationships.add(
				buildChildOfRelationship( child, relationship, parent )
			);
			graph.addRelationship( child.getSobjectType(), parent.getSobjectType() );
		}

		public void registerParentOfRelationship( sfab_FabricatedSObject parent, String relationship, sfab_FabricatedSObject child )
		{
			relationships.add(
				buildParentOfRelationship( parent, relationship, child )
			);
			graph.addRelationship( child.getSobjectType(), parent.getSobjectType() );
		}

		public void persist( ortoo_SObjectUnitOfWork uow )
		{
			buildObjectsByFabricated();
			registerInserts( uow );
			registerRelationships( uow );
			uow.commitWork();
		}

		public void persist()
		{
			persist( (ortoo_SObjectUnitOfWork)Application.UNIT_OF_WORK.newInstance( getOrderOfInserts(), new UnsecureDml() ) );
		}

		@testVisible
		private List<SobjectType> getOrderOfInserts()
		{
			List<Object> childToParentTypes = graph.generateSorted();

			List<SobjectType> parentToChildTypes = new List<SobjectType>();
			for( Integer i = childToParentTypes.size() - 1; i >= 0; i-- )
			{
				parentToChildTypes.add( (SobjectType)childToParentTypes[i] );
			}
			return parentToChildTypes;
		}

		private void buildObjectsByFabricated()
		{
			sobjectsByFabricated = new Map<sfab_FabricatedSObject,Sobject>();
			for ( sfab_FabricatedSObject thisFabricatedObject : objectRegister )
			{
				Sobject objectToStore = thisFabricatedObject.toPersistableSobject();
				sobjectsByFabricated.put( thisFabricatedObject, objectToStore );
			}
		}

		private void registerInserts( ortoo_SobjectUnitOfWork uow )
		{
			for ( sfab_FabricatedSObject thisFabricatedObject : objectRegister )
			{
				uow.registerNew( sobjectsByFabricated.get( thisFabricatedObject ) );
			}
		}

		private void registerRelationships( ortoo_SobjectUnitOfWork uow )
		{
			for ( Relationship thisRelationship : relationships )
			{
				thisRelationship.register( uow, sobjectsByFabricated );
			}
		}
	}

	private inherited sharing class Relationship
	{
		sfab_FabricatedSObject child;
		sfab_FabricatedSObject parent;
		SobjectField relationship;

		public Relationship( sfab_FabricatedSObject child, SobjectField relationship, sfab_FabricatedSObject parent )
		{
			this.parent = parent;
			this.relationship = relationship;
			this.child = child;
		}

		public void register( ortoo_SobjectUnitOfWork uow, Map<sfab_FabricatedSObject,Sobject> sobjectsByFabricated )
		{
			Sobject parentSobject = sobjectsByFabricated.get( parent );
			Sobject childSobject  = sobjectsByFabricated.get( child );

			uow.registerRelationship( childSobject, relationship, parentSobject );
		}
	}

	// Would be on Relationship if inner classes were allowed to have static methods
	private static Relationship buildChildOfRelationship( sfab_FabricatedSObject child, String relationship, sfab_FabricatedSObject parent )
	{
		SobjectField relationshipField = new sfab_ObjectDescriber().getFieldForParentRelationship( child.getSobjectName(), relationship );
		return new Relationship( child, relationshipField, parent );
	}

	// Would be on Relationship if inner classes were allowed to have static methods
	private static Relationship buildParentOfRelationship( sfab_FabricatedSObject parent, String relationship, sfab_FabricatedSObject child )
	{
		SobjectField relationshipField = new sfab_ObjectDescriber().getFieldForChildRelationship( parent.getSobjectName(), relationship );
		return new Relationship( child, relationshipField, parent );
	}
}
