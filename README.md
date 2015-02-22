the run.analysis file:

- Checks to see if a folder for data exists, and creates that folder if it does not.
- Downloads and unzips the data file to that folder.
- reads the six text files into data tables
- merges the data into a single data table
- renames the variables in the table
- extracts only those variables containing mean or std data, as well as the subject and activity columns.
- Expands on some abbreviated variable names to make them clearer.
- Aggregates the data in the table, finding means for variables grouped by subject and activity
- Writes out a text file with the tidy data.