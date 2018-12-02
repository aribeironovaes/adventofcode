#pragma once

#include <vector>
#include <map>

using namespace std; 

class Solution {
public: 
	string findCommonStringOnRightBox(vector<string>& boxIds) {
		string returnString = "";

		for (int i = 0; i < boxIds.size(); i++)
		{
			for (int  j = i+1; j < boxIds.size(); j++)
			{
				int numberOfDifferentLetters = 0;
				int lastDifferentIndex = 0;
				for (int k = 0; k < boxIds[i].size(); k++)
				{
					if (boxIds[i][k] != boxIds[j][k]) {
						numberOfDifferentLetters++;
						lastDifferentIndex = k;
					}
				}

				if (numberOfDifferentLetters == 1) {
					returnString += boxIds[i].substr(0, lastDifferentIndex);
					returnString += boxIds[i].substr(lastDifferentIndex+1, boxIds[i].size() -1);
					return returnString;
				}
			}
		}

		return returnString; 
	}
};
