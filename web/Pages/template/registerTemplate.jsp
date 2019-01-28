<%-- 
    Document   : registerTemplate
    Created on : 28-nov-2018, 10.48.53
    Author     : della
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
        <div class="modal-header">
            <div class="page-title">
                <div class="container">
                    <h1>Register</h1>
                </div>
                <!--end container-->
            </div>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
        <div class="modal-body">
            <!-- Form per il login -->
            <form class="form clearfix" id="register-form" action="/Lists/RegisterAction" method="post" enctype="multipart/form-data" onsubmit="return (checkCheckBoxes(this) && validate());">
                <div class="form-group">
                    <label for="email" class="col-form-label">Email</label><span data-toggle="tooltip" title="Usa lettere o numeri + @ + lettere o numeri + . + almeno 2 lettere">i</span>
                    <input type="email" name="email" id="emailRegister" tabindex="1" class="form-control" placeholder="Email" value="" pattern="[A-Za-z0-9.]+@+[A-Za-z0-9.]+\.[a-z]{2,}$" required>
                </div>
                <!--end form-group-->
                <div class="form-group">
                    <label for="nominativo" class="col-form-label">Nome</label>
                    <input type="text" name="nominativo" id="nominativoRegister" tabindex="1" class="form-control" placeholder="Nome" value="" required>
                </div>
                <!--end form-group-->
                <div class="form-group">
                    <label for="password" class="col-form-label">Password</label>
                    <input type="password" name="password" id="passwordRegister" tabindex="2" class="form-control" placeholder="Password" required><br>
                    <label for="pswrt2" class="col-form-label">Conferma Password</label>
                    <input type="password" name="pswrt2" id="pswrt2" tabindex="2" class="form-control" placeholder="Password"  value="${user.password}">
                </div>

                <!--end form-group-->

                <div class="form-group">
                    <label for="image" class="col-form-label required">Avatar</label>
                    <input type="file" name="file1" required>
                </div>
                <!--end form-group-->
                <div class="d-flex justify-content-between align-items-baseline">
                    <div class="form-group text-center" style="display: inline-grid;">
                        <input type="checkbox" tabindex="3" class="" name="standard" id="standard">
                        <label for="standard" style="display: flex;">Standard</label>
                        <input type="checkbox" tabindex="3" class="" name="amministratore" id="amministratore">
                        <label for="amministratore" style="display: flex;">Amministratore</label>
                    </div>
                    <button type="submit" name="register-submit" id="register-submit" tabindex="4" class="btn btn-primary">Register Now</button>
                </div>

                <div class="form-group">
                    Per andare avanti accetta la nostra <a data-toggle="modal" href="#PrivacyModal" class="link">Privacy Policy</a><br>                
                    <label for="privacy">Ho letto e accetto l'informativa sulla Privacy</label>         
                    <input required type="checkbox" tabindex="3" class="" name="privacy" id="privacy">
                </div>
            </form>
            <hr>                                                
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
    </div>
</div>
