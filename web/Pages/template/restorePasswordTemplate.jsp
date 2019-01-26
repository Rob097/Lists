<%-- 
    Document   : restorePasswordTemplate
    Created on : 28-nov-2018, 10.57.00
    Author     : della
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
        <div class="modal-header">

            <div class="page-title">
                <div class="container">
                    <h1>Recupera la password</h1>
                </div>
                <!--end container-->
            </div>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>            

        </div>
        <div class="modal-body">
            <!-- Form per il login -->
            <form class="form clearfix" id="restore-form-temp" action="/Lists/restorePassword" method="post" role="form">
                <div class="form-group">
                    <label for="email" class="col-form-label required">Email</label>
                    <input type="text" name="emailrestore" id="emailrestore" tabindex="1" class="form-control" placeholder="Email" required>
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
