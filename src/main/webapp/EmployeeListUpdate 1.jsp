<%@ page import="java.util.Map"%>
<%@ page import="java.util.TreeMap"%>
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
<%@ page import="org.json.simple.JSONArray" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>User Type Update</title>
<title>Employee List</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
<link rel="stylesheet" href="css/navigationBar.css">
<link rel="stylesheet" href="css/employeeListUpdate.css">
</head>
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
						href="EmployeeList1.jsp" class=" active" >Users List</a>
						
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
			<a href="changePassword.jsp?sourcePage=EmployeeListUpdate" style="text-decoration: none;">Change
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
		<form id="updateForm" action="UserTypeUpdateServlet" method="post">
			<div class="TableBody">
			<table border="1" id="table">
				<thead>
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

					String designationFilePath = "C:\\Users\\KiranTG\\Downloads\\ExpenditureReimburse 1\\ExpenditureReimburse\\src\\main\\webapp\\designation.json";
			        JSONParser designationParser = new JSONParser();
			        JSONArray designations = null;

			        try {
			            designations = (JSONArray) designationParser.parse(new FileReader(designationFilePath));
			        } catch (ParseException e) {
			            e.printStackTrace();
			        }
					
					
					try {
						users = (JSONObject) parser.parse(new FileReader(filePath));
					} catch (ParseException e) {
						e.printStackTrace();
					}
					// Loop through the user data and display in table rows
				/* 	for (Object userId : users.keySet()) {
						JSONObject userData = (JSONObject) users.get(userId); */
						Map<String, JSONObject> sortedUsers = new TreeMap<>(users);

                        // Loop through the sorted user data and display in table rows
                        for (JSONObject userData : sortedUsers.values()) {
					%>
					<tr>
						<td id="userName"><%=userData.get("fn")%></td>
						<td id="designationBody">
									<!-- Dropdown for Designation --> 
								<select name="designationArray[]" class="designationDropDown" required>
								<% 
                    			for (Object obj : designations) {
                        		String designation = (String) obj;
                				%>
                				<option value="<%=designation%>" <%=designation.equals(userData.get("designation")) ? "selected" : ""%>><%=designation%></option>
                				<% } %>
								</select>
								</td>
								<td id="emialBody"><%=userData.get("email")%></td>
						<td id="regionBody"><%=userData.get("region")%></td>
						<td id="EC"><%=userData.get("EC")%></td>
						<td id="userTypeBody"><select name="usertypeArray[]" class="userTypeDropDown"required>
								<option value="User"
									<%="User".equals(userData.get("userType")) ? "selected" : ""%>>User</option>
								<option value="Approving Authority"
									<%="Approving Authority".equals(userData.get("userType")) ? "selected" : ""%>>Approving
									authority</option>
								<option value="Finance"
									<%="Finance".equals(userData.get("userType")) ? "selected" : ""%>>Finance</option>
								<option value="Admin"
									<%="Admin".equals(userData.get("userType")) ? "selected" : ""%>>Admin</option>
						</select> <input type="hidden" name="userIdArray[]" value="<%=userData.get("fn")%>">
						</td>
						<td id="rmBody"><select name="reportingManagerArray[]" class="rmDropDown"
							id="reportingManager" required>
								 <option value="<%=userData.get("Approving Authority")%>"><%=userData.get("Approving Authority")%></option> 
						</select></td>
						
						
						
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
			</div>
			<div id="bContainer">
				<button type="button" id="submitBtn" onclick="submitForm()"
					class="button">Submit</button>
			</div>
		</form>
		</div>
	</main>
	


	<script src="js/navigationBar.js"></script>
	<script src="js/employeeListUpdate.js"></script>
		<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	
</body>
</html>