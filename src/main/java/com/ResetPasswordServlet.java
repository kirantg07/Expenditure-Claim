package com;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Retrieve the OTP from the session
		HttpSession session = request.getSession();
		Integer storedOTP = (Integer) session.getAttribute("otp");
		String email = request.getParameter("email");

		// Retrieve the OTP entered by the user
		String enteredOTPString = request.getParameter("otp");
		int enteredOTP = -1; // Default value, indicating no OTP entered

		if (enteredOTPString != null && !enteredOTPString.isEmpty()) {
			enteredOTP = Integer.parseInt(enteredOTPString);
		}

		// Compare the entered OTP with the stored OTP
		if (storedOTP != null && enteredOTP == storedOTP) {
			// If OTPs match, proceed to the password update page
			session.setAttribute("email", email);
			response.sendRedirect("UpdatePassowrd.jsp");
		} else {
			// If OTPs do not match, show an error message
			response.sendRedirect("ResetPassword.jsp?error=Invalid OTP. Please try again.");
		}
	}
}
