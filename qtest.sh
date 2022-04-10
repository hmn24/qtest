# Purge all existing results at the start
q qtest.q -action cleanResult

# Find all relevant files in the tests folder
for i in $(find tests/ -name "*.q" -type f);
  do q qtest.q -action runTest -file $i $@;
done 

# Show results at the end
q qtest.q -action showResult