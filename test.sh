#!/bin/bash
# Bash script of tester for project push_swap from 42 Core Curriculum, by maweiss | https://github.com/WSSMRKS
# Instructions:
	# Clone the Repo git@github.com:WSSMRKS/42_get_next_line_tester.git to your push_swap Project folder.
	# if there is a Makefile it will run the Makefile to make all and make bonus.
	# depending on your selection when starting the tester it is running the tests.
	# possible issues:
		# Mandatory part: 	Makefile not running correctly
		# Bonus:			"checker" not named as stated in subject.

# Display Options
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
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
echo "9: Tests with 1 to 500 random values including corner cases."
echo "0: Options for the tests."
echo "(all tests are performed with several different Values some random some fix)"
echo "Type in your choice as a single digit!"
# Read Input
read line
# Clear logfile
rm logfile.txt
# state and verify chosen input
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
	VALGRIND=1
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
	echo "9: Tests with 1 to 500 random values including corner cases."
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
SILENT="/dev/null" #silencing output
# Make project from Makefile
(cd ../ && make) &> $SILENT
if [ "$BONUS" == 1 ]
then
	(cd ../ && make bonus) &> $SILENT
	(cp "../checker" "42_push_swap_tester/") &> $SILENT
fi
(cd ../ && make clean) &> $SILENT
(cp "../push_swap" "./") &> $SILENT
# set variables
LOGFILE="logfile.txt"
rm "logfile.txt" &> $SILENT
THREE=0
MAX_3=
FIVE=0
MAX_5=
TEN=0
MAX_10=0
HUNDRED=0
MAX_100=0
BIG=0
MAX_BIG=0
# Tests with 3 objects
if [ "$line" == "5" ] || [ "$MANDATORY" == 1 ]
then
	# File to read
	file="$parent_path/solve_1-3.txt"
	# Check if the file exists
	if [ ! -f "$file" ]; then
		echo "File '$file' not found!"
		exit 1
	fi
	MAX=0
	WRONG=0
	# Read lines from the file
	while IFS= read -r line_file; do
		echo "Line: $line_file"
		TCASE="$line_file"
		if [ "$VALGRIND" == 1 ]
			then
				valgrind -s --show-leak-kinds=all --error-exitcode=5 --exit-on-first-error=no --leak-check=full ./push_swap $TCASE &>> $LOGFILE
			fi
			if [ $? == 5 ]
			then
			WRONG=1
			echo "valgrind -s --show-leak-kinds=all --error-exitcode=5 --exit-on-first-error=no --leak-check=full ./push_swap $TCASE"
			echo "Valgrind error!!"
			fi
			output=0
			output=$(./push_swap "$TCASE" | ./checker_linux "$TCASE")
			echo $output
			if [ "$output" != "OK" ]
			then
			WRONG=1
			echo "Output mismatch!!"
			echo "./push_swap $TCASE"
			fi
			./push_swap $TCASE | wc -l
			COUNT=$(./push_swap $TCASE | wc -l)
			NCOUNT=$(expr "$COUNT" + 0)
			if [ $MAX -lt $NCOUNT ]
			then
			MAX=$NCOUNT
		fi
	done < "$file"

	if [ $MAX -le 3 -a $WRONG == 0 ]
	then
		THREE=1
		MAX_3=$(expr "$MAX" + 0)
	fi
fi

# # Tests with 5 objects
# if [ "$line" == "6" ] || [ "$MANDATORY" == 1 ]
# then
# 	# File to read
# 	file="solve_5.txt"
# 	# Check if the file exists
# 	if [ ! -f "$file" ]; then
# 		echo "File '$file' not found!"
# 		exit 1
# 	fi
# 	MAX=0
# 	WRONG=0
# 	# Read lines from the file
# 	while IFS= read -r line_file; do
# 		echo "Line: $line_file"
# 		TCASE="$line_file"
# 		if [ "$VALGRIND" == 1 ]
# 			then
# 				valgrind -s --show-leak-kinds=all --error-exitcode=5 --exit-on-first-error=no --leak-check=full ./push_swap $TCASE | tee -a $LOGFILE
# 				# [ ] use return value for output
# 			fi
# 			output=0
# 			output=$(./push_swap "$TCASE" | ./checker_linux "$TCASE")
# 			echo $output
# 			if [ "$output" != "OK" ]
# 			then
# 			WRONG=1
# 			fi
# 			./push_swap $TCASE | wc -l
# 			COUNT=$(./push_swap $TCASE | wc -l)
# 			NCOUNT=$(expr "$COUNT" + 0)
# 			if [ $MAX -lt $NCOUNT ]
# 			then
# 			MAX=$NCOUNT
# 		fi
# 	done < "$file"

# 	if [ $MAX -le 3 -a $WRONG == 0 ]
# 	then
# 		FIVE=1
# 		MAX_5=$(expr "$MAX" + 0)
# 	fi
# fi

# # Tests with 10 objects
# if [ "$line" == "7" ] || [ "$MANDATORY" == 1 ]
# then
# 	# File to read
# 	file="solve_10.txt"
# 	# Check if the file exists
# 	if [ ! -f "$file" ]; then
# 		echo "File '$file' not found!"
# 		exit 1
# 	fi
# 	MAX=0
# 	WRONG=0
# 	# Read lines from the file
# 	while IFS= read -r line_file; do
# 		echo "Line: $line_file"
# 		TCASE="$line_file"
# 		if [ "$VALGRIND" == 1 ]
# 			then
# 				valgrind -s --show-leak-kinds=all --error-exitcode=5 --exit-on-first-error=no --leak-check=full ./push_swap $TCASE | tee -a $LOGFILE
# 				# [ ] use return value for output
# 			fi
# 			output=0
# 			output=$(./push_swap "$TCASE" | ./checker_linux "$TCASE")
# 			echo $output
# 			if [ "$output" != "OK" ]
# 			then
# 			WRONG=1
# 			fi
# 			./push_swap $TCASE | wc -l
# 			COUNT=$(./push_swap $TCASE | wc -l)
# 			NCOUNT=$(expr "$COUNT" + 0)
# 			if [ $MAX -lt $NCOUNT ]
# 			then
# 			MAX=$NCOUNT
# 		fi
# 	done < "$file"

# 	if [ $MAX -le 3 -a $WRONG == 0 ]
# 	then
# 		TEN=1
# 		$MAX_10=$(expr "$MAX" + 0)
# 	fi
# fi

# Tests with 100 objects
# if [ "$line" == "8" ] || [ "$MANDATORY" == 1 ]
# then
# 	# File to read
# 	file="solve_100.txt"
# 	# Check if the file exists
# 	if [ ! -f "$file" ]; then
# 		echo "File '$file' not found!"
# 		exit 1
# 	fi
# 	MAX=0
# 	WRONG=0
# 	# Read lines from the file
# 	while IFS= read -r line_file; do
# 		echo "Line: $line_file"
# 		TCASE="$line_file"
# 		if [ "$VALGRIND" == 1 ]
# 			then
# 				valgrind -s --show-leak-kinds=all --error-exitcode=5 --exit-on-first-error=no --leak-check=full ./push_swap $TCASE | tee -a $LOGFILE
# 				# [ ] use return value for output
# 			fi
# 			output=0
# 			output=$(./push_swap "$TCASE" | ./checker_linux "$TCASE")
# 			echo $output
# 			if [ "$output" != "OK" ]
# 			then
# 			WRONG=1
# 			fi
# 			./push_swap $TCASE | wc -l
# 			COUNT=$(./push_swap $TCASE | wc -l)
# 			NCOUNT=$(expr "$COUNT" + 0)
# 			if [ $MAX -lt $NCOUNT ]
# 			then
# 			MAX=$NCOUNT
# 		fi
# 	done < "$file"

# 	if [ $MAX -le 3 -a $WRONG == 0 ]
# 	then
# 		HUNDRED=1
# 		$MAX_100=$(expr "$MAX" + 0)
# 	fi
# fi

# # Tests with big objects
# if [ "$line" == "9" ] || [ "$MANDATORY" == 1 ]; then
# 	# File to read
# 	file="solve_big.txt"
# 	# Check if the file exists
# 	if [ ! -f "$file" ]; then
# 		echo "File '$file' not found!"
# 		exit 1
# 	fi
# 	MAX=0
# 	WRONG=0
# 	LINE_COUNT=0
# 	# Read lines from the file
# 	while IFS= read -r line_file; do
# 		echo "Line: $line_file"
# 		TCASE="$line_file"
# 		LINE_COUNT=$((LINE_COUNT + 1))
# 		if [ "$VALGRIND" == 1 ]; then
# 			valgrind -s --show-leak-kinds=all --error-exitcode=5 --exit-on-first-error=no --leak-check=full ./push_swap "$TCASE"
# 			# [ ] use return value for output
# 		fi
# 		output=0
# 		output=$(./push_swap "$TCASE" | ./checker_linux "$TCASE")
# 		echo "$output"
# 		if [ "$output" != "OK" ] && [ "$LINE_COUNT" -le 9 ]; then
# 			WRONG=1
# 		fi
# 		if [ "$output" != "ERROR" ] && [ "$LINE_COUNT" -ge 10 ]; then
# 			WRONG=1
# 		fi
# 		./push_swap "$TCASE" | wc -l
# 		COUNT=$(./push_swap "$TCASE" | wc -l)
# 		NCOUNT=$((COUNT + 0))
# 		if [ "$MAX" -lt "$NCOUNT" ]; then
# 			MAX="$NCOUNT"
# 		fi
# 		echo "$LINE_COUNT"
# 	done < "$file"
# 	if [ "$MAX" -le 3 ] && [ "$WRONG" == 0 ]; then
# 		BIG=1
# 		MAX_BIG=$((MAX + 0))
# 	fi
# fi

#Output results:

if [ "$THREE" -eq 1 ]; then
echo "Test of 3 PASSED!"
echo "Maximum number of moves: $MAX_3 "
else
echo "Test of 3 FAIL!"
fi
if [ $FIVE -eq 1 ]; then
echo "Test of 5 PASSED!"
echo "Maximum number of moves: $MAX_5 "
else
echo "Test of 5 FAIL!"
fi
if [ $TEN -eq 1 ]; then
echo "Test of 10 PASSED!"
echo "Maximum number of moves: $MAX_10 "
else
echo "Test of 10 FAIL!"
fi
if [ $HUNDRED -eq 1 ]; then
echo "Test of 100 PASSED!"
echo "Maximum number of moves: $MAX_100 "
else
echo "Test of 100 FAIL!"
fi
if [ $BIG -eq 1 ]; then
echo "Test of 500 + Corner cases PASSED!"
echo "Maximum number of moves: $MAX_BIG "
else
echo "Test of 500 + Corner cases FAIL!"
fi

# Remove all the files created by make
(cd ../ && make fclean) &> $SILENT
(rm push_swap) &> $SILENT
(rm checker) &> $SILENT
