#!/bin/bash
# Bash script of tester for project push_swap from 42 Core Curriculum, by maweiss | https://github.com/WSSMRKS
# Instructions:
	# Clone the Repo git@github.com:WSSMRKS/42_get_next_line_tester.git to your push_swap Project folder.
	# if there is a Makefile it will run the Makefile to make all and make bonus.
	# depending on your selection when starting the tester it is running the tests.
	# possible issues:
		# Mandatory part: 	Makefile not running correctly
		# Bonus:			"checker" not named as stated in subject.

echo "Welcome to the automated Tester for push_swap of 42 Core Curriculum!"
echo "To run correctly the source files of the tester need to be put in the Project folder!"
echo "The source files are: yet to be developed"
echo "Results of the tests will be stored in: logfile.txt!"
echo "Please choose the test scenario:"
echo "1: Full test + Valgrind!"
echo "2: Full test including bonus + Valgrind!"
echo "3: Full test"
echo "4: Full test including bonus!"
echo "5: Tests with 3 objects."
echo "6: Tests with 5 objects."
echo "7: Tests with 10 objects."
echo "8: Tests with 100 objects."
echo "9: Tests with 500 objects and try to push the limits."
echo "0: Options for the tests."
echo "(all tests are performed with several different Values some random some fix)"
echo "Type in your choice as a single digit!"
read line
rm logfile.txt
if [ "$line" == '1' ]
then
	echo "1: Full test + Valgrind!"
	MANDATORY=1
	VALGRIND=1
	BONUS=0
elif [ "$line" = '2' ]
then
	echo "2: Full test including bonus + Valgrind!"
	MANDATORY=1
	VALGRIND=1
	BONUS=1
elif [ "$line" = '3' ]
then
	echo "3: Full test"
	MANDATORY=1
	VALGRIND=0
	BONUS=0
elif [ "$line" = '4' ]
then
	echo "4: Full test including bonus!"
	MANDATORY=1
	VALGRIND=0
	BONUS=1
elif [ "$line" = '5' ]
then
	echo "5: Tests with 3 objects."
elif [ "$line" = '6' ]
then
	echo "6: Tests with 5 objects."
elif [ "$line" = '7' ]
then
	echo "7: Tests with 10 objects."
elif [ "$line" = '8' ]
then
	echo "8: Tests with 100 objects."
elif [ "$line" = '9' ]
then
	echo "8: Tests with 10000 objects."
elif [ "$line" = '0' ]
then
	echo "Options for the tests:"
# [ ] Add Options
#   suspend Function output
#   Save detailed report
#   test only specific Cases
#	turn Testcases on and of
#	run without makefile
else
	echo "Invalid choice! Please type in a single digit!"
fi
cd ..
make all
if [ "$BONUS" == 1 ]
then
	make bonus
fi
cd "42_push_swap_tester/"
LOGFILE="logfile.txt"
rm "logfile.txt"
S="/dev/null"
WRONG=0
if [ "$line" == "5" ] || [ "$MANDATORY" == 1 ]
then
	# File to read
	file="solve_3.txt"
	# Check if the file exists
	if [ ! -f "$file" ]; then
		echo "File '$file' not found!"
		exit 1
	fi
	MAX=0;
	# Read lines from the file
	while IFS= read -r line_file; do
		echo "Line: $line_file"
		TCASE="$line_file"
		if [ "$VALGRIND" == 1 ]
			then
				valgrind -s --show-leak-kinds=all --error-exitcode=5 --exit-on-first-error=no --leak-check=full ./../push_swap $TCASE
			fi
			output=0
			output=$(./../push_swap "$TCASE" | ./checker "$TCASE")
			echo $output
			if [ $output != "OK" ]
			then
			WRONG=1
			fi
			./../push_swap $TCASE | wc -l
			COUNT=$(./../push_swap $TCASE | wc -l)
			NCOUNT=$(expr "$COUNT" + 0)
			if [ $MAX -lt $NCOUNT ]
			then
			MAX=$NCOUNT
		fi
	done < "$file"

	if [ $MAX -le 3 -a $WRONG == 0 ]
	then
		echo -e "Result: Passed tests of 3!" | tee -a $LOGFILE
		echo -e "Your highest number was: $MAX" | tee -a $LOGFILE
	fi
fi
cd ..
make fclean
cd "42_push_swap_tester/"



