#!/bin/bash

# chmod u+x CreateScratchOrgWithNamespaceOnlyHeadless.sh
# run in Terminal window of SFDX project with ./scripts/std_batch/CreateScratchOrgWithNamespaceOnlyHeadless.sh OrtooQassignScratch

# CREATE SCRATCH ORG WITH NAMESPACE AND GENERATE PASSWORD
#
echo "Scratch Org Creation With Namespace ONLY (no data loaded) started."

ORG_ALIAS="OrtooQassignScratch"

if [ $# = 1 ]; then
    ORG_ALIAS=$1
else
    echo
    echo "Script requires one parameter"
    echo "1. Org Alias for created org. e.g. OrtooQassignScratch"
	echo
	echo "**** Remember to update config/project-scratch-def.json file as appropriate."
	echo "     Include your public facing IP Address to prevent two-factor authentication."
	echo "     Update Business Hours if necessary."
	echo
	echo "**** Remember to update sfdx-project.json file with Namespace to be used."
	echo
    exit 1
fi

echo
echo "Using $ORG_ALIAS for Org alias"
echo

echo "1. create"
sfdx force:org:create -f config/project-scratch-def.json --setalias "$ORG_ALIAS" --durationdays 30 --setdefaultusername --loglevel fatal
if [ $? = 0 ]; then
    echo "Created Scratch Org with alias $ORG_ALIAS"
else
	echo
    echo "Non zero exit code: $?"
    echo "Exiting script"
    exit 1
fi

echo "2. password generation"
sfdx force:user:password:generate -u "$ORG_ALIAS"
if [ $? = 0 ]; then
    echo "Password generated"
else
	echo
    echo "Non zero exit code: $?"
    echo "Exiting script"
    echo
    exit 1
fi

echo "3. display Org details"
sfdx force:org:display -u "$ORG_ALIAS"
if [ $? = 0 ]; then
    echo "Org details displayed"
else
	echo
    echo "Non zero exit code: $?"
    echo "Exiting script"
    echo
    exit 1
fi

echo
echo "Scratch Org Creation With Namespace ONLY completed."
echo

exit 0