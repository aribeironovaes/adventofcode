#include "stdafx.h"
#include "CppUnitTest.h"

#include <fstream>
#include <iostream>
#include <ctime>
#include <cstdlib>

#include "Solution.h"

using namespace Microsoft::VisualStudio::CppUnitTestFramework;

namespace UnitTest1
{		
	TEST_CLASS(UnitTest1)
	{
	public:
		
		TEST_METHOD(TestMethod1)
		{
			//Arrange
			Solution solutioninstance;
			string polymer("dabAcCaCBAcCcaDA");
			std::list<char> input;

			for (char c : polymer)
				input.push_back(c);

			int expectedOutput = 10;

			//Act
			int realOutput = solutioninstance.reactPolymer(input);

			//Assert
			Assert::AreEqual(expectedOutput, realOutput);
		}

		TEST_METHOD(TestMethod2)
		{
			//Arrange
			Solution solutioninstance;
			string polymer("aabAAB");
			std::list<char> input;

			for (char c : polymer)
				input.push_back(c);

			int expectedOutput = 6;

			//Act
			int realOutput = solutioninstance.reactPolymer(input);

			//Assert
			Assert::AreEqual(expectedOutput, realOutput);
		}

		TEST_METHOD(TestMethod3)
		{
			//Arrange
			Solution solutioninstance;
			string polymer("aA");
			std::list<char> input;

			for (char c : polymer)
				input.push_back(c);

			int expectedOutput = 0;

			//Act
			int realOutput = solutioninstance.reactPolymer(input);

			//Assert
			Assert::AreEqual(expectedOutput, realOutput);
		}
		
		TEST_METHOD(TestMethod4)
		{
			//Arrange
			Solution solutioninstance;
			string polymer("abBA");
			std::list<char> input;

			for (char c : polymer)
				input.push_back(c);

			int expectedOutput = 0;

			//Act
			int realOutput = solutioninstance.reactPolymer(input);

			//Assert
			Assert::AreEqual(expectedOutput, realOutput);
		}



		TEST_METHOD(TestMethod5)
		{
			//Arrange
			Solution solutioninstance;
			string polymer("abAB");
			std::list<char> input;

			for (char c : polymer)
				input.push_back(c);

			int expectedOutput = 4;

			//Act
			int realOutput = solutioninstance.reactPolymer(input);

			//Assert
			Assert::AreEqual(expectedOutput, realOutput);
		}
	};
}