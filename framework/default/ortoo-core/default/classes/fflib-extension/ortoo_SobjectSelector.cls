/**
 * Is an extension of the provided fflib version of SobjectSelector in order to try to limit the impact of changes
 *
 * @group fflib Extension
 */
public abstract inherited sharing class ortoo_SobjectSelector extends fflib_SobjectSelector // NOPMD: specified a mini-namespace to differentiate from fflib versions
{
    public ortoo_SobjectSelector()
    {
        super();
        enforceFLS();
    }

    public fflib_SObjectSelector ignoreFls()
    {
        m_enforceFLS = false;
        return this;
    }
}