public class ortoo_FabricatedSObjectRegister {

    private static List<sfab_FabricatedSObject> objectRegister = new List<sfab_FabricatedSObject>();

    private static Map<sfab_FabricatedSObject,Sobject> sobjectsByFabricated;

    private static List<Relationship> relationships = new List<Relationship>();


    public static void registerObject( sfab_FabricatedSObject objectToRegister )
    {
        objectRegister.add( objectToRegister );
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

            Sobject objectToStore = thisFabricatedObject.toSObject();
            // TODO: strip any lookups or similar
            if (objectToStore instanceOf Contact )
            {
                ((Contact)objectToStore).Account = null;
            }

            sobjectsByFabricated.put( thisFabricatedObject, objectToStore );
        }
        system.debug( sobjectsByFabricated.values() );

        // work out the order to do things in, using the directed graph
        // TODO: work out the order
        List<SobjectType> sobjectTypes = new List<SobjectType>
        {
            Account.sobjectType,
            Contact.sobjectType
        };

        // register all the inserts
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( sobjectTypes );
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

        public void register( ortoo_SobjectUnitOfWork uow )
        {
            Sobject parentSobject = sobjectsByFabricated.get( parent );
            Sobject childSobject  = sobjectsByFabricated.get( child );

            system.debug( 'registering the relationship: ' + childSobject + ' : ' + relationship + ' : ' + parentSobject );

            uow.registerRelationship( childSobject, relationship, parentSobject );
        }
    }

    public static Relationship buildChildOfRelationship( sfab_FabricatedSObject child, String relationship, sfab_FabricatedSObject parent )
    {
        // TODO: resolve the passed in relationship
        return new Relationship( child, Contact.AccountId, parent );
    }

    public static Relationship buildParentOfRelationship( sfab_FabricatedSObject parent, String relationship, sfab_FabricatedSObject child )
    {
        // TODO: resolve the passed in relationship
        return new Relationship( child, Contact.AccountId, parent );
    }
}
