// ConsoleApplication1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include "pch.h"
#include <iostream>
#include "Solution.h"
#include <string>
#include <fstream>

int main()
{
	Solution solution_instance;
	//string fileName("E:\\repos\\adventofcode\\2018\\Day7 - TheSumOfItsParts\\ConsoleApplication1\\InputSample.txt");
	string fileName("E:\\repos\\adventofcode\\2018\\Day7 - TheSumOfItsParts\\ConsoleApplication1\\RealInput.txt");
	std::ifstream infile(fileName);
	std::string line;

	while (std::getline(infile, line))
	{
		string father = line.substr(5, 1);
		string child = line.substr(36, 1);

		solution_instance.addItemToMap(child[0], father[0]);
	}

	solution_instance.printInOrder();

	Solution solution_instance2;
	std::ifstream infile2(fileName);

	while (std::getline(infile2, line))
	{
		string father = line.substr(5, 1);
		string child = line.substr(36, 1);

		solution_instance2.addItemToMap(child[0], father[0]);
	}

	int totalTime = solution_instance2.executeWork(5, 60);

	std::cout << "Part2 of Problem: " << to_string(totalTime);
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
