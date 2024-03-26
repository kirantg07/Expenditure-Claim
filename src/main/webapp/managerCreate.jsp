<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Create</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
	integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<link rel="stylesheet" href="css/table.css">
<link rel="stylesheet" href="css/create.css">
<link rel="stylesheet" href="css/navigationBar.css">

</head>
<body style="padding: auto; margin: auto;">
<%
   response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
if(session.getAttribute("email")==null){
	response.sendRedirect("login.jsp");
}
%>

	<!-- navigation -->

	<header>
		<div class="navContainer">
			<div class="rightContainer">
				<img src="assets/images/eds.png" alt=""> <span>Expenditure
					Claim</span>
			</div>
			<label class="menu-btn"><i class="fa-solid fa-bars"></i></label>
			<div class="leftContainer">
				<nav class="navText menu menu-1">
					<a href="managerCreate.jsp" class="nav-link">Create</a> <a
						href="managerMyForms.jsp" class="nav-link">My Forms</a> <a
						href="DemoManager?pageType=managerReview" class="nav-link">Review</a>
					<a href="DemoHistory?pageType=managerHistory" class="nav-link">History</a>
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
			<a href="changePassword.jsp?sourcePage=managerCreate" style="text-decoration: none;">Change
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
	<div class="successContainer">
		<div id="success"
			style="color: red; text-align: center; font-size: large; margin-bottom: 5px; display: none;">Updated
			successfully</div>

		<div id="failed"
			style="color: red; text-align: center; font-size: large; margin-bottom: 5px; display: none;">Updation
			Failed</div>
	</div>
	<!-- <td><button type="button" onclick="addRow()">Add Row</button></td> -->
	<div class="container">
		<table class="table">
			<thead>
				<tr>
					<th class="slNo">SL NO.</th>
					<th class="particulars">Particulars*</th>
					<th class="billNo">Bill No.*</th>
					<th class="billDate">Bill Date*</th>
					<th class="amount">Amount*</th>
					<th class="uploadBill">Upload bill*</th>
					<!-- <th>Action</th> -->
					<th>
						<div class="actionContainer">
							<button class="success" onclick="addRow('tableBody')">
								<i class="fa fa-solid fa-plus"></i>
							</button>
						</div>
					</th>
				</tr>
			</thead>
			<tbody id="tableBody">
				<%
				Object fn = session.getAttribute("fn");
				Object EC = session.getAttribute("EC");
				Object ApprovingAuthority = session.getAttribute("ApprovingAuthority");
				/*       out.println("Approving Authority is "+ ApprovingAuthority) */;
				%>
				<tr id="inputRow">
					<td><input type="text" id="slNo" name="slNo" value="1"
						class="formControl greyBackground" readonly></td>
					<td><textarea name="particulars" id="particulars"
							class="formControl" required></textarea></td>
					<td><input type="text" id="billNo" class="formControl"
						required></td>
					<td><input type="date" id="billDate" class="formControl"
						required></td>
					<td><input type="text" id="amount" class="formControl"
						pattern="\d+" title="Please enter only digits" required></td>
					<input type="hidden" name="userIdArray[]" id="name" value="<%=fn%>">
					<input type="hidden" name="userIdArray[]" id="EmpCode"
						value="<%=EC%>">
					<input type="hidden" name="ApprovingAuthority"
						id="ApprovingAuthority" value="<%=ApprovingAuthority%>">
					<td><input type="file" id="uploadBill" class="formControl"
						accept="image/*"></td>

					<td>
						<div class="actionContainer">
							<button class="danger" onclick="deleteRow(this)">
								<i class="fa fa-solid fa-trash"></i>
							</button>
						</div>
					</td>

				</tr>
			</tbody>

		</table>

	</div>
	<div class="buttonContainer">
		<button class="button" onclick="onSubmit('Saved')">Save</button>
		<button type="button" class="button" onclick="onSubmit('Submitted')">Submit</button>
	</div>


	<script src="js/managerCreate.js"></script>
	<script src="js/navigationBar.js"></script>
	<script src="js/userJs"></script>



</body>
</html>