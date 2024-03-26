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
<link rel="stylesheet" href="css/review1.css">
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
					<a href="financeCreate.jsp" class="nav-link">Create</a> <a
						href="financeMyForms.jsp" class="nav-link">My Forms</a> <a
						href="DemoManager?pageType=financeReview" class="nav-link">Review</a>
					<a href="DemoHistory?pageType=financeReport" class="nav-link">History</a>
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
			<a href="changePassword.jsp?sourcePage=financeMyForms">Change password</a>
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
		<!-- <button class="payButton"><a href="logout.jsp" style="text-decoration: none; color: white;">Logout</a></button> -->
	</div>


	<!-- navigation -->



	<!-- Edit Form -->
	<div id="editForm">
		<!-- Your table HTML -->
		<!-- <br> <br> -->
		<div class="successContainer">
			<div id="success"
				style="color: red; text-align: center; font-size: large; margin-bottom: 5px; display: none;">Updated
				successfully</div>
			<div id="failed"
				style="color: red; text-align: center; font-size: large; margin-bottom: 5px; display: none;">Updation
				Failed</div>
		</div>

		<table id="editTable" class="table">
			<thead>
				<tr>
					<!--  <th id="editSl">Sl NO.</th> -->
					<th id="editParticulars">Particulars*</th>
					<th id="editBillNo">Bill No.*</th>
					<th id="editBillDate">Bill Date*</th>
					<th id="editAmount">Amount*</th>
					<th id="editViewBill">View Bill</th>
					<th id="edituploadBill">Upload New Bill</th>
				</tr>
			</thead>
			<tbody id="tableBody">

				<tr id="inputRow">
					<!--  <td><input type="text" id="sl" class="formControl greyBackground" required></td> -->
					<td><textarea name="" id="parti" rows="1" class="formControl"
							required></textarea></td>
					<td><input type="text" id="bNo" class="formControl"
						pattern="\d+" title="Please enter only digits" required></td>
					<td><input type="date" id="bDate" class="formControl" required></td>
					<td><input type="text" id="amo" class="formControl"
						pattern="\d+" title="Please enter only digits" required></td>
					<td><a id="viewBillLink" target="_blank" class="view-bill">View
							Bill</a></td>
					<td><input type="file" id="uBill" class="formControl"></td>
					<input type="hidden" name="id" id="formId">
					<input type="hidden" name="billEdit" id="billEdit">
					<input type="hidden" name="mApproval" id="mApproval">
					<input type="hidden" name="cDate" id="cDate">
				</tr>
			</tbody>
		</table>

		<!-- Close Button -->
		<!-- <button id="closeButton" onclick="closeEditForm()">Close</button> -->
		<button class="close" onclick="closeEditForm()" style="right: 25px;">X</button>

		<div class="buttonContainer">
			<!--  <button class="button" onclick="update('Saved')">Save </button> -->
			<button type="button" class="buttonE" onclick="update('Submitted')">Submit</button>
			<!--   <button type="button" class="button" onclick="delete()" >Delete</button> -->

		</div>
	</div>


	<%
	Object fn = session.getAttribute("fn");
	Object EC = session.getAttribute("EC");

	// Read JSON file and parse data
	String filePath = "C:\\Users\\KiranTG\\Downloads\\ExpenditureReimburse 1\\ExpenditureReimburse\\src\\main\\webapp\\table.json";
	JSONParser parser = new JSONParser();
	JSONObject info = null;

	try {
		info = (JSONObject) parser.parse(new FileReader(filePath));
	} catch (ParseException | IOException e) {
		e.printStackTrace();
	}

	// Check if the EC attribute matches any key in the JSON object
	if (info.containsKey(EC)) {
		JSONArray userData = (JSONArray) info.get(EC);
	%>

	<div class="dateValidationContainer">
		<label for="fromDate" class="dateCss">From Bill Date:</label> <input
			type="date" id="fromDate" name="fromDate" class="dateInput">

		<label for="toDate" class="dateCss">To Bill Date:</label> <input
			type="date" id="toDate" name="toDate" class="dateInput"> <label
			for="managerApproval" class="dateCss">Status:</label> <select
			id="managerApprovalFilter" class="dateInput dateSelect">
			<option value="All">All</option>
			<option value="Saved">Saved</option>
			<option value="Submitted">Submitted</option>
			<option value="Resubmitted">Resubmitted</option>
			<option value="Approved">Approved</option>
			<option value="Rejected">Rejected</option>
			<option value="Modify">Modify</option>
			<option value="Settled">Settled</option>
		</select>

		<button onclick="filterTable()" class="inputButton">Go</button>
		<span class="resetButtonContainer">
			<button onclick="refreshPage()" class="inputButton" id="resetButton">Reset</button>
			<span id="hoverText">Click here. To reset the data.</span>
		</span>

	</div>


	<!-- 	 <div class="containerWrap">  -->
	<div class="container">

		<table class="table" id="table">
			<thead class="fix">
				<tr>
					<!-- <th id="slHeader">SL NO.</th> -->
					<th id="particularsHeader">Particulars</th>
					<th id="billNoHeader">Bill No.</th>
					<th id="billDateHeader">Bill Date</th>
					<th id="ClaimedAmountHeader">Claimed amount</th>
					<th id="viewBillHeader">View Bill</th>
					<th id="ClaimedDateHeader">Claimed Date</th>
					<th id="ReclaimedDateHeader">Reclaimed Date</th>
					<th id="managerRemarksHeader">Manager Remarks</th>
					<th id="approvedAmountHeader">Approved Amount</th>
					<th id="finTeamRemarksHeader">Fin. team Remarks</th>
					<th id="settledDateHeader">Settled Date</th>
					<th id="statusHeader">Status <span class="toolTipcontainer">
							<i class="fas fa-info-circle" id="tooltipTrigger"></i>
							<div class="tooltip" id="tooltipContent">
								<p>
									<span class="highlight">Saved:</span><span class="description">The
										form is saved but not sent to approving authority.</span>
								</p>
								<p>
									<span class="highlight">Submitted:</span><span
										class="description">The form is sent to approving
										authority.</span>
								</p>
								<p>
									<span class="highlight">Resubmitted:</span><span
										class="description">The form is resubmitted after
										modification.</span>
								</p>
								<p>
									<span class="highlight">Approved:</span><span
										class="description">The form is approved by reporting
										manager.</span>
								</p>
								<p>
									<span class="highlight">Rejected:</span><span
										class="description">The form is rejected by reporting
										manager.</span>
								</p>
								<p>
									<span class="highlight">Modify:</span><span class="description">The
										form is sent back for modification from finance <span
										style="margin-left: 120px;">department.</span>
									</span>
								</p>
								<p>
									<span class="highlight">Settled:</span><span
										class="description">The amount is settled.</span>
								</p>
							</div>
					</span>

					</th>
					<th id="actionHeader">Action</th>
				</tr>
			</thead>
			<tbody id="bd">
				<%
				// Loop through the data and display in table rows
				/* for (int i = 0; i < userData.size(); i++) { */
				int id = 0;
				for (int i = userData.size() - 1; i >= 0; i--) {
					id++;
					JSONObject userObject = (JSONObject) userData.get(i);
				%>
				<tr>
					<%-- <td class="formControl center-align" id="slNo"><%=id%></td> --%>
					<td class="formControl center-align" id="particulars"><%=userObject.get("particulars")%></td>
					<td class="formControl center-align" id="bno"><%=userObject.get("billNo")%></td>
					<td class="formControl center-align" id="billDate"><%=userObject.get("billDate")%></td>
					<td class="formControl center-align" id="amount"><%=userObject.get("amount")%></td>
					<td><a href='<%=userObject.get("uploadBill")%>'
						target='_blank' id="viewBill" class="view-bill">View Bill</a></td>
					<td class="formControl center-align" id="claimedDate"><%=userObject.get("claimedDate")%></td>
					<td class="formControl center-align" id="reclaimedDate"><%=userObject.get("reclaimedDate")%></td>
					<td class="formControl center-align" id="managerRemarks"><%=userObject.get("managerRemarks")%></td>
					<input type="hidden" name="id" id="id"
						value="<%=userObject.get("id")%>">
					<input type="hidden" name="uBillHidden" id="uBillHidden"
						value="<%=userObject.get("uploadBill")%>">
					<%-- <td class="formControl center-align" id="managerApproval"><%=userObject.get("managerApproval")%></td> --%>
					<%-- Display approvedAmount, if not null, otherwise display blank --%>
					<%
					Object approvedAmount = userObject.get("approvedAmount");
					if (approvedAmount != null) {
					%>
					<td class="formControl center-align" id="approvedAmount"><%=approvedAmount%></td>
					<%
					} else {
					%>
					<td class="formControl center-align" id="approvedAmount"></td>
					<%
					}
					%>

					<%
					Object finTeamRemarks = userObject.get("finTeamRemarks");
					if (finTeamRemarks != null) {
					%>
					<td class="formControl center-align" id="finTeamRemarks"><%=finTeamRemarks%></td>
					<%
					} else {
					%>
					<td class="formControl center-align" id="finTeamRemarks"></td>
					<%
					}
					%>


					<td class="formControl center-align" id="settledDate"><%=userObject.get("settledDate")%></td>

					<td class="formControl center-align" id="managerApproval"><%=userObject.get("managerApproval")%></td>

					<%
					if (!("Approved".equals(userObject.get("managerApproval")) || "Settled".equals(userObject.get("managerApproval")))) {
					%>
					<td class="formControl center-align" id="editButtonContainer"><button
							onclick='find.call(this)' id="editButton">Edit</button></td>
					<%
					} else {
					%>
					<td class="formControl center-align">-</td>
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

	<%
	}
	%>

	<!-- The Modal -->
	<div id="myModal" class="modal">
		<span class="closee">&times;</span> <img class="modal-content"
			id="img01">
		<div id="caption"></div>
	</div>

	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="js/financeMyForms.js"></script>
	<script src="js/navigationBar.js"></script>
</body>
</html>
