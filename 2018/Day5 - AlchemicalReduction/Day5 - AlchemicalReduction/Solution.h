#pragma once

#include <string>
#include <list>

using namespace std; 

class Solution {
public: 
	int reactPolymer(list<char>& polymer) {

		if (polymer.size() == 0) {
			return 0;
		}
		else if (polymer.size() == 1) {
			return 1;
		}

		int firstCharacter = 0;
		int secondCharacter = 1;

		while (secondCharacter < polymer.size())
		{
			std::list<char>::iterator it1 = polymer.begin();
			std::advance(it1, firstCharacter);

			std::list<char>::iterator it2 = polymer.begin();
			std::advance(it2, secondCharacter);

			if (*it1 != *it2 && tolower(*it1) == tolower(*it2)) {
				polymer.erase(it1);
				polymer.erase(it2);
				if (firstCharacter > 0) {
					firstCharacter--;
				}
				secondCharacter = firstCharacter + 1;
			}
			else {
				firstCharacter++;
				secondCharacter++;
			}
		}

		return polymer.size();
	}
};