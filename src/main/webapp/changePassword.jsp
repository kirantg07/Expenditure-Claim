<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="css/changePassword.css">
<link rel="stylesheet" href="css/navigationBar.css">
<title>Change Password</title>


</head>
<body>
<%
   response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
if(session.getAttribute("email")==null){
	response.sendRedirect("login.jsp");
}
%>
 <%
    // Retrieve the source page parameter from the URL
    String sourcePage = request.getParameter("sourcePage");
    // Determine the appropriate header based on the source page
    String headerText = "";
    if ("managerHistory".equals(sourcePage)||"managerCreate".equals(sourcePage)||"managerReview".equals(sourcePage)|| "managerMyForms".equals(sourcePage)) {
        headerText = "<header>\n" +
                "    <div class=\"navContainer\">\n" +
                "        <div class=\"rightContainer\">\n" +
                "            <img src=\"assets/images/eds.png\" alt=\"\"> <span>Expenditure\n" +
                "                Claim</span>\n" +
                "        </div>\n" +
                "        <div class=\"leftContainer\">\n" +
                "            <nav class=\"navText menu menu-1\">\n" +
                "                <a href=\"managerCreate.jsp\" class=\"nav-link\">Create</a> <a\n" +
                "                    href=\"managerMyForms.jsp\" class=\"nav-link\">My Forms</a> <a\n" +
                "                    href=\"DemoManager?pageType=managerReview\" class=\"nav-link\">Review</a>\n" +
                "                <a href=\"DemoHistory?pageType=managerHistory\" class=\"nav-link\">History</a>\n" +
                "            </nav>\n" +
                "            <img class=\"profilePic\" src=\"assets/images/profile2.png\" alt=\"\"\n" +
                "                style=\"height: 40px; width: auto; mix-blend-mode: multiply;\">\n" +
                "        </div>\n" +
                "    </div>\n" +
                "</header>\n" 
                ;
    } else if ("create".equals(sourcePage)||"review".equals(sourcePage)) {
        headerText = "<header>" +
                "<div class='navContainer'>" +
                "<div class='rightContainer'>" +
                    "<img src='assets/images/eds.png' alt=''> <span>Expenditure Claim</span>" +
                "</div>" +
                "<label class='menu-btn'><i class='fa-solid fa-bars'></i></label>" +
                "<div class='leftContainer'>" +
                    "<nav class='navText menu menu-1'>" +
                        "<a href='create.jsp' class='nav-link'>Create</a> <a href='review1.jsp' class='nav-link'>My Forms</a>" +
                    "</nav>" +
                    "<img class='profilePic' src='assets/images/profile2.png' alt='' style='height: 40px; width: auto;'>" +
                "</div>" +
            "</div>" +
        "</header>";
;
    } else if ("financeCreate".equals(sourcePage)||"financeMyForms".equals(sourcePage)||"financeReport".equals(sourcePage)||"financeReview".equals(sourcePage)) {
        headerText = "<header>\n" +
                "    <div class=\"navContainer\">\n" +
                "        <div class=\"rightContainer\">\n" +
                "            <img src=\"assets/images/eds.png\" alt=\"\"> <span>Expenditure\n" +
                "                Claim</span>\n" +
                "        </div>\n" +
                "        <label class=\"menu-btn\"><i class=\"fa-solid fa-bars\"></i></label>\n" +
                "        <div class=\"leftContainer\">\n" +
                "            <nav class=\"navText menu menu-1\">\n" +
                " <a href=\"financeCreate.jsp\" class=\"nav-link\">Create</a> <a\n" +
                "                    href=\"financeMyForms.jsp\" class=\"nav-link\">My Forms</a> <a\n" +
                "                    href=\"DemoManager?pageType=financeReview\" class=\"nav-link\">Review</a>\n" +
                "                <a href=\"DemoHistory?pageType=financeReport\" class=\"nav-link\">History</a>\n" +
                "            </nav>\n" +
                "            <img class=\"profilePic\" src=\"assets/images/profile2.png\" alt=\"\"\n" +
                "                style=\"height: 40px; width: auto;\">\n" +
                "        </div>\n" +
                "    </div>\n" +
                "</header>";
    } else if ("Home".equals(sourcePage)||"adminCreate".equals(sourcePage)||"adminMyForms".equals(sourcePage)||"EmployeeList1".equals(sourcePage)||"EmployeeListUpdate".equals(sourcePage)) {
        headerText = "<header> <div class=\"navContainer\"> <div class=\"rightContainer\"> <img src=\"assets/images/eds.png\" alt=\"\"> <span>Expenditure Claim</span> </div> <label class=\"menu-btn\"><i class=\"fa-solid fa-bars\"></i></label> <div class=\"leftContainer\"> <nav class=\"navText menu menu-1\">  <a href=\"Home.jsp\" class=\"nav-link\">Home</a>   <a href=\"adminCreate.jsp\" class=\"nav-link\">Create</a> <a href=\"adminMyForms.jsp\" class=\"nav-link\">My Forms</a> <a href=\"EmployeeList1.jsp\" class=\"nav-link\">Users List</a> </nav> <img class=\"profilePic\" src=\"assets/images/profile2.png\" alt=\"\" style=\"height: 40px; width: auto;\"> </div> </div> </header>";;
    }
    %>
    <header>
        <h1><%= headerText %></h1>
    </header>
	<%
	Object fn = session.getAttribute("fn");
	Object EC = session.getAttribute("EC");
	Object ApprovingAuthority = session.getAttribute("ApprovingAuthority");
	%>

	<div class=containerb>
		<span class="close" onclick="goBack()">X</span>
		<form id="changePasswordForm" action="changePasswordServlet"
			method="post">
			<h1>Change Password</h1>
			<div id="errorMessage" style="text-align: center; color: red;">
				<%
				String errorMessage = (String) request.getParameter("error");
				if (errorMessage != null && !errorMessage.isEmpty()) {
				%>
				<h3><%=errorMessage%></h3>
				<%
				}
				%>
			</div>
			<%-- <label for="employeeID">Employee ID:     <b><%=session.getAttribute("EC")%></b></label>
			<br>  --%>
			 <label
				for="oldPassword">Old Password:</label> <input type="password"
				name="oldPassword" id="oldPassword" placeholder="Enter Old password"
				required> <label for="newPassword">New Password:</label> <input type="password" name="newPassword" id="newPassword"
				placeholder="Enter New password" required> <label
				for="confirmNewPassword">Confirm Password:</label> <input
				type="password" name="confirmNewPassword" id="confirmNewpassword"
				placeholder="Confirm new password" required>

			<!-- Submit Button -->
			<div class="buttonContainer">
				<button type="submit" name="submitButton">Change Password</button>
			</div>

		</form>

	</div>
	<script>
		function goBack() {
			window.history.back();
		}
	</script>
	<script src="js/navigationBar.js"></script>
</body>
</html>