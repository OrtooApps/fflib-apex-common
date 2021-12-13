const DISPLAY_DENSITY = Object.freeze({
    COMFY   : 'comfy',
    COMPACT : 'compact',
    DEFAULT : 'comfy',
});

const getKeyForDisplayDensity = displayDensity => {
    for ( let key in DISPLAY_DENSITY ) {
        if ( DISPLAY_DENSITY[ key ] == displayDensity ) {
            return key;
        }
    }
}

const LABEL_PROPERTIES = Object.freeze({
    COMFY   : {
        VARIANT : 'standard',
        CLASSES : 'slds-form-element slds-form-element_stacked'
    },
    COMPACT : {
        VARIANT : 'label-inline',
        CLASSES : 'slds-form-element slds-form-element_horizontal'
    },
    HIDDEN : {
        VARIANT : 'label-hidden',
        CLASSES : ''
    },
});

const CONSTANTS = Object.freeze({
    DISPLAY_DENSITY  : DISPLAY_DENSITY,
    LABEL_PROPERTIES : LABEL_PROPERTIES,
    getLabelVariant  : displayDensity => LABEL_PROPERTIES[ getKeyForDisplayDensity( displayDensity ) ].VARIANT,
    getLabelClasses  : displayDensity => LABEL_PROPERTIES[ getKeyForDisplayDensity( displayDensity ) ].CLASSES
});

export default CONSTANTS;