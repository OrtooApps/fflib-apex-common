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

sfdx force:data:soql:query -u "$ORG_ALIAS" -t -q "SELECT SUM(NumLinesUncovered), SUM(NumLinesCovered) FROM ApexCodeCoverageAggregate" | grep -o -E '[0-9]+' | xargs | while read -r uncovered covered remainder ; do
	totallines=$(expr $covered + $uncovered)
	coveredtimeshundred=$(expr $covered \* 100)
	percentage=$(expr $coveredtimeshundred / $totallines)
	echo "Uncovered: $uncovered, Covered: $covered, Percentage: $percentage%"
done