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
        <!--Tutti i sguenti tipi di notifiche vengono inviati a tutti gli utenti
        della lista eccetto l'utente che effettua la modifica o il cambiamento.-->
        <c:if test="${not empty notifiche}">
            <c:forEach items="${notifiche}" var="notifica">
                <c:choose>
                    
                    <c:when test="${notifica.type == 'new_product'}"><!--Quando Qualcuno aggiunge un nuovo prodotto alla lista-->
                        <a class="content" href="/Lists/ShowShopList?nome=${notifica.listName}"> 
                            <div class="notification-item" id="${notifica.type}ID">
                                <img src="/Lists/${notifica.listimage}">
                                <h4 class="item-title">Nuovi prodotti! <small> Sono stati aggiunti nuoi prodotti alla lista <b>${notifica.listName}</b></small></h4>
                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                            </div>  
                        </a> 
                    </c:when>

                    <c:when test="${notifica.type == 'empty_list'}"><!--Se la lista viene svuotata-->
                        <a class="content" href="/Lists/ShowShopList?nome=${notifica.listName}"> 
                            <div class="notification-item" id="${notifica.type}ID">
                                <img src="/Lists/${notifica.listimage}">
                                <h4 class="item-title">Lista svuotata! <small> E' stata svuotata la lista <b>${notifica.listName}</b></small></h4>
                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                            </div>  
                        </a>
                    </c:when>

                    <c:when test="${notifica.type == 'new_user'}"><!--Se viene aggiunto un nuovo utente alla lista-->
                        <a class="content" href="/Lists/ShowShopList?nome=${notifica.listName}"> 
                            <div class="notification-item" id="${notifica.type}ID">
                                <img src="/Lists/${notifica.listimage}">
                                <h4 class="item-title">Utenti aggiunti alla lista! <small> Nuovi utenti nella lista <b>${notifica.listName}</b></small></h4>
                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                            </div>  
                        </a>
                    </c:when>

                    <c:when test="${notifica.type == 'change_status_product'}"><!--Se cambia lo stato di un prodotto della lista da 'da acquistare' a 'acquistato' o il contrario-->
                        <a class="content" href="/Lists/ShowShopList?nome=${notifica.listName}"> 
                            <div class="notification-item" id="${notifica.type}ID">
                                <img src="/Lists/${notifica.listimage}">
                                <h4 class="item-title">Stato prodotti cambiato! <small> E' cambiato lo stato dei prodotti nella lista <b>${notifica.listName}</b></small></h4>
                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                            </div>  
                        </a>
                    </c:when>

                    <c:when test="${notifica.type == 'new_message'}"><!--Se qualcuno scrive messaggi nella chat della lista-->
                        <a class="content" href="/Lists/ShowShopList?nome=${notifica.listName}"> 
                            <div class="notification-item" id="${notifica.type}ID">
                                <img src="/Lists/${notifica.listimage}">
                                <h4 class="item-title">Nuovi Messaggi! <small> Ci sono dei nuovi messaggi nella lista <b>${notifica.listName}</b></small></h4>
                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                            </div>  
                        </a>
                    </c:when>

                    <c:when test="${notifica.type == 'role_change'}"><!--Se il tuo ruolo all'interno della lista cambia tra in sola lettura e scrittura-->
                        <a class="content" href="/Lists/ShowShopList?nome=${notifica.listName}"> 
                            <div class="notification-item" id="${notifica.type}ID">
                                <img src="/Lists/${notifica.listimage}">
                                <h4 class="item-title">Permessi aggiornati! <small> Sono cambiati i tuoi permessi nella lista <b>${notifica.listName}</b></small></h4>
                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                            </div>  
                        </a>
                    </c:when>

                    <c:when test="${notifica.type == 'remove_product'}"><!--Se qualcuno rimuove un prodotto dalla lista-->
                        <a class="content" href="/Lists/ShowShopList?nome=${notifica.listName}"> 
                            <div class="notification-item" id="${notifica.type}ID">
                                <img src="/Lists/${notifica.listimage}">
                                <h4 class="item-title">Sono stati rimossi dei prodotti!<small> Potrebbe essere che la lista <b>${notifica.listName}</b> ora sia vuota</small></h4>
                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                            </div>  
                        </a>
                    </c:when>

                    <c:when test="${notifica.type == 'primoReminder'}"><!--se ci sono uno o più prodotti nella lista che devono essere comprati tra 2 e 4 giorni a partire da oggi-->
                        <a class="content" href="/Lists/ShowShopList?nome=${notifica.listName}"> 
                            <div class="notification-item" id="${notifica.type}ID">
                                <img src="/Lists/${notifica.listimage}">
                                <h4 class="item-title">Attenzione!<small> alcuni prodotti nella lista <b>${notifica.listName}</b> sono vicini all'esaurmineto</small></h4>
                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                            </div>  
                        </a>
                    </c:when>

                    <c:when test="${notifica.type == 'secondoReminder'}"><!--se ci sono uno o più prodotti nella lista che devono essere comprati tra 0 e 2 giorni a partire da oggi-->
                        <a class="content" href="/Lists/ShowShopList?nome=${notifica.listName}"> 
                            <div class="notification-item" id="${notifica.type}ID">
                                <img src="/Lists/${notifica.listimage}">
                                <h4 class="item-title">Attenzione!<small> alcuni prodotti nella lista <b>${notifica.listName}</b> devono essere acquistati al più presto</small></h4>
                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                            </div>  
                        </a>
                    </c:when>
                    
                    <c:when test="${notifica.type == 'proximityMail'}"><!--Se mi trovo in prossimità di un negozio inerente alla categoria della lista-->
                        <a class="content" href="/Lists/ShowShopList?nome=${notifica.listName}"> 
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
<script>

        function deleteFromArray(idDiv, array) {
            var size = $("#notificationsSize").html();
            console.log("SIIIIIZEEEE::"+size);
            $.ajax({
                type: "POST",
                url: "/Lists/deleteNotificationsFromArray",
                cache: false,
                data: {"array": array, "user": '${user.email}'},
                success: function () {
                    $("#" + idDiv).hide();
                    $("#notificationsSize").html(--size);
                },
                error: function () {
                    alert("Errore notificationArray");
                }
            });
        }
        function deleteALLNotifications() {
            $.ajax({
                type: "POST",
                url: "/Lists/Pages/template/deleteALLNotifications.jsp",
                cache: false,
                success: function (response) {
                    $("#NotificationsWrapper").html(response);
                    $("#notificationsSize").html(0);
                },
                error: function () {
                    alert("Errore notificationALL");
                }
            });
        }
    </script>