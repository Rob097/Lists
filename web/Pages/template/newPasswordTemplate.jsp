<%-- 
    Document   : newPasswordTemplate
    Created on : 28-nov-2018, 10.59.32
    Author     : della
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
        <div class="modal-header">

            <div class="page-title">
                <div class="container">
                    <h1>Nuova password</h1>
                </div>
                <!--end container-->
            </div>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>            

        </div>
        <div class="modal-body">
            <h5>Nuova passworrd per <%=request.getParameter("restorePasswordOf")%></h5>
            <!-- Form per il login -->
            <form class="form clearfix" id="restore-form" action="/Lists/changePassword" method="post" role="form">
                <div class="form-group">
                    <label for="password" class="col-form-label required">Password</label>
                    <input type="password" name="password" id="passwordnew" tabindex="1" class="form-control" placeholder="Password" value="" required>
                    <input type="hidden" name="email" value="<%=request.getParameter("restorePasswordOf")%>">
                </div>
                <!--end form-group-->
                <div class="d-flex justify-content-between align-items-baseline">
                    <button style="float: left;" type="submit" class="btn btn-primary">Recupera password</button>
                    <button style="float: right;" type="button" class="btn btn-secondary" data-dismiss="modal">Chiudi</button>
                </div>
            </form>
        </div>
    </div>
</div>
