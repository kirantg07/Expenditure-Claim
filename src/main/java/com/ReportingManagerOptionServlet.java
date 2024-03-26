
package com;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

@WebServlet("/ReportingManagerOptionServlet")
public class ReportingManagerOptionServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();

		// Path to your JSON file
		String filePath = "C:\\Users\\KiranTG\\Downloads\\ExpenditureReimburse 1\\ExpenditureReimburse\\src\\main\\webapp\\users.json";

		// Read JSON content from file
		String jsonContent = Files.readString(Paths.get(filePath));

		// Parse JSON data
		JSONParser parser = new JSONParser();
		try {
			JSONObject users = (JSONObject) parser.parse(jsonContent);

			// Build options for the "Reporting Manager" dropdown based on users with
			// "Approving Authority" role
			String options = new String();
			for (Object userId : users.keySet()) {
				JSONObject userData = (JSONObject) users.get(userId);
				if ("Approving Authority".equals(userData.get("userType"))) {
					String fullName = (String) userData.get("fn") + ",";
					System.out.println("Approving authority matched: " + fullName);
					options += fullName;
				}
			}
			options = options.replaceFirst(",\\s*$", "");
			System.out.println(options);
			// Send options as response
			out.println(options.toString());

		} catch (Exception e) {
			e.printStackTrace();
			out.println("Error occurred while processing the JSON file.");
		}
	}

}