#pragma once

#include <vector>
#include <map>

using namespace std;

class Solution {
public:
	int getCheckSum(vector<string>& boxIds) {
		int count2 = 0;
		int count3 = 0;
		for (auto id : boxIds)
		{
			map<char, int> countOfCharacter;
			//First Count Character.
			for (auto character : id)
			{
				countOfCharacter[character]++;
			}
			bool found2 = false;
			bool found3 = false;
			//Now check if have 2 or 3. 
			for (const auto& each_pair : countOfCharacter)
			{
				if (!found2 && each_pair.second == 2) {
					found2 = true;
					count2++;
				}

				if (!found3 && each_pair.second == 3) {
					found3 = true;
					count3++;
				}
				if (found2 == true && found3 == true) {
					break;
				}
			}

		}

		return count2 * count3;
	}
};
