
<%
    // Clear session, invalidate session, redirect, etc.
    session.invalidate();
response.sendRedirect("login.jsp");
%>

