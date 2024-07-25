Server Hosting Guide:
https://redmoon-fantasy.com 

Introduction:
Welcome to my guide on server hosting, specifically for games like Minecraft, RuneScape, and more. All the files and information here are freely available. I hold an Associate of Science Degree in Database Technology and am two semesters away from completing my Bachelor of Science Degree in Information Technology.

Purpose:
This guide is for anyone interested in server hosting, whether you're new or experienced. If you've come across .LDF or .MDF database files, you're in the right place.

Background:
All the files here are created by me. My journey in tech has been mostly self-taught over 14 years, starting with hosting servers since High School. I've been hosting a game called Redmoon Fantasy, an MMORPG reminiscent of Old School Runescape and Diablo 2, since 2010. Redmoon has two versions: 3.8 (up to level 1000) and 4.5 (up to level 5000). I prefer hosting version 3.8 due to fewer bugs and issues compared to 4.5, which has many hardcoded, unfixable errors.

Redmoon Online was initially released in 1999 but was discontinued a few years later. I was fortunate to obtain the server files, although the original company never released the source code. This leaves two paths: learning reverse engineering or mastering database administration to navigate challenges creatively.

Server and Website Hosting:
I host my PHP files locally on a spare tower PC to save costs, while my main homepage is hosted in the cloud for domain and security reasons. Despite some skepticism about local hosting, it costs me only around $15 a year for a Dynamic-Hidden-IP-DNS service and my domain. My server has had less downtime compared to some Cloud services...

File Structure and Setup:
The files available here are live and connected to my database, with sensitive information like usernames and passwords redacted. I use XAMPP to host my PHP files, and the mssqlconfig.php file handles the database connection. An ODBC is required to connect the database to the website files, specifically the PHP scripts.

Key Scripts:
AddAccount.php: Allows new players to create an in-game account.
DELETElogin.php, DELETEpage.php, REBIRTHlogout.php: These scripts handle the login, permissions, and logout processes.
InjectionBLOCK.php: A crucial script to prevent SQL injection attacks by monitoring and blocking unauthorized queries.
Online.php: Displays the number of players currently online by refreshing data every 10 seconds.
Shop.php: An integrated online shop using PayPal's API. It automates purchases and delivers items to players in-game.
UpdateLogFilesMonthly.php: Automates the monthly update of log files, saving manual effort.
Additionally, I have numerous stored procedures, triggers, and tables available for those interested.

My Daily Tasks:
Front-End Development: HTML, CSS
Back-End Development: Python, PHP
Database Management: MSSQL Server 2019
DevOps and Deployment: Automate deployment processes
Data Analytics and Visualization: Power BI, Tableau
Agile Methodologies: Implementing Agile practices
Reporting and Insights: Create reports and provide data-driven insights

If you're interested in exploring more or trying out my game, please visit the website and download the necessary files. I'm open to feedback and happy to share more resources.
