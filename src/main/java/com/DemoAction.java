package com;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.json.simple.parser.JSONParser;

@WebServlet("/DemoAction")
public class DemoAction extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String JSON_FILE_PATH = "C:\\Users\\KiranTG\\Downloads\\ExpenditureReimburse 1\\ExpenditureReimburse\\src\\main\\webapp\\table.json";

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("Demo action is getting called ");
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

			// Read existing data from JSON file
			info = readUsersFromJsonFile();
			/* System.out.println("Existing JSON Data: " + info.toJSONString()); */

			// Redirect after successful processing
			sortJsonDataByClaimedDate(info, EC);
			System.out.println(info);
			writeUsersToJsonFile(info);
			jsonResponse.put("success", true);
			jsonResponse.put("message", "Submitted successfully!");
			response.getWriter().write(jsonResponse.toJSONString());

		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"error\": \"Internal Server Error\"}");

		}
	}

	@SuppressWarnings("unchecked")
	private void sortJsonDataByClaimedDate(JSONObject info, Object EC) {
		for (Object key : info.keySet()) {
			if (key.equals(EC)) {
				JSONArray expenseItems = (JSONArray) info.get(key);

				// Sort expenseItems based on reclaimedDate if not empty, otherwise use
				// claimedDate
				Collections.sort(expenseItems, new Comparator<JSONObject>() {
					@Override
					public int compare(JSONObject o1, JSONObject o2) {
						String reclaimedDate1 = (String) o1.get("reclaimedDate");
						String reclaimedDate2 = (String) o2.get("reclaimedDate");
						String claimedDate1 = (String) o1.get("claimedDate");
						String claimedDate2 = (String) o2.get("claimedDate");

						String updatedDate1 = (String) o1.get("updatedDate");
						String updatedDate2 = (String) o2.get("updatedDate");

						return compareDates(updatedDate1, updatedDate2);

						/*
						 * if (!reclaimedDate1.isEmpty() && !reclaimedDate2.isEmpty()) { return
						 * compareDates(reclaimedDate1, reclaimedDate2); } else if
						 * (!reclaimedDate1.isEmpty()) { // return -1; // o1 should come before o2
						 * return compareDates(reclaimedDate1, claimedDate2); } else if
						 * (!reclaimedDate2.isEmpty()) { // return 1; // o2 should come before o1 return
						 * compareDates(claimedDate1, reclaimedDate2); } else { return
						 * compareDates(claimedDate1, claimedDate2); }
						 */

					}

					// Utility method to compare dates
					private int compareDates(String date1, String date2) {
						SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy HH:mm:ss", Locale.ENGLISH);
						try {
							Date parsedDate1 = sdf.parse(date1);
							Date parsedDate2 = sdf.parse(date2);
							return parsedDate1.compareTo(parsedDate2);
						} catch (ParseException e) {
							e.printStackTrace();
						}
						return 0; // Default comparison result
					}
				});
			}
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
			} catch (IOException | org.json.simple.parser.ParseException e) {
				e.printStackTrace();
			}
		}
		return info;
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

}
