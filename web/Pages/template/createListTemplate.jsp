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
                    <h1 style="text-align: center;">Create list</h1>
                </div>
                <!--end container-->
            </div>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
        <div class="modal-body">
            <!-- Form per il login -->
            <form class="form clearfix" id="CreateShopListform" action="/Lists/CreateShopList"  method="post" role="form" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="Nome" class="col-form-label">Nome della lista</label>
                    <input type="text" name="Nome" id="Nome" tabindex="1" class="form-control" placeholder="Nome" value="" required>
                </div>
                <!--end form-group-->
                <div class="form-group">
                    <label for="Descrizione" class="col-form-label">Descrizione</label>
                    <input type="text" name="Descrizione" id="Descrizione" tabindex="1" class="form-control" placeholder="Descrizione" value="" required>
                </div>
                <!--end form-group-->
                <div class="form-group">
                    <label for="Categoria" class="col-form-label">Categoria</label>
                    <select name="Categoria" id="Categoria" tabindex="1" required>

                        <c:forEach items="${categorie}" var="categoria">
                            <option value="${categoria.nome}"><c:out value="${categoria.nome}"/></option> 
                        </c:forEach>
                    </select><!--<input type="text" name="Categoria" id="Categoria" tabindex="1" class="form-control" placeholder="Categoria" value="" required>-->

                </div>
                <!--end form-group-->
                <c:if test="${not empty user}">
                    <div class="form-group">
                        <label for="Immagine" class="col-form-label required">Immagine</label>
                        <input type="file" name="file1" accept=".jpg,.png, .jpeg, .JPG, .gif" required>
                    </div>
                </c:if>
                <!--end form-group-->
                <div class="d-flex justify-content-between align-items-baseline">

                    <button type="submit" name="register-submit" id="create-list-submit" tabindex="4" class="btn btn-primary">Crea lista</button>
                    <c:if test="${empty user && not empty guestList}">
                        <h5>Attenzione, hai già salvato una lista. Se non sei registrato puoi salvare solo una lista alla volta. Salvando questa lista, cancellerai la lista gia salvata.</h5>
                    </c:if>
                </div>
            </form>
            <hr>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
    </div>
</div>
