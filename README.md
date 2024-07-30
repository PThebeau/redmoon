# Server Hosting Guide

Welcome to my guide on server hosting, specifically tailored for games like Minecraft, RuneScape, and more. All the files and information provided are freely available. I hold an Associate of Science Degree in Database Technology and am two semesters away from completing my Bachelor of Science Degree in Information Technology.

## Introduction
Hey everyone, welcome to my server hosting guide. This guide is perfect for both beginners and experienced users interested in setting up servers for various games, including Minecraft and RuneScape. If you've encountered .LDF or .MDF database files, you're in the right place!

## Purpose
This guide aims to provide comprehensive instructions and insights for setting up and managing game servers. Whether you're looking to host your own game or just curious about the process, this guide will walk you through everything you need to know.

## Background
All the files and instructions provided here are created and tested by me. My journey in tech has been largely self-taught over 14 years, starting with hosting servers during high school. Since 2010, I've been hosting a game called Redmoon Fantasy, an MMORPG similar to Old School RuneScape and Diablo 2. The game has two versions: 3.8 (up to level 1000) and 4.5 (up to level 5000). I prefer version 3.8 due to its stability and fewer bugs compared to version 4.5.

## What You Will Need
### PHP
- Latest version (I'm using PHP 8.2.12)

### ODBC
- Required to connect the database to the PHP scripts

### XAMPP
- For hosting PHP files locally

### Dynamic-Hidden-IP-DNS Service
- To manage your domain and IP

## Server and Website Hosting
I host my PHP files locally on a spare tower PC to save costs, while my main homepage is hosted in the cloud for domain and security reasons. Despite some skepticism about local hosting, it costs me only around $15 a year for a Dynamic-Hidden-IP-DNS service and my domain. My server has had less downtime compared to some cloud services.

## File Structure and Setup
The files provided here are live and connected to my database, with sensitive information like usernames and passwords redacted. The key configuration file, `mssqlconfig.php`, handles the database connection setup.

### Key Scripts
- **AddAccount.php**: Allows new players to create an in-game account.
- **DELETElogin.php, DELETEpage.php, REBIRTHlogout.php**: Manage the login, permissions, and logout processes for the game.
- **InjectionBLOCK.php**: Prevents SQL injection attacks by monitoring and blocking unauthorized queries.
- **Online.php**: Displays the number of players currently online, with data refreshing every 10 seconds.
- **Shop.php**: An integrated online shop using PayPal's API, automating the purchase process and delivering items to players in-game.
- **UpdateLogFilesMonthly.php**: Automates the monthly update of log files, saving manual effort.

Additionally, there are numerous stored procedures, triggers, and tables available for those interested.

## My Daily Tasks
- **Front-End Development**: HTML, CSS
- **Back-End Development**: Python, PHP
- **Database Management**: MSSQL Server 2019
- **DevOps and Deployment**: Automating deployment processes
- **Data Analytics and Visualization**: Power BI, Tableau
- **Agile Methodologies**: Implementing Agile practices
- **Reporting and Insights**: Creating reports and providing data-driven insights

## Contact and Feedback
If you're interested in exploring more or trying out my game, please visit the [Redmoon Fantasy website](https://redmoon-fantasy.com) and download the necessary files. I'm open to feedback and happy to share more resources.
