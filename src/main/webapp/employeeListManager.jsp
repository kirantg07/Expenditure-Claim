<%@ page import="java.util.Map"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page
	import="java.io.PrintWriter, java.nio.file.Files, java.nio.file.Path, java.nio.file.Paths, java.nio.file.Files,java.nio.file.Path,java.nio.file.Paths"%>
<%@ page import="java.io.FileReader"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.io.FileNotFoundException"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="org.json.simple.parser.ParseException"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Approving authority</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="css/employeeListManager.css">
<link rel="stylesheet" href="css/navigationBar.css">

</head>
<body>
	<!-- navigation -->

	<header>
		<div class="navContainer">
			<div class="rightContainer">
				<img src="assets/images/eds.png" alt=""> <span>Expenditure
					Claim</span>
			</div>
			<div class="leftContainer">
				<nav class="navText menu menu-1">
					<a href="adminCreate.jsp" class="nav-link">Create</a> <a
						href="adminMyForms.jsp" class="nav-link">My Forms</a> <a
						href="EmployeeList1.jsp" class="nav-link">Users List</a> <a
						href="employeeListManager.jsp" class="nav-link">Reporting
						manager</a>
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
			<a href="changePassword.jsp" style="text-decoration: none;">Change
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
		<form action="EmployeeListManagerAction" method="post">
			<table id="table" border="1">
				<thead>
					<tr>
						<th>Name</th>
						<th>Designation</th>
						<th>Email</th>
						<th>Region</th>
						<th id="ECHeader">Employee Code</th>
						<th>User Type</th>
						<th>Travel plan</th>
						<th>Reporting Manager</th>
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
					for (Object userId : users.keySet()) {
						JSONObject userData = (JSONObject) users.get(userId);
						Object approvingAuthority = userData.get("Approving Authority");
						 if (approvingAuthority != null && approvingAuthority.toString().equals("")) { 
							Object fn = userData.get("fn");
					%>
					<tr>
						<td id='userName'><%=userData.get("fn")%></td>
						<td><%=userData.get("designation")%></td>
						<td><%=userData.get("email")%></td>
						<td><%=userData.get("region")%></td>
						<td id="EC"><%=userData.get("EC")%></td>
						<td><%=userData.get("userType")%></td>
						<td><%=userData.get("travelPlan")%></td>
						<td><select name="reportingManagerArray[]"
							id="reportingManager" required>
								<!-- <option value="">Select Reporting Manager</option> -->
						</select></td>
						<input type="hidden" name="userIdArray[]" value="<%=fn%>">
					</tr>
					<%
					 } 
					}
					%>
				</tbody>
			</table>
			<div id="bContainer">
				<button id="submitBtn" class="button">Update</button>
			</div>
		</form>
	</main>
	<script src="js/navigationBar.js"></script>
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="js/employeeListManager.js"></script>

</body>
</html>
