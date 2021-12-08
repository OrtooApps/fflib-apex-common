public inherited sharing class ortoo_UnitOfWorkFactory extends fflib_Application.UnitOfWorkFactory // NOPMD: specified a mini-namespace to differentiate from fflib versions
{
    private static fflib_SobjectUnitOfWork.Idml defaultIdml = new SecureDml( new SecureDml.ErrorOnInaccessibleFieldsHandler() );
    /*
    * Constructs a Unit Of Work factory with no default configuration
    *
    * @group fflib Extension
    **/
    public ortoo_UnitOfWorkFactory()
    {
       super( new List<SObjectType>() );
    }

    /*
    * Constructs a Unit Of Work factory
    *
    * @param objectTypes List of SObjectTypes in dependency order
    **/
    public ortoo_UnitOfWorkFactory( List<SObjectType> objectTypes )
    {
       super( objectTypes );
    }

    /**
     * Returns a new SObjectUnitOfWork configured with the
     *   SObjectType list provided in the constructor, returns a Mock implementation
     *   if set via the setMock method
     **/
    public override fflib_ISObjectUnitOfWork newInstance()
    {
        if ( m_mockUow != null )
        {
            return m_mockUow;
        }
        return new ortoo_SObjectUnitOfWork( m_objectTypes, defaultIdml );
    }

    /**
     * Returns a new SObjectUnitOfWork configured with the
     *   SObjectType list provided in the constructor, returns a Mock implementation
     *   if set via the setMock method
     **/
    public override fflib_ISObjectUnitOfWork newInstance( fflib_SObjectUnitOfWork.Idml dml )
    {
        if ( m_mockUow != null )
        {
            return m_mockUow;
        }
        return new ortoo_SObjectUnitOfWork( m_objectTypes, dml );
    }

    /**
     * Returns a new SObjectUnitOfWork configured with the
     *   SObjectType list specified, returns a Mock implementation
     *   if set via the setMock method
     *
     * @remark If mock is set, the list of SObjectType in the mock could be different
     *         then the list of SObjectType specified in this method call
     **/
    public override fflib_ISObjectUnitOfWork newInstance( List<SObjectType> objectTypes )
    {
        if ( m_mockUow != null )
        {
            return m_mockUow;
        }
        return new ortoo_SObjectUnitOfWork( objectTypes, defaultIdml );
    }

    /**
     * Returns a new SObjectUnitOfWork configured with the
     *   SObjectType list specified, returns a Mock implementation
     *   if set via the setMock method
     *
     * @remark If mock is set, the list of SObjectType in the mock could be different
     *         then the list of SObjectType specified in this method call
     **/
    public override fflib_ISObjectUnitOfWork newInstance( List<SObjectType> objectTypes, fflib_SObjectUnitOfWork.Idml dml )
    {
        if ( m_mockUow != null )
        {
            return m_mockUow;
        }
        return new ortoo_SObjectUnitOfWork( objectTypes, dml );
    }

    @TestVisible
    protected override void setMock( fflib_ISObjectUnitOfWork mockUow )
    {
        m_mockUow = mockUow;
    }
}