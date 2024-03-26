package test;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.net.URLEncoder;

@WebServlet("/modifyManager")
public class ModifyManagerServlet extends HttpServlet {
    private JSONObject expenseData;
    private String filePath = "D:\\eclipse-workspace\\ExpenditureReimburse\\src\\main\\webapp\\table.json";

    @Override
    public void init() throws ServletException {
        loadExpenseData();
    }

    private void loadExpenseData() {
        JSONParser parser = new JSONParser();
        try {
            FileReader reader = new FileReader(filePath);
            expenseData = (JSONObject) parser.parse(reader);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void saveExpenseData() {
        try (FileWriter fileWriter = new FileWriter(filePath)) {
            fileWriter.write(expenseData.toJSONString());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Display the form
        out.println("<html><body>");
        out.println("<h2>Modify Manager</h2>");
        out.println("<form action=\"modifyManager\" method=\"post\">");
        out.println("Bill No: <input type=\"text\" name=\"billNo\" required><br>");
        out.println("New Manager: <input type=\"text\" name=\"newManager\" required><br>");
        out.println("<input type=\"submit\" value=\"Modify Manager\">");
        out.println("</form>");

        out.println("</body></html>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Process form submission
        String billNo = request.getParameter("billNo");
        String newManager = request.getParameter("newManager");
        String message = "";

        if (billNo != null && newManager != null) {
            // Modify manager value based on billNo
            modifyManager(billNo, newManager);
            message = "Manager updated successfully!";
           
        
        }
        // Redirect to the initial form page
        request.setAttribute(newManager, message);
//        RequestDispathcher rd = request.getRequestDispatcher(message);
        response.sendRedirect("modifyManager?message=" + URLEncoder.encode(message, "UTF-8"));
    }

    private void modifyManager(String billNo, String newManager) {
        for (Object key : expenseData.keySet()) {
            JSONArray expenseItems = (JSONArray) expenseData.get(key);
            for (Object item : expenseItems) {
                JSONObject expenseItem = (JSONObject) item;
                if (billNo.equals(expenseItem.get("billNo"))) {
                    // Modify the manager value
                    expenseItem.put("manager", newManager);
                }
            }
        }

        // Save the modified data back to the file
        saveExpenseData();
    }
}
