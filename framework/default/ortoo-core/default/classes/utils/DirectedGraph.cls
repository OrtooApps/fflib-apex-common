// Directed Graph algorithm ased on the DirectedGraph implemented by Robert Sösemann: https://github.com/rsoesemann/apex-domainbuilder
public inherited sharing class DirectedGraph
{
	public inherited sharing class GraphContainsCircularReferenceException extends ortoo_Exception {}
	//
	// TODO: detect and block circular references.  We can deal with them independently
	//
	private Map<Object,Set<Object>> parentsByChildren = new Map<Object, Set<Object>>();

	/**
	 * Adds a node to the graph
	 *
	 * @param	Object			The node to add
	 * @return	DirectedGraph	Itself, allowing for a fluent interface
	 */
	public DirectedGraph addNode( Object node )
	{
		if( ! parentsByChildren.containsKey( node ) )
		{
			parentsByChildren.put( node, new Set<Object>() );
		}
		return this;
	}

	/**
	 * Adds a relationship between two nodes
	 *
	 * @param	Object			The child node of the relationship
	 * @param	Object			The parent node of the relationship
	 * @return	DirectedGraph	Itself, allowing for a fluent interface
	 */
	public DirectedGraph addRelationship( Object child, Object parent )
	{
		Contract.requires( parentsByChildren.containsKey( child ), 'addRelationship called with a child that has not been added as a node (' + child + ')' );
		Contract.requires( parentsByChildren.containsKey( parent ), 'addRelationship called with a parent that has not been added as a node (' + parent + ')' );
		parentsByChildren.get( child ).add( parent );
		return this;
	}

	/**
	 * Generates a list of nodes, sorted by their depdencies.
	 *
	 * That is, the children first, resolving upwards to the parents.
	 * No parent appears in the list prior to any of their children.
	 *
	 * Algorithm:
	 * 		A leaf node is added
	 * 		All references to that as a child are removed
	 * 			If any parent no longer has any children registered, it is regarded as a leaf node
	 * 		Move onto the next leaf node.
	 *
	 *		Assuming that there are no circular references,
	 * 			Eventually, every node will be regarded as a leaf node, and therefore every node will be added
	 *
	 * @param	Object			The child node of the relationship
	 * @param	Object			The parent node of the relationship
	 * @return	DirectedGraph	Itself, allowing for a fluent interface
	 */
	public List<Object> generateSorted()
	{
		List<Object> sortedObjects = new List<Object>();

		while( ! leafNodes.isEmpty() )
		{
			Object currentLeaf = (Object)leafNodes.iterator().next();
			leafNodes.remove( currentLeaf );

			sortedObjects.add( currentLeaf );

			for( Object thisParent : parentsByChildren.get( currentLeaf ) )
			{
				if ( childCountsByParents.containsKey( thisParent ) )
				{
					Integer remainingChildrenCount = childCountsByParents.get( thisParent ) - 1;
					childCountsByParents.put( thisParent, remainingChildrenCount );

					if ( remainingChildrenCount == 0 )
					{
						leafNodes.add( thisParent );
					}
				}
			}
		}

		leafNodes = null; // reset the leaf nodes so they will be re-calculated on a subsequent call
		childCountsByParents = null; // similar to above

		if ( sortedObjects.size() != allNodes.size() )
		{
			throw new GraphContainsCircularReferenceException( 'The graph contains a circular reference and therefore cannot be resolved.' );
		}
		return sortedObjects;
	}

	/**
	 * A reference to the full list of nodes registered on this graph.
	 */
	private Set<Object> allNodes
	{
		get
		{
			return parentsByChildren.keySet();
		}
	}

	private Set<Object> leafNodes
	{
		get
		{
			if ( leafNodes == null )
			{
				leafNodes = new Set<Object>();
				leafNodes.addAll( allNodes );
				leafNodes.removeAll( childCountsByParents.keySet() );
			}
			return leafNodes;
		}
		set;
	}

	private Map<Object,Integer> childCountsByParents
	{
		get
		{
			if ( childCountsByParents == null )
			{
				childCountsByParents = new Map<Object,Integer>();

				for ( Object thisChild : allNodes )
				{
					for ( Object parent : parentsByChildren.get( thisChild ) )
					{
						if ( ! childCountsByParents.containsKey( parent ) )
						{
							childCountsByParents.put( parent, 0 );
						}
						childCountsByParents.put( parent, childCountsByParents.get( parent ) + 1 );
					}
				}

			}
			return childCountsByParents;
		}
		set;
	}
}
