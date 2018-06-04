

/* 1. Find available routes from the Waco area to the Tampa area. Display the Waco Airline, Waco Airport Name, Dallas Airline, 
and Dallas Airport Name HINT1: All routes out of "Waco" must go through a "Dallas" airport first. 
	HINT2: Consider including subqueries in the query       
    HINT3: Consider including a self-join in the query                                   */

SELECT R.Airline,R.AirlineID,AR.Name,R.SourceAirportID,A.name,R.DestinationAirportID,A2.Name
  FROM Routes R , Airports A, Airports A2, Airlines AR
  where SourceAirportID in(3476,3700,3502,3670,6948,7935,8188)
  and DestinationAirportID in (3502,3670,6948,7935,8188,3646,3789,8339,8447)
  and R.SourceAirportID=A.AirportID
  and R.DestinationAirportID=A2.AirportID
  and R.AirlineID=AR.AirlineID

--------------------------------------------------
/* 2. Find airports in the country of Zambia that do not have any recorded routes. 
Show results in order of the airport's city.                                         */

Select * from Airports A where  NOT EXISTS 
(select * from Routes R where R.SourceAirportID=AirportID or R.DestinationAirportID=AirportID)
 and  A.Country like '%zambia%' order by A.City asc

--------------------------------------------------
/* 3. Show the number of different airlines and number of routes using E75 equipment */

select airline,airlineid,count(*) As NumberOfdifferentAirlinesAndRoutes 
from Routes  
where Equipment = 'E75'  group by Airline,AirlineID order by Airline

------------------------------------------------------
/* 4. Show the name, city and number of routes of the 3 busiest airports 
(i.e., airports with the most number of flights departing from that airport. Account for ties.       */

SELECT top (3) with ties A.Name,A.City,count(SourceAirportID) AS NumOfRoutes
	  
  FROM Routes R , Airports A
  where A.AirportID=R.SourceAirportID
 group by SourceAirportID,A.Name,A.City  order by NumOfRoutes desc

-------------------------------------------------------
/* 5. Show Timezones (i.e., TZ's) that have more than 100 airports.
 Display TZ's with the largest number of airports first.                              */ 

select TZ,count(TZ) As [TZ>100] FROM Airports 
 group by TZ 
 having  count(TZ)>100
 order by [TZ>100] desc

------------------------------------------------------
/* 6. Write a query to find the ONE closest airport to a location of interest to you.   
Your query should display meaningful information about the closest airport. 
Before writing your query, find the GPS coordinates (latitude/longitude) of a specific location of interest to you (you can google this). 
Then in your query, the following calculation can be used in an Order By to determine the distance in km between a  location of interest 
and the latitude/longitude of an airport: 
 
 111.045 * DEGREES(ACOS(COS(RADIANS(@latitude)) * COS(RADIANS(latitude))  * COS(RADIANS(longitude) - RADIANS(@longitude)) 
   + SIN(RADIANS(@latitude)) * SIN(RADIANS(latitude)))) 
 
Replace ONLY the 3 variables in the above calculation with the longitude & latitude values of your location of interest; 
leave all else the same.  Variables begin with an @ symbol. There should be no @ symbols left in the query once you supply your coordinates. 
 
ALSO, inside of comments, tell me what location is represented by the coordinates you included in the query. 

**Location of interest** = MIAMI, FLORIDA      25.7617° N, 80.1918° W                                                   */

SELECT top 1 [AirportID]
      ,[Name]
      ,[City]
      ,[Country]
      ,[Latitude]
      ,[Longitude]
	  ,  111.045 * DEGREES(ACOS(COS(RADIANS(latpoint)) * COS(RADIANS(latitude))
* COS(RADIANS(longitude) - RADIANS(longpoint))
+ SIN(RADIANS(latpoint)) * SIN(RADIANS(latitude))))  DistInKM
  FROM [FlightsDB].[dbo].[Airports]

JOIN (
     SELECT  25.7617  AS latpoint,  -80.1918 AS longpoint
   ) AS p ON 1=1
 ORDER BY DistInKM

----------------------------------------------------------------
