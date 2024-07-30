Server Hosting Guide
Welcome to my guide on server hosting, specifically tailored for games like Minecraft, RuneScape, and more. All the files and information provided are freely available. I hold an Associate of Science Degree in Database Technology and am two semesters away from completing my Bachelor of Science Degree in Information Technology.

Purpose
This guide is designed for anyone interested in server hosting, whether you're new or experienced. If you've encountered .LDF or .MDF database files, this is the right place for you.

Background
All the files here are created by me. My journey in tech has been mostly self-taught over 14 years, starting with hosting servers since high school. I've been hosting a game called Redmoon Fantasy, an MMORPG reminiscent of Old School RuneScape and Diablo 2, since 2010. Redmoon has two versions: 3.8 (up to level 1000) and 4.5 (up to level 5000). I prefer hosting version 3.8 due to fewer bugs and issues compared to 4.5, which has many hardcoded, unfixable errors.

Redmoon Online was initially released in 1999 but was discontinued a few years later. I was fortunate to obtain the server files, although the original company never released the source code. This has led to a focus on reverse engineering and mastering database administration to creatively navigate challenges.

Server and Website Hosting
I host my PHP files locally on a spare tower PC to save costs, while my main homepage is hosted in the cloud for domain and security reasons. Despite some skepticism about local hosting, it costs me only around $15 a year for a Dynamic-Hidden-IP-DNS service and my domain. My server has had less downtime compared to some cloud services.

File Structure and Setup
The files available here are live and connected to my database, with sensitive information like usernames and passwords redacted. I use XAMPP to host my PHP files, and the mssqlconfig.php file handles the database connection. An ODBC is required to connect the database to the website files, specifically the PHP scripts.

Key Scripts
AddAccount.php: Allows new players to create an in-game account.
DELETElogin.php, DELETEpage.php, REBIRTHlogout.php: Manage the login, permissions, and logout processes for the game.
InjectionBLOCK.php: A crucial security script that prevents SQL injection attacks by monitoring and blocking unauthorized queries.
Online.php: Displays the number of players currently online, with data refreshing every 10 seconds.
Shop.php: An integrated online shop using PayPal's API, automating the purchase process and delivering items to players in-game.
UpdateLogFilesMonthly.php: Automates the monthly update of log files, saving manual effort.
Additionally, there are numerous stored procedures, triggers, and tables available for those interested.

My Daily Tasks
Front-End Development: HTML, CSS
Back-End Development: Python, PHP
Database Management: MSSQL Server 2019
DevOps and Deployment: Automate deployment processes
Data Analytics and Visualization: Power BI, Tableau
Agile Methodologies: Implementing Agile practices
Reporting and Insights: Create reports and provide data-driven insights
If you're interested in exploring more or trying out my game, please visit the Redmoon Fantasy website and download the necessary files. I'm open to feedback and happy to share more resources.
