#pragma once

#include <vector>
#include <fstream>
#include <sstream>
#include <stdio.h>
#include <regex>
#include <time.h>
#include <ctime>
#include <iomanip>
#include <map>
#include <tuple>
#include <iostream>

using namespace std; 

struct LogEntry {
	tm date_time;
	string text;
};

class Solution {
public:
	vector<LogEntry> readFromFile(string fileName) {
		vector<LogEntry> returnVector;
		std::ifstream infile(fileName);

		//Read file here. 
		std::string line;
		while (std::getline(infile, line))
		{
			LogEntry currentGuardEntry;

			string time_string = line.substr(1,16);

			/* get current timeinfo and modify it to the user's choice */
			time_t rawtime;
			time(&rawtime);

			struct std::tm tm = { 0 };

			localtime_s(&tm, &rawtime);

			std::istringstream ss(time_string);
			ss >> std::get_time(&tm, "%Y-%m-%d %H:%M"); // or just %T in this case

			tm.tm_year = 118; //Since sample has all the same year. 

			currentGuardEntry.date_time = tm;
			currentGuardEntry.text = line.substr(19);
			
			returnVector.push_back(currentGuardEntry);
		}
		
		return returnVector;
	}

	//map<int, map<int,int>> --> First int is Guard Id, and other is a map of Minutes Sleeping and quantity times that it was sleeping.
	map<int, map<int,int>> parseLogsToGuard(vector<LogEntry>& entries) {
		map<int, map<int, int>>valueToReturn;
		std::string guardToken("Guard");
		std::string idToken("#");
		std::string fallsToken("falls");
		std::string wakesToken("wakes");

		int currentGuardID = -1;
		int currentSleepMinute = -1;

		for (size_t i = 0; i < entries.size(); i++)
		{
			//Check if it's Guards shift entry.
			std::size_t found = entries[i].text.find(guardToken);
			if (found != std::string::npos) {
				found = entries[i].text.find(idToken, found+1);
				size_t StartId = found + 1;
				found = entries[i].text.find(" ", StartId);
				currentGuardID = atoi(entries[i].text.substr(StartId, found).c_str());
			}				

			//Check if it's Fall Sleep Entry. 
			found = entries[i].text.find(fallsToken);
			if (found != std::string::npos) {
				currentSleepMinute = entries[i].date_time.tm_min;
			}

			//Check if it's awake entry. 
			found = entries[i].text.find(wakesToken);
			if (found != std::string::npos) {
				int timeAwake = entries[i].date_time.tm_min;

				//At this moment, add an Entry on the Guard History
				for (size_t i = currentSleepMinute; i < timeAwake; i++)
				{
					valueToReturn[currentGuardID][i]++;
				}				
			}
		}

		return valueToReturn;
	}

	int guardWhoSleepsTheMost(map<int, map<int, int>>& guardsLogs) {
		int returnValue = -1; 

		int guardID = -1;
		int MinutesMostSlept = 0;

		for (auto guard :guardsLogs)
		{
			int currentMinutes = 0;
			for (auto minutes : guard.second) {
				currentMinutes += minutes.second;
			}	

			if (MinutesMostSlept < currentMinutes) {
				guardID = guard.first;
				MinutesMostSlept = currentMinutes;
			}
		}
		return guardID;
	}

	int minuteMostSlept(map<int, int>& minutesSlept) {
		int minuteIdentified = -1;
		int maximumMinuteSlept = -1;


		for (auto minute : minutesSlept)
		{
			if (minute.second > maximumMinuteSlept) {
				maximumMinuteSlept = minute.second;
				minuteIdentified = minute.first;
			}
		}

		return minuteIdentified;
	}

	tuple<int, int> GuardAndMinutConsistent(map<int, map<int, int>>& guardsLogs) {
		tuple<int, int> returnValue(0, 0);

		int guardID = -1;
		int MinutesMostSlept = 0;

		for (auto guard : guardsLogs)
		{
			for (auto minute : guard.second)
			{
				if (MinutesMostSlept < minute.second) {
					MinutesMostSlept = minute.second;
					get<0>(returnValue) = guard.first;
					get<1>(returnValue) = minute.first;
				}
			}

		}
		return returnValue;
	}

};
