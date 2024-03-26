<%@ page import="java.util.Map"%>
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
<%@page import="org.json.simple.JSONArray"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Employee List</title>
<link rel="stylesheet" href="css/table.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
<link rel="stylesheet" href="css/navigationBar.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<link rel="stylesheet" href="css/Home.css">

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
				<a href="Home.jsp" class=" active">Home</a>
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
			<a href="changePassword.jsp?sourcePage=Home">Change password</a>
		</button>
		<button class="profileButton">
			<a href="logout.jsp">Logout</a>
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
	</div>
	<div class="Designation-add-container">
	<h3 id="registered" style="display: none;">Added
			Successfully</h3>
	<h4 id="errormessage"></h4>
		<form  id="Designationform" >
			<label for="designation">New Designation :</label> <input type="text" id="designation" name="designation" placeholder="Enter new designation" required> 
			<button type="submit" onclick="solve()">Add</button>
			</form>
	</div>

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="js/navigationBar.js"></script>
	<script src="js/Home.js"></script>
</body>
</html>
