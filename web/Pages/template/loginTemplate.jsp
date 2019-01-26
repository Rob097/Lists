<%-- 
    Document   : loginTemplate
    Created on : 28-nov-2018, 10.46.49
    Author     : della
--%>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
        <div class="modal-header">

            <div class="page-title">
                <div class="container">
                    <h1>Sign In</h1>
                </div>
                <!--end container-->
            </div>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>            

        </div>
        <div class="modal-body">
            <c:if test="${loginResult==false}">
                <div class="alert alert-danger">
                    <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                    <strong>Login Failed!</strong> <br> Please try again or <a data-toggle="modal" href="#RegisterModal" class="alert-link"><u>Sign up!</u></a>

                </div>
            </c:if>
            <!-- Form per il login -->
            <form class="form clearfix" id="login-form" action="/Lists/LoginAction" method="post" role="form">
                <div class="form-group">
                    <label for="email" class="col-form-label required">Email</label>
                    <input type="text" name="email" id="emaillogin" tabindex="1" class="form-control" placeholder="Email" value="" required>
                </div>
                <!--end form-group-->
                <div class="form-group">
                    <label for="password" class="col-form-label required" style="width: 100%">Password</label>
                    <input type="password" name="password" id="passwordlogin" tabindex="2" class="form-control" placeholder="Password" required>
                </div>
                <!--end form-group-->
                <div class="d-flex justify-content-between align-items-baseline">
                    <div class="form-group text-center">
                        <label>
                            <input type="checkbox" name="remember" value="1" checked>
                            Remember Me
                        </label>
                    </div>
                    <button type="submit" class="btn btn-primary">Sign In</button>
                </div>

            </form>
            <hr>
            <p>
                Hai dimenticato la password? <a data-dismiss="modal" href="#" data-toggle="modal" data-target="#restorePassword" class="link">Recuperala.</a>
            </p>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {
        ${loginResult = null};
    });
</script>