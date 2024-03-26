<%@ page import="java.util.Map"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page
	import="java.io.PrintWriter, java.nio.file.Files, java.nio.file.Path, java.nio.file.Paths"%>
<%@ page import="java.io.FileReader"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.io.FileNotFoundException"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="org.json.simple.parser.ParseException"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.Collections"%>
<%@ page import="java.util.Comparator"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Locale"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%@ page import="javax.servlet.http.HttpSession"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>History</title>
<link rel="stylesheet" href="css/navigationBar.css">
<link rel="stylesheet" href="css/managerHistory.css">
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
			<a href="changePassword.jsp?sourcePage=managerHistory" style="text-decoration: none;">Change
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
	<%
	Object fn = session.getAttribute("fn");
	Object EC = session.getAttribute("EC");

	// Read JSON file and parse data
	String filePath = "C:\\Users\\KiranTG\\Downloads\\ExpenditureReimburse 1\\ExpenditureReimburse\\src\\main\\webapp\\table.json";
	JSONParser parser = new JSONParser();
	JSONObject expenseData = null;

	try {
		expenseData = (JSONObject) parser.parse(new FileReader(filePath));
	} catch (ParseException | IOException e) {
		e.printStackTrace();
	}
	%>


	<div class="dateValidationContainer" style="margin-top: 5px;">
		<label for="fromDate">From Bill Date:</label> <input type="date"
			id="fromDate" name="fromDate"> <label for="toDate">To
			Bill Date:</label> <input type="date" id="toDate" name="toDate"> <label
			for="fullName">Name:</label> <input type="text" id="fullName"
			name="fullName">


		<button onclick="filterTable()" class="button" style="width: 60px;">Go</button>
		<span class="resetButtonContainer">
			<button onclick="refreshPage()" class="inputButton button"
				id="resetButton" style="width: 60px;">Reset</button> <span
			id="hoverText">Click here. To reset the data.</span>
		</span>

	</div>

	<div class="ManagerContainer">
		<table class="table" border="1">
			<thead>
				<tr>
					<!-- <th id="slNoHeader">SL NO.</th> -->
					<th id="nameHeader">Name</th>
					<th id="particularsHeader">Particulars</th>
					<th id="billNoHeader">Bill No.</th>
					<th id="billDateheader">Bill Date</th>
					<th id="claimedDateHeader">Claimed Date</th>
					<th id="reclaimedDateHeader">Reclaimed Date</th>
					<th id="settledDateHeader">Settled Date</th>
					<th id="amountHeader">Amount</th>
					<th id="viewBillHeader">View Bill</th>
					<th id="actionHeader">Action</th>
					<th id="remarksHeader">Manager Remarks</th>
					<th id="finRemarksHeader">Fin. Team Remarks</th>
				</tr>
			</thead>
			<tbody id="tableBody">



				<%
				int id = 0;
				List<JSONObject> sortedData = (List<JSONObject>) request.getAttribute("sortedData");
				for (int i = sortedData.size() - 1; i >= 0; i--) {
					JSONObject expenseItem = sortedData.get(i);

					/*  for (JSONObject expenseItem : sortedData) { */
					if (("Approved".equals(expenseItem.get("managerApproval")) || "Rejected".equals(expenseItem.get("managerApproval"))
					|| "Settled".equals(expenseItem.get("managerApproval"))
					|| "Modify".equals(expenseItem.get("managerApproval")))
					&& fn != null && fn.equals(expenseItem.get("Approving Authority"))) {

						id++;
				%>
				<tr>
					<%-- <td class=" center-align" id="slNo"><%=id%></td> --%>
					<td class=" center-align" id="fn"><%=expenseItem.get("name")%></td>
					<td class=" center-align" id="particulars"><%=expenseItem.get("particulars")%></td>
					<td class=" center-align" id="bno"><%=expenseItem.get("billNo")%></td>
					<td class=" center-align" id="billDate"><%=expenseItem.get("billDate")%></td>
					<td class="center-align" id="claimedDate"><%=expenseItem.get("claimedDate")%></td>
					<td class="center-align" id="reclaimedDate"><%=expenseItem.get("reclaimedDate")%></td>
					<td class="center-align" id="settledDate"><%=expenseItem.get("settledDate")%></td>
					<td class="center-align" id="amount"><%=expenseItem.get("amount")%></td>
					<td><a href='<%=expenseItem.get("uploadBill")%>'
						target='_blank' class="view-bill">View Bill</a></td>
					<td class="center-align" id="managerApproval"><%=expenseItem.get("managerApproval")%></td>
					<%
					Object managerRemarks = expenseItem.get("managerRemarks");
					if ("-".equals(managerRemarks)) {
					%>
					<td class="center-align" id="managerRemarks"></td>
					<%
					} else {
					%>
					<td class="center-align" id="managerRemarks"><%=managerRemarks%></td>
					<%
					}
					%>
					<td class="center-align" id="finTeamRemarks"><%=expenseItem.get("finTeamRemarks")%></td>
				</tr>

				<%
				}
				}
				%>
			</tbody>

		</table>

	</div>
	<!-- The Modal -->
	<div id="myModal" class="modal">
		<span class="closee">&times;</span> <img class="modal-content"
			id="img01">
		<div id="caption"></div>
	</div>

	<script src="js/navigationBar.js"></script>
	<script src="js/managerHistory.js"></script>

</body>
</html>