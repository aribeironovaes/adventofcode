// ConsoleApplication1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include "pch.h"
#include <iostream>

#include "Solution.h"


bool myfunction(LogEntry i, LogEntry j) { 
	
	time_t timei = mktime(&i.date_time);
	time_t timej = mktime(&j.date_time);


	double difftimeresult = difftime(timei, timej);


	return difftimeresult < 0;

}

int main()
{
	Solution solution_instance;
	//Parse File.
	vector<LogEntry> guardEntries = solution_instance.readFromFile("E:\\repos\\adventofcode\\2018\\Day 4 - Repose Record\\Day 4 - Repose Record\\Input.txt");

	//Sort Entries.
	sort(guardEntries.begin(), guardEntries.end(), myfunction);

	//Get a list of Guards and Minutes they were sleeping. 
	map<int, map<int, int>>  guardHistories = solution_instance.parseLogsToGuard(guardEntries);

	//Get the count of minutes sleep per guard.
	int guardSleptTheMost = solution_instance.guardWhoSleepsTheMost(guardHistories);

	//Now Identify Minute Most Slept
	int minuteMostSlept = solution_instance.minuteMostSlept(guardHistories[guardSleptTheMost]);

    std::cout << "Result part1 is: " << to_string(guardSleptTheMost*minuteMostSlept);

	tuple<int,int> guardMostAsleepIntheSameMinut = solution_instance.GuardAndMinutConsistent(guardHistories);

	int result = get<0>(guardMostAsleepIntheSameMinut) * get<1>(guardMostAsleepIntheSameMinut);
	std::cout << "Result part2 is: " << to_string(result);
}

// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file
