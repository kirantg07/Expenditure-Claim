package com;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

@WebServlet("/ForgotUpdateServlet")
public class ForgotUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String newPassword = request.getParameter("updatepassword");

        // Validate new and confirm passwords
        String confirmNewPassword = request.getParameter("confirm_update");
        
        if (!newPassword.equals(confirmNewPassword)) {
            response.sendRedirect("UpdatePassword.jsp?error=New and confirm passwords do not match");
            return;
        }

        try {
            // Read users from JSON file
            JSONObject users = readUsersFromJsonFile();

            // Check if the user with the given email exists
            if (doesUserExist(users, email)) {
                // Update password for the user with the given email
                updateUserPassword(users, email, newPassword);

                // Write updated users back to JSON file
                writeUsersToJsonFile(users);

                // Redirect to a success page
                response.sendRedirect("index.jsp");
            } else {
                // Redirect with an error if the user doesn't exist
                response.sendRedirect("UpdatePassowrd.jsp?error=User with email not found");
            }
        } catch (ParseException e) {
            e.printStackTrace();
            response.sendRedirect("UpdatePassowrd.jsp?error=Error updating password");
        }
    }

    // Helper method to read users from JSON file
    private JSONObject readUsersFromJsonFile() throws ParseException, IOException {
        Path path = Paths.get("C:\\Users\\KiranTG\\Downloads\\ExpenditureReimburse 1\\ExpenditureReimburse\\src\\main\\webapp\\users.json");
        byte[] jsonData = Files.readAllBytes(path);
        String content = new String(jsonData, "UTF-8");
        JSONParser parser = new JSONParser();
        return (JSONObject) parser.parse(content);
    }

    // Helper method to check if a user with the given email exists
    private boolean doesUserExist(JSONObject users, String email) {
        for (Object key : users.keySet()) {
            JSONObject user = (JSONObject) users.get(key);
            if (email.equals(user.get("email"))) {
                return true;
            }
        }
        return false;
    }

    // Helper method to update user password in the JSON object
    private void updateUserPassword(JSONObject users, String email, String newPassword) {
        for (Object key : users.keySet()) {
            JSONObject user = (JSONObject) users.get(key);
            if (email.equals(user.get("email"))) {
                user.put("password", newPassword);
                return;
            }
        }
    }

    // Helper method to write users back to JSON file
    private void writeUsersToJsonFile(JSONObject users) throws IOException {
        Path path = Paths.get("C:\\Users\\KiranTG\\Downloads\\ExpenditureReimburse 1\\ExpenditureReimburse\\src\\main\\webapp\\users.json");
        Files.write(path, users.toJSONString().getBytes());
    }
}