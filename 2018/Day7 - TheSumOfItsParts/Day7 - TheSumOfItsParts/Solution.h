#pragma once

#include <vector>
#include <map>
#include <iostream>
#include <algorithm>
#include <set>

using namespace std;

struct Workers {
	char Item;
	int Time;

	Workers() : Item('.'), Time(0) {}; //Default Worker


	bool operator<(const Workers& rhs) const
	{
		if (Item < rhs.Item)
		{
			return true;
		}
		else if (Item == rhs.Item)
		{
			if (Time < rhs.Time)
			{
				return true;
			}
		}

		return false;
	}

	inline bool operator==(const Workers& rhs)
	{
		return Item == rhs.Item &&
			Time == rhs.Time;
	}
};

class Solution {
	vector<char> activeItems;

	map<char, set<char>> items;
public:
	void addItemToMap(char item, char father) {
		items[item].insert(father);

		if (items.find(father) == items.end()) {
			// not found
			set<char> emptyset;
			items[father] = emptyset;
		}
	};

	void printInOrder() {
		//First itendify from items who doesn't have a father. 
		//Then add this to the active list. 

		//Repeat this till items is empty. This is the order. 
		while (!items.empty() || !activeItems.empty()) {
			map<char, set<char>>::iterator it;
			char currentActiveItem;
			for (it = items.begin(); it != items.end(); ++it)
			{
				if (it->second.empty()) {
					if (find(activeItems.begin(), activeItems.end(), it->first) == activeItems.end()) {
						activeItems.push_back(currentActiveItem = it->first);
					}					
				}
			}
			

			//Sort the Active List by Alfabhetical Order of the map Char. 
			sort(activeItems.begin(), activeItems.end());
			//print the first item and remove this item from the list of fathres on all items.

			if (!activeItems.empty()) {
				cout << activeItems[0];
				for (it = items.begin(); it != items.end(); ++it)
				{
					it->second.erase(activeItems[0]);
				}
				it = items.find(activeItems[0]);
				items.erase(it);
				activeItems.erase(activeItems.begin());
			}
		}
		cout << endl;
	}

	int executeWork(int numberOfElves, int basetime) {
		//First itendify from items who doesn't have a father. 
		//Then add this to the active list. 
		int totalTime = 0;
		vector<Workers> activeWorkingElves;

		//Repeat this till items is empty. This is the order. 
		while (!items.empty() || !activeItems.empty()) {
			map<char, set<char>>::iterator it;
			char currentActiveItem;
			for (it = items.begin(); it != items.end(); ++it)
			{
				if (it->second.empty()) {
					if (find(activeItems.begin(), activeItems.end(), it->first) == activeItems.end()) {
						activeItems.push_back(currentActiveItem = it->first);
					}
				}
			}

			//Sort the Active List by Alfabhetical Order of the map Char. 
			sort(activeItems.begin(), activeItems.end());

			//Create Workers for the current active Items. 
			for (int i = 0; i < activeItems.size(); i++)
			{
				if (activeWorkingElves.size() == numberOfElves) {
					break;
				}
				
				bool alreadyAdded = false;
				//Find next Active item that it not on activeWorking Elves
				for (auto elf : activeWorkingElves)
				{
					if (elf.Item == activeItems[i]) {
						//Item already added. 
						alreadyAdded = true;
						break;
					}
				}

				if (alreadyAdded) {
					continue;
				}
				//Otherwise, add item to active Working Elves. 
				Workers currentElf;
				currentElf.Item = activeItems[i];
				currentElf.Time = basetime + activeItems[i] - 'A' + 1;
				activeWorkingElves.push_back(currentElf);
			}

			//At this point we have to start working. 
			bool elfDone = false; 
			while (!elfDone) {

				for (Workers& elf: activeWorkingElves)
				{
					//decrement each elf by 1. 
					elf.Time--;
					if (elf.Time == 0) {
						elfDone = true;
					}
				}

				//Increment Total Time by 1. 
				totalTime++;
			}			

			//Now that we have Elf Done, time to readjust all the tasks done. 
			//First remove the task from ativeItems List.
			//Than remove the task from items chidl. 


			//At this point I must have Tasks and Workers Working. So, start assigning and couting this the 1st worker is free. 

			vector<Workers> elfToClean; 
			for (Workers& elf : activeWorkingElves) {
				if (elf.Time == 0) {
					//Erase Item from Items Children
					for (it = items.begin(); it != items.end(); ++it)
					{
						it->second.erase(elf.Item);
					}

					//Now have to remove the item itself.
					it = items.find(elf.Item);
					items.erase(it);

					auto it2 = find(activeItems.begin(), activeItems.end(), elf.Item);
					activeItems.erase(it2);
					elfToClean.push_back(elf);
				}
			}

			for (size_t i = 0; i < elfToClean.size(); i++)
			{
				vector<Workers>::iterator iterateElf = find(activeWorkingElves.begin(), activeWorkingElves.end(), elfToClean[i]);
				activeWorkingElves.erase(iterateElf);
			}			
		}

		return totalTime;
	}

};
