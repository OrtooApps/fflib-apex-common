public with sharing class PerSobjectTypeDmlConfiguration implements fflib_SobjectUnitOfWork.Idml
{
    fflib_SobjectUnitOfWork.Idml defaultIdml;
    Map<SobjectType,fflib_SobjectUnitOfWork.Idml> idmlBySobjectType;

    public PerSobjectTypeDmlConfiguration()
    {
        idmlBySobjectType = new Map<SobjectType,fflib_SobjectUnitOfWork.Idml>();
    }

    public PerSobjectTypeDmlConfiguration setDefault( fflib_SobjectUnitOfWork.Idml idml )
    {
        defaultIdml = idml;
        return this;
    }

    public PerSobjectTypeDmlConfiguration addIdml( SobjectType sobjectType, fflib_SobjectUnitOfWork.Idml idml )
    {
        idmlBySobjectType.put( sobjectType, idml );
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
        fflib_SobjectUnitOfWork.Idml idml;

        if ( !objList.isEmpty() )
        {
            idml = idmlBySobjectType.get( objList[0].getSObjectType() );
        }

        if ( idml == null )
        {
            idml = defaultIdml;
        }
        return idml;
    }
}
