package com;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

@WebServlet("/EmployeeListManagerAction")
public class EmployeeListManagerAction extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();

		String[] userIdArray = request.getParameterValues("userIdArray[]");
		String[] reportingManagerArray = request.getParameterValues("reportingManagerArray[]");

		for (String id : userIdArray) {
			System.out.println("UserId is " + id);
		}

		for (String manager : reportingManagerArray) {
			System.out.println("Reporting manger is  " + manager);
		}

		// Update JSON file with new user type
		updateJsonFile(userIdArray, reportingManagerArray);

		String contextPath = request.getContextPath();
		response.sendRedirect(contextPath + "/EmployeeList1.jsp");
	}

	private void updateJsonFile(String[] userIdArray, String[] userTypeArray) {
		try {
			// Path to your JSON file
			String filePath = "C:\\Users\\KiranTG\\Downloads\\ExpenditureReimburse 1\\ExpenditureReimburse\\src\\main\\webapp\\users.json";

			Path path = Paths.get(filePath);

			// Read JSON content from file
			String jsonContent = Files.readString(path);
			JSONParser parser = new JSONParser();
			JSONObject users = (JSONObject) parser.parse(jsonContent);

			// Update user types for each user ID
			for (int i = 0; i < userIdArray.length; i++) {
				String userId = userIdArray[i];
				String userType = userTypeArray[i];

				JSONObject userData = (JSONObject) users.get(userId);
				userData.put("Approving Authority", userType);
			}

			// Write updated content back to the file
			Files.writeString(path, users.toJSONString());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
