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

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;


@WebServlet("/SortAmount")
public class SortAmount extends HttpServlet {
	 private static final long serialVersionUID = 1L;
	    private static final String JSON_FILE_PATH = "C:\\Users\\KiranTG\\Downloads\\ExpenditureReimburse 1\\ExpenditureReimburse\\src\\main\\webapp\\table.json";
	    
	    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	        response.setContentType("text/html;charset=UTF-8");
	        System.out.println("Sort amount servlet is being called");
	        PrintWriter out = response.getWriter();

	        JSONObject info = readUsersFromJsonFile();
	        List<JSONObject> sortedData = sortJsonDataByAmount(info);

	        // Set the sorted data in the request attribute
			
			  request.setAttribute("sortedData", sortedData);
			  
			  // Forward the request to the appropriate JSP page 
			  String pageType =request.getParameter("pageType"); 
       		  request.getRequestDispatcher(pageType +".jsp").forward(request, response);
//			  request.getRequestDispatcher("managerReview.jsp").forward(request, response);
			 
	        System.out.println("Sorted data by amount " + sortedData);
	    }

	    // Implement the common sorting logic
	    private List<JSONObject> sortJsonDataByAmount(JSONObject info) {
	        List<JSONObject> allObjects = new ArrayList<>();

	        for (Object key : info.keySet()) {
	            JSONArray expenseItems = (JSONArray) info.get(key);
	            for (Object obj : expenseItems) {
	                allObjects.add((JSONObject) obj);
	            }
	        }

            // Sort expenseItems based on amount
            Collections.sort(allObjects, new Comparator<JSONObject>() {
                @Override
                public int compare(JSONObject o1, JSONObject o2) {
                    String amount1 = (String) o1.get("amount");
                    String amount2 = (String) o2.get("amount");
                    
                    String amount1WithoutComma = amount1.replace(",", "");
                    String amount2WithoutComma = amount2.replace(",", "");
                    
                    // Parse amount strings to floats
                    float floatAmount1 = Float.parseFloat(amount1WithoutComma);
                    float floatAmount2 = Float.parseFloat(amount2WithoutComma);
                    
                    // Compare floats
                    if (floatAmount1 < floatAmount2) {
                        return -1;
                    } else if (floatAmount1 > floatAmount2) {
                        return 1;
                    } else {
                        return 0;
                    }
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
