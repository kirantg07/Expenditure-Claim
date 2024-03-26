package com;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

@WebServlet("/DesignationAction")
public class DesignationAction extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String JSON_FILE_PATH = "C:\\Users\\KiranTG\\Downloads\\ExpenditureReimburse 1\\ExpenditureReimburse\\src\\main\\webapp\\designation.json";

    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        String designation = request.getParameter("designation");

        JSONObject jsonResponse = new JSONObject();
        JSONArray designationArray = readDesignationsFromJsonFile();

        if (isDesignationAdded(designationArray, designation)) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Designation already exists.");
        } else {
            // update designation data
            designationArray.add(designation);
            writeDesignationsToJsonFile(designationArray);

            jsonResponse.put("success", true);
            jsonResponse.put("message", "Added successfully!");
        }
        out.println(jsonResponse.toJSONString());
    }

    public JSONArray readDesignationsFromJsonFile() {
        JSONArray designationArray = new JSONArray();
        Path path = Paths.get(JSON_FILE_PATH);

        if (Files.exists(path)) {
            try {
                String jsonContent = Files.readString(path);
                JSONParser parser = new JSONParser();
                designationArray = (JSONArray) parser.parse(jsonContent);
            } catch (IOException | ParseException e) {
                e.printStackTrace();
            }
        }

        return designationArray;
    }

    private boolean isDesignationAdded(JSONArray designationArray, String designation) {
        Set<String> existingDesignations = new HashSet<>();
        
        for (Object obj : designationArray) {
            existingDesignations.add((String) obj);
        }
        
        return existingDesignations.contains(designation);
    }

    private void writeDesignationsToJsonFile(JSONArray designationArray) {
        Path path = Paths.get(JSON_FILE_PATH);

        try {
            if (!Files.exists(path)) {
                Files.createFile(path);
            }

            // Write designation data to JSON file
            Files.writeString(path, designationArray.toJSONString());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
