# Sedna
Covid contact tracing app

•	Retrieve a list of people who should be warned that they were in contact with a person who tested positive. 

Explanation: 
The goal of this project is to maintain a list of people who should be warned that they might have come in contact with a covid positive person.

Approach:
•	I joined Positives table with Attendance table on User to get the location details for all the users that were tested posited (this is a one to many relationship).
•	Using the positive_date column I filtered the dataset such that we only get the locations and the attendance_users who might have come in contact with the covid patient in the last 7 days from the time he/she was tested positive
    o	This was done by using the following logic:
        	where date(presence_date) >= positive_date - 7 and date(presence_date) <= positive_date
•	Now I have the dates and the past 7 days location history of the covid patient. Using this information I joined the dataset back to the attendance table to get the location details and the user id’s for all the people who came in contact with a covid positive patient in the last 7 days.
    o	The join was performed on location and date
•	As a last step I compared the timestamps of when a covid positive patient was near someone from the Attendance table. If the difference is less than 0.5 hours at the same location I tagged them as ‘Alert’, these people should be alerted at the very least.
•	Created a table alert_list in the schema u_0972430 and populated it with the above query – This is the list of all the users that came in contact with a covid positive patient at the same location within 30 minutes 

DB Connection:
	Host details: data-interview-db.ce7oyzeskgrt.eu-west-1.rds.amazonaws.com
	Port: 5432
	
	Source Datasets: Positives and Attendance are in public schema
	
Materialized Table: alert_list is in the schema - u_0972430


Visualization:
	I created a Tableau visualization using the newly materialized table alert_list 
•	The top 10 covid hotspots gives us information such as what locations had the largest number of people tested positive, if these locations are closed we might be able to slow the spread of the virus
•	The second visualization tracks a list of all the events for up to 7 days before a person tested positive for covid. You can input a User ID and this gives the information for that person and his/her location history with dates.

Link to the Tableau visualization: https://public.tableau.com/views/CovidHotspots/CovidContactTracing?:language=en&:display_count=y&publish=yes&:origin=viz_share_link


