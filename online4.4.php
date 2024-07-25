
<?
include("mssqlconfig.php");
print('<html>');
print('<head><title>');
print('Viewing Players Online</title>');
print('<link rel="stylesheet" href="dns.css">');
print('</head>');
print('<body>');
print("<center>");
print("<table border='2'>");
print("<tr>");
print("<th>ONLINE</th>");

print("</tr>");
print("<tr>");
$names = mssql_query("select top 500 GameID from tblOccupiedGameID1 where gameid not like 'GMFantasy' and GameID not like 'GMTest'");
while ($row = mssql_fetch_array($names)) {


print("<td> $row[0]</td>");
print("</tr>");
}
print("<tr>");
print("</tr>");
print("</table>");
print("</body></html>");
?>








