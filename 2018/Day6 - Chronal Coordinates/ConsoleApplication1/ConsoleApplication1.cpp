// ConsoleApplication1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include "pch.h"
#include <iostream>
#include "Solution.h"
#include <string>
#include <fstream>

//#DEFINE _CRT_SECURE_NO_WARNINGS;

int main()
{
	//vector<Point> input = { {'A',1, 1}, {'B', 1, 6}, {'C', 8, 3}, {'D', 3, 4}, {'E', 5, 5}, {'F', 8, 9} };

	vector<Point> input;

	//Read input and create list. 
	string fileName("E:\\repos\\adventofcode\\2018\\Day6 - Chronal Coordinates\\ConsoleApplication1\\Input.txt");

	std::ifstream infile(fileName);
	std::string line;

	int currentID = 1;

	while (std::getline(infile, line))
	{
	
		std::size_t pos = line.find(",");      // position of "live" in str

		std::string x = line.substr(0, pos);     // "x"
		std::string y = line.substr(pos + 1);     // "y"

		Point currentPoint(currentID++, stoi(x), stoi(y));
		input.push_back(currentPoint);
	}


	Solution solution_instance;
	solution_instance.buildMatrix(input);
	//solution_instance.printMatrix();
	int biggerLimitedIslandAccount = solution_instance.paintMatrixReturnBiggerLimitedIslandCount();
	int sizeOfSafeRegion = solution_instance.calculateSafeRegion(10000);
	//solution_instance.printMatrix();

    std::cout << "Part1 Result is: " << to_string(biggerLimitedIslandAccount) << endl; 
	std::cout << "Part2 Result is: " << to_string(sizeOfSafeRegion);
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
