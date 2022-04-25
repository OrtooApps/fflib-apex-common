public inherited sharing class ortoo_DynamicUnitOfWorkFactory // NOPMD: specified a mini-namespace to differentiate from fflib versions
{
    private static fflib_SobjectUnitOfWork.Idml defaultIdml = new SecureDml();
	protected fflib_ISObjectUnitOfWork mockUow;

    /**
     * Returns a new SObjectUnitOfWork configured with the
     *   SObjectType list provided in the constructor, returns a Mock implementation
     *   if set via the setMock method
     **/
    public fflib_ISObjectUnitOfWork newInstance()
    {
        return newInstance( defaultIdml );
    }

    /**
     * Returns a new SObjectUnitOfWork configured with the
     *   SObjectType list provided in the constructor, returns a Mock implementation
     *   if set via the setMock method
     **/
    public fflib_ISObjectUnitOfWork newInstance( fflib_SObjectUnitOfWork.Idml dml )
    {
        if ( this.mockUow != null )
        {
            return this.mockUow;
        }
        return new ortoo_DynamicSObjectUnitOfWork( dml );
    }

    @TestVisible
    private void setMock( fflib_ISObjectUnitOfWork mockUow )
    {
        this.mockUow = mockUow;
    }
}