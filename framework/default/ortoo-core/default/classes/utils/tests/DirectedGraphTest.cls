@isTest
private without sharing class DirectedGraphTest
{
	@isTest
	private static void generateSorted_whenASimpleGraphIsSpecified_willReturnTheNodesInOrder() // NOPMD: Test method name format
	{
		DirectedGraph graph = new DirectedGraph()
									.addNode( 'Great grandparent' )
									.addNode( 'Grandparent' )
									.addNode( 'Parent' )
									.addNode( 'Child' )
									.addRelationship( 'Child', 'Parent' )
									.addRelationship( 'Parent', 'Grandparent')
									.addRelationship( 'Grandparent', 'Great grandparent' );

		List<Object> expectedNodes = new List<Object>
		{
			'Child',
			'Parent',
			'Grandparent',
			'Great grandparent'
		};

		List<Object> returnedNodes = graph.generateSorted();

		System.assertEquals( expectedNodes, returnedNodes, 'generateSorted, when a simple graph has been built, will return the nodes in child to parent order' );
	}

	@isTest
	private static void generateSorted_whenAComplexGraphIsSpecified_willReturnTheNodesInOrder() // NOPMD: Test method name format
	{
		DirectedGraph graph = new DirectedGraph()
									.addNode( 'Great grandparent' )
									.addNode( 'Grandparent of both parents' )
									.addNode( 'Parent 1' )
									.addNode( 'Parent 2' )
									.addNode( 'Child 1 of Parent 1' )
									.addNode( 'Child 2 of Parent 1' )
									.addNode( 'Child 1 of Parent 2' )
									.addNode( 'Child 2 of Parent 2' )
									.addNode( 'Child of Parents 1 and 2' )

									.addRelationship( 'Grandparent of both parents', 'Great grandparent' )
									.addRelationship( 'Parent 1', 'Grandparent of both parents' )
									.addRelationship( 'Parent 2', 'Grandparent of both parents' )
									.addRelationship( 'Child 1 of Parent 1', 'Parent 1' )
									.addRelationship( 'Child 2 of Parent 1', 'Parent 1' )
									.addRelationship( 'Child 1 of Parent 2', 'Parent 2' )
									.addRelationship( 'Child 2 of Parent 2', 'Parent 2' )
									.addRelationship( 'Child of Parents 1 and 2', 'Parent 1')
									.addRelationship( 'Child of Parents 1 and 2', 'Parent 2' );

		List<Object> expectedNodes = new List<Object>
		{
			'Child 1 of Parent 1',
			'Child 2 of Parent 1',
			'Child 1 of Parent 2',
			'Child 2 of Parent 2',
			'Child of Parents 1 and 2',
			'Parent 1',
			'Parent 2',
			'Grandparent of both parents',
			'Great grandparent'
		};

		List<Object> returnedNodes = graph.generateSorted();

		System.assertEquals( expectedNodes, returnedNodes, 'generateSorted, when a complex graph has been built, will return the nodes in child to parent order' );
	}

	@isTest
	private static void generateSorted_whenNoGraphIsSpecified_willReturnAnEmptyList() // NOPMD: Test method name format
	{
		DirectedGraph graph = new DirectedGraph();
		List<Object> expectedNodes = new List<Object>();

		List<Object> returnedNodes = graph.generateSorted();

		System.assertEquals( expectedNodes, returnedNodes, 'generateSorted, when no graph has been built, will return the an empty list' );
	}

	@isTest
	private static void generateSorted_whenADuplicatedNodesAreSpecified_willReturnTheUniqueNodesInOrder() // NOPMD: Test method name format
	{
		DirectedGraph graph = new DirectedGraph()
									.addNode( 'Great grandparent' )
									.addNode( 'Great grandparent' )
									.addNode( 'Great grandparent' )
									.addNode( 'Grandparent' )
									.addNode( 'Grandparent' )
									.addNode( 'Grandparent' )
									.addNode( 'Parent' )
									.addNode( 'Parent' )
									.addNode( 'Child' )
									.addNode( 'Child' )
									.addNode( 'Child' )
									.addNode( 'Child' )
									.addNode( 'Child' )
									.addRelationship( 'Child', 'Parent' )
									.addRelationship( 'Child', 'Parent' )
									.addRelationship( 'Child', 'Parent' )
									.addRelationship( 'Child', 'Parent' )
									.addRelationship( 'Parent', 'Grandparent')
									.addRelationship( 'Parent', 'Grandparent')
									.addRelationship( 'Grandparent', 'Great grandparent' );

		List<Object> expectedNodes = new List<Object>
		{
			'Child',
			'Parent',
			'Grandparent',
			'Great grandparent'
		};

		List<Object> returnedNodes = graph.generateSorted();

		System.assertEquals( expectedNodes, returnedNodes, 'generateSorted, when duplicate nodes and relationships are specified, will return the unique nodes in child to parent order' );
	}

	@isTest
	private static void generateSorted_whenACircularReference_willThrowAnException() // NOPMD: Test method name format
	{
		DirectedGraph graph = new DirectedGraph()
								.addNode( 1 )
								.addNode( 2 )
								.addNode( 3 )
								.addRelationship( 1, 2 )
								.addRelationship( 2, 3 )
								.addRelationship( 3, 1 );
		Test.startTest();
			String exceptionMessage;
			try
			{
				graph.generateSorted();
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'The graph contains a circular reference and therefore cannot be resolved', exceptionMessage, 'generateSorted, when a circular reference has been defined, will throw an exception' );
	}

	@isTest
	private static void addRelationship_whenGivenAnInvalidChild_willThrowAnException() // NOPMD: Test method name format
	{
		DirectedGraph graph = new DirectedGraph()
									.addNode( 'Parent' );
		Test.startTest();
			String exceptionMessage;
			try
			{
				graph.addRelationship( 'UnregisteredChild', 'Parent' );
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'addRelationship called with a child that has not been added as a node (UnregisteredChild)', exceptionMessage, 'addRelationship, when given a child that has not previously been added, will throw an exception' );
	}

	@isTest
	private static void addRelationship_whenGivenAnInvalidParent_willThrowAnException() // NOPMD: Test method name format
	{
		DirectedGraph graph = new DirectedGraph()
									.addNode( 'Child' );
		Test.startTest();
			String exceptionMessage;
			try
			{
				graph.addRelationship( 'Child', 'UnregisteredParent' );
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'addRelationship called with a parent that has not been added as a node (UnregisteredParent)', exceptionMessage, 'addRelationship, when given a parent that has not previously been added, will throw an exception' );
	}
}