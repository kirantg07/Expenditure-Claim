
package com;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

@WebServlet("/LoginAction")
public class LoginAction extends HttpServlet {
	private static final long serialVersionUID = 1L;
	//private static final String JSON_FILE_PATH= "/WEB-INF/lib/users.json";
	private static final String JSON_FILE_PATH = "C:\\Users\\KiranTG\\Downloads\\ExpenditureReimburse 1\\ExpenditureReimburse\\src\\main\\webapp\\users.json";

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

//        response.setContentType("application/json");
//    	response.setContentType("text/html");

		String email = request.getParameter("email");
		String password = request.getParameter("password");

		System.out.println(email);
		HttpSession session = request.getSession();
		session.setAttribute("email", email);

		//JSONObject users = readUsersFromJsonFile(request.getServletContext().getRealPath(JSON_FILE_PATH));
		JSONObject users = readUsersFromJsonFile();

		if (email != null && email.equals("admin@edstechnologies.com") && password.equals("admin")) {
			RequestDispatcher dispatcher = request.getRequestDispatcher("EmployeeList 1.jsp");
			dispatcher.forward(request, response);
		}

		if (UserAuthenticated(users, email, password, session)) {
			Object fn = session.getAttribute("fn");
			Object EC = session.getAttribute("EC");
			if (fn != null && EC != null) {
				// Authentication successful
//                JSONResponse.put("success", true);
//                JSONResponse.put("message", "Authentication successful!");
//                
				// Set session attributes
//                session.setAttribute("fn", fn);
//                session.setAttribute("EC", EC);
				String userType = (String) session.getAttribute("userType");

				if (userType.equalsIgnoreCase("User")) {
					response.sendRedirect("create.jsp");
				} else if (userType.equalsIgnoreCase("Approving Authority")) {
					response.sendRedirect("DemoManager?pageType=managerReview");

				} else if (userType.equalsIgnoreCase("Finance")) {
					response.sendRedirect("DemoManager?pageType=financeReview");

				} else if (userType.equalsIgnoreCase("Admin")) {
					response.sendRedirect("EmployeeList1.jsp");

				}

			}

		} else {
			// Authentication failed
//            JSONResponse.put("success", false);
//            JSONResponse.put("message", "Authentication failed. Invalid email or password.");
//            
			response.getWriter().write("Invalid email or password");
			response.sendRedirect("login.jsp?error=Invalid%20email%20or%20password");

		}

//        out.println(JSONResponse.toJSONString());
	}

	private boolean UserAuthenticated(JSONObject users, String email, String password, HttpSession session) {
		for (Object user : users.values()) {
			if (user instanceof JSONObject) {
				Object emailObject = ((JSONObject) user).get("email");
				if (emailObject != null && emailObject.equals(email)) {
					Object passwordObject = ((JSONObject) user).get("password");

					if (passwordObject != null) {
						String storedPassword = passwordObject.toString();

						if (storedPassword.equals(password)) {
							Object fn = ((JSONObject) user).get("fn");
							Object EC = ((JSONObject) user).get("EC");
							Object userType = ((JSONObject) user).get("userType");
							Object approvingAuthority = ((JSONObject) user).get("Approving Authority");
							Object designation = ((JSONObject) user).get("designation");
							Object region = ((JSONObject) user).get("region");
							Object travelPlan = ((JSONObject) user).get("travelPlan");
							Object userPassword = ((JSONObject) user).get("password");

							System.out.println("Printing userPassword of json data " + userPassword);
							// Set session attributes
							session.setAttribute("fn", fn);
							session.setAttribute("EC", EC);
							session.setAttribute("userType", userType);
							session.setAttribute("ApprovingAuthority", approvingAuthority);
							session.setAttribute("email", email);
							session.setAttribute("designation", designation);
							session.setAttribute("region", region);
							session.setAttribute("travelPlan", travelPlan);
							session.setAttribute("userPassword", userPassword);

							return true;
						}
					}
				}
			}
		}
		return false;
	}

	/*
	 * private JSONObject readUsersFromJsonFile(String realPath) { JSONObject info =
	 * new JSONObject(); Path path = Paths.get(realPath);
	 * 
	 * if (Files.exists(path)) { try { String jsonContent = Files.readString(path);
	 * JSONParser parser = new JSONParser(); info = (JSONObject)
	 * parser.parse(jsonContent); } catch (IOException | ParseException e) {
	 * e.printStackTrace(); } } return info; }
	 */
	
	
	public JSONObject readUsersFromJsonFile() {
		JSONObject users = new JSONObject();
		Path path = Paths.get(JSON_FILE_PATH);

		if (Files.exists(path)) {
			try {
				String jsonContent = Files.readString(path);
				JSONParser parser = new JSONParser();
				users = (JSONObject) parser.parse(jsonContent);
			} catch (IOException | ParseException e) {
				e.printStackTrace();
			}
		}

		return users;
	}
	 
}