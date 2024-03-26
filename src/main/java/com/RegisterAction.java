
package com;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

@WebServlet("/RegisterAction")
public class RegisterAction extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static final String JSON_FILE_PATH = "C:\\Users\\KiranTG\\Downloads\\ExpenditureReimburse 1\\ExpenditureReimburse\\src\\main\\webapp\\users.json";

	@SuppressWarnings("unchecked")
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();

		String email = request.getParameter("email");
		String fn = request.getParameter("fn");
		String EC = request.getParameter("EC");
		String designation = request.getParameter("designation");
		String department = request.getParameter("department");
		String region = request.getParameter("region");
		String password = request.getParameter("password");
		String travelPlan = request.getParameter("travelPlan");

		JSONObject jsonResponse = new JSONObject();
		JSONObject users = readUsersFromJsonFile();

		if (isECRegistered(users, EC)) {
			jsonResponse.put("success", false);
			jsonResponse.put("message", "User already exists.");
		} else if (isEmailRegistered(users, email)) {
			jsonResponse.put("success", false);
			jsonResponse.put("message", "Email is already registered. Please use a different email.");
		} else {
			// update user data
			JSONObject userInfoJson = new JSONObject();
			userInfoJson.put("fn", fn);
			userInfoJson.put("email", email);
			userInfoJson.put("EC", EC);
			userInfoJson.put("designation", designation);
//    	   userInfoJson.put("department", department);
			userInfoJson.put("region", region);
			userInfoJson.put("password", password);
			userInfoJson.put("travelPlan", travelPlan);
			userInfoJson.put("userType", "User");
			userInfoJson.put("status", "0");
			userInfoJson.put("Approving Authority", "None");

			users.put(fn, userInfoJson);
			writeUsersToJsonFile(users);

//    	   writeUsersToJsonFile(users);

			jsonResponse.put("success", true);
			jsonResponse.put("message", "Registration successful!");
		}
		out.println(jsonResponse.toJSONString());
	}

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

	private boolean isEmailRegistered(JSONObject users, String email) {
		for (Object user : users.values()) {
			if (user instanceof JSONObject) {
				String userEmail = ((JSONObject) user).get("email").toString();
				if (userEmail.equals(email)) {
					return true;
				}
			}
		}
		return false;
	}

	private boolean isECRegistered(JSONObject users, String emplCode) {
		for (Object user : users.values()) {
			if (user instanceof JSONObject) {
				String EC = ((JSONObject) user).get("EC").toString();
				if (EC.equals(emplCode)) {
					return true;
				}
			}
		}
		return false;
	}

	private void writeUsersToJsonFile(JSONObject users) {
		Path path = Paths.get(JSON_FILE_PATH);

		try {
			if (!Files.exists(path)) {
				Files.createFile(path);
			}

			// Write user data to JSON file
			Files.writeString(path, users.toJSONString());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
