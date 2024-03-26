package com;

import java.io.IOException;
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
import org.json.simple.parser.JSONParser;

@WebServlet("/DemoManager")
public class DemoManager extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String JSON_FILE_PATH = "C:\\Users\\KiranTG\\Downloads\\ExpenditureReimburse 1\\ExpenditureReimburse\\src\\main\\webapp\\table.json";

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		System.out.println("Demo manager servlet is being called");
		PrintWriter out = response.getWriter();

		JSONObject info = readUsersFromJsonFile();
		List<JSONObject> sortedData = sortJsonDataByClaimedDate(info);

		// Set the sorted data in the request attribute
		request.setAttribute("sortedData", sortedData);

		// Forward the request to the appropriate JSP page
		String pageType = request.getParameter("pageType");
		request.getRequestDispatcher(pageType + ".jsp").forward(request, response);
	}

	// Implement the common sorting logic
	private List<JSONObject> sortJsonDataByClaimedDate(JSONObject info) {
		List<JSONObject> allObjects = new ArrayList<>();

		for (Object key : info.keySet()) {
			JSONArray expenseItems = (JSONArray) info.get(key);
			for (Object obj : expenseItems) {
				allObjects.add((JSONObject) obj);
			}
		}

		// Sort allObjects based on claimedDate or reclaimedDate or updatedDate
		Collections.sort(allObjects, new Comparator<JSONObject>() {
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
				} catch (ParseException e) {
					e.printStackTrace();
				}
				return 0; // Default comparison result
			}
		});

		return allObjects;
	}

	// Implement the method to read JSON data from the file
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
}
