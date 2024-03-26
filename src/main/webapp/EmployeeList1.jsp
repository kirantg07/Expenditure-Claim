
<%@ page import="java.util.Map"%>
<%@ page import="java.util.TreeMap"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page
	import="java.io.PrintWriter, java.nio.file.Files, java.nio.file.Path, java.nio.file.Paths, 
 java.nio.file.Files,
 java.nio.file.Path,
java.nio.file.Paths"%>
<%@ page import="java.io.FileReader"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.io.FileNotFoundException"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="org.json.simple.parser.ParseException"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" href="css/employeeList.css">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Employee List</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
<link rel="stylesheet" href="css/navigationBar.css">
</head>

<style>
@import
	url('https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap')
	;

/* * {
	/* font-size: 16px; */
	box-sizing: border-box;
	font-family: Poppins, Arial, Helvetica, sans-serif;
}

#table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
}

/* #table th,

*/
#table th, #table td {
	padding: 10px;
	text-align: left;
	border: 1px solid black; /* Light Gray Border */
	color: black;
}

#table th {
	background-color: #cdc1ff;
	/* color: #fff; */
}

#table tr:hover {
	background-color: #ecf0f1; /* Light Gray Hover Background */
}

/* Form input fields */
#table input[type="text"], #table input[type="date"], #table textarea,
	#table select, #table input[type="file"] {
	width: 100%;
	padding: 10px;
	box-sizing: border-box;
	border: 1px solid #bdc3c7; /* Light Gray Border */
	border-radius: 5px;
}

#table textarea {
	resize: vertical;
}

div#bContainer {
	float: right;
	margin-top: 10px;
	/*  background-color: #3498db; */
}

.dateValidationContainer {
	margin-top: 10px
}

#ECHeader, #EC {
	text-align: right !important;
}

.button {
	padding: 7px 20px;
	background-color: #cdc1ff;
	color: black;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	transition: background-color 0.3s ease;
	margin-left: 20px;
	font-weight: 600;
	font-size: medium;
}

.button:hover {
	background-color: #cdc1ff;
} */
</style>


<body>
	<!-- navigation -->
<%
   response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
if(session.getAttribute("email")==null){
	response.sendRedirect("login.jsp");
}
%>
	<header>
		<div class="navContainer">
			<div class="rightContainer">
				<img src="assets/images/eds.png" alt=""> <span>Expenditure
					Claim</span>
			</div>
			<div class="leftContainer">
				<nav class="navText menu menu-1">
				<a href="Home.jsp" class="nav-link">Home</a>
					<a href="adminCreate.jsp" class="nav-link">Create</a> <a
						href="adminMyForms.jsp" class="nav-link">My Forms</a> <a
						href="EmployeeList1.jsp" class="nav-link">Users List</a> 
						
				</nav>
				<img class="profilePic" src="assets/images/profile2.png" alt=""
					style="height: 40px; width: auto;">
			</div>
		</div>
	</header>

	<div class="profile">
		<p style="font-size: large;"><%=session.getAttribute("fn")%></p>
		<p style="font-weight: 300; margin-top: 5px;"><%=session.getAttribute("email")%></p>
		<button class="profileButton profileInfoButton">
			<a>Profile Information</a>
		</button>
		<button class="profileButton">
			<a href="changePassword.jsp?sourcePage=EmployeeList1" style="text-decoration: none;">Change
				password</a>
		</button>
		<button class="profileButton">
			<a href="logout.jsp" style="text-decoration: none;">Logout</a>
		</button>
		<!-- <button class="payButton"><a href="logout.jsp" style="text-decoration: none; color: white;">Logout</a></button> -->
	</div>


	<div class="payment">
		<h1 class="profileInfo">Profile Information</h1>
		<div class="profileDetails">
			<p>
				<span class="label">Employee ID:</span> <span class="value"><%=session.getAttribute("EC")%></span>
			</p>
			<p>
				<span class="label">Email:</span> <span class="value"><%=session.getAttribute("email")%></span>
			</p>
			<p>
				<span class="label">Full Name:</span> <span class="value"><%=session.getAttribute("fn")%></span>
			</p>
			<p>
				<span class="label">User Type:</span> <span class="value"><%=session.getAttribute("userType")%></span>
			</p>
			<p>
				<span class="label">Designation:</span> <span class="value">
					<%=session.getAttribute("designation")%></span>
			</p>
			<p>
				<span class="label">Reporting Manager:</span> <span class="value"><%=session.getAttribute("ApprovingAuthority")%></span>
			</p>
			<p>
				<span class="label">Region:</span> <span class="value"><%=session.getAttribute("region")%></span>
			</p>
			<p>
				<span class="label">Travel Plan:</span> <span class="value">
					<%=session.getAttribute("travelPlan")%></span>
			</p>
		</div>
		<span class="close">X</span>
		<!-- <button class="payButton"><a href="logout.jsp" style="text-decoration: none; color: white;">Logout</a></button> -->
	</div>


	<!-- navigation -->
	<main>
	<div class="tableContainer">
		<form action="EmployeeListUpdate 1.jsp" method="post">
			<div class="TableBody">
			<table id="table" border="1">
				<thead class="fix">
					<tr>
						<th id="nameHeader">Name</th>
						<th id="designationHeader">Designation</th>
						<th id="emailHeader">Email</th>
						<th id="regionHeader">Region</th>
						<th id="ECHeader">Employee Code</th>
						<th id="userTypeHeader">User Type</th>
						<th id="rmHeader">Reporting Manager</th>
					</tr>
				</thead>
				<tbody>
					<%
					// Read JSON file and parse data
					String filePath = "C:\\Users\\KiranTG\\Downloads\\ExpenditureReimburse 1\\ExpenditureReimburse\\src\\main\\webapp\\users.json";
					JSONParser parser = new JSONParser();
					JSONObject users = null;

					try {
						users = (JSONObject) parser.parse(new FileReader(filePath));
					} catch (ParseException e) {
						e.printStackTrace();
					}

					// Loop through the user data and display in table rows
					/* for (Object userId : users.keySet()) {
						JSONObject userData = (JSONObject) users.get(userId); */
						
						Map<String, JSONObject> sortedUsers = new TreeMap<>(users);

                        // Loop through the sorted user data and display in table rows
                        for (JSONObject userData : sortedUsers.values()) {
					%>
					<tr>
						<td id="fnBody"><%=userData.get("fn")%></td>
						<td id="designationBody"><%=userData.get("designation")%></td>
						<td id="emialBody"><%=userData.get("email")%></td>
						<td id="regionBody"><%=userData.get("region")%></td>
						<td id="EC"><%=userData.get("EC")%></td>
						<td id="userTypeBody"><%=userData.get("userType")%></td>
						<%
						String ap = (String) userData.get("Approving Authority");
						if (ap.equalsIgnoreCase("None")) {
						%>
						<td style="color: red;" id="rmBody"><%=ap%></td>
						<%
						} else {
						%>
						<td id="rmBody"><%=ap%></td>
						<%
						}
						%>
						
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
			</div>
			<div id="bContainer">
				<button id="submitBtn" class="button">Update</button>
			</div>
		</form>
		</div>
		
	</main>

	<script src="js/navigationBar.js"></script>
</body>
</html>










