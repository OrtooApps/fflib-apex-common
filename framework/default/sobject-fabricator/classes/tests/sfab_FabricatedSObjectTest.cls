@isTest
private class sfab_FabricatedSObjectTest {
    @isTest
    private static void constructor_expectFieldsSetViaSObjectField() {
        Map<Schema.SObjectField, Object> accountFields = new Map<SObjectField, Object> {
                Account.Id => 'Id-1',
                Account.Name => 'Foo'
        };

        sfab_FabricatedSObject fabricatedAccount = new sfab_FabricatedSObject(Account.class, accountFields);
        System.assertEquals(accountFields.size(), fabricatedAccount.getNumberOfNodes());
    }

    @isTest
    private static void constructor_expectFieldsSetViaString() {
        Map<String, Object> accountFields = new Map<String, Object> {
                'Id' => 'Id-1',
                'Name' => 'Foo'
        };

        sfab_FabricatedSObject fabricatedAccount = new sfab_FabricatedSObject(Account.class, accountFields);
        System.assertEquals(accountFields.size(), fabricatedAccount.getNumberOfNodes());
    }

    @isTest
    private static void toSObject_expectSpecifiedSObjectType() {
        SObject sObj = new sfab_FabricatedSObject(Account.class).toSObject();
        System.assert(sObj instanceof Account);
    }

    @isTest
    private static void toSObject_expectSerializeInvokedOnNodes() {
        sfab_FabricatedSObject.sfab_FabricatedSObjectNodeStub node1 = new sfab_FabricatedSObject.sfab_FabricatedSObjectNodeStub( 'node1' );
        sfab_FabricatedSObject.sfab_FabricatedSObjectNodeStub node2 = new sfab_FabricatedSObject.sfab_FabricatedSObjectNodeStub( 'node2' );
        SObject sObj = new sfab_FabricatedSObject(Account.class, new List<sfab_FabricatedSObject.sfab_FabricatedSObjectNode> { node1, node2 }).toSObject();
        System.assert(node1.serializeInvoked);
        System.assert(node2.serializeInvoked);
    }

    @isTest
    private static void toSObject_expectProperties() {
        Map<String, Object> fields = new Map<String, Object> { 'Id' => 'id-1', 'Name' => 'Foo' };
        sfab_FabricatedSObject.sfab_FabricatedSObjectNodeStub node = new sfab_FabricatedSObject.sfab_FabricatedSObjectNodeStub(fields);
        SObject sObj = new sfab_FabricatedSObject(Account.class, new List<sfab_FabricatedSObject.sfab_FabricatedSObjectNode> { node }).toSObject();
        System.assertEquals(fields.get('Id'), sObj.Id);
        System.assertEquals(fields.get('Name'), sObj.get('Name'));
    }

    @isTest
    private static void setField_expectFieldAddedToNodes() {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Account.class);
        fabricatedSObject.setField(Account.Id, 'Id-1');
        System.assertEquals(1, fabricatedSObject.getNumberOfNodes());
        System.assertEquals( 'Id-1', fabricatedSObject.getFieldValue( 'Id' ) );
    }

    @isTest
    private static void setField_whenString_expectFieldAddedToNodes() {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Account.class);
        fabricatedSObject.setField('Id', 'Id-1');
        System.assertEquals(1, fabricatedSObject.getNumberOfNodes());
        System.assertEquals( 'Id-1', fabricatedSObject.getFieldValue( 'Id' ) );
    }

    @isTest
    private static void setField_whenStringIsAParentField_expectFieldAddedToNodes() {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Contact.class );
        fabricatedSObject.setField( 'Account.Id', 'Id-1' );
        System.assertEquals( 1, fabricatedSObject.getNumberOfNodes());
        System.assertEquals( 'Id-1', fabricatedSObject.getParent( 'Account' ).getFieldValue( 'Id' ) );
    }

    @isTest
    private static void set_whenField_expectFieldAddedToNodes() {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Account.class);
        fabricatedSObject.set(Account.Id, 'Id-1');
        System.assertEquals(1, fabricatedSObject.getNumberOfNodes());
        System.assertEquals( 'Id-1', fabricatedSObject.getFieldValue( 'Id' ) );
    }

    @isTest
    private static void set_whenStringField_expectFieldAddedToNodes() {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Account.class);
        fabricatedSObject.set('Id', 'Id-1');
        System.assertEquals(1, fabricatedSObject.getNumberOfNodes());
        System.assertEquals( 'Id-1', fabricatedSObject.getFieldValue( 'Id' ) );
    }

    @isTest
    private static void set_whenStringFieldForParent_expectParentAddedToNodes() {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Contact.class);
        fabricatedSObject.set('Account.Id', 'Account-Id-1');
        fabricatedSObject.set('Account.Name', 'Account-Name');
        fabricatedSObject.set('Id', 'Contact-Id-1');
        System.assertEquals(2, fabricatedSObject.getNumberOfNodes());

        sfab_FabricatedSObject fabricatedAccount = fabricatedSObject.getParent( 'Account' );
        System.assertNotEquals(null, fabricatedAccount);

        System.assertEquals( 'Account-Id-1', fabricatedAccount.getFieldValue( 'Id' ) );
        System.assertEquals( 'Account-Name', fabricatedAccount.getFieldValue( 'Name' ) );
        System.assertEquals( 'Contact-Id-1', fabricatedSObject.getFieldValue( 'Id' ) );
    }


    @isTest
    private static void set_whenMapSobjectField_expectFieldsAddedToNodes() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Account.class);

        Map<Schema.SObjectField, Object> fields = new Map<SObjectField, Object> {
                Account.Id => 'Id-1',
                Account.Name => 'Foo'
        };

        fabricatedSObject.set(fields);
        System.assertEquals( fields.size(), fabricatedSObject.getNumberOfNodes());

        System.assertEquals( 'Id-1', fabricatedSObject.getFieldValue( 'Id' ) );
        System.assertEquals( 'Foo', fabricatedSObject.getFieldValue( 'Name' ) );
    }

    @isTest
    private static void set_whenMapString_expectFieldsParentsAndChildrenAddedToNodes() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Account.class);

        Map<String,Object> fields = new Map<String,Object> {
                'Id'        =>  'Id-1',
                'Name'      =>  'Foo',
                'Contacts'  =>  new List<sfab_FabricatedSObject>{
                                    new sfab_FabricatedSObject( Contact.class )
                                        .set( 'Name', 'ContactName' )
                                },
                'Owner'     =>  new sfab_FabricatedSObject( User.class )
                                .set( 'Username', 'The user' )
        };

        fabricatedSObject.set(fields);
        System.assertEquals( 4, fabricatedSObject.getNumberOfNodes(), 'set, when given a map indexed by string, will add each of the fields' );

        System.assertEquals( 'Id-1', fabricatedSObject.getFieldValue( 'Id' ), 'set, when given a map indexed by string, will add each of the fields, setting the value of a simple field' );
        System.assertEquals( 'Foo', fabricatedSObject.getFieldValue( 'Name' ), 'set, when given a map indexed by string, will add each of the fields, setting the value of a simple field' );
        System.assertEquals( 1, fabricatedSObject.getNumberOfChildren( 'Contacts' ), 'set, when given a map indexed by string, will add each of the fields, setting the value of a child relationship field' );
        System.assertEquals( 1, fabricatedSObject.getParent( 'Owner' ).getNumberOfNodes(), 'set, when given a map indexed by string, will add each of the fields, setting the value of a parent relationship field' );
    }

    @isTest
    private static void set_whenMapString_expectMultiLevelParentFieldsAddedToNodes() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Account.class);

        Map<String,Object> fields = new Map<String,Object> {
                'Owner.Contact'             =>  new sfab_FabricatedSObject( Contact.class )
                                                    .set( 'LastName', 'TheOwnerLast' ),
                'Owner.Contact.FirstName'   =>  'TheOwnerFirst'
        };

        fabricatedSObject.set(fields);

        System.assertEquals( 1, fabricatedSObject.getNumberOfNodes() );

        sfab_FabricatedSObject fabricatedOwner   = fabricatedSObject.getParent( 'Owner' );
        System.assertEquals( 1, fabricatedOwner.getNumberOfNodes() );

        sfab_FabricatedSObject fabricatedContact = fabricatedOwner.getParent( 'Contact' );
        System.assertEquals( 'TheOwnerLast', fabricatedContact.getFieldValue( 'LastName' ) );
        System.assertEquals( 'TheOwnerFirst', fabricatedContact.getFieldValue( 'FirstName' ) );
    }

    @isTest
    private static void set_whenMapString_expectMultiLevelChildFieldsAddedToNodes() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Contact.class);

        Map<String,Object> fields = new Map<String,Object> {
                'Account.Opportunities'     =>  new List<sfab_FabricatedSObject>{
                                                    new sfab_FabricatedSObject( Opportunity.class )
                                                        .set( 'Name', 'The Opportunity' )
                                                }
        };

        fabricatedSObject.set(fields);

        System.assertEquals( 1, fabricatedSObject.getNumberOfNodes() );

        sfab_FabricatedSObject       fabricatedAccount      = fabricatedSObject.getParent( 'Account' );
        List<sfab_FabricatedSObject> fabricatedOportunities = fabricatedAccount.getChildren( 'Opportunities' );

        System.assertEquals( 1, fabricatedOportunities.size() );
        System.assertEquals( 'The Opportunity', fabricatedOportunities[0].getFieldValue( 'Name' ) );
    }

    @isTest
    private static void setParent_expectFieldAddedToNodes() {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Opportunity.class);
        fabricatedSObject.setParent('Account', new sfab_FabricatedSObject(Account.class));
        System.assertNotEquals( null, fabricatedSObject.getParent('Account') );
    }

    @isTest
    private static void setParent_whenParentOfParent_expectFieldAddedToNodes() {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Opportunity.class);
        fabricatedSObject.setParent('Account.CreatedBy', new sfab_FabricatedSObject(User.class));
        System.assertNotEquals( null, fabricatedSObject.getParent('Account').getParent('CreatedBy') );
    }

    @isTest
    private static void set_whenParent_expectFieldAddedToNodes() {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Opportunity.class);
        fabricatedSObject.set('Account', new sfab_FabricatedSObject(Account.class));
        System.assertNotEquals( null, fabricatedSObject.getParent('Account') );
    }

    @isTest
    private static void setChildren_expectChildrenSet() {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Account.class);
        fabricatedSObject.setChildren('Opportunities', new List<sfab_FabricatedSObject>{
                                                                new sfab_FabricatedSObject(Opportunity.class),
                                                                new sfab_FabricatedSObject(Opportunity.class) } );
        System.assertEquals( 2, fabricatedSObject.getNumberOfChildren('Opportunities') );
    }

    @isTest
    private static void setChildren_whenChildrenOfParent_expectChildrenSet() {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Opportunity.class);
        fabricatedSObject.setChildren('Account.Contacts', new List<sfab_FabricatedSObject>{
                                                                    new sfab_FabricatedSObject(Contact.class),
                                                                    new sfab_FabricatedSObject(Contact.class) } );

        System.assertEquals( 2, fabricatedSObject.getParent('Account').getNumberOfChildren('Contacts') );
    }

    @isTest
    private static void set_whenChildren_expectChildSet() {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Account.class);
        fabricatedSObject.set('Opportunities', new List<sfab_FabricatedSObject>{
                                                        new sfab_FabricatedSObject(Opportunity.class),
                                                        new sfab_FabricatedSObject(Opportunity.class) } );
        System.assertEquals( 2, fabricatedSObject.getNumberOfChildren('Opportunities') );
    }

    @isTest
    private static void set_whenChildrenOfParent_expectChildSet() {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Opportunity.class);
        fabricatedSObject.set('Account.Contacts', new List<sfab_FabricatedSObject>{
                                                        new sfab_FabricatedSObject(Contact.class),
                                                        new sfab_FabricatedSObject(Contact.class) } );

        System.assertEquals( 2, fabricatedSObject.getParent('Account').getNumberOfChildren('Contacts') );
    }

    @isTest
    private static void addChild_expectObjectsAdded() {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Account.class);
        fabricatedSObject.addChild('Opportunities', new sfab_FabricatedSObject(Opportunity.class));
        fabricatedSObject.addChild('Opportunities', new sfab_FabricatedSObject(Opportunity.class));
        System.assertEquals( 1, fabricatedSObject.getNumberOfNodes());
        System.assertEquals( 2, fabricatedSObject.getNumberOfChildren( 'Opportunities' ) );
    }

    @isTest
    private static void addChild_whenAParentsChildIsSpecified_expectObjectsAdded() {
        sfab_FabricatedSObject fabricatedContact = new sfab_FabricatedSObject(Contact.class);
        fabricatedContact.addChild('Account.Opportunities', new sfab_FabricatedSObject(Opportunity.class));
        fabricatedContact.addChild('Account.Opportunities', new sfab_FabricatedSObject(Opportunity.class));
        System.assertEquals( 1, fabricatedContact.getNumberOfNodes());

        sfab_FabricatedSObject fabricatedAccount = fabricatedContact.getParent( 'Account' );
        System.assertEquals( 1, fabricatedAccount.getNumberOfNodes());
        System.assertEquals( 2, fabricatedAccount.getNumberOfChildren( 'Opportunities' ) );
    }

    @isTest
    private static void add_expectObjectsAdded() {
        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject(Account.class);
        fabricatedSObject.add('Opportunities', new sfab_FabricatedSObject(Opportunity.class));
        fabricatedSObject.add('Opportunities', new sfab_FabricatedSObject(Opportunity.class));
        System.assertEquals( 1, fabricatedSObject.getNumberOfNodes());
        System.assertEquals( 2, fabricatedSObject.getNumberOfChildren( 'Opportunities' ) );
    }

    @isTest
    private static void add_whenAParentsChildIsSpecified_expectObjectsAdded() {
        sfab_FabricatedSObject fabricatedContact = new sfab_FabricatedSObject(Contact.class);
        fabricatedContact.add('Account.Opportunities', new sfab_FabricatedSObject(Opportunity.class));
        fabricatedContact.add('Account.Opportunities', new sfab_FabricatedSObject(Opportunity.class));
        System.assertEquals(1, fabricatedContact.getNumberOfNodes());

        sfab_FabricatedSObject fabricatedAccount = fabricatedContact.getParent( 'Account' );
        System.assertEquals( 1, fabricatedAccount.getNumberOfNodes());
        System.assertEquals( 2, fabricatedAccount.getNumberOfChildren( 'Opportunities' ) );
    }

    @isTest
    private static void setField_whenFieldDoesNotExist_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Contact.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setField( Account.AccountNumber, 'Id-1' );
        } catch ( sfab_FabricatedSObject.FieldDoesNotExistException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Contact.AccountNumber does not exist' ),
                        'setField, when field does not exist, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setField_whenStringFieldDoesNotExist_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Account.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setField( 'Invalid', 'Id-1' );
        } catch ( sfab_FabricatedSObject.FieldDoesNotExistException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Account.Invalid does not exist' ),
                        'setField, when field does not exist, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setField_whenStringFieldIsParentRelationship_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Contact.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setField( 'Account', 'Is a parent relationship' );
        } catch ( sfab_FabricatedSObject.FieldIsNotSimpleFieldException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Contact.Account cannot to set to a primitive, it is a parent relationship field' ),
                        'setField, when field is a parent relationship, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setField_whenStringFieldIsChildRelationship_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Account.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setField( 'Contacts', 'Is a child relationship' );
        } catch ( sfab_FabricatedSObject.FieldIsNotSimpleFieldException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Account.Contacts cannot to set to a primitive, it is a child relationship field' ),
                        'setField, when field is a child relationship, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setField_whenStringNavigatingAndFieldDoesNotExist_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Contact.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setField( 'Account.Invalid', 'Id-1' );
        } catch ( sfab_FabricatedSObject.FieldDoesNotExistException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Account.Invalid does not exist' ),
                        'setField, when field does not exist, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setField_whenStringNavigatingAndFieldIsParentRelationship_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Contact.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setField( 'Account.Owner', 'Is a parent relationship' );
        } catch ( sfab_FabricatedSObject.FieldIsNotSimpleFieldException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Account.Owner cannot to set to a primitive, it is a parent relationship field' ),
                        'setField, when field is a parent relationship, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setField_whenStringNavigatingAndFieldIsChildRelationship_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Contact.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setField( 'Account.Contacts', 'Is a child relationship' );
        } catch ( sfab_FabricatedSObject.FieldIsNotSimpleFieldException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Account.Contacts cannot to set to a primitive, it is a child relationship field' ),
                        'setField, when field is a child relationship, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setParent_whenFieldDoesNotExist_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Account.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setParent( 'Account', new sfab_FabricatedSObject( Account.class ) );
        } catch ( sfab_FabricatedSObject.ParentRelationshipDoesNotExistException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The parent relationship Account.Account does not exist' ),
                        'setParent, when field does not exist, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setParent_whenFieldIsASimpleField_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Account.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setParent( 'Name', new sfab_FabricatedSObject( Account.class ) );
        } catch ( sfab_FabricatedSObject.FieldIsNotParentRelationshipException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Account.Name is not a parent relationship' ),
                        'setParent, when field is a simple field, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setParent_whenFieldIsAChildRelationship_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Account.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setParent( 'Contacts', new sfab_FabricatedSObject( Account.class ) );
        } catch ( sfab_FabricatedSObject.FieldIsNotParentRelationshipException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Account.Contacts is not a parent relationship' ),
                        'setParent, when field is a child relationship, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setParent_whenFieldIsADifferentSobject_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Contact.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setParent( 'Account', new sfab_FabricatedSObject( Contact.class ) );
        } catch ( sfab_FabricatedSObject.FieldIsADifferentTypeException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Contact.Account is Account, not Contact' ),
                        'setParent, when field is a different SObject, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setParent_whenFieldIsPolymorphicAndADifferentSobject_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Task.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setParent( 'Owner', new sfab_FabricatedSObject( Contact.class ) );
        } catch ( sfab_FabricatedSObject.FieldIsADifferentTypeException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Task.Owner is Group,User, not Contact' ),
                        'setParent, when field is polymorphic and for a different SObject, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setParent_whenFieldIsPolymorphicAndACorrectSobject_expectNoException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Task.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setParent( 'Owner', new sfab_FabricatedSObject( User.class ) );
        } catch ( sfab_FabricatedSObject.FieldIsADifferentTypeException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assertEquals( '', exceptionMessage, 'setParent, when field is polymorphic and the passed SObject included, will not throw an exception (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setParent_whenFieldOnParentDoesNotExist_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Contact.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setParent( 'Account.NotValid', new sfab_FabricatedSObject( Account.class ) );
        } catch ( sfab_FabricatedSObject.ParentRelationshipDoesNotExistException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The parent relationship Account.NotValid does not exist' ),
                        'setParent, when field on the parent does not exist, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setParent_whenFieldOnParentIsASimpleField_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Contact.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setParent( 'Account.Name', new sfab_FabricatedSObject( Account.class ) );
        } catch ( sfab_FabricatedSObject.FieldIsNotParentRelationshipException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Account.Name is not a parent relationship' ),
                        'setParent, when field on the parent is a simple field, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setParent_whenFieldOnParentIsAChildRelationship_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Contact.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setParent( 'Account.Opportunities', new sfab_FabricatedSObject( Account.class ) );
        } catch ( sfab_FabricatedSObject.FieldIsNotParentRelationshipException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Account.Opportunities is not a parent relationship' ),
                        'setParent, when field on the parent is a child relationship, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setChildren_whenFieldDoesNotExist_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Account.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setChildren( 'Accounts', new List<sfab_FabricatedSObject>{
                                                            new sfab_FabricatedSObject( Account.class )
                                                        });
        } catch ( sfab_FabricatedSObject.ChildRelationshipDoesNotExistException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The child relationship Account.Accounts does not exist' ),
                        'setChildren, when field does not exist, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setChildren_whenFieldIsASimpleField_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Account.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setChildren( 'Name', new List<sfab_FabricatedSObject>{
                                                        new sfab_FabricatedSObject( Account.class )
                                                    });
        } catch ( sfab_FabricatedSObject.FieldIsNotChildRelationshipException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Account.Name is not a child relationship' ),
                        'setChildren, when field is a simple field, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setChildren_whenFieldIsAParentRelationship_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Contact.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setChildren( 'Account', new List<sfab_FabricatedSObject>{
                                                            new sfab_FabricatedSObject( Account.class )
                                                        });
        } catch ( sfab_FabricatedSObject.FieldIsNotChildRelationshipException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Contact.Account is not a child relationship' ),
                        'setChildren, when field is a child relationship, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setChildren_whenFieldIsADifferentSobject_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Account.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setChildren( 'Contacts', new List<sfab_FabricatedSObject>{
                                                            new sfab_FabricatedSObject( User.class )
                                                        });
        } catch ( sfab_FabricatedSObject.FieldIsADifferentTypeException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The relationship Account.Contacts is Contact, not User' ),
                        'setChildren, when field is a different SObject, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setChildren_whenFieldOnParentDoesNotExist_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Contact.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setChildren( 'Account.Accounts', new List<sfab_FabricatedSObject>{
                                                                    new sfab_FabricatedSObject( Account.class )
                                                                });
        } catch ( sfab_FabricatedSObject.ChildRelationshipDoesNotExistException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The child relationship Account.Accounts does not exist' ),
                        'setChildren, when field on parent does not exist, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setChildren_whenFieldOnParentIsASimpleField_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Contact.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setChildren( 'Account.Name', new List<sfab_FabricatedSObject>{
                                                                new sfab_FabricatedSObject( Account.class )
                                                            });
        } catch ( sfab_FabricatedSObject.FieldIsNotChildRelationshipException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Account.Name is not a child relationship' ),
                        'setChildren, when field is a simple field, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void setChildren_whenFieldOnParentIsAParentRelationship_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Contact.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.setChildren( 'Account.Owner', new List<sfab_FabricatedSObject>{
                                                                new sfab_FabricatedSObject( Account.class )
                                                            });
        } catch ( sfab_FabricatedSObject.FieldIsNotChildRelationshipException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Account.Owner is not a child relationship' ),
                        'setChildren, when field is a child relationship, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void addChild_whenFieldDoesNotExist_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Account.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.addChild( 'Accounts', new sfab_FabricatedSObject( Account.class ) );
        } catch ( sfab_FabricatedSObject.ChildRelationshipDoesNotExistException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The child relationship Account.Accounts does not exist' ),
                        'addChild, when field does not exist, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void addChild_whenFieldIsADifferentObjectType_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Account.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.addChild( 'Contacts', new sfab_FabricatedSObject( Account.class ) );
        } catch ( sfab_FabricatedSObject.FieldIsADifferentTypeException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The relationship Account.Contacts is Contact, not Account' ),
                        'addChild, when field does not exist, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void addChild_whenFieldIsASimpleField_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Account.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.addChild( 'Name', new sfab_FabricatedSObject( Account.class ) );
        } catch ( sfab_FabricatedSObject.FieldIsNotChildRelationshipException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Account.Name is not a child relationship' ),
                        'addChild, when field is a simple field, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void addChild_whenFieldIsAParentRelationship_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Contact.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.addChild( 'Account', new sfab_FabricatedSObject( Account.class ) );
        } catch ( sfab_FabricatedSObject.FieldIsNotChildRelationshipException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Contact.Account is not a child relationship' ),
                        'addChild, when field is a child relationship, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void addChild_whenFieldOnParentDoesNotExist_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Contact.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.addChild( 'Account.Accounts', new sfab_FabricatedSObject( Account.class ) );
        } catch ( sfab_FabricatedSObject.ChildRelationshipDoesNotExistException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The child relationship Account.Accounts does not exist' ),
                        'addChild, when field on parent does not exist, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void addChild_whenFieldOnParentIsASimpleField_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Contact.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.addChild( 'Account.Name', new sfab_FabricatedSObject( Account.class ) );
        } catch ( sfab_FabricatedSObject.FieldIsNotChildRelationshipException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Account.Name is not a child relationship' ),
                        'addChild, when field is a simple field, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void addChild_whenFieldOnParentIsAParentRelationship_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Contact.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.addChild( 'Account.Owner', new sfab_FabricatedSObject( Account.class ) );
        } catch ( sfab_FabricatedSObject.FieldIsNotChildRelationshipException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'The field Account.Owner is not a child relationship' ),
                        'addChild, when field is a child relationship, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void set_whenStringFieldForParentNotARelationship_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Account.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.set( 'Name.NotARelationship', 'name is not a relationship' );
        } catch ( sfab_FabricatedSObject.FieldIsNotParentRelationshipException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'Account.Name is not a parent relationship' ), 'set, when field does not exist, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void set_whenStringFieldForParentPolymorphic_expectException() {

        sfab_FabricatedSObject fabricatedSObject = new sfab_FabricatedSObject( Task.class );

        String exceptionMessage = '';
        try {
            fabricatedSObject.set( 'Owner.Username', 'cannot create polymorphic ones automatically' );
        } catch ( sfab_FabricatedSObject.ParentRelationshipObjectCannotBeAutoCreatedException e ) {
            exceptionMessage = e.getMessage();
        }
        System.assert( exceptionMessage.contains( 'Could not auto-assign an object for the field Owner' ), 'set, when field does not exist, will throw an exception with a useful message (got "' + exceptionMessage + '")' );
    }

    @isTest
    private static void toSObject_whenBlobSetOnContentVersion_expectBlobValueSet() {
        sfab_FabricatedSObject fabricated = new sfab_FabricatedSObject( ContentVersion.class );
        fabricated.set( 'VersionData', Blob.valueOf( 'abc' ) );
        ContentVersion sobj = (ContentVersion)fabricated.toSObject();
        System.assertEquals( Blob.valueOf( 'abc' ), sobj.VersionData );
    }

    @isTest
    private static void toSObject_whenBlobSetOnAttachment_expectBlobValueSet() {
        sfab_FabricatedSObject fabricated = new sfab_FabricatedSObject( Attachment.class );
        fabricated.set( 'Body', Blob.valueOf( 'abc' ) );
        Attachment sobj = (Attachment)fabricated.toSObject();
        System.assertEquals( Blob.valueOf( 'abc' ), sobj.Body );
    }

    @isTest
    private static void toSObject_whenBlobSetOnDocument_expectBlobValueSet() {
        sfab_FabricatedSObject fabricated = new sfab_FabricatedSObject( Document.class );
        fabricated.set( 'Body', Blob.valueOf( 'abc' ) );
        Document sobj = (Document)fabricated.toSObject();
        System.assertEquals( Blob.valueOf( 'abc' ), sobj.Body );
    }

    @isTest
    private static void toSObject_whenBlobSetOnStaticResource_expectBlobValueSet() {
        sfab_FabricatedSObject fabricated = new sfab_FabricatedSObject( StaticResource.class );
        fabricated.set( 'Body', Blob.valueOf( 'abc' ) );
        StaticResource sobj = (StaticResource)fabricated.toSObject();
        System.assertEquals( Blob.valueOf( 'abc' ), sobj.Body );
    }

    @isTest
    private static void toSObject_whenBlobSetOnMailMergeTemplate_expectBlobValueSet() {
        sfab_FabricatedSObject fabricated = new sfab_FabricatedSObject( MailMergeTemplate.class );
        fabricated.set( 'Body', Blob.valueOf( 'abc' ) );
        MailMergeTemplate sobj = (MailMergeTemplate)fabricated.toSObject();
        System.assertEquals( Blob.valueOf( 'abc' ), sobj.Body );
    }

    @isTest
    private static void toSObject_whenBlobSetOnEventLogFile_expectBlobValueSet() {
        sfab_FabricatedSObject fabricated = new sfab_FabricatedSObject( EventLogFile.class );
        fabricated.set( 'LogFile', Blob.valueOf( 'abc' ) );
        EventLogFile sobj = (EventLogFile)fabricated.toSObject();
        System.assertEquals( Blob.valueOf( 'abc' ), sobj.LogFile );
    }

    @isTest
    private static void toSObject_whenBlobSetOnMobileApplicationDetail_expectBlobValueSet() {
        sfab_FabricatedSObject fabricated = new sfab_FabricatedSObject( MobileApplicationDetail.class );
        fabricated.set( 'ApplicationBinary', Blob.valueOf( 'abc' ) );
        MobileApplicationDetail sobj = (MobileApplicationDetail)fabricated.toSObject();
        System.assertEquals( Blob.valueOf( 'abc' ), sobj.ApplicationBinary );
    }

    @isTest
    private static void toSObject_whenBlobSetViaField_expectBlobValueSet() {
        sfab_FabricatedSObject fabricated = new sfab_FabricatedSObject( ContentVersion.class );
        fabricated.set( ContentVersion.VersionData, Blob.valueOf( 'abc' ) );
        ContentVersion sobj = (ContentVersion)fabricated.toSObject();
        System.assertEquals( Blob.valueOf( 'abc' ), sobj.VersionData );
    }

    @isTest
    private static void toSObject_whenBlobSetViaSetField_expectBlobValueSet() {
        sfab_FabricatedSObject fabricated = new sfab_FabricatedSObject( ContentVersion.class );
        fabricated.setField( 'VersionData', Blob.valueOf( 'abc' ) );
        ContentVersion sobj = (ContentVersion)fabricated.toSObject();
        System.assertEquals( Blob.valueOf( 'abc' ), sobj.VersionData );
    }

    @isTest
    private static void toSObject_whenBlobSetViaSetFieldWithField_expectBlobValueSet() {
        sfab_FabricatedSObject fabricated = new sfab_FabricatedSObject( ContentVersion.class );
        fabricated.setField( ContentVersion.VersionData, Blob.valueOf( 'abc' ) );
        ContentVersion sobj = (ContentVersion)fabricated.toSObject();
        System.assertEquals( Blob.valueOf( 'abc' ), sobj.VersionData );
    }

    @isTest
    private static void toSObject_whenBlobSetToString_expectBlobValueSet() {
        sfab_FabricatedSObject fabricated = new sfab_FabricatedSObject( ContentVersion.class );
        fabricated.set( 'VersionData', 'abc' );
        ContentVersion sobj = (ContentVersion)fabricated.toSObject();
        System.assertEquals( Blob.valueOf( 'abc' ), sobj.VersionData );
    }

    @isTest
    private static void toSObject_whenBlobSetToEmptyString_expectBlobValueSet() {
        sfab_FabricatedSObject fabricated = new sfab_FabricatedSObject( ContentVersion.class );
        fabricated.set( 'VersionData', '' );
        ContentVersion sobj = (ContentVersion)fabricated.toSObject();
        System.assertEquals( Blob.valueOf( '' ), sobj.VersionData );
    }

    @isTest
    private static void toSObject_whenBlobSetToNull_expectBlobValueSet() {
        sfab_FabricatedSObject fabricated = new sfab_FabricatedSObject( ContentVersion.class );
        fabricated.set( 'VersionData', (String)null );
        ContentVersion sobj = (ContentVersion)fabricated.toSObject();
        System.assertEquals( null, sobj.VersionData );
    }

    @isTest
    private static void toSObject_whenBlobSetOnParent_expectBlobValueSet() {
        sfab_FabricatedSObject fabricated = new sfab_FabricatedSObject( ContentDocumentLink.class );
        fabricated.set( 'ContentDocument.LatestPublishedVersion.VersionData', Blob.valueOf( 'abc' ) );
        ContentDocumentLink sobj = (ContentDocumentLink)fabricated.toSObject();
        System.assertEquals( Blob.valueOf( 'abc' ), sobj.ContentDocument.LatestPublishedVersion.VersionData );
    }

    @isTest
    private static void toSObject_whenBlobSetAndChildren_expectBlobValueSet() {
        sfab_FabricatedSObject fabricated =
            new sfab_FabricatedSObject( ContentDocument.class )
                .add( 'ContentVersions', new sfab_FabricatedSObject( ContentVersion.class )
                                            .set( 'VersionData', Blob.valueOf( 'def' ) ) )
                .add( 'ContentVersions', new sfab_FabricatedSObject( ContentVersion.class )
                                            .set( 'VersionData', Blob.valueOf( 'ghi' ) ) )
                .add( 'ContentVersions', new sfab_FabricatedSObject( ContentVersion.class )
                                            .set( 'VersionData', Blob.valueOf( 'abc' ) ) );

        ContentDocument sobj = (ContentDocument)fabricated.toSObject();
        System.assertEquals( Blob.valueOf( 'def' ), sobj.ContentVersions[0].VersionData );
        System.assertEquals( Blob.valueOf( 'ghi' ), sobj.ContentVersions[1].VersionData );
        System.assertEquals( Blob.valueOf( 'abc' ), sobj.ContentVersions[2].VersionData );
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // sfab_FabricatedSObject.sfab_FieldValuePairNode tests
    //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    @isTest
    private static void fieldNode_serialize_whenPassedTrue_expectMap() {
        sfab_FabricatedSObject.sfab_FieldValuePairNode node = new sfab_FabricatedSObject.sfab_FieldValuePairNode(Account.Name, 'Foo');
        Map<String, Object> builtNode = node.serialize( true );

        System.assertEquals(new Map<String, Object> { 'Name' => 'Foo' }, builtNode);
    }
    @isTest
    private static void fieldNode_serialize_whenPassedFalse_expectMap() {
        sfab_FabricatedSObject.sfab_FieldValuePairNode node = new sfab_FabricatedSObject.sfab_FieldValuePairNode(Account.Name, 'Foo');
        Map<String, Object> builtNode = node.serialize( false );

        System.assertEquals(new Map<String, Object> { 'Name' => 'Foo' }, builtNode);
    }

    @isTest
    private static void fieldNode_getName_expectNameFromField() {
        sfab_FabricatedSObject.sfab_FieldValuePairNode node = new sfab_FabricatedSObject.sfab_FieldValuePairNode(Account.Name, 'Foo');
        System.assertEquals( 'Name', node.getName() );
    }

    @isTest
    private static void fieldNode_getName_whenNoField_expectNull() {
        sfab_FabricatedSObject.sfab_FieldValuePairNode node = new sfab_FabricatedSObject.sfab_FieldValuePairNode(null, 'Foo');
        System.assertEquals( null, node.getName() );
    }

    @isTest
    private static void fieldNode_getValue_expectValueFromField() {
        sfab_FabricatedSObject.sfab_FieldValuePairNode node = new sfab_FabricatedSObject.sfab_FieldValuePairNode(Account.Name, 'Foo');
        System.assertEquals( 'Foo', node.getValue() );
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // sfab_FabricatedSObject.sfab_FabricatedSObject.sfab_ChildRelationshipNode tests
    //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    @isTest
    private static void childNode_serialize_whenPassedTrue_expectSerializeInvokedOnChildren() {
        sfab_FabricatedSObject.sfab_FabricatedSObjectStub child1 = new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class);
        sfab_FabricatedSObject.sfab_FabricatedSObjectStub child2 = new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class);
        sfab_FabricatedSObject.sfab_ChildRelationshipNode node = new sfab_FabricatedSObject.sfab_ChildRelationshipNode('Accounts__r', new List<sfab_FabricatedSObject> { child1, child2 });

        node.serialize( true );

        System.assert(child1.serializeInvoked);
        System.assert(child1.serializeInvokedWith);
        System.assert(child2.serializeInvoked);
        System.assert(child2.serializeInvokedWith);
    }
    @isTest
    private static void childNode_serialize_whenPassedFalse_expectSerializeInvokedOnChildren() {
        sfab_FabricatedSObject.sfab_FabricatedSObjectStub child1 = new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class);
        sfab_FabricatedSObject.sfab_FabricatedSObjectStub child2 = new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class);
        sfab_FabricatedSObject.sfab_ChildRelationshipNode node = new sfab_FabricatedSObject.sfab_ChildRelationshipNode('Accounts__r', new List<sfab_FabricatedSObject> { child1, child2 });

        node.serialize( false );

        System.assert(child1.serializeInvoked);
        System.assert(!child1.serializeInvokedWith);
        System.assert(child2.serializeInvoked);
        System.assert(!child2.serializeInvokedWith);
    }

    @isTest
    private static void childNode_serialize_whenPassedTrue_expectDoneMapKey() {
        sfab_FabricatedSObject.sfab_ChildRelationshipNode node = new sfab_FabricatedSObject.sfab_ChildRelationshipNode('Accounts__r', new List<sfab_FabricatedSObject>());

        Map<String, Object> builtNode = node.serialize( true );

        System.assert(((Map<String, Object>)builtNode.get('Accounts__r')).containsKey('done'));
        System.assert((Boolean)((Map<String, Object>)builtNode.get('Accounts__r')).get('done'));
    }

    @isTest
    private static void childNode_serialize_whenPassedTrue_expectTotalSizeMapKey() {
        sfab_FabricatedSObject.sfab_ChildRelationshipNode node = new sfab_FabricatedSObject.sfab_ChildRelationshipNode('Accounts__r', new List<sfab_FabricatedSObject.sfab_FabricatedSObjectStub> {
                new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class),
                new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class)
        });

        Map<String, Object> builtNode = node.serialize( true );

        System.assert(((Map<String, Object>)builtNode.get('Accounts__r')).containsKey('totalSize'));
        System.assertEquals(2, ((Map<String, Object>)builtNode.get('Accounts__r')).get('totalSize'));
    }

    @isTest
    private static void childNode_serialize_whenPassedTrue_expectSerializedChildrenMap() {
        sfab_FabricatedSObject.sfab_FabricatedSObjectStub child1 = new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class, new Map<String, Object> { 'Name' => 'Foo-1' });
        sfab_FabricatedSObject.sfab_FabricatedSObjectStub child2 = new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class, new Map<String, Object> { 'Name' => 'Foo-2' });
        sfab_FabricatedSObject.sfab_ChildRelationshipNode node = new sfab_FabricatedSObject.sfab_ChildRelationshipNode('Accounts__r', new List<sfab_FabricatedSObject> { child1, child2 });

        List<Map<String, Object>> serializedChildren = new List<Map<String, Object>>();
        serializedChildren.add(child1.serialize());
        serializedChildren.add(child2.serialize());

        Map<String, Object> builtNode = node.serialize( true );

        System.assertEquals(serializedChildren, ((Map<String, Object>)builtNode.get('Accounts__r')).get('records'));
    }

    @isTest
    private static void childNode_serialize_whenPassedFalse_expectDoneMapKey() {
        sfab_FabricatedSObject.sfab_ChildRelationshipNode node = new sfab_FabricatedSObject.sfab_ChildRelationshipNode('Accounts__r', new List<sfab_FabricatedSObject>());

        Map<String, Object> builtNode = node.serialize( false );

        System.assert(((Map<String, Object>)builtNode.get('Accounts__r')).containsKey('done'));
        System.assert((Boolean)((Map<String, Object>)builtNode.get('Accounts__r')).get('done'));
    }

    @isTest
    private static void childNode_serialize_whenPassedFalse_expectTotalSizeMapKey() {
        sfab_FabricatedSObject.sfab_ChildRelationshipNode node = new sfab_FabricatedSObject.sfab_ChildRelationshipNode('Accounts__r', new List<sfab_FabricatedSObject.sfab_FabricatedSObjectStub> {
                new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class),
                new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class)
        });

        Map<String, Object> builtNode = node.serialize( false );

        System.assert(((Map<String, Object>)builtNode.get('Accounts__r')).containsKey('totalSize'));
        System.assertEquals(2, ((Map<String, Object>)builtNode.get('Accounts__r')).get('totalSize'));
    }

    @isTest
    private static void childNode_serialize_whenPassedFalse_expectSerializedChildrenMap() {
        sfab_FabricatedSObject.sfab_FabricatedSObjectStub child1 = new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class, new Map<String, Object> { 'Name' => 'Foo-1' });
        sfab_FabricatedSObject.sfab_FabricatedSObjectStub child2 = new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class, new Map<String, Object> { 'Name' => 'Foo-2' });
        sfab_FabricatedSObject.sfab_ChildRelationshipNode node = new sfab_FabricatedSObject.sfab_ChildRelationshipNode('Accounts__r', new List<sfab_FabricatedSObject> { child1, child2 });

        List<Map<String, Object>> serializedChildren = new List<Map<String, Object>>();
        serializedChildren.add(child1.serialize());
        serializedChildren.add(child2.serialize());

        Map<String, Object> builtNode = node.serialize( false );

        System.assertEquals(serializedChildren, ((Map<String, Object>)builtNode.get('Accounts__r')).get('records'));
    }

    @isTest
    private static void childNode_getNumberOfChildren_expectNumberOfChildrenAdded() {

        sfab_FabricatedSObject.sfab_FabricatedSObjectStub child1 = new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class, new Map<String, Object> { 'Name' => 'Foo-1' });
        sfab_FabricatedSObject.sfab_FabricatedSObjectStub child2 = new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class, new Map<String, Object> { 'Name' => 'Foo-2' });
        sfab_FabricatedSObject.sfab_ChildRelationshipNode node = new sfab_FabricatedSObject.sfab_ChildRelationshipNode('Accounts__r', new List<sfab_FabricatedSObject> { child1, child2 });

        System.assertEquals(2, node.getNumberOfChildren());
    }

    @isTest
    private static void childNode_getChildren_expectTheChildren() {

        sfab_FabricatedSObject.sfab_FabricatedSObjectStub child1 = new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class, new Map<String, Object> { 'Name' => 'Foo-1' });
        sfab_FabricatedSObject.sfab_FabricatedSObjectStub child2 = new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class, new Map<String, Object> { 'Name' => 'Foo-2' });
        List<sfab_FabricatedSObject.sfab_FabricatedSObjectStub> children = new List<sfab_FabricatedSObject.sfab_FabricatedSObjectStub> { child1, child2 };
        sfab_FabricatedSObject.sfab_ChildRelationshipNode node = new sfab_FabricatedSObject.sfab_ChildRelationshipNode('Accounts__r', children);

        System.assertEquals(children, node.getChildren());
    }

    @isTest
    private static void childNode_getName_expectTheName() {
        sfab_FabricatedSObject.sfab_ChildRelationshipNode node = new sfab_FabricatedSObject.sfab_ChildRelationshipNode('Accounts__r');
        System.assertEquals('Accounts__r', node.getName());
    }

    @isTest
    private static void childNode_constructor_withNoChildren_expectEmptyChildren() {
        sfab_FabricatedSObject.sfab_ChildRelationshipNode node = new sfab_FabricatedSObject.sfab_ChildRelationshipNode('Accounts__r');
        System.assertEquals(0, node.getNumberOfChildren());
    }

    @isTest
    private static void childNode_addChild_expectAddsAChildNode() {

        sfab_FabricatedSObject.sfab_ChildRelationshipNode node = new sfab_FabricatedSObject.sfab_ChildRelationshipNode('Accounts__r' );
        node.addChild( new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class, new Map<String, Object> { 'Name' => 'Foo-1' } ) );
        node.addChild( new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class, new Map<String, Object> { 'Name' => 'Foo-2' } ) );

        System.assertEquals(2, node.getNumberOfChildren());
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // sfab_FabricatedSObject.sfab_ParentRelationshipNode tests
    //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    @isTest
    private static void parentNode_serialize_whenPassedTrue_expectSerializeInvokedOnParent() {
        sfab_FabricatedSObject.sfab_FabricatedSObjectStub fabricatedParent = new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class);
        sfab_FabricatedSObject.sfab_ParentRelationshipNode node = new sfab_FabricatedSObject.sfab_ParentRelationshipNode('Account__r', fabricatedParent);

        node.serialize( true );

        System.assert(fabricatedParent.serializeInvoked);
        System.assert(fabricatedParent.serializeInvokedWith);
    }

    @isTest
    private static void parentNode_serialize_whenPassedFalse_expectSerializeInvokedOnParent() {
        sfab_FabricatedSObject.sfab_FabricatedSObjectStub fabricatedParent = new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class);
        sfab_FabricatedSObject.sfab_ParentRelationshipNode node = new sfab_FabricatedSObject.sfab_ParentRelationshipNode('Account__r', fabricatedParent);

        node.serialize( false );

        System.assert(fabricatedParent.serializeInvoked);
        System.assert(!fabricatedParent.serializeInvokedWith);
    }

    @isTest
    private static void parentNode_serialize_whenPassedFalse_expectSerializedParentMap() {
        sfab_FabricatedSObject.sfab_FabricatedSObjectStub fabricatedParent = new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class, new Map<String, Object> { 'Name' => 'Foo' });
        sfab_FabricatedSObject.sfab_ParentRelationshipNode node = new sfab_FabricatedSObject.sfab_ParentRelationshipNode('Account__r', fabricatedParent);

        Map<String, Object> builtNode = node.serialize( false );

        System.assertEquals(new Map<String, Object> { 'Account__r' => fabricatedParent.serialize() }, builtNode);
    }

    @isTest
    private static void parentNode_serialize_whenPassedTrue_expectSerializedParentMap() {
        sfab_FabricatedSObject.sfab_FabricatedSObjectStub fabricatedParent = new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class, new Map<String, Object> { 'Name' => 'Foo' });
        sfab_FabricatedSObject.sfab_ParentRelationshipNode node = new sfab_FabricatedSObject.sfab_ParentRelationshipNode('Account__r', fabricatedParent);

        Map<String, Object> builtNode = node.serialize( true );

        System.assertEquals(new Map<String, Object>(), builtNode);
    }

    @isTest
    private static void parentNode_getName_expectParentReturned() {
        sfab_FabricatedSObject.sfab_FabricatedSObjectStub fabricatedParent = new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class, new Map<String, Object> { 'Name' => 'Foo' });
        sfab_FabricatedSObject.sfab_ParentRelationshipNode node = new sfab_FabricatedSObject.sfab_ParentRelationshipNode('Account__r', fabricatedParent);

        System.assertEquals( 'Account__r', node.getName() );
    }

    @isTest
    private static void parentNode_getParent_expectParentReturned() {
        sfab_FabricatedSObject.sfab_FabricatedSObjectStub fabricatedParent = new sfab_FabricatedSObject.sfab_FabricatedSObjectStub(Account.class, new Map<String, Object> { 'Name' => 'Foo' });
        sfab_FabricatedSObject.sfab_ParentRelationshipNode node = new sfab_FabricatedSObject.sfab_ParentRelationshipNode('Account__r', fabricatedParent);

        System.assertEquals( fabricatedParent, node.getParent() );
    }

    @isTest
    private static void getSobjectType_whenTypeIsSet_willReturnTheTypeAsAnSObjectType() {
        sfab_FabricatedSObject obj = new sfab_FabricatedSObject( Contact.class );
        System.assertEquals( Contact.sobjectType, obj.getSobjectType(), 'getSobjectType, when type is set, will return the type as an SObjectType' );
    }

    @isTest
    private static void getSobjectName_whenTypeIsSet_willReturnTheTypeAsAString() {
        sfab_FabricatedSObject obj = new sfab_FabricatedSObject( Contact.class );
        System.assertEquals( 'Contact', obj.getSobjectName(), 'getSobjectName, when type is set, will return the type as a String' );
    }
}