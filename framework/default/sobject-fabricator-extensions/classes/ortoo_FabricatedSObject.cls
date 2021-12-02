public virtual class ortoo_FabricatedSObject extends sfab_FabricatedSObject
{
    public ortoo_FabricatedSObject( Type sType )
    {
        super( sType );
        ortoo_FabricatedSObjectRegister.registerObject( this );
    }

    public List<sfab_ParentRelationshipNode> getParentRelationshipNodes()
    {
        List<sfab_ParentRelationshipNode> parentNodes = new List<sfab_ParentRelationshipNode>();
        for ( sfab_FabricatedSObjectNode thisNode : nodes.values() )
        {
            if ( thisNode instanceOf sfab_ParentRelationshipNode )
            {
                parentNodes.add( (sfab_ParentRelationshipNode)thisNode );
            }
        }
        return parentNodes;
    }
}