/**
 * Copyright (c), FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

@IsTest
private class fflib_ApplicationTest 
{
	@IsTest
	private static void callingDomainFactoryShouldGiveRegisteredImplsAndMocks()
	{
		// Registered Accounts domain class by SObject List
		Id testAccountId = fflib_IDGenerator.generate(Account.SObjectType);
		fflib_IDomain domainObjectAcct =
			Domain.newInstance(
				new List<Account> 
					{ new Account( 
						Id = testAccountId,
						Name = 'Test Account') });
		System.assert(domainObjectAcct instanceof AccountsDomain);
		System.assertEquals(testAccountId, getFirstSObject(domainObjectAcct).Id);

		// Registered Accounts domain class by SObject List
		testAccountId = fflib_IDGenerator.generate(Account.SObjectType);
		domainObjectAcct = 
			Domain.newInstance(
				new List<SObject> 
					{ new Account( 
						Id = testAccountId,
						Name = 'Test Account') }
				, Account.SObjectType);
		System.assert(domainObjectAcct instanceof AccountsDomain);
		System.assertEquals(testAccountId, getFirstSObject(domainObjectAcct).Id);

		// Registered Opportunities domain class by SObject List
		Id testOpportunityId = fflib_IDGenerator.generate(Opportunity.SObjectType);
		fflib_IDomain domainObjectOpp =
			Domain.newInstance(
				new List<Opportunity> 
					{ new Opportunity( 
						Id = testOpportunityId,
						Name = 'Test Opportunity') });
		System.assertEquals(testOpportunityId, getFirstSObject(domainObjectOpp).Id);
		System.assert(domainObjectOpp instanceof OpportuntiesDomain);

		// Test failure for creating new instance using IConstructable2
		// for domain class that does not support it
		testOpportunityId = fflib_IDGenerator.generate(Opportunity.SObjectType);
		domainObjectOpp = 
			Domain.newInstance(
				new List<SObject> 
					{ new Opportunity( 
						Id = testOpportunityId,
						Name = 'Test Opportunity') }
				, Opportunity.SObjectType);
		System.assertEquals(testOpportunityId, getFirstSObject(domainObjectOpp).Id);
		System.assert(domainObjectOpp instanceof OpportuntiesDomain);

		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		mocks.startStubbing();		
		fflib_ISObjectDomain domainMock = new fflib_SObjectMocks.SObjectDomain(mocks);
		mocks.when(domainMock.sObjectType()).thenReturn(Account.SObjectType);
		mocks.stopStubbing();		
		Domain.setMock(domainMock);

		// When
		domainObjectAcct = 
			Domain.newInstance(
				new List<Account> 
					{ new Account( 
						Id = testAccountId,
						Name = 'Test Account') });

		// Then
		System.assert(domainObjectAcct instanceof fflib_SObjectMocks.SObjectDomain);

		// When
		domainObjectAcct = 
			Domain.newInstance(
				new List<SObject> 
					{ new Account( 
						Id = testAccountId,
						Name = 'Test Account') }
				, Account.SObjectType);

		// Then
		System.assert(domainObjectAcct instanceof fflib_SObjectMocks.SObjectDomain);		
	}

	private static SObject getFirstSObject(fflib_IDomain domainObjectAcct)
	{
		return ((List<SObject>) domainObjectAcct.getObjects())[0];
	}

	@IsTest
	private static void callingDomainFactoryWithIdsShouldGiveRegisteredImpls()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		mocks.startStubbing();
		fflib_ISObjectSelector selectorMock = new fflib_SObjectMocks.SObjectSelector(mocks);
		Id testAccountId = fflib_IDGenerator.generate(Account.SObjectType);
		List<Account> accounts = 
			new List<Account> 
				{ new Account( 
					Id = testAccountId,
					Name = 'Test Account') };
		Set<Id> accountIds = new Map<Id, Account>(accounts).keySet();
		mocks.when(selectorMock.selectSObjectsById(accountIds)).thenReturn(accounts);
		mocks.when(selectorMock.sObjectType()).thenReturn(Account.SObjectType);
		mocks.stopStubbing();

		// When
		Selector.setMock(selectorMock);
		fflib_IDomain domainObjectAcc = Domain.newInstance(new Set<Id> { testAccountId });

		// Then
		List<Account> assertAccounts = (List<Account>) domainObjectAcc.getObjects();
		System.assert(domainObjectAcc instanceof AccountsDomain);
		System.assertEquals(testAccountId, getFirstSObject(domainObjectAcc).Id);
		System.assertEquals(1, assertAccounts.size());
		System.assertEquals(testAccountId, assertAccounts[0].Id);
		System.assertEquals('Test Account', assertAccounts[0].Name);
	}

	@IsTest
	private static void callingDomainFactoryWithGenericListShouldGiveException()
	{
		try {
			Domain.newInstance(new List<SObject>());
			System.assert(false, 'Expected exception');
		} catch (fflib_Application.DeveloperException e) {
			System.assertEquals('Unable to determine SObjectType', e.getMessage());
		}
	}

	@IsTest
	private static void callingDomainFactoryWithNoSObjectTypeShouldGiveException()
	{
		try {
			Domain.newInstance(new List<SObject>(), null);
			System.assert(false, 'Expected exception');
		} catch (fflib_Application.DeveloperException e) {
			System.assertEquals('Must specify sObjectType', e.getMessage());
		}
	}	

	@IsTest
	private static void callingDomainFactoryWithInAccessableConstructorShouldGiveException()
	{
		try {
			Domain.newInstance(new List<Product2>{ new Product2(Name = 'Test Product') });
			System.assert(false, 'Expected exception');
		} catch (fflib_Application.DeveloperException e) {
			System.assertEquals('Domain constructor class not found for SObjectType Product2', e.getMessage());
		}

		try {
			Domain.newInstance(new List<SObject>{ new Product2(Name = 'Test Product') }, Product2.SObjectType);
			System.assert(false, 'Expected exception');
		} catch (fflib_Application.DeveloperException e) {
			System.assertEquals('Domain constructor class not found for SObjectType Product2', e.getMessage());
		}		
	}

	@IsTest
	private static void callingDomainFactoryWithContructorClassThatDoesNotSupportIConstructableShouldGiveException()
	{
		try {
			Domain.newInstance(new List<Contact>{ new Contact(LastName = 'TestContactLName') });
			System.assert(false, 'Expected exception');
		} catch (System.TypeException e) {

			System.assert(Pattern.Matches('Invalid conversion from runtime type \\w*\\.?fflib_ApplicationTest\\.ContactsConstructor to \\w*\\.?fflib_IDomainConstructor',
				e.getMessage()), 'Exception message did not match the expected pattern: ' + e.getMessage());
		}	

		try {
			Domain.newInstance(new List<SObject>{ new Contact(LastName = 'TestContactLName') }, Contact.SObjectType);
			System.assert(false, 'Expected exception');
		} catch (System.TypeException e) {
			System.assert(Pattern.Matches('Invalid conversion from runtime type \\w*\\.?fflib_ApplicationTest\\.ContactsConstructor to \\w*\\.?fflib_IDomainConstructor',
				e.getMessage()), 'Exception message did not match the expected pattern: ' + e.getMessage());
		}		
	}	

	@IsTest
	private static void callingUnitOfWorkFactoryShouldGivenStandardImplsAndMockImpls()
	{
		// Standard behaviour
		System.assert(UnitOfWork.newInstance() instanceof fflib_SObjectUnitOfWork);
 		
		// Mocking behaviour
		UnitOfWork.setMock(new fflib_SObjectMocks.SObjectUnitOfWork(new fflib_ApexMocks()));
		System.assert(UnitOfWork.newInstance() instanceof fflib_SObjectMocks.SObjectUnitOfWork);
	}

	@IsTest
	private static void callingUnitOfWorkFactoryWithCustomTypesShouldGivenStandardImplsAndMockImpls()
	{
		// Standard behaviour
		System.assert(
				UnitOfWork.newInstance(
						new List<SObjectType>{ Account.SObjectType}
				) instanceof fflib_SObjectUnitOfWork);

		// Mocking behaviour
		UnitOfWork.setMock(new fflib_SObjectMocks.SObjectUnitOfWork(new fflib_ApexMocks()));
		System.assert(
				UnitOfWork.newInstance(
						new List<SObjectType>{ Account.SObjectType}
				) instanceof fflib_SObjectMocks.SObjectUnitOfWork);
	}

	@IsTest
	private static void callingServiceFactoryShouldGiveRegisteredImplementationAndMockOnes()
	{
		// Standard behaviour
		System.assert(Service.newInstance(IRegisteredServiceWithStandardName1.class) instanceof RegisteredServiceWithStandardName1Impl, 'ServiceFactory.newInstance will return registered implementations' ) ;
		System.assert(Service.newInstance(IRegisteredServiceWithStandardName2.class) instanceof RegisteredServiceWithStandardName2Impl, 'ServiceFactory.newInstance will return registered implementations (2)' );
		System.assert(Service.newInstance(IRegisteredServiceWithNonStandardImplName.class) instanceof RegisteredServiceWithNonStandardNameImplName, 'ServiceFactory.newInstance will return registered implementations (3)' );
		System.assert(Service.newInstance(RegisteredServiceWithNonStandardName.class) instanceof RegisteredServiceWithNonStandardNameImpl, 'ServiceFactory.newInstance will return registered implementations (4)' );

		// Mocking behaviour
		Service.setMock(IRegisteredServiceWithStandardName1.class, new ServiceMock());
		System.assert(Service.newInstance(IRegisteredServiceWithStandardName1.class) instanceof ServiceMock,'ServiceFactory.newInstance, when a mock is registered, will return the mock for that type');
		System.assert(Service.newInstance(IRegisteredServiceWithStandardName2.class) instanceof RegisteredServiceWithStandardName2Impl, 'ServiceFactory.newInstance, when a mock is registered, will still return the standard one for other types (1)');
		System.assert(Service.newInstance(IRegisteredServiceWithNonStandardImplName.class) instanceof RegisteredServiceWithNonStandardNameImplName, 'ServiceFactory.newInstance, when a mock is registered, will still return the standard one for other types (2)');
		System.assert(Service.newInstance(RegisteredServiceWithNonStandardName.class) instanceof RegisteredServiceWithNonStandardNameImpl, 'ServiceFactory.newInstance, when a mock is registered, will still return the standard one for other types (3)');
	}

	@IsTest
	private static void callingServiceFactoryShouldGiveDefaultImplementation()
	{
		// Standard behaviour
		System.assert(Service.newInstance(IUnregisteredServiceWithStandardName.class) instanceof UnregisteredServiceWithStandardNameImpl, 'ServiceFactory.newInstance, when given a standard format interface that is not registered, and a standard implentation that exists, will return the standard service' ) ;

		// Mocking behaviour
		Service.setMock(IUnregisteredServiceWithStandardName.class, new ServiceMock());
		System.assert(Service.newInstance(IUnregisteredServiceWithStandardName.class) instanceof ServiceMock, 'ServiceFactory.newInstance, when given a standard format interface that is not registered and a mock is set, will return the mock for that type');
	}

	@isTest
	private static void serviceFactory_whenAnUnregisteredInterfaceWithNoDefaultImpl_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				Service.newInstance(IUnregisteredServiceWithNonStandardImpl.class);
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		System.assert( exceptionMessage.contains( 'No implementation registered for service interface' ), 'serviceFactory, when given a standard format interface that has no default implementation, will throw an exception' );
		System.assert( exceptionMessage.contains( 'and no default implementation found with the name' ), 'serviceFactory, when given a standard format interface that has no default implementation, will throw an exception' );
	}

	@isTest
	private static void serviceFactory_whenAnUnregisteredInterfaceWithNoImpl_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				Service.newInstance(IUnregisteredServiceWithNoImplementation.class);
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		System.assert( exceptionMessage.contains( 'No implementation registered for service interface' ), 'serviceFactory, when given a standard format interface that has no default implementation, will throw an exception' );
		System.assert( exceptionMessage.contains( 'and no default implementation found with the name' ), 'serviceFactory, when given a standard format interface that has no default implementation, will throw an exception' );
	}

	@isTest
	private static void serviceFactory_whenAnUnregisteredInterfaceWithNonStandardName_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				Service.newInstance(UnregisteredServiceWithNonStandardName.class);
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		System.assert( exceptionMessage.contains( 'No implementation registered for service interface' ), 'serviceFactory, when given a non standard format interface that is not registered, will throw an exception' );
		System.assert( exceptionMessage.contains( 'and default implementation cannot be determined from the name (not an interface in the standard naming convention (Ixxxx)' ), 'serviceFactory, when given a standard format interface that is not registered, will throw an exception' );
	}

	@isTest
	private static void serviceFactory_whenARegisteredInterfaceCannotBeConstructed_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage = '';
			try
			{
				Service.newInstance(IRegisteredServiceUnconstructable.class);
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		System.assert( exceptionMessage.contains( 'Implementation for service interface' ), 'serviceFactory, when given registered service that cannot be constructed, will throw an exception' );
		System.assert( exceptionMessage.contains( 'could not be constructed' ), 'serviceFactory, when given registered service that cannot be constructed, will throw an exception' );
	}

	@isTest
	private static void serviceFactory_whenAnUnregisteredInterfaceCannotBeConstructed_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage = '';
			try
			{
				Service.newInstance(IUnregisteredServiceUnconstructable.class);
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		System.assert( exceptionMessage.contains( 'Default implementation for service interface' ), 'serviceFactory, when given unregistered service that cannot be constructed, will throw an exception' );
		System.assert( exceptionMessage.contains( 'could not be constructed' ), 'serviceFactory, when given unregistered service that cannot be constructed, will throw an exception' );
	}

	@isTest
	private static void isAServiceInterfaceName_whenGivenInterfaceNameWithNoNs_returnsTrue() // NOPMD: Test method name format
	{
		System.assertEquals( true, Service.isAServiceInterfaceName( 'IIsAnInterface' ), 'isAServiceInterfaceName, when given a top level interface name with no namespace, returns true' );
	}

	@isTest
	private static void isAServiceInterfaceName_whenGivenInterfaceNameWithANs_returnsTrue() // NOPMD: Test method name format
	{
		System.assertEquals( true, Service.isAServiceInterfaceName( 'namespace.IIsAnInterface' ), 'isAServiceInterfaceName, when given a top level interface name with a namespace, returns true' );
	}

	@isTest
	private static void isAServiceInterfaceName_whenGivenInnerInterfaceNameWithNoNs_returnsTrue() // NOPMD: Test method name format
	{
		System.assertEquals( true, Service.isAServiceInterfaceName( 'TopLevelClass.IIsAnInterface' ), 'isAServiceInterfaceName, when given an inner interface name with no namespace, returns true' );
	}

	@isTest
	private static void isAServiceInterfaceName_whenGivenInnerInterfaceNameWithANs_returnsTrue() // NOPMD: Test method name format
	{
		System.assertEquals( true, Service.isAServiceInterfaceName( 'namespace.TopLevelClass.IIsAnInterface' ), 'isAServiceInterfaceName, when given an inner interface name with a namespace, returns true' );
	}

	@isTest
	private static void isAServiceInterfaceName_whenGivenInterfaceNameWithNoNs_returnsFalse() // NOPMD: Test method name format
	{
		System.assertEquals( false, Service.isAServiceInterfaceName( 'NotAnInterface' ), 'isAServiceInterfaceName, when given a top level non interface name (does not start with I) with no namespace, returns false' );
	}

	@isTest
	private static void isAServiceInterfaceName_whenGivenNotInterfaceNameWithANs_returnsFalse() // NOPMD: Test method name format
	{
		System.assertEquals( false, Service.isAServiceInterfaceName( 'namespace.NotAnInterface' ), 'isAServiceInterfaceName, when given a top level non interface name (does not start with I) with a namespace, returns false' );
	}

	@isTest
	private static void isAServiceInterfaceName_whenGivenInnerInterfaceNameWithNoNs_returnsFalse() // NOPMD: Test method name format
	{
		System.assertEquals( false, Service.isAServiceInterfaceName( 'TopLevelClass.NotAnInterface' ), 'isAServiceInterfaceName, when given an inner non interface name (does not start with I) with no namespace, returns false' );
	}

	@isTest
	private static void isAServiceInterfaceName_whenGivenInnerNonInterfaceNameWithANs_returnsFalse() // NOPMD: Test method name format
	{
		System.assertEquals( false, Service.isAServiceInterfaceName( 'namespace.TopLevelClass.NotAnInterface' ), 'isAServiceInterfaceName, when given an inner non interface name (does not start with I) with a namespace, returns false' );
	}

	@isTest
	private static void isAServiceInterfaceName_whenGivenInnerNonInterfaceNameWithANsAndRestLooksLikeInterface_returnsFalse() // NOPMD: Test method name format
	{
		System.assertEquals( false, Service.isAServiceInterfaceName( 'Inamespace.ITopLevelClass.NotAnInterface' ), 'isAServiceInterfaceName, when given an inner non interface name (does not start with I) with a namespace, and the other levels look like an interface, returns false' );
	}

	@isTest
	private static void buildDefaultServiceName_whenGivenNameWithNoNamespace_returnsTheDefaultServiceName() // NOPMD: Test method name format
	{
		System.assertEquals( 'ServiceNameImpl', Service.buildDefaultServiceName( 'IServiceName'), 'buildDefaultServiceName, when given an outer class with no namespace, will return a default service name' );
	}

	@isTest
	private static void buildDefaultServiceName_whenGivenNameWithANamespace_returnsTheDefaultServiceName() // NOPMD: Test method name format
	{
		System.assertEquals( 'namespace.ServiceNameImpl', Service.buildDefaultServiceName( 'namespace.IServiceName'), 'buildDefaultServiceName, when given an outer class with a namespace, will return a default service name' );
	}

	@isTest
	private static void buildDefaultServiceName_whenGivenInnerClassWithNoNamespace_returnsTheDefaultServiceName() // NOPMD: Test method name format
	{
		System.assertEquals( 'ParentClass.ServiceNameImpl', Service.buildDefaultServiceName( 'ParentClass.IServiceName'), 'buildDefaultServiceName, when given an inner class with no namespace, will return a default service name' );
	}

	@isTest
	private static void buildDefaultServiceName_whenGivenInnerClassWithANamespace_returnsTheDefaultServiceName() // NOPMD: Test method name format
	{
		System.assertEquals( 'namespace.ParentClass.ServiceNameImpl', Service.buildDefaultServiceName( 'namespace.ParentClass.IServiceName'), 'buildDefaultServiceName, when given an inner class with a namespace, will return a default service name' );
	}

	@IsTest
	private static void callingSelectorFactoryShouldGiveRegisteredImpls()
	{
		// Standard behaviour
		System.assert(Selector.newInstance(Account.SObjectType) instanceof AccountsSelector);
		System.assert(Selector.newInstance(Opportunity.SObjectType) instanceof OpportuntiesSelector);
		try {
			Selector.newInstance(User.SObjectType);
			System.assert(false, 'Expected exception');
		} catch (fflib_Application.DeveloperException e) {
			System.assertEquals('Selector class not found for SObjectType User', e.getMessage());
		}
	}

	@IsTest
	private static void callingSelectorFactorySelectByIdWithEmptyListShouldGiveException()
	{
		try {
			Selector.selectById(null);
			System.assert(false, 'Expected exception');
		} catch (fflib_Application.DeveloperException e) {
			System.assertEquals('Invalid record Id\'s set', e.getMessage());
		}
		try {
			Selector.selectById(new Set<Id>());
			System.assert(false, 'Expected exception');
		} catch (fflib_Application.DeveloperException e) {
			System.assertEquals('Invalid record Id\'s set', e.getMessage());
		}
	}

	@IsTest
	private static void callingSelectorFactorySelectByIdWithMixedIdTypeListShouldGiveException()
	{
		try {
			Selector.selectById(
				new Set<Id> { 
					fflib_IDGenerator.generate(Opportunity.SObjectType), 
					fflib_IDGenerator.generate(Account.SObjectType) });
			System.assert(true, 'Expected exception');
		} catch (fflib_Application.DeveloperException e) {
			System.assertEquals('Unable to determine SObjectType, Set contains Id\'s from different SObject types', e.getMessage());
		}		
	}

	@IsTest
	private static void callingSelectoryFactorySelectByIdShouldReturnResults()
	{	
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		mocks.startStubbing();
		fflib_ISObjectSelector selectorMock = new fflib_SObjectMocks.SObjectSelector(mocks);
		Id testAccountId = fflib_IDGenerator.generate(Account.SObjectType);
		List<Account> accounts = 
			new List<Account> 
				{ new Account( 
					Id = testAccountId,
					Name = 'Test Account') };
		Set<Id> accountIds = new Map<Id, Account>(accounts).keySet();
		mocks.when(selectorMock.selectSObjectsById(accountIds)).thenReturn(accounts);
		mocks.when(selectorMock.sObjectType()).thenReturn(Account.SObjectType);
		mocks.stopStubbing();

		// When
		Selector.setMock(selectorMock);
		List<Account> assertAccounts = Selector.selectById(accountIds);

		// Then
		System.assert(Selector.newInstance(Account.SObjectType) instanceof fflib_SObjectMocks.SObjectSelector);
		System.assertEquals(1, assertAccounts.size());
		System.assertEquals(testAccountId, assertAccounts[0].Id);
		System.assertEquals('Test Account', assertAccounts[0].Name);
		System.assert(Selector.newInstance(Opportunity.SObjectType) instanceof OpportuntiesSelector);
	}


	@IsTest
	private static void callingSelectoryFactorySselectByRelationshipPassRelatedIds()
	{	
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		mocks.startStubbing();
		fflib_ISObjectSelector selectorMock = new fflib_SObjectMocks.SObjectSelector(mocks);
		Id testAccountId = fflib_IDGenerator.generate(Account.SObjectType);
		Id testOpportunityId = fflib_IDGenerator.generate(Opportunity.SObjectType);
		List<Account> accounts = 
			new List<Account> 
				{ new Account( 
					Id = testAccountId,
					Name = 'Test Account') };
		Set<Id> accountIds = new Map<Id, Account>(accounts).keySet();
		mocks.when(selectorMock.selectSObjectsById(accountIds)).thenReturn(accounts);
		mocks.when(selectorMock.sObjectType()).thenReturn(Account.SObjectType);
		mocks.stopStubbing();
		Selector.setMock(selectorMock);

		// When
		List<Opportunity> opportunties = 
			new List<Opportunity>
				{ new Opportunity(
						Id = testOpportunityId,
						Account = accounts[0],
						AccountId = testAccountId,
						Name = 'Test Opportunity 1'),
				  new Opportunity(
						Id = testOpportunityId,
						Name = 'Test Opportunity 2') };
		List<Account> assertAccounts = Selector.selectByRelationship(opportunties, Opportunity.AccountId);

		// Then
		System.assert(Selector.newInstance(Account.SObjectType) instanceof fflib_SObjectMocks.SObjectSelector);
		System.assertEquals(1, assertAccounts.size());
		System.assertEquals(testAccountId, assertAccounts[0].Id);
		System.assertEquals('Test Account', assertAccounts[0].Name);
		System.assert(Selector.newInstance(Opportunity.SObjectType) instanceof OpportuntiesSelector);
	}


	@IsTest
	private static void callingUnitOfWorkWithCustomDML()
	{
		// Given a custom DML class and a new record
		CustomDML customDML = new CustomDML();
		Account myAccount = new Account(Name = 'Test Account');

		// When the unit of work is instantiated from the Application Class and the record is registered and commited
		fflib_ISObjectUnitOfWork unitOfWork = UnitOfWork.newInstance(customDML);
		unitOfWork.registerNew(myAccount);
		unitOfWork.commitWork();

		// Then the Custom DML is used by the unit of Work
		System.assert(customDML.isInsertCalled, 'Oops, custom DML was not called');
	}

	@IsTest
	private static void callingMockedUnitOfWorkWithCustomDML()
	{
		// Given a custom DML class and a new record
		CustomDML customDML = new CustomDML();
		Account myAccount = new Account(Name = 'Test Account');

		// When the unit of work is instantiated from the Application Class and the record is registered and commited
		UnitOfWork.setMock(new fflib_SObjectMocks.SObjectUnitOfWork(new fflib_ApexMocks()));
		fflib_ISObjectUnitOfWork uow = UnitOfWork.newInstance(customDML);

		uow.registerNew(myAccount);
		uow.commitWork();

		// Then the Custom DML should not be used by the unit of Work
		System.assert(!customDML.isInsertCalled, 'Oops, custom DML was called');
	}

	@IsTest
	private static void callingUnitOfWorkWithCustomObjectTypesAndDML()
	{
		// Given a custom DML class and a new record
		CustomDML customDML = new CustomDML();
		Account myAccount = new Account(Name = 'Test Account');

		// When the unit of work is instantiated from the Application Class and the record is registered and commited
		fflib_ISObjectUnitOfWork unitOfWork = UnitOfWork.newInstance(
				new List<SObjectType>{ Account.SObjectType },
				customDML
		);
		unitOfWork.registerNew(myAccount);
		unitOfWork.commitWork();

		// Then the Custom DML is used by the unit of Work
		System.assert(customDML.isInsertCalled, 'Oops, custom DML was not called');
	}

	@IsTest
	private static void callingMockedUnitOfWorkWithCustomObjectTypesAndDML()
	{
		// Given a custom DML class and a new record
		CustomDML customDML = new CustomDML();
		Account myAccount = new Account(Name = 'Test Account');

		// When the unit of work is instantiated from the Application Class and the record is registered and commited
		UnitOfWork.setMock(new fflib_SObjectMocks.SObjectUnitOfWork(new fflib_ApexMocks()));
		fflib_ISObjectUnitOfWork uow = UnitOfWork.newInstance(
				new List<SObjectType>{ Account.SObjectType },
				customDML
		);
		uow.registerNew(myAccount);
		uow.commitWork();

		// Then the Custom DML should not be used by the unit of Work
		System.assert(!customDML.isInsertCalled, 'Oops, custom DML was called');
	}

	public class CustomDML implements fflib_SObjectUnitOfWork.IDML
	{
		public boolean isInsertCalled = false;
		public boolean isUpdateCalled = false;
		public boolean isDeleteCalled = false;
		public boolean isPublishCalled = false;
		public Boolean isEmptyRecycleBinCalled = false;

		public void dmlInsert(List<SObject> objList){
			this.isInsertCalled = true;
		}
		public void dmlUpdate(List<SObject> objList){
			this.isUpdateCalled = true;
		}
		public void dmlDelete(List<SObject> objList){
			this.isDeleteCalled = true;
		}
		public void eventPublish(List<SObject> objList)
		{
			this.isPublishCalled = true;
		}
		public void emptyRecycleBin(List<SObject> objList)
		{
			this.isEmptyRecycleBinCalled = true;
		}
	}

	// Configure and create the ServiceFactory for this Application
	public static final fflib_Application.ServiceFactory Service =
	new fflib_Application.ServiceFactory(
		new Map<Type, Type> {
			IRegisteredServiceWithStandardName1.class => RegisteredServiceWithStandardName1Impl.class,
			IRegisteredServiceWithStandardName2.class => RegisteredServiceWithStandardName2Impl.class,
			IRegisteredServiceWithNonStandardImplName.class => RegisteredServiceWithNonStandardNameImplName.class,
			RegisteredServiceWithNonStandardName.class => RegisteredServiceWithNonStandardNameImpl.class,
			IRegisteredServiceUnconstructable.class => RegisteredServiceUnconstructableImpl.class
		 });

	// Configure and create the UnitOfWorkFactory for this Application
	public static final fflib_Application.UnitOfWorkFactory UnitOfWork = 
		new fflib_Application.UnitOfWorkFactory(
				new List<SObjectType> { 
					Account.SObjectType,
					Opportunity.SObjectType,
					OpportunityLineItem.SObjectType });	

	// Configure and create the SelectorFactory for this Application
	public static final fflib_Application.SelectorFactory Selector = 
		new fflib_Application.SelectorFactory(
			new Map<SObjectType, Type> {
					Account.SObjectType => AccountsSelector.class,
					Opportunity.SObjectType => OpportuntiesSelector.class });

	// Configure and create the DomainFactory for this Application
	public static final fflib_Application.DomainFactory Domain = 
		new fflib_Application.DomainFactory(
			fflib_ApplicationTest.Selector,
			new Map<SObjectType, Type> {
					Account.SObjectType => AccountsConstructor.class,
					Opportunity.SObjectType => OpportuntiesConstructor.class,
					Contact.SObjectType => ContactsConstructor.class });

	public class AccountsDomain extends fflib_SObjectDomain
	{
		public AccountsDomain(List<Account> sObjectList)
		{
			super(sObjectList);
		}

		public AccountsDomain(List<SObject> sObjectList, SObjectType sObjectType)
		{
			super(sObjectList, sObjectType);
		}
	}			

	public class AccountsConstructor implements fflib_SObjectDomain.IConstructable2
	{
		public fflib_SObjectDomain construct(List<SObject> sObjectList)
		{
			return new AccountsDomain(sObjectList);
		}

		public fflib_SObjectDomain construct(List<SObject> sObjectList, SObjectType sObjectType)
		{
			return new AccountsDomain(sObjectList, sObjectType);
		}		
	}	

	public class OpportuntiesDomain extends fflib_SObjectDomain
	{
		public OpportuntiesDomain(List<Opportunity> sObjectList)
		{
			super(sObjectList);
		}

		public OpportuntiesDomain(List<SObject> sObjectList, SObjectType sObjectType)
		{
			super(sObjectList, sObjectType);
		}		
	}	

	public class OpportuntiesConstructor implements fflib_SObjectDomain.IConstructable2
	{
		public fflib_SObjectDomain construct(List<SObject> sObjectList)
		{
			return new OpportuntiesDomain(sObjectList);
		}

		public fflib_SObjectDomain construct(List<SObject> sObjectList, SObjectType sObjectType)
		{
			return new OpportuntiesDomain(sObjectList, sObjectType);
		}		
	}

	public class ContactsDomain extends fflib_SObjectDomain
	{
		public ContactsDomain(List<Opportunity> sObjectList)
		{
			super(sObjectList);
		}

		public ContactsDomain(List<SObject> sObjectList, SObjectType sObjectType)
		{
			super(sObjectList, sObjectType);
		}
	}			

	// Intentionally does not support IConstructable or IConstructable2 interfaces in order to support testing
	public class ContactsConstructor
	{

	}		

	class OpportuntiesSelector extends fflib_SObjectSelector
	{
		public List<Schema.SObjectField> getSObjectFieldList()
		{
			return new List<Schema.SObjectField> {
				Opportunity.Name,
				Opportunity.Id
			};
		}
		
		public Schema.SObjectType getSObjectType()
		{
			return Opportunity.sObjectType;
		}
	}
	
	class AccountsSelector extends fflib_SObjectSelector
	{
		public List<Schema.SObjectField> getSObjectFieldList()
		{
			return new List<Schema.SObjectField> {
				Account.Name,
				Account.Id,
				Account.AccountNumber,
				Account.AnnualRevenue
			};
		}
		
		public Schema.SObjectType getSObjectType()
		{
			return Account.sObjectType;
		}
	}

	public interface IUnregisteredServiceWithStandardName {}
	public class UnregisteredServiceWithStandardNameImpl implements IUnregisteredServiceWithStandardName {}

	public interface IUnregisteredServiceWithNoImplementation { }

	public interface UnregisteredServiceWithNonStandardName { }

	public interface IUnregisteredServiceWithNonStandardImpl { }
	public class UnregisteredServiceWithNonStandardImplName implements IUnregisteredServiceWithNonStandardImpl {}

	public interface IRegisteredServiceWithStandardName1 {}
	public class RegisteredServiceWithStandardName1Impl implements IRegisteredServiceWithStandardName1 {}
	public class ServiceMock implements IRegisteredServiceWithStandardName1 {}

	public interface IRegisteredServiceWithStandardName2 {}
	public class RegisteredServiceWithStandardName2Impl implements IRegisteredServiceWithStandardName2 {}

	public interface IRegisteredServiceWithNonStandardImplName {}
	public class RegisteredServiceWithNonStandardNameImplName implements IRegisteredServiceWithNonStandardImplName {}

	public interface RegisteredServiceWithNonStandardName {}
	public class RegisteredServiceWithNonStandardNameImpl implements RegisteredServiceWithNonStandardName {}

	public interface IRegisteredServiceUnconstructable {}
	public class RegisteredServiceUnconstructableImpl implements IRegisteredServiceUnconstructable {
		public RegisteredServiceUnconstructableImpl( String parameter ) {}
	}

	public interface IUnregisteredServiceUnconstructable {}
	public class UnregisteredServiceUnconstructableImpl implements IUnregisteredServiceUnconstructable {
		public UnregisteredServiceUnconstructableImpl( String parameter ) {}
	}

}
