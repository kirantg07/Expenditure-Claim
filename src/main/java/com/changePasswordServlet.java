package com;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

@WebServlet("/changePasswordServlet")
public class changePasswordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String JSON_FILE_PATH = "C:\\Users\\KiranTG\\Downloads\\ExpenditureReimburse 1\\ExpenditureReimburse\\src\\main\\webapp\\users.json";

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		String employeeName = (String) session.getAttribute("fn");
		String oldPassword = request.getParameter("oldPassword");
		Object registeredPassword = session.getAttribute("userPassword");
		String newPassword = request.getParameter("newPassword");
		String confirmNewPassword = request.getParameter("confirmNewPassword");

		try {
			JSONObject users = readUsersFromJsonFile();

//            JSONObject registeredPassword =  (JSONObject) users.get(employeeName);
			System.out.println("Registered password is " + registeredPassword);
			System.out.println("Old password is " + oldPassword);
			for (Object user : users.values()) {
				if (user instanceof JSONObject) {
					Object nameObject = ((JSONObject) user).get("fn");
					if (nameObject != null && nameObject.equals(employeeName)) {
						if (registeredPassword.toString() != null) {
							if (registeredPassword.equals(oldPassword)) {
								if (newPassword.equals(confirmNewPassword)) {
									JSONObject userObj = (JSONObject) user;
									userObj.put("password", newPassword);
									writeUsersToJsonFile(users);
									session.invalidate();
									response.sendRedirect(
											"login.jsp?success=Password changed successfully. Login with your new Password");
									return;

								} else {
									response.sendRedirect(
											"changePassword.jsp?error=New password and confirm password must match.");
									return;
								}
							} else {
								response.sendRedirect("changePassword.jsp?error=Old password is incorrect.");
								return;
							}
						} else {
							response.sendRedirect("changePassword.jsp?error=user_not_found");
							return;
						}
					}
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("changePassword.jsp?error=change_password_failed");
		}
	}

	public JSONObject readUsersFromJsonFile() throws IOException, ParseException {
		Path path = Paths.get(JSON_FILE_PATH);
		JSONObject users = new JSONObject();

		if (Files.exists(path)) {
			String jsonContent = Files.readString(path);
			JSONParser parser = new JSONParser();
			users = (JSONObject) parser.parse(jsonContent);
		} else {
			// Handle file not found scenario
			throw new IOException("JSON file not found");
		}

		return users;
	}

	private void writeUsersToJsonFile(JSONObject users) throws IOException {
		Path path = Paths.get(JSON_FILE_PATH);

		if (!Files.exists(path)) {
			Files.createFile(path);
		}

		// Write user data to JSON file
		Files.writeString(path, users.toJSONString());
	}
}
