/**
 * Provides the error codes that are applicable for exceptions that are thrown by the framework itself
 */
public inherited sharing class FrameworkErrorCodes {

	public final static String OBJECT_UTILS_GET_CLASS_TYPE_UNABLE = 'UTILS-0000000';

	public final static String FACTORY_NO_IMPLEMENTATION_REGISTERED      = 'FACTORY-00000';
	public final static String FACTORY_INVALID_IMPLEMENTATION_REGISTERED = 'FACTORY-00001';
	public final static String FACTORY_NO_PARAMETERLESS_CONSTRUCTOR      = 'FACTORY-00002';

	public final static String VALIDATOR_NO_IMPLEMENTATION_REGISTERED_FOR_SINGLE = 'FACTORY-V-00000';
	public final static String VALIDATOR_NO_IMPLEMENTATION_REGISTERED_FOR_LIST   = 'FACTORY-V-00001';
	public final static String VALIDATOR_NO_PARAMETERLESS_CONSTRUCTOR            = 'FACTORY-V-00002';
	public final static String VALIDATOR_IMPLEMENTATION_IS_NOT_VALIDATOR         = 'FACTORY-V-00003';

	public final static String CRF_IMPLEMENTATION_IS_NOT_CRF = 'FACTORY-CRF-00003';

	public final static String MR_IMPLEMENTATION_IS_NOT_MR = 'FACTORY-MR-00003';

	public final static String CONSTRUCTED_DOMAIN_FACTORY_BEFORE_SELECTOR = 'APP-00000';
	public final static String CONFIGURATION_WITH_INVALID_TYPE            = 'APP-00001';
	public final static String CONFIGURATION_WITH_INVALID_CLASS           = 'APP-00002';
	public final static String CONFIGURATION_WITH_INVALID_SOBJECT_TYPE    = 'APP-00003';

	public final static String NON_EVALUATABLE_CRITERIA		= 'CRI-00000';

	public final static String CACHE_ACCESS_VIOLATION			= 'CACHE-00000';
	public final static String UNABLE_TO_RETRIEVE_IDENTIFIER	= 'CACHE-00001';

	public final static String DML_ON_INACCESSIBLE_FIELDS	= '0000000';
	public final static String DML_INSERT_NOT_ALLOWED		= '0000001';
	public final static String DML_UPDATE_NOT_ALLOWED		= '0000002';
	public final static String DML_DELETE_NOT_ALLOWED		= '0000003';
	public final static String DML_PUBLISH_NOT_ALLOWED		= '0000004';

	public final static String SELECTOR_UNBOUND_COUNT_QUERY = '0000000';

}