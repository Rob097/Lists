<%-- 
    Document   : notifiche
    Created on : 21-gen-2019, 8.33.10
    Author     : Roberto97
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<a id="dLabel" role="button" data-toggle="dropdown" data-target="#" href="/page.html">
    <h3 style="width: 20px; position: absolute; background: yellow; border-radius: 50%; height: 20px; text-align: center;" id="notificationsSize">${fn:length(notifiche)}</h3>
    <img style="width: 5rem;" src="/Lists/Image/Icons/notification.svg">
</a>

<ul class="dropdown-menu notifications" role="menu" aria-labelledby="dLabel">

    <div class="notification-heading"><h4 class="menu-title">Notifiche</h4><h4 class="menu-title pull-right"><a onclick="deleteALLNotifications();" style="cursor: pointer;">Cancella tutto</a><i class="glyphicon glyphicon-circle-arrow-right"></i></h4>
    </div> 
    <div class="notifications-wrapper" id="NotificationsWrapper"> 
        <c:if test="${not empty notifiche}">
            <c:forEach items="${notifiche}" var="notifica">
                <c:choose>

                    <c:when test="${notifica.type == 'new_product'}">
                        <a class="content" href="ShowShopList?nome=${notifica.listName}"> 
                            <div class="notification-item" id="${notifica.type}ID">
                                <img src="/Lists/${notifica.listimage}">
                                <h4 class="item-title">Nuovi prodotti! <small> Sono stati aggiunti nuoi prodotti alla lista <c:out value="${notifica.listName}"/></small></h4>
                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                            </div>  
                        </a> 
                    </c:when>

                    <c:when test="${notifica.type == 'empty_list'}">
                        <a class="content" href="ShowShopList?nome=${notifica.listName}"> 
                            <div class="notification-item" id="${notifica.type}ID">
                                <img src="/Lists/${notifica.listimage}">
                                <h4 class="item-title">Lista svuotata! <small> E' stata svuotata la lista <c:out value="${notifica.listName}"/></small></h4>
                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                            </div>  
                        </a>
                    </c:when>

                    <c:when test="${notifica.type == 'new_user'}">
                        <a class="content" href="ShowShopList?nome=${notifica.listName}"> 
                            <div class="notification-item" id="${notifica.type}ID">
                                <img src="/Lists/${notifica.listimage}">
                                <h4 class="item-title">Utenti aggiunti alla lista! <small> Nuovi utenti nella lista <c:out value="${notifica.listName}"/></small></h4>
                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                            </div>  
                        </a>
                    </c:when>

                    <c:when test="${notifica.type == 'change_status_product'}">
                        <a class="content" href="ShowShopList?nome=${notifica.listName}"> 
                            <div class="notification-item" id="${notifica.type}ID">
                                <img src="/Lists/${notifica.listimage}">
                                <h4 class="item-title">Stato prodotti cambiato! <small> E' cambiato lo stato dei prodotti nella lista ${notifica.listName}</small></h4>
                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                            </div>  
                        </a>
                    </c:when>

                    <c:when test="${notifica.type == 'new_message'}">
                        <a class="content" href="ShowShopList?nome=${notifica.listName}"> 
                            <div class="notification-item" id="${notifica.type}ID">
                                <img src="/Lists/${notifica.listimage}">
                                <h4 class="item-title">Nuovi Messaggi! <small> Ci sono dei nuovi messaggi nella lista ${notifica.listName}</small></h4>
                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                            </div>  
                        </a>
                    </c:when>

                    <c:when test="${notifica.type == 'role_change'}">
                        <a class="content" href="ShowShopList?nome=${notifica.listName}"> 
                            <div class="notification-item" id="${notifica.type}ID">
                                <img src="/Lists/${notifica.listimage}">
                                <h4 class="item-title">Permessi aggiornati! <small> Sono cambiati i tuoi permessi nella lista ${notifica.listName}</small></h4>
                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                            </div>  
                        </a>
                    </c:when>

                    <c:when test="${notifica.type == 'remove_product'}">
                        <a class="content" href="ShowShopList?nome=${notifica.listName}"> 
                            <div class="notification-item" id="${notifica.type}ID">
                                <img src="/Lists/${notifica.listimage}">
                                <h4 class="item-title">Sono stati rimossi dei prodotti!<small> Potrebbe essere che la lista <b>${notifica.listName}</b> ora sia vuota</small></h4>
                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                            </div>  
                        </a>
                    </c:when>

                    <c:when test="${notifica.type == 'primoReminder'}">
                        <a class="content" href="ShowShopList?nome=${notifica.listName}"> 
                            <div class="notification-item" id="${notifica.type}ID">
                                <img src="/Lists/${notifica.listimage}">
                                <h4 class="item-title">Attenzione!<small> alcuni prodotti nella lista <b>${notifica.listName}</b> sono vicini all'esaurmineto</small></h4>
                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                            </div>  
                        </a>
                    </c:when>

                    <c:when test="${notifica.type == 'secondoReminder'}">
                        <a class="content" href="ShowShopList?nome=${notifica.listName}"> 
                            <div class="notification-item" id="${notifica.type}ID">
                                <img src="/Lists/${notifica.listimage}">
                                <h4 class="item-title">Attenzione!<small> alcuni prodotti nella lista <b>${notifica.listName}</b> devono essere acquistati al più presto</small></h4>
                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                            </div>  
                        </a>
                    </c:when>
                    
                    <c:when test="${notifica.type == 'proximityMail'}">
                        <a class="content" href="ShowShopList?nome=${notifica.listName}"> 
                            <div class="notification-item" id="${notifica.type}ID">
                                <img src="/Lists/${notifica.listimage}">
                                <h4 class="item-title">Attenzione!<small> Ci risulta che sei particolarmente vicino a negozi inerenti alla lista <b>${notifica.listName}</b></h4>
                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                            </div>  
                        </a>
                    </c:when>

                </c:choose>
            </c:forEach>
        </c:if>
        <c:if test="${empty notifiche}">
            <h4>Non ci sono notifiche!</h4>
        </c:if>

    </div> 
</ul>
