# Analysis_of_New_York_Bus_Data
Analysis of New York Bus Data in December 2017. Handling big data analysis and visualization, especially in time series analysis and Null hypothesis.

Data source: big data more than 1 GB.
https://www.kaggle.com/stoney71/new-york-city-transport-statistics/mta_1712.csv

Purpose: Finding potential questions could be answered by studying this big data, and answering the questions

1. How many bus lines in each borough of New York city?

  - There are 43, 54, 41, 37 and 31 bus lines in Bronx, Brooklyn, Manhattan, Queens and Staten Island, respectively. 

2. What is the average delay time in each borough?
Which borough has the worst bus service according to the delay time?

  -	The average delay time(minutes) in each borough can be found in the list below. 
      Bronx	4.39
      Brooklyn	4.92
      Manhattan	5.34
      Queens	4.67
      Staten Island	4.48

  -	The average delay time in Manhattan is 5.34 minutes, which is longer than other boroughs. Therefore, Manhattan provides the worst bus service based on the longest average delay time. 


3. How long will the average delay be for each bus line? 
Was each bus line running to schedule during December,2017? 
Which one has the longest delay in each borough?

  -	On average, no bus was running to schedule in these 5 boroughs.
  -	In the Bronx, Bx15 had the longest delay time of 7.99 minutes. In Brooklyn, B35 had the longest delay time of 9.83 minutes. In Manhattan, M60-SBS had the longest delay time of 11.40 minutes. In Queens, Q56 had the longest delay time of 10.05 minutes. In Staten Island, S86 had the longest delay time 12.75 minutes.


4. How many bus lines use the Select Bus Service(SBS) route? 
Do these bus lines are more punctual than bus lines that do not use the SBS route? 

  -	There are  14 bus lines use the Select Bus Service(SBS) route.
  -	No. Following table shows the average and median delay time for bus lines that use or do not use the SBS route. Both the average and median delay time indicate bus lines use the SBS route have longer delay than bus lines that do not use the SBS route.


5. What are the possible factors related to the average delay time?
  - The delay time is highly related to the recording time (local time). 
    - From Monday to Friday, the delay time had a small peak in the morning between 9:00 am to 10:00 am and a big peak in the evening between 18:00 pm to 19:00 pm. 
    - On Saturday, the delay time had only one big peak which appeared between 18:00 pm to 19:00 pm.
    - On Sunday, the delay time had only one big peak which appeared between 17:00 pm to 18:00 pm. 
    
-	Based on the correlation analysis, the delay time has a weak relationship with “The distance from the Starting point to the current location”. 




Bus lines that use the “Select Bus Service” route will have “-SBS” in their published names, For example, Q44-SBS.

“Select Bus Service(SBS) provides a complementary service to the subway system by connecting neighborhoods to subway stations and major destinations. The goal of SBS is to bring faster, more reliable and quality bus service to high ridership corridors. SBS improves speed and reliability through dedicated bus lanes, off-board fare payment, station spacing and transit signal priority (TSP).” (from MTA website)
