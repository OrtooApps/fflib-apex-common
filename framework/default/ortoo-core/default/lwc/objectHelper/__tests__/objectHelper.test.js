import ObjectHelper from 'c/objectHelper';

describe( 'generateRowId', () => {

    it( 'returns an alpha numeric string that is 10 characters long', () => {

		const got = ObjectHelper.generateRowId();
        expect( got ).toHaveLength( 10 );
    });

    it( 'does not return the same string when called multiple times', () => {

		let previousIds = [];
		for ( let i=0; i<100; i++ ) {
			const got = ObjectHelper.generateRowId();
			expect( previousIds ).not.toContain( got );
			previousIds.push( got );
		}
    });
});