public class ortoo_FabricatedSObjectRegister {

    private static List<sfab_FabricatedSObject> objectRegister = new List<sfab_FabricatedSObject>();
    private static List<Relationship> relationships = new List<Relationship>();
    private static Map<sfab_FabricatedSObject,Sobject> sobjectsByFabricated;

    private static DirectedGraph graph = new DirectedGraph();

    public static void registerObject( sfab_FabricatedSObject objectToRegister )
    {
        objectRegister.add( objectToRegister );
        graph.addNode( objectToRegister.getSobjectType() );
    }

    public static void registerChildOfRelationship( sfab_FabricatedSObject child, String relationship, sfab_FabricatedSObject parent )
    {
        relationships.add(
            buildChildOfRelationship( child, relationship, parent )
        );
    }

    public static void registerParentOfRelationship( sfab_FabricatedSObject parent, String relationship, sfab_FabricatedSObject child )
    {
        relationships.add(
            buildParentOfRelationship( parent, relationship, child )
        );
    }

    public static void persist()
    {
        // build all the sobjects, and key them on the fabricated version
        sobjectsByFabricated = new Map<sfab_FabricatedSObject,Sobject>();
        for ( sfab_FabricatedSObject thisFabricatedObject : objectRegister )
        {
            Sobject objectToStore = thisFabricatedObject.toPersistableSobject();
            sobjectsByFabricated.put( thisFabricatedObject, objectToStore );
        }

        // work out the order to do things in, using the directed graph
        List<Object> childToParentTypes = graph.generateSorted();

        List<SobjectType> parentToChildTypes = new List<SobjectType>();
        for( Integer i = childToParentTypes.size() - 1; i >= 0; i-- )
        {
            parentToChildTypes.add( (SobjectType)childToParentTypes[i] );
        }

        // register all the inserts
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( parentToChildTypes );
        for ( sfab_FabricatedSObject thisFabricatedObject : objectRegister )
        {
            uow.registerNew( sobjectsByFabricated.get( thisFabricatedObject ) );
        }

        // register all the relationships
        for ( Relationship thisRelationship : relationships )
        {
            thisRelationship.register( uow );
        }

        uow.commitWork();
    }

    private void clearRegister()
    {
        objectRegister = new List<sfab_FabricatedSObject>();
        relationships = new List<Relationship>();
        sobjectsByFabricated = null;
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
            graph.addRelationship( child.getSobjectType(), parent.getSobjectType() );
        }

        public void register( ortoo_SobjectUnitOfWork uow )
        {
            Sobject parentSobject = sobjectsByFabricated.get( parent );
            Sobject childSobject  = sobjectsByFabricated.get( child );

            uow.registerRelationship( childSobject, relationship, parentSobject );
        }
    }

    public static Relationship buildChildOfRelationship( sfab_FabricatedSObject child, String relationship, sfab_FabricatedSObject parent )
    {
        SobjectField relationshipField = new sfab_ObjectDescriber().getFieldForParentRelationship( child.getSobjectName(), relationship );
        return new Relationship( child, relationshipField, parent );
    }

    public static Relationship buildParentOfRelationship( sfab_FabricatedSObject parent, String relationship, sfab_FabricatedSObject child )
    {
        SobjectField relationshipField = new sfab_ObjectDescriber().getFieldForChildRelationship( parent.getSobjectName(), relationship );
        return new Relationship( child, relationshipField, parent );
    }
}
