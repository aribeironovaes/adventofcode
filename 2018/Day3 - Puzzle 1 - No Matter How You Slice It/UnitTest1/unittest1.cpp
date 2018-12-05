#include "stdafx.h"
#include "CppUnitTest.h"

#include "Solution.h"
#include <fstream>
#include <sstream>
#include <regex>
#include <stdio.h>

using namespace Microsoft::VisualStudio::CppUnitTestFramework;

namespace UnitTest1
{		
	TEST_CLASS(UnitTest1)
	{
	public:
		
		TEST_METHOD(TestMethod1)
		{
			//Arrange
			Solution solution_instance;
			vector<ClaimEntry> input = { {1, 1,2,10,10} };
			int expectedOutput = 0;
			//Act
			int realOutput = solution_instance.doubleBookedSquareInches(input);


			//Assert
			Assert::AreEqual(expectedOutput, realOutput);
		}

		TEST_METHOD(TestMethod2)
		{
			//Arrange
			Solution solution_instance;
			vector<ClaimEntry> input = { {1, 1,2,10,10},{2, 1,2,10,10} };
			int expectedOutput = 100;
			//Act
			int realOutput = solution_instance.doubleBookedSquareInches(input);


			//Assert
			Assert::AreEqual(expectedOutput, realOutput);
		}

		TEST_METHOD(TestMethod3)
		{
			//Arrange
			Solution solution_instance;
			vector<ClaimEntry> input = { {1, 1,2,2,2},{2, 1,2,2,2} };
			int expectedOutput = 4;
			//Act
			int realOutput = solution_instance.doubleBookedSquareInches(input);


			//Assert
			Assert::AreEqual(expectedOutput, realOutput);
		}

		TEST_METHOD(TestMethod4)
		{
			//Arrange
			Solution solution_instance;
			vector<ClaimEntry> input = { {1, 1,2,2,2},{2, 1,2,2,2}, {3, 1,2,2,2} };
			int expectedOutput = 4;
			//Act
			int realOutput = solution_instance.doubleBookedSquareInches(input);


			//Assert
			Assert::AreEqual(expectedOutput, realOutput);
		}
		
		vector<ClaimEntry> readFromFile(string fileName) {
			vector<ClaimEntry> returnVector;
			std::ifstream infile(fileName);

			//Read file here. 
			std::string line;
			while (std::getline(infile, line))
			{
				ClaimEntry currentClaim;
				std::string delimiter = ";";
				size_t currentItem = 0;
				size_t pos = 0;
				std::string token;
				while ((pos = line.find(delimiter)) != std::string::npos) {
					token = line.substr(0, pos);
					switch (currentItem)
					{
					case 0:
						currentClaim.id = stoi(token);
						currentItem++;
						break;
					case 1:
						currentClaim.leftToSquare = stoi(token);
						currentItem++;
						break;
					case 2:
						currentClaim.topToSquare = stoi(token);
						currentItem++;
						break;
					case 3:
						currentClaim.width = stoi(token);
						currentItem++;
						break;
					case 4:
						currentClaim.height = stoi(token);
						currentItem++;
						break;
					default:
						break;
					}

					line.erase(0, pos + delimiter.length());
				}
 
				//Parse content of the file here. 
				returnVector.push_back(currentClaim);

			}

			return returnVector;
		}


		TEST_METHOD(TestMethod5)
		{
			//Arrange
			Solution solution_instance;
			vector<ClaimEntry> input = readFromFile("c:\\temp\\testInput.txt");
			//Read input from a file. 

			long expectedOutput = 121163;
			//Act
			long realOutput = solution_instance.doubleBookedSquareInches(input);


			//Assert
			Assert::AreEqual(expectedOutput, realOutput);
		}
	};
}