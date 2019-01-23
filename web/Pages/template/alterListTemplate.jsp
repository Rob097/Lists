<%-- 
    Document   : createListTemplate
    Created on : 28-nov-2018, 11.01.06
    Author     : della
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
        <div class="modal-header">
            <div class="page-title">
                <div class="container">
                    <h1 style="text-align: center;">Modifica Lista</h1>
                </div>
                <!--end container-->
            </div>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
        <div class="modal-body">
            <!-- Form per il login -->
            <form class="form clearfix" id="CreateShopListform" action="/Lists/alterList"  method="post" role="form" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="Nome" class="col-form-label">Nome della lista</label>
                    <input type="text" name="Nome" id="Nome" tabindex="1" class="form-control" placeholder="Nome" value="">
                </div>
                <!--end form-group-->
                <div class="form-group">
                    <label for="Descrizione" class="col-form-label">Descrizione</label>
                    <input type="text" name="Descrizione" id="Descrizione" tabindex="1" class="form-control" placeholder="Descrizione" value="">
                </div>
                <!--end form-group-->
                <div class="form-group">
                    <label for="Categoria" class="col-form-label">Categoria</label>
                    <select name="Categoria" id="Categoria" tabindex="1">

                        <c:forEach items="${categorie}" var="categoria">
                            <option value="${categoria.nome}"><c:out value="${categoria.nome}"/></option> 
                        </c:forEach>
                    </select><!--<input type="text" name="Categoria" id="Categoria" tabindex="1" class="form-control" placeholder="Categoria" value="">-->

                </div>
                <!--end form-group-->
                <c:if test="${not empty user}">
                    <div class="form-group">
                        <label for="Immagine" class="col-form-label">Immagine</label>
                        <input type="file" name="file1">
                    </div>
                </c:if>
                <!--end form-group-->
                <div class="d-flex justify-content-between align-items-baseline">

                    <button type="submit" name="register-submit" id="create-list-submit" tabindex="4" class="btn btn-primary">Crea lista</button>
                </div>
            </form>
            <hr>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
    </div>
</div>
