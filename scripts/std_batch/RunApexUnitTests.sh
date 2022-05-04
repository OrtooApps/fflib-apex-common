#!/bin/bash
ORG_ALIAS="OrtooQassignScratch"

if [ $# = 1 ]; then
    ORG_ALIAS=$1
else
    echo
    echo "Script requires one parameter"
    echo "1. Org Alias for created org. e.g. OrtooQassignScratch"
	echo
    exit 1
fi

( set -o pipefail; SFDX_IMPROVED_CODE_COVERAGE='true' SFDX_MAX_QUERY_LIMIT=200000 sfdx force:apex:test:run -u "$ORG_ALIAS" -r human --codecoverage --wait 30 | grep -v ' Pass   ' | grep -v '^[a-zA-Z0-9]\{18\}\s\s' | grep -v 'UNCOVERED' | grep -v 'Apex Code Coverage' | grep -v ' ───────  ───────────────' | grep -v '─────────────────────────────────────────────────────────────────────────────────────────────────────────────' )