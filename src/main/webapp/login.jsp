<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="css/style 1.css">
<title>Login</title>
<script>
	function displayErrorMessage(message) {
		document.getElementById("errormessage").innerText = message;
		setTimeout(function() {
			document.getElementById("errormessage").innerText = "";
		}, 3000);
	}
	function preventBack() {
        window.history.forward();
    }
    setTimeout("preventBack()", 0);
    window.onunload = function () {
        null;
    };
</script>
</head>
<body>
	<div class="login-container">
		<h4 id="errormessage"></h4>
		<div id="successMessage" style="text-align: left; color: green;">
			<%
			String successMessage = (String) request.getParameter("success");
			if (successMessage != null && !successMessage.isEmpty()) {
			%>
			<h4 style="color: green;"><%=successMessage%></h4>
			<%
			}
			%>
		</div>
		<div class="imageContainer">
			<img src="assets/images/eds.png" style="height: 50px; width: auto;">
		</div>
		<h2>Login</h2>

		<form method="post" id="loginform" action="LoginAction">
			<label for="email">Email:</label> <input type="email" id="email"
				name="email" required> <label for="password">Password:</label>
			<input type="password" id="password" name="password" required>

			<button type="submit">Login</button>

			<p>
				Don't have an account? <a href="register.jsp">Register</a>
			</p>
		</form>
		
	</div>
	<script src="js/register1.js"></script>
</body>
</html>