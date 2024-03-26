<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" href="css/style1 3.css">
<title>Registration Form</title>
</head>
<body>
<%
   response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
if(session.getAttribute("email")==null){
	response.sendRedirect("login.jsp");
}
%>
	<div class="container">

		<h3 id="registered" style="display: none;">Registered
			Successfully</h3>
		<h4 id="errormessage"></h4>

		<header>Registration</header>
		<form id="registrationForm" method="post">

			<div class="partition">
				<div class="p1">
					<label>Full Name<span class="star">*</span>:
					</label> <input type="text" placeholder="Enter your full name" name="fn"
						id="fn" required> <label>Designation</label> <select name="designation" id="designation" required>
       <option value="">Select designation</option>
      </select> <label>Email<span
						class="star">*</span>:
					</label> <input type="email" placeholder="Enter Email ID" id="email"
						name="email" required> <label>Region<span
						class="star">*</span>:
					</label> <input type="text" placeholder="Enter job location" name="region"
						id="region" required>
				</div>

				<div class="p2">
					<label for="travelPlan">Select your Travel plan <span
						class="star">*</span> :
					</label> <select name="travelPlan" id="travelPlan" required>
						<option value="A">A</option>
						<option value="B">B</option>
						<option value="C">C</option>
					</select> <label>Employee Code<span class="star">*</span>:
					</label> <input type="number" placeholder="Enter employee code" name="EC"
						id="EC" required> <label for="password">Password <span
						class="star">*</span> :
					</label> <input type="password" id="password" name="password"
						placeholder="Enter your password" pattern="^[0-9]{1,6}$" required
						title="Password must be of 6 digits"> <label
						for="repassword" id="retype-paasword">Re-type Password <span
						class="star">*</span> :
					</label> <input type="password" id="repassword" name="repassword"
						placeholder="Re-Enter your password" required>
				</div>

			</div>
			<button type="submit" onclick="solve()">Submit</button>
		</form>
		<div style="text-align: center;">
			<p>
				Already a member? <a href="login.jsp">Login</a>
			</p>
		</div>
	</div>
	<script src="js/register1.js"></script>


</body>
</html>