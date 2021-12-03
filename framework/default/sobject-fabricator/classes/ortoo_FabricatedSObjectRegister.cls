public class ortoo_FabricatedSObjectRegister {

	public static void registerObject( sfab_FabricatedSObject objectToRegister )
	{
		instance.registerObject( objectToRegister );
	}

	public static void registerChildOfRelationship( sfab_FabricatedSObject child, String relationship, sfab_FabricatedSObject parent )
	{
		instance.registerChildOfRelationship( child, relationship, parent );
	}

	public static void registerParentOfRelationship( sfab_FabricatedSObject parent, String relationship, sfab_FabricatedSObject child )
	{
		instance.registerParentOfRelationship( parent, relationship, child );
	}

	public static void persist()
	{
		instance.persist();
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

		public void persist()
		{
			ortoo_SObjectUnitOfWork uow = (ortoo_SObjectUnitOfWork)Application.UNIT_OF_WORK.newInstance( getOrderOfInserts() );

			buildObjectsByFabricated();
			registerInserts( uow );
			registerRelationships( uow );
			uow.commitWork();
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
