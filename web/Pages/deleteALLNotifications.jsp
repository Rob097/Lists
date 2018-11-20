<%-- 
    Document   : deleteALLNotifications
    Created on : 20-nov-2018, 14.44.56
    Author     : della
--%>

<%@page import="database.entities.User"%>
<%@page import="database.jdbc.JDBCNotificationsDAO"%>
<%@page import="database.daos.NotificationDAO"%>
<%@page import="database.factories.DAOFactory"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession s = (HttpSession) request.getSession(false);
    DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
    if (daoFactory == null) {
        throw new ServletException("Impossible to get dao factory for user storage system");
    }
    NotificationDAO notificationdao = new JDBCNotificationsDAO(daoFactory.getConnection());
    User user = new User();
    
    if(s.getAttribute("user") != null){
        user = (User) s.getAttribute("user");
        notificationdao.deleteALLNotification(user.getEmail());
%>
    <h4>Non ci sono notifiche!</h4>
<%}%>