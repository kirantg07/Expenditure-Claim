//createAction.java

package com;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

@WebServlet("/createAction")
public class createAction extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String JSON_FILE_PATH = "C:\\Users\\KiranTG\\Downloads\\ExpenditureReimburse 1\\ExpenditureReimburse\\src\\main\\webapp\\table.json";

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();

		// Session attributes fetched
		HttpSession session = request.getSession();
		String sessionId = session.getId();

		Object fn = session.getAttribute("fn");
		Object EC = session.getAttribute("EC");

		JSONObject jsonResponse = new JSONObject();
		JSONObject info;

		try {
			// Get the JSON data from the request body
			StringBuilder requestData = new StringBuilder();
			try (BufferedReader reader = new BufferedReader(new InputStreamReader(request.getInputStream()))) {
				String line;
				while ((line = reader.readLine()) != null) {
					requestData.append(line);
				}
			}

			// Read existing data from JSON file
			info = readUsersFromJsonFile();

			// Get unique IDs from existing data
			Set<String> uniqueId = idFun(info);

			// Converting the raw Json data into Json array
			JSONArray newDataArray = (JSONArray) JSONValue.parse(requestData.toString());

			// Generate unique ID for each row in newDataArray
			for (Object entry : newDataArray) {
				JSONObject row = (JSONObject) entry;
				String formId = generateUniqueFormId(uniqueId, info);
				row.put("id", formId);
				uniqueId.add(formId); // Add the generated ID to ensure uniqueness
			}

			// Append new data or create a new entry for EC
			appendDataToJsonFile(info, EC.toString(), newDataArray.toString());

			// Redirect after successful processing
			jsonResponse.put("success", true);
			jsonResponse.put("message", "Submitted successfully!");
			response.getWriter().write(jsonResponse.toJSONString());

			// checking if billNo unique or not
			/*
			 * List<String> duplicateBillNos = findDuplicateBillNos(newDataArray, info); if
			 * (!duplicateBillNos.isEmpty()) { String duplicateBillNosString =
			 * String.join(", ", duplicateBillNos); jsonResponse.put("success", false);
			 * jsonResponse.put("message", "Error: Duplicate BillNos found - " +
			 * duplicateBillNosString);
			 * response.getWriter().write(jsonResponse.toJSONString()); } else { // Append
			 * new data or create a new entry for EC appendDataToJsonFile(info,
			 * EC.toString(), newDataArray.toString());
			 * 
			 * // Redirect after successful processing jsonResponse.put("success", true);
			 * jsonResponse.put("message", "Submitted successfully!");
			 * response.getWriter().write(jsonResponse.toJSONString()); }
			 */
		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"error\": \"Internal Server Error\"}");

		}
	}

	private Set<String> idFun(JSONObject info) {
		Set<String> uniqueId = new HashSet<>();

		for (Object key : info.keySet()) {
			JSONArray expenseItems = (JSONArray) info.get(key);
			for (Object item : expenseItems) {
				JSONObject expenseItem = (JSONObject) item;
				String existingId = (String) expenseItem.get("id");

				uniqueId.add(existingId);
			}
		}
		return uniqueId;
	}

	private String generateUniqueFormId(Set<String> uniqueId, JSONObject info) {
		String formId;
		do {
			formId = UUID.randomUUID().toString();
		} while (uniqueId.contains(formId));

		return formId;
	}

	private void appendDataToJsonFile(JSONObject info, String key, String newData) {
		if (info.containsKey(key)) {
			// If the key already exists, append the new data to the existing array
			JSONArray existingDataArray = (JSONArray) info.get(key);
			JSONArray newDataArray = (JSONArray) JSONValue.parse(newData);
			existingDataArray.addAll(newDataArray);
		} else {
			// If the key doesn't exist, create a new array with the new data
			JSONArray newDataArray = (JSONArray) JSONValue.parse(newData);
			info.put(key, newDataArray);
		}

		writeUsersToJsonFile(info);
	}

	private void writeUsersToJsonFile(JSONObject info) {
		Path path = Paths.get(JSON_FILE_PATH);

		try {
			if (!Files.exists(path)) {
				Files.createFile(path);
			}
			// Write user data to JSON file
			Files.writeString(path, info.toJSONString());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private JSONObject readUsersFromJsonFile() {
		JSONObject info = new JSONObject();
		Path path = Paths.get(JSON_FILE_PATH);

		if (Files.exists(path)) {
			try {
				String jsonContent = Files.readString(path);
				JSONParser parser = new JSONParser();
				info = (JSONObject) parser.parse(jsonContent);
			} catch (IOException | ParseException e) {
				e.printStackTrace();
			}
		}
		return info;
	}

	private List<String> findDuplicateBillNos(JSONArray newDataArray, JSONObject info) {
		Set<String> uniqueBillNos = new HashSet<>();
		List<String> duplicateBillNos = new ArrayList<>();

		for (Object key : info.keySet()) {
			JSONArray expenseItems = (JSONArray) info.get(key);
			for (Object item : expenseItems) {
				JSONObject expenseItem = (JSONObject) item;
				String existingBillNo = (String) expenseItem.get("billNo");
				uniqueBillNos.add(existingBillNo);
			}
		}

		for (Object entry : newDataArray) {
			JSONObject row = (JSONObject) entry;
			String billNo = (String) row.get("billNo");
			if (uniqueBillNos.contains(billNo)) {
				// BillNo is not unique
				duplicateBillNos.add(billNo);
			}
		}

		return duplicateBillNos;
	}

}
