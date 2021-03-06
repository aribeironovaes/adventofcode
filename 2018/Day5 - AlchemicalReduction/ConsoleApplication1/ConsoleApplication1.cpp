// ConsoleApplication1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include "pch.h"
#include "Solution.h"
#include <fstream>
#include <iostream>
#include <ctime>
#include <cstdlib>
#include <limits>
#include <algorithm>

int main()
{
	cout << "Hellow World!" << endl;
	//Arrange
	Solution solutioninstance;
	string fileName("E:\\repos\\adventofcode\\2018\\Day5 - AlchemicalReduction\\Day5 - AlchemicalReduction\\Input.txt");

	std::ifstream infile(fileName);
	std::string line;
	std::list<char> input;

	int count = 1;
	while (std::getline(infile, line))
	{
		for (char c : line) {
			input.push_back(c);
		}			
	}

	int realOutput = solutioninstance.reactPolymer(input);
	cout << "Result first part is: " << to_string(realOutput) << endl;


	//Assert
	string alfabeto("ABCDEFGHIJKLMNOPKRSTUVXYWZ");
	int minSize = 50000;


	for (char c : alfabeto)
	{
		//Read File again and put to the list. 
		std::ifstream infile(fileName);
		std::string line;
		std::list<char> input;
		while (std::getline(infile, line))
		{
			for (char c : line) {
				input.push_back(c);
			}
		}
		//Remove current Character and it's corresponding lower letter. 
		input.remove(c);
		input.remove(tolower(c));

		minSize = min(minSize, solutioninstance.reactPolymer(input));
	}
	cout << "Result second part is: " << to_string(minSize) << endl;
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
