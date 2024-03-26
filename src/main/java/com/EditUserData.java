
package com;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.lang.reflect.Executable;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
/*import java.text.ParseException;*/
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

@WebServlet("/EditUserData")
public class EditUserData extends HttpServlet {
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

		System.out.println("fn and EC is " + fn + " : " + EC);

		JSONObject jsonResponse = new JSONObject();

		JSONObject expenseData = readUsersFromJsonFile();

		String slNo = request.getParameter("slNo");
		String particulars = request.getParameter("particulars");
		String billNo = request.getParameter("billNo");
		String billDate = request.getParameter("billDate");
		String uploadBill = request.getParameter("uploadBill");
		String managerApproval = request.getParameter("managerApproval");
		String reclaimedDate = request.getParameter("reclaimedDate");
		String amount = request.getParameter("amount");
		String id = request.getParameter("id");
		String claimedDate = request.getParameter("claimedDate");
		String updatedDate = request.getParameter("updatedDate");

		System.out.println("id is " + id);
		
		for (Object key : expenseData.keySet()) {
			System.out.println("Inside  for statement : " + key);

			if (EC.equals(key.toString())) {
				System.out.println("Inside if statement");
				JSONArray expenseItems = (JSONArray) expenseData.get(key);
				System.out.println("Outside if statemnt");
				for (Object item : expenseItems) {
					JSONObject expenseItem = (JSONObject) item;
//	                System.out.println("Expense items is " + expenseItem);
					if (id.equals(expenseItem.get("id"))) {
						System.out.println("Inside the loop edit ");
						expenseItem.put("slNo", slNo);
						expenseItem.put("particulars", particulars);
						expenseItem.put("billNo", billNo);
						expenseItem.put("billDate", billDate);
						expenseItem.put("uploadBill", uploadBill);
						expenseItem.put("managerApproval", managerApproval);
						expenseItem.put("reclaimedDate", reclaimedDate);
						expenseItem.put("amount", amount);
						expenseItem.put("claimedDate", claimedDate);
						expenseItem.put("updatedDate", updatedDate);
						System.out.println("outside the loop edit ");
					}
				}
			}

		}

		sortJsonDataByClaimedDate(expenseData, EC);
		// Save the modified data back to the file
		saveExpenseData(expenseData, JSON_FILE_PATH);

		// setting Json response
		jsonResponse.put("success", true);
		jsonResponse.put("message", "Registration successful!");

		// sending JSON response
		out.println(jsonResponse.toJSONString());

		// Your code here
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
			}
		}

	}

	private void saveExpenseData(JSONObject expenseData, String jsonFilePath) {
		try (FileWriter fileWriter = new FileWriter(jsonFilePath)) {
			fileWriter.write(expenseData.toJSONString());
		} catch (IOException e) {
			e.printStackTrace();
		}

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

}
