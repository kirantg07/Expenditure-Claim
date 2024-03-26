package com;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/checkBillNo")
public class checkBillNoServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	private JSONObject expenseData;

	@Override
	public void init() throws ServletException {
		// Load JSON data during servlet initialization
		String filePath = "C:\\Users\\KiranTG\\Downloads\\ExpenditureReimburse 1\\ExpenditureReimburse\\src\\main\\webapp\\table.json";
		JSONParser parser = new JSONParser();

		try (FileReader reader = new FileReader(filePath)) {
			expenseData = (JSONObject) parser.parse(reader);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();

		// Retrieve billNo parameter from the request
		String billNoToCheck = request.getParameter("billNo");

		if (billNoToCheck != null) {
			// Check if billNo is unique
			boolean isUnique = isUniqueBillNo(billNoToCheck);

			out.println("<html><body>");
			if (isUnique) {
				out.println("BillNo '" + billNoToCheck + "' is unique.");
			} else {
				out.println("BillNo '" + billNoToCheck + "' is not unique.");
			}
			out.println("</body></html>");
		} else {
			out.println("Please provide a billNo parameter in the URL.");
		}
	}

	// Check if a given billNo is unique across all arrays
	private boolean isUniqueBillNo(String billNo) {
		for (Object key : expenseData.keySet()) {
			JSONArray expenseItems = (JSONArray) expenseData.get(key);
			for (Object item : expenseItems) {
				JSONObject expenseItem = (JSONObject) item;
				if (billNo.equals(expenseItem.get("billNo"))) {
					return false; // billNo is not unique
				}
			}
		}
		return true; // billNo is unique
	}
}
