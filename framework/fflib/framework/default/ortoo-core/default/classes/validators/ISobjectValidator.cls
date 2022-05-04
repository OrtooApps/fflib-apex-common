/**
 * Defines the interface that an Sobject Validator must implement, being a mechanism
 * for providing enhanced validation for objects that have relationship requirements.

 * For example, a search filter record that has a formula (e.g. 1 AND 2) that references
 * child search filter row records.
 */
public interface ISobjectValidator
{
    ISobjectValidator setSobject( Sobject thisSobjectToValidate );

    /**
     * When implemented, should throw an Exceptions.ValidationException with MessageDetail
     * objects against it that describe all the validation issues on the given SObject.
     */
    void validate();
}