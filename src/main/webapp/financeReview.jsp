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
<title>Insert title here</title>
<link rel="stylesheet" href="css/navigationBar.css">
<link rel="stylesheet" href="css/financeReview.css">
<link rel="stylesheet" href="css/navigationBar.css">
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
			<a href="changePassword.jsp?sourcePage=financeReview" style="text-decoration: none;">Change
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

	<div class="dateValidationContainer" style="margin-top: 5px;">
		<label for="fromDate">From Bill Date:</label> <input type="date"
			id="fromDate" name="fromDate"> <label for="toDate">To
			Bill Date:</label> <input type="date" id="toDate" name="toDate"> <label
			for="fullName">Name:</label> <input type="text" id="fullName"
			name="fullName"> <label for="amountValidation">Minimum
			amount:</label> <input type="text" id="amountValidation"
			name="amountValidation">

		<button onclick="filterTable()" class="button" style="width: 60px;">Go</button>
		<span class="resetButtonContainer">
			<button onclick="refreshPage()" class="inputButton button"
				id="resetButton" style="width: 60px;">Reset</button> <span
			id="hoverText">Click here. To reset the data.</span>
		</span>

	</div>

	<%
	Object fn = session.getAttribute("fn");
	Object EC = session.getAttribute("EC");
	Object userType = session.getAttribute("Finance");

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
	<div class="successContainer">
		<div id="success"
			style="color: red; text-align: center; font-size: large; margin-bottom: 5px; display: none;">Updated
			successfully</div>
		<div id="failed"
			style="color: red; text-align: center; font-size: large; margin-bottom: 5px; display: none;">Updation
			Failed</div>
	</div>
	<!-- 	<div class="buttonContainer">
		<button class="button" onclick="approveAll()">Settle all</button>
	</div > -->
	<div class="buttonContainer buttonContainerTop">
		<div>
			<label for="sortSelection" id="sortSelection">Sort By:</label>
			<!--  sortSelectionOption -->
			<select id="a_background" name="background" class="widget">
				<option value="0">Select</option>
				<option value="1">Recent</option>
				<option value="2">Amount</option>
			</select>
		</div>
		<!-- <button onclick="sortAction()" class="button" id="sortAction" style="width:60px;">Go</button> -->

		<button class="button" onclick="approveAll()">Approve all</button>
	</div>
	<div class="financeContainer">
		<table class="table" border="1">
			<thead class="fix">
				<tr>
					<!-- <th id="slNoHeader">SL NO.</th> -->
					<th id="nameHeader">Name</th>
					<th id="particularsHeader">Particulars</th>
					<th id="billNoHeader">Bill No.</th>
					<th id="billDateheader">Bill Date</th>
					<th id="claimedDateHeader">Claimed Date</th>
					<th id="reclaimedDateHeader">Reclaimed Date</th>
					<th id="viewBillHeader">View Bill</th>
					<th id="managerRemarksHeader">Manager Remarks</th>
					<th id="claimedAmountHeader">Claimed Amount</th>
					<th id="approvedAmountHeader">Approved Amount</th>
					<th id="actionHeader">Action</th>
					<th id="remarksHeader">Remarks</th>
				</tr>
			</thead>
			<tbody id="tableBody">



				<%
				int id = 0;

				List<JSONObject> sortedData = (List<JSONObject>) request.getAttribute("sortedData");
				for (int i = sortedData.size() - 1; i >= 0; i--) {
					JSONObject expenseItem = sortedData.get(i);
					/*  for (JSONObject expenseItem : sortedData) { */

					if ("Approved".equals(expenseItem.get("managerApproval"))
					&& !"Credited".equals(expenseItem.get("paymentReference"))) {
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
					<td><a href='<%=expenseItem.get("uploadBill")%>'
						target='_blank' class="view-bill">View Bill</a></td>
					<td class="center-align" id="managerRemarks"><%=expenseItem.get("managerRemarks")%></td>
					<td class="center-align" id="amount"><%=expenseItem.get("amount")%></td>
					<td class="center-align"><input type="text"
						id="approvedAmount" name="approvedAmount"
						value='<%=expenseItem.get("amount")%>'></td>
					<%-- <td class="center-align" id="uploadBill"><%=expenseItem.get("uploadBill")%></td> --%>
					<input type="hidden" name="empId" id="empId"
						value="<%=expenseItem.get("id")%>">
					<td class="center-align" id="finaceApproval"><select
						name="finaceApprovalDropdown" id="finaceApprovalDropdown">
							<option value="select">Select</option>
							<option value="Settled">Settle</option>
							<option value="Modify">Modify</option>
							<!--  <option value="notAccept">Not accept</option> -->
					</select></td>
					<input type="hidden" name="managerApprovalHidden"
						id="managerApprovalHidden"
						value="<%=expenseItem.get("managerApproval")%>">
					<input type="hidden" name="updatedDate" id="updatedDate"
						value="<%=expenseItem.get("updatedDate")%>">
					<td class="formControl center-align"><textarea
							name="finTeamRemarks" id="finTeamRemarks" required><%=expenseItem.get("finTeamRemarks")%></textarea>
					</td>

					<!-- <td  id="finTeamRemarks" contenteditable="true" style="word-wrap: break-word;"></td> -->


				</tr>

				<%
				}
				}
				%>
			</tbody>

		</table>
	</div>
	<div class="buttonContainer buttonContainerDown"
		style="padding-top: 10px;">
		<span style="color: white;">.</span>
		<button class="button" onclick="submit()">Submit</button>
	</div>
	<!-- The Modal -->
	<div id="myModal" class="modal">
		<span class="closee">&times;</span> <img class="modal-content"
			id="img01">
		<div id="caption"></div>
	</div>


	<script>
	 function updateDateLimits() {
	        const fromDateInput = document.getElementById("fromDate");
	        const toDateInput = document.getElementById("toDate");

	        // Set the fromDate to the maximum date of today
	        const currentDate = new Date();
	        fromDateInput.max = currentDate.toISOString().split('T')[0];

	        // Set the toDate max attribute to the current date
	        toDateInput.max = currentDate.toISOString().split('T')[0];

	        // If fromDate is today, set toDate to only allow selecting today
	        if (fromDateInput.value === currentDate.toISOString().split('T')[0]) {
	            toDateInput.min = fromDateInput.value;
	            toDateInput.max = fromDateInput.value;
	        } else {
	            toDateInput.min = fromDateInput.value;
	        }
	    }
	 function filterTable() {
		    const fullName = document.getElementById("fullName").value.toLowerCase(); // Convert name to lowercase for case-insensitive matching
		    const fromDateStr = document.getElementById("fromDate").value;
		    const toDateStr = document.getElementById("toDate").value;
		    const amountValidationString = document.getElementById("amountValidation").value;
		    const amountValidation = parseFloat(amountValidationString.replace(",", ""));
		   /*  const amountValidation = parseFloat(document.getElementById("amountValidation").value); // Parse amount to float */

		    // Parse the dates in dd-mm-yyyy format if they are not empty
		    let fromDate, toDate;
		    if (fromDateStr && toDateStr) {
		        const fromDateParts = fromDateStr.split("-");
		        const toDateParts = toDateStr.split("-");
		        fromDate = new Date(fromDateParts[0], fromDateParts[1] - 1, fromDateParts[2]);
		        toDate = new Date(toDateParts[0], toDateParts[1] - 1, toDateParts[2]);

		        // Check if the dates are valid
		        if (isNaN(fromDate) || isNaN(toDate) || fromDate > toDate) {
		            alert("Please enter valid dates");
		            return;
		        }
		    }

		    const tableRows = document.querySelectorAll('.financeContainer table tbody tr');

		    tableRows.forEach((row) => {
		        const billDateStr = row.querySelector("#billDate").innerHTML;
		        const billDateParts = billDateStr.split("-");
		      /*   const billDate = new Date(billDateParts[2], billDateParts[1] - 1, billDateParts[0]); */
		        
			       //===========================================================================
		        // Define an array to map month abbreviations to numbers
		        const monthsMaping = {
		            'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04', 'May': '05', 'Jun': '06',
		            'Jul': '07', 'Aug': '08', 'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12'
		        };

		        // Split the bill date string into parts
		        const datePartition = billDateStr.split("-");

		        // Check if the date format is correct
		        if (datePartition.length !== 3) {
		            console.error("Invalid date format:", billDateStr);
		            return;
		        }

		        // Extract day, month, and year parts
		        const dayBillingDate = datePartition[0];
		        const monthAbbreviationing = datePartition[1];
		        const yearBillingDate = datePartition[2];

		        // Convert month abbreviation to number
		        const monthBillingDate = monthsMaping[monthAbbreviationing];

		        // Check if the month abbreviation is valid
		      /*   if (!month) {
		            console.error("Invalid month abbreviation:", monthAbbreviationing);
		            return;
		        } */

		        // Format the date as yyyy-mm-dd
		       /*  const billDate = `${yearBillingDate}-${monthBillingDate}-${dayBillingDate}`; */
		        const RetrievedBillingDate = yearBillingDate + "-" + monthBillingDate + "-" + dayBillingDate;
		        console.log("Retrieved bill date is " + RetrievedBillingDate);
		        
		        const billDate = new Date(yearBillingDate, monthBillingDate - 1, dayBillingDate);
		       console.log("billDate is " + billDate);
		        
		        //============================================================
		        
		        const name = row.querySelector("#fn").innerHTML.toLowerCase(); // Convert name to lowercase for case-insensitive matching
		       /*  const amount = parseFloat(row.querySelector("#amount").innerHTML); // Parse amount to float */
		       const amountString = row.querySelector("#amount").innerHTML; // Assuming innerHTML contains "25,500"
		        const amount = parseFloat(amountString.replace(",", ""));
		        /* console.log(amount); */ // Output: 25500

		        // Check if either dates are empty or bill date falls within the specified range
		        const isDateInRange = !fromDate || !toDate || (billDate >= fromDate && billDate <= toDate);

		        // Check if fullName is empty or name contains the provided fullName
		        const isNameMatched = fullName === "" || name.includes(fullName);

		        // Check if amountValidation is empty or amount is equal or above the provided amountValidation
		        const isAmountMatched = isNaN(amountValidation) || amount >= amountValidation;

		        // Show the row if all conditions are satisfied, otherwise hide it
		        row.style.display = (isDateInRange && isNameMatched && isAmountMatched) ? "" : "none";
		    });
		}


		
		 // Initial call to set the initial date limits
	    updateDateLimits();

	    function refreshPage() {
	        window.location.reload();
	    }

	    
	   //Get the modal
	    var modal = document.getElementById("myModal");

	    // Get the close button
	    var closeBtn = document.getElementsByClassName("closee")[0];

	    // Get the image and insert it inside the modal - use its "alt" text as a caption
	    var modalImg = document.getElementById("img01");
	    var captionText = document.getElementById("caption");

	    // Get all elements with class="view-bill"
	    var viewBillLinks = document.getElementsByClassName("view-bill");

	    // Loop through all elements and add the click event listener
	    for (var i = 0; i < viewBillLinks.length; i++) {
	        viewBillLinks[i].onclick = function() {
	            modal.style.display = "block"; // Display the modal

	            // Extract the image URL from the href attribute of the clicked link
	            var imageUrl = this.getAttribute("href");

	            // Set the src attribute of the modal image
	            modalImg.src = imageUrl;

	            // Prevent the default behavior of the link (opening in a new tab/window)
	            return false;
	        }
	    }

	    // When the user clicks on the close button, close the modal
	    closeBtn.onclick = function() {
	        modal.style.display = "none";
	    }

	    // When the user clicks anywhere outside of the modal, close it
	    window.onclick = function(event) {
	        if (event.target == modal) {
	            modal.style.display = "none";
	        }
	    }
	 </script>

	<script src="js/financeReview.js"></script>
	<script src="js/navigationBar.js"></script>
</body>
</html>