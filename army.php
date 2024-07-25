<center><form>
<input type="button" value="MainWebsite" onclick="window.location.href='https://redmoon-fantasy.com'" />
</form></center>

<center><form>
<input type="button" value="Online" onclick="window.location.href='http://redmoonfantasy.ddns.net:3400/redmoon/online.php/'" />
</form></center>

<html>
<head>
<title>Redmoon</title>
 
<style>
body {
    background-image: url("img/redmoon1.png");
    background-repeat: no-repeat;
    height: 100%;
    width: 100%;
    background-size: 100%;
    background-attachment: scroll;

 }
 
</style>
 
</head>
 
<body>
 
</body>
</html>

<?
include("mssqlconfig.php");
print('<html>');
print('<head><title>');
print('Viewing Redmoon Fantasy Army</title>');
print('<link rel="stylesheet" href="dns.css">');
print('</head>');
print('<body>');
print("<center>");
print("<table border='10'>");
print("<tr>");
print("<th><b>Army Names</b></th>");
print("<th><b>Commander</b></th>");
print("<th><b>Camp</b></th>");
print("</tr>");
print("<tr>");
$names = mssql_query("select top 500 Name from tblArmyList1");
while ($row = mssql_fetch_array($names)) {


print("<td> $row[0]</td>");
print("<td> $row[1]</td>");
print("<td> $row[2]</td>");


print("</tr>");
}
print("<tr>");
print("</tr>");
print("</table>");
print("</body></html>");
?>




