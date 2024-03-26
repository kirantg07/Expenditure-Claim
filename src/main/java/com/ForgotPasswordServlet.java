package com;

import java.io.IOException;	
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Properties;
import java.util.Random;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        RequestDispatcher dispatcher=null;
        int otpvalue=0;
        HttpSession mysession=request.getSession();

        try {
            JSONObject users = readUsersFromJsonFile();

            JSONObject user = getUserByEmail(email);

            if (user != null) {
                // If user is found, generate and send OTP along with the message
            	Random rand=new Random();
            	otpvalue=rand.nextInt(900000) + 100000; // Generate a 6-digit OTP
            	
            	String to=email;
            	
            	Properties props = new Properties();
            	props.put("mail.smtp.host", "smtp.office365.com");
            	props.put("mail.smtp.port", "587");
            	props.put("mail.smtp.auth", "true");
            	props.put("mail.smtp.starttls.enable", "true");
            	props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            	props.put("mail.smtp.ssl.cipherSuites", "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA");

            	Session session = Session.getInstance(props,
            	    new javax.mail.Authenticator() {
            	        protected PasswordAuthentication getPasswordAuthentication() {
            	            return new PasswordAuthentication("sagar.blr@edstechnologies.com", "Be$Qx%Y2");
            	        }
            	    });
                
                try {
                    MimeMessage message = new MimeMessage(session);
                    message.setFrom(new InternetAddress("sagar.blr@edstechnologies.com", "Sagar M A"));
                    message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
                    message.setSubject("Your OTP for Password Reset");

                    message.setText("Your OTP for password reset is: " + otpvalue + "\n\nTesting.......");
                    Transport.send(message);

                    mysession.setAttribute("otp", otpvalue);

                    String url = "ResetPassword.jsp?email=" + URLEncoder.encode(email, "UTF-8");
                    System.out.println(email);
                    response.sendRedirect(url);

                } catch (MessagingException e) {
                    throw new RuntimeException(e);
                }
            } else {
                // If user is not found, show error message
                response.sendRedirect("ForgotPassword.jsp?error=Invalid Email Address");
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }

    // Helper method to read users from JSON file
    private JSONObject readUsersFromJsonFile() throws ParseException {
        JSONObject users = new JSONObject();
        Path path = Paths.get("C:\\Users\\KiranTG\\Downloads\\ExpenditureReimburse 1\\ExpenditureReimburse\\src\\main\\webapp\\users.json");

        if (Files.exists(path)) {
            try {
                String jsonContent = Files.readString(path);
                JSONParser parser = new JSONParser();
                users = (JSONObject) parser.parse(jsonContent);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        return users;
    }

    // Helper method to get user by email
    private JSONObject getUserByEmail(String email) throws ParseException {
        JSONObject users = readUsersFromJsonFile();

        for (Object userKey : users.keySet()) {
            String username = (String) userKey;
            JSONObject userObject = (JSONObject) users.get(username);
            String storedEmail = (String) userObject.get("email");

            if (storedEmail != null && storedEmail.equals(email)) {
                return userObject;
            }
        }

        return null; // User not found or email doesn't match
    }
}
