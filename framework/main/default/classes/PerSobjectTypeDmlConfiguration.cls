public with sharing class PerSobjectTypeDmlConfiguration implements fflib_SobjectUnitOfWork.Idml
{
    fflib_SobjectUnitOfWork.Idml defaultIdml;
    Map<SobjectType,fflib_SobjectUnitOfWork.Idml> IDmlBySobjectType;

    public PerSobjectTypeDmlConfiguration()
    {
        IDmlBySobjectType = new Map<SobjectType,fflib_SobjectUnitOfWork.Idml>();
    }

    public PerSobjectTypeDmlConfiguration setDefaultDml( fflib_SobjectUnitOfWork.Idml IDml )
    {
        defaultIdml = IDml;
        return this;
    }

    public PerSobjectTypeDmlConfiguration setDml( SobjectType sobjectType, fflib_SobjectUnitOfWork.Idml IDml )
    {
        IDmlBySobjectType.put( sobjectType, IDml );
        return this;
    }

    public void dmlInsert( List<SObject> objList )
    {
        getIdmlForSobjectType( objList ).dmlInsert( objList );
    }

    public void dmlUpdate( List<SObject> objList )
    {
        getIdmlForSobjectType( objList ).dmlUpdate( objList );
    }

    public void dmlDelete( List<SObject> objList )
    {
        getIdmlForSobjectType( objList ).dmlDelete( objList );
    }

    public void eventPublish( List<SObject> objList )
    {
        getIdmlForSobjectType( objList ).eventPublish( objList );
    }

    public void emptyRecycleBin( List<SObject> objList )
    {
        getIdmlForSobjectType( objList ).emptyRecycleBin( objList );
    }

    private fflib_SobjectUnitOfWork.Idml getIdmlForSobjectType( List<SObject> objList )
    {
        fflib_SobjectUnitOfWork.Idml IDml;

        if ( !objList.isEmpty() )
        {
            IDml = IDmlBySobjectType.get( objList[0].getSObjectType() );
        }

        if ( IDml == null )
        {
            IDml = defaultIdml;
        }
        return IDml;
    }
}
