package com;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
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
import org.json.simple.parser.ParseException;

@WebServlet("/SubmitActionFinance")
public class SubmitActionFinance extends HttpServlet {
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
//            System.out.println(requestData.toString());
			System.out.println("Request Data: " + requestData.toString());

			// Read existing data from JSON file
			info = readUsersFromJsonFile();
			System.out.println("Existing JSON Data: " + info.toJSONString());

			// Converting the raw Json data into Json array
			JSONArray newDataArray = (JSONArray) JSONValue.parse(requestData.toString());
			System.out.println("New Data Array: " + newDataArray.toJSONString());

			updateInformation(newDataArray, info);

			// Redirect after successful processing
			jsonResponse.put("success", true);
			jsonResponse.put("message", "Submitted successfully!");
			response.getWriter().write(jsonResponse.toJSONString());

		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"error\": \"Internal Server Error\"}");

		}
	}

	private void updateInformation(JSONArray newDataArray, JSONObject info) {
		for (Object entry : newDataArray) {
			JSONObject row = (JSONObject) entry;
			String billNumber = (String) row.get("billNo");
			String name = (String) row.get("name");
			String finTeamRemarks = (String) row.get("finTeamRemarks");
			String approvedAmount = (String) row.get("approvedAmount");
			String paymentReference = (String) row.get("paymentReference");
			String settledDate = (String) row.get("settledDate");
			String id = (String) row.get("id");
			String managerApproval = (String) row.get("managerApproval");
			String updatedDate = (String) row.get("updatedDate");

			for (Object key : info.keySet()) {
				JSONArray expenseItems = (JSONArray) info.get(key);
				for (Object item : expenseItems) {
					JSONObject expenseItem = (JSONObject) item;
					if (expenseItem.get("id").toString().equals(id)
							&& expenseItem.get("name").toString().equals(name)) {
						expenseItem.put("finTeamRemarks", finTeamRemarks);
						expenseItem.put("approvedAmount", approvedAmount);
						expenseItem.put("paymentReference", paymentReference);
						expenseItem.put("settledDate", settledDate);
						expenseItem.put("managerApproval", managerApproval);
						expenseItem.put("updatedDate", updatedDate);
						System.out.println("Coming inside the loop");
					}
				}
			}
		}

		System.out.println(info);
		sortJsonDataByClaimedDate(info);
		// Write the updated JSON back to the file
		writeUsersToJsonFile(info);
	}

	@SuppressWarnings("unchecked")
	private void sortJsonDataByClaimedDate(JSONObject info) {
		for (Object key : info.keySet()) {
//            if (key.equals(EC)) {
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
					} catch (java.text.ParseException e) {
						e.printStackTrace();
					}
					return 0; // Default comparison result
				}
			});
//            }
		}
	}

	private void writeUsersToJsonFile(JSONObject info) {
		Path path = Paths.get(JSON_FILE_PATH);

		try (PrintWriter writer = new PrintWriter(path.toFile())) {
			writer.print(info.toJSONString());
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

}
