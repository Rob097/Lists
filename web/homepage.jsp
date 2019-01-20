<%-- 
    Document   : homepage
    Created on : 16-giu-2018, 18.28.06
    Author     : Roberto97
--%>

<%@page import="Notifications.Notification"%>
<%@page import="java.util.ArrayList"%>
<%@page import="database.entities.*"%>
<%@page import="database.jdbc.*"%>
<%@page import="database.daos.*"%>
<%@page import="database.factories.DAOFactory"%>
<%@ page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700|Varela+Round" rel="stylesheet">
        <link rel="stylesheet" href="Pages/bootstrap/css/bootstrap.css" type="text/css">
        <link rel="stylesheet" href="Pages/bootstrap/css/bootstrap.min.css" type="text/css">
        <link rel="stylesheet" href="Pages/fonts/font-awesome.css" type="text/css">
        <link rel="stylesheet" href="Pages/css/selectize.css" type="text/css">
        <link rel="stylesheet" href="Pages/css/style.css">
        <link rel="stylesheet" href="Pages/css/user.css">  
        <link rel="stylesheet" href="Pages/css/navbar.css"> 
        <link rel="stylesheet" href="Pages/css/datatables.css" type="text/css"> 
        <link rel="stylesheet" href="Pages/css/notificationCss.css" type="text/css"> 
        <link rel="icon" href="Pages/img/favicon.png" sizes="16x16" type="image/png">
        <script src="Pages/js/jquery-3.3.1.min.js"></script>
        <script type="text/javascript" src="Pages/js/popper.min.js"></script>
        <script type="text/javascript" src="Pages/bootstrap/js/bootstrap.min.js"></script>

        <title>Lists</title>


        <c:set var="privacy" scope="session" value="false"/>


    </head>
    <body>
        <!--###############################################################################################################################-->
        <div class="page home-page">
            <header class="hero">
                <div class="hero-wrapper">
                    <div id="navbar">
                        <!-- Qui viene inclusa la navbar -->
                    </div>
                    <!--============ End Secondary Navigation ===========================================================-->
                    <!--######################################################################################### 
                                    check dell'eventuale messaggio da visualizzare
                    ######################################################################################### -->

                    <c:if test="${regResult==true}">
                        <div class="alert alert-success text-center" id="alert">
                            <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                            <strong>Registrazione avvenuta con successo</strong> Adesso puoi fare il login al tuo account!
                        </div>
                        <c:set var="regResult" value="${null}"/>
                    </c:if>
                    <c:if test="${erroreIMG!=null}">
                        <div class="alert alert-warning text-center" id="alert">
                            <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                            <strong>Attenzione!</strong> ${erroreIMG}
                        </div>
                        <c:set var="erroreIMG" value="${null}"/>
                    </c:if>
                    <!--#########################################################################################-->

                    <!--============ Page Title =========================================================================-->
                    <div class="page-title" id="home">
                        <div class="container pt-5">
                            <c:if test="${not empty user}" >
                                <h1 class="opacity-60 center">
                                    Ciao <a href="/Lists/profile.jsp" data-toggle="tooltip" title="Il mio profilo"><c:out value="${user.nominativo}"/>!</a>
                                </h1><br>
                            </c:if>
                            <c:if test="${empty user}">
                                <h1 class="opacity-60 center">
                                    Benvenuto
                                </h1><br> 
                            </c:if>                           
                        </div>
                    </div>

                    <!--============ End Page Title =====================================================================-->
                    <div class="container text-center" id="welcomeGrid">
                        <div class="row">
                            <div class="col-md-4">
                                <a href="/Lists/userlists.jsp" class="text-caps" style="font-size: 15px; font-weight: bold; font-style: italic;">Le mie liste</a>
                            </div>
                            <div class="col-md-4">
                                <a data-toggle="modal" data-target="#CreateListModal" class="btn btn-primary text-caps btn-rounded" style="color: white;">Crea una nuova Lista</a>
                            </div>
                            <div class="col-md-4">
                                <c:if test="${not empty user}">
                                    <a href="/Lists/foreignLists.jsp" class="text-caps" style="font-size: 15px; font-weight: bold; font-style: italic;">Liste condivise</a>
                                </c:if>
                                <c:if test="${empty user}">
                                    <a class="text-caps disabled" style="font-size: 15px; font-weight: bold; font-style: italic;" data-toggle="tooltip" title="Registrati o fai il login per usare questa funzione">Liste condivise</a>
                                </c:if>                                
                            </div>
                        </div>
                        <br>
                        <div class="row">
                            <c:if test="${not empty user}">
                                <c:if test="${user.tipo == 'amministratore'}">
                                    <div class="col-md-2">                                
                                    </div>
                                    <div class="col-md-3">
                                        <a href="Pages/AdminProducts.jsp" class="btn btn-primary text-caps btn-rounded" style="color: white;">Lista prodotti</a>
                                    </div>
                                    <div class="col-md-2">
                                        <a href="Pages/ShowProductCategories.jsp" class="btn btn-primary text-caps btn-rounded" style="color: white;">Categorie prodotti</a>                                
                                    </div>
                                    <div class="col-md-3">
                                        <a href="Pages/ShowListCategories.jsp" class="btn btn-primary text-caps btn-rounded" style="color: white;">Categorie lista</a>
                                    </div>  
                                    <div class="col-md-2">                                
                                    </div>                             
                                </c:if>
                            </c:if>
                        </div>
                    </div>

                    <div class="background">
                        <div class="background-image">
                            <img src="Pages/img/hero-background-image-02.jpg" alt="">
                        </div>
                        <!--end background-image-->
                    </div>
                    <!--end background-->
                </div>
                <!--end hero-wrapper-->
            </header>
            <!--end hero-->

            <!-- SISTEMA PER LE NOTIFICHE -->

            <li class="dropdown" id="notificationsLI">
                <a id="dLabel" role="button" data-toggle="dropdown" data-target="#" href="/page.html">
                    <h3 style="width: 20px; position: absolute; background: yellow; border-radius: 50%; height: 20px; text-align: center;" id="notificationsSize">${fn:length(notifiche)}</h3>
                    <img style="width: 5rem;" src="Image/Icons/notification.svg">
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
                                                <img src="${notifica.listimage}">
                                                <h4 class="item-title">Nuovi prodotti! <small> Sono stati aggiunti nuoi prodotti alla lista <c:out value="${notifica.listName}"/></small></h4>
                                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                                            </div>  
                                        </a> 
                                    </c:when>
                                    
                                    <c:when test="${notifica.type == 'empty_list'}">
                                        <a class="content" href="ShowShopList?nome=${notifica.listName}"> 
                                            <div class="notification-item" id="${notifica.type}ID">
                                                <img src="${notifica.listimage}">
                                                <h4 class="item-title">Lista svuotata! <small> E' stata svuotata la lista <c:out value="${notifica.listName}"/></small></h4>
                                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                                            </div>  
                                        </a>
                                    </c:when>
                                    
                                    <c:when test="${notifica.type == 'new_user'}">
                                        <a class="content" href="ShowShopList?nome=${notifica.listName}"> 
                                            <div class="notification-item" id="${notifica.type}ID">
                                                <img src="${notifica.listimage}">
                                                <h4 class="item-title">Utenti aggiunti alla lista! <small> Nuovi utenti nella lista <c:out value="${notifica.listName}"/></small></h4>
                                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                                            </div>  
                                        </a>
                                    </c:when>
                                    
                                    <c:when test="${notifica.type == 'change_status_product'}">
                                        <a class="content" href="ShowShopList?nome=${notifica.listName}"> 
                                            <div class="notification-item" id="${notifica.type}ID">
                                                <img src="${notifica.listimage}">
                                                <h4 class="item-title">Stato prodotti cambiato! <small> E' cambiato lo stato dei prodotti nella lista ${notifica.listName}</small></h4>
                                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                                            </div>  
                                        </a>
                                    </c:when>
                                    
                                    <c:when test="${notifica.type == 'new_message'}">
                                        <a class="content" href="ShowShopList?nome=${notifica.listName}"> 
                                            <div class="notification-item" id="${notifica.type}ID">
                                                <img src="${notifica.listimage}">
                                                <h4 class="item-title">Nuovi Messaggi! <small> Ci sono dei nuovi messaggi nella lista ${notifica.listName}</small></h4>
                                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                                            </div>  
                                        </a>
                                    </c:when>
                                    
                                    <c:when test="${notifica.type == 'role_change'}">
                                        <a class="content" href="ShowShopList?nome=${notifica.listName}"> 
                                            <div class="notification-item" id="${notifica.type}ID">
                                                <img src="${notifica.listimage}">
                                                <h4 class="item-title">Permessi aggiornati! <small> Sono cambiati i tuoi permessi nella lista ${notifica.listName}</small></h4>
                                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                                            </div>  
                                        </a>
                                    </c:when>
                                    
                                    <c:when test="${notifica.type == 'remove_product'}">
                                        <a class="content" href="ShowShopList?nome=${notifica.listName}"> 
                                            <div class="notification-item" id="${notifica.type}ID">
                                                <img src="${notifica.listimage}">
                                                <h4 class="item-title">Sono stati rimossi dei prodotti!<small> Potrebbe essere che la lista <b>${notifica.listName}</b> ora sia vuota</small></h4>
                                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                                            </div>  
                                        </a>
                                    </c:when>
                                    
                                    <c:when test="${notifica.type == 'primoReminder'}">
                                        <a class="content" href="ShowShopList?nome=${notifica.listName}"> 
                                            <div class="notification-item" id="${notifica.type}ID">
                                                <img src="${notifica.listimage}">
                                                <h4 class="item-title">Attenzione!<small> alcuni prodotti nella lista <b>${notifica.listName}</b> sono vicini all'esaurmineto</small></h4>
                                                <a class="item-info" style="color: red; cursor: pointer;" onclick="deleteFromArray('${notifica.type}ID', '${notifica.type}')">elimina</a>
                                            </div>  
                                        </a>
                                    </c:when>
                                    
                                    <c:when test="${notifica.type == 'secondoReminder'}">
                                        <a class="content" href="ShowShopList?nome=${notifica.listName}"> 
                                            <div class="notification-item" id="${notifica.type}ID">
                                                <img src="${notifica.listimage}">
                                                <h4 class="item-title">Attenzione!<small> alcuni prodotti nella lista <b>${notifica.listName}</b> devono essere acquistati al più presto</small></h4>
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
            </li>

            <!--ERRORI-->
            <c:if test="${not empty errore}">
                <div class="container pt-5" id="alert">
                    <div class="alert alert-danger text-center" role="alert">
                        <strong><c:out value="${errore}"/></strong>
                    </div>
                </div>
            </c:if>
            
            <!--MESSAGGI-->
            <c:if test="${not empty messaggio}">
                <div class="container pt-5" id="alert">
                    <div class="alert alert-success text-center" role="alert">
                        <strong><c:out value="${messaggio}"/></strong>
                    </div>
                </div>
            </c:if>            

            <!-- FINE DELLE NOTIFICHE -->

            <!--*********************************************************************************************************-->
            <!--************ CONTENT ************************************************************************************-->
            <!--*********************************************************************************************************-->
            <section class="content">    
                <!--============ products =============================================================================-->
                <section class="block">
                    <div class="container">
                        <div class="hero" style="background-color: #f2f2f2;">
                            <div class="page-title">
                                <h2>Categorie di <a href="/Lists/Pages/ShowProducts.jsp" data-toggle="tooltip" title="Tutti i prodotti">Prodotti</a></h2>
                            </div>
                        </div>

                        <ul class="categories-list clearfix">
                            <c:forEach items="${catProd}" var="catP">
                               <li>
                                    <img src="${catP.immagine}" alt="">
                                    <h3><a href="/Lists/Pages/ShowProducts.jsp?cat=${catP.nome}"><c:out value="${catP.nome}"/></a></h3>
                                    <div class="sub-categories">
                                    </div>
                                </li>
                            </c:forEach>                            
                            <!--end category item-->
                        </ul>
                        <!--end categories-list-->
                    </div>
                    <!--end container-->
                </section>
                
                <!--============ Features Steps =========================================================================-->
                <section class="block has-dark-background">
                    <div class="container">
                        <div class="block">
                            <h2>Come funziona</h2>
                            <div class="row">
                                <div class="col-md-3">
                                    <div class="feature-box">
                                        <figure>
                                            <img src="Pages/img/add-user.png" alt="">
                                            <span>1</span>
                                        </figure>
                                        <c:if test="${empty user}">
                                            <a style="cursor: pointer;" data-toggle="modal" data-target="#RegisterModal"><h3>Crea un Account</h3></a>
                                        </c:if>
                                        <c:if test="${not empty user}">
                                            <h3>Crea un Account</h3>
                                        </c:if>                                            
                                        <p>Scegli che tipo di utente vuoi essere, o usa l'applicazione come ospite</p>
                                    </div>
                                    <!--end feature-box-->
                                </div>
                                <!--end col-->
                                <div class="col-md-3">
                                    <div class="feature-box">
                                        <figure>
                                            <img src="Pages/img/add-list.png" alt="">
                                            <span>2</span>
                                        </figure>                                        
                                        <a style="cursor: pointer;" data-toggle="modal" data-target="#CreateListModal"><h3>Crea una lista</h3></a>                                                                               
                                        <p>Crea la tua lista personalizzata</p>
                                    </div>
                                    <!--end feature-box-->
                                </div>
                                <!--end col-->
                                <div class="col-md-3">
                                    <div class="feature-box">
                                        <figure>
                                            <img src="Pages/img/add-product.png" alt="">
                                            <span>3</span>
                                        </figure>
                                        <h3>Salva i prodotti</h3>
                                        <p>Salva i prodotti che usi piu spesso</p>
                                    </div>
                                    <!--end feature-box-->
                                </div>
                                <!--end col-->
                                <div class="col-md-3">
                                    <div class="feature-box">
                                        <figure>
                                            <img src="Pages/img/collaboration.png" alt="">
                                            <span>4</span>
                                        </figure>
                                        <h3>Condividi la lista con altri utenti</h3>
                                        <p>Condividi gli impegni con gli altri</p>
                                    </div>
                                    <!--end feature-box-->
                                </div>
                                <!--end col-->
                            </div>
                            <!--end row-->
                        </div>
                        <!--end block-->
                    </div>
                    <!--end container-->
                    <div class="background" data-background-color="#2b2b2b"></div>
                    <!--end background-->
                </section>
                <!--end block-->
                <!--============ End Features Steps =====================================================================-->

                <section class="block">
                    <div class="container">
                        <div class="d-flex align-items-center justify-content-around">
                            <a href="#" style="font-weight: bold; font-style: italic; color: #f00;">
                                <h1 style="font-size: 6rem;">LISTS</h1>
                            </a>
                        </div>
                    </div>
                </section>

            </section>


            <!--end content-->

            <!--*********************************************************************************************************-->
            <!--************ FOOTER *************************************************************************************-->
            <!--*********************************************************************************************************-->
            <footer class="footer">
               
            </footer>

        </div>
        <!--end page-->



        <!--#########################################################
                                MODAL
        ##########################################################-->

        <!-- Login Modal -->
        <div class="modal fade" id="LoginModal" tabindex="-1" role="dialog" aria-labelledby="LoginModal" aria-hidden="true"></div>
        <!--######################################################-->

        <!-- Register Modal -->
        <div class="modal fade" id="RegisterModal" tabindex="-1" role="dialog" aria-labelledby="RegisterModal" aria-hidden="true" enctype="multipart/form-data"></div>

        <!-- Privacy Policy Modal -->
        <div class="modal fade" tabindex="-1" aria-hidden="true" id="PrivacyModal">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="title">Informativa sulla Privacy</h1>
                    </div>
                    <div class="modal-body-pcy">                                
                        <p>Data di entrata in vigore: November 02, 2018</p>
                        <p>myLists ("noi" o "nostro") gestisce il http://localhost:8080 sito web (in appresso il "Servizio").</p>
                        <p>Questa pagina vi informa delle nostre politiche riguardanti la raccolta, l'uso e la divulgazione dei dati personali quando usate il nostro Servizio e le scelte che avete associato a quei dati. <a href="https://www.freeprivacypolicy.com/free-privacy-policy-generator.php">Informativa sulla Privacy via Free Privacy Policy</a>.</p>
                        <p>Utilizziamo i vostri dati per fornire e migliorare il Servizio. Utilizzando il Servizio, accettate la raccolta e l'utilizzo delle informazioni in conformità con questa informativa. Se non diversamente definito nella presente Informativa sulla privacy, i termini utilizzati nella presente Informativa hanno la stessa valenza dei nostri Termini e condizioni, accessibili da http://localhost:8080</p>
                        <h2>Definizioni</h2>
                        <ul>
                            <li>
                                <p><strong>Servizio</strong></p>
                                <p>Il Servizio è il sito http://localhost:8080 gestito da myLists</p>
                            </li>
                            <li>
                                <p><strong>Dati personali</strong></p>
                                <p>I Dati personali sono i dati di un individuo vivente che può essere identificato da quei dati (o da quelli e altre informazioni in nostro possesso o che potrebbero venire in nostro possesso).</p>
                            </li>
                            <li>
                                <p><strong>Dati di utilizzo</strong></p>
                                <p>I dati di utilizzo sono i dati raccolti automaticamente generati dall'utilizzo del Servizio o dall'infrastruttura del Servizio stesso (ad esempio, la durata della visita di una pagina).</p>
                            </li>
                            <li>
                                <p><strong>Cookies</strong></p>
                                <p>I cookie sono piccoli file memorizzati sul vostro dispositivo (computer o dispositivo mobile).</p>
                            </li>
                        </ul>

                        <h2>Raccolta e uso delle informazioni</h2>
                        <p>Raccogliamo diversi tipi di informazioni per vari scopi, per fornire e migliorare il nostro servizio.</p>

                        <h3>Tipologie di Dati raccolti</h3>

                        <h4>Dati personali</h4>
                        <p>Durante l'utilizzo del nostro Servizio, potremmo chiedervi di fornirci alcune informazioni di identificazione personale che possono essere utilizzate per contattarvi o identificarvi ("Dati personali"). Le informazioni di identificazione personale possono includere, ma non sono limitate a:</p>

                        <ul>
                            <li>Indirizzo email</li>    <li>Nome e cognome</li>            <li>Cookie e dati di utilizzo</li>
                        </ul>

                        <h4>Dati di utilizzo</h4>

                        <p>Potremmo anche raccogliere informazioni su come l'utente accede e utilizza il Servizio ("Dati di utilizzo"). Questi Dati di utilizzo possono includere informazioni quali l'indirizzo del protocollo Internet del computer (ad es. Indirizzo IP), il tipo di browser, la versione del browser, le pagine del nostro servizio che si visita, l'ora e la data della visita, il tempo trascorso su tali pagine, identificatore unico del dispositivo e altri dati diagnostici.</p>

                        <h4>Tracciamento; dati dei cookie</h4>
                        <p>Utilizziamo cookie e tecnologie di tracciamento simili per tracciare l'attività sul nostro Servizio e conservare determinate informazioni.</p>
                        <p>I cookie sono file con una piccola quantità di dati che possono includere un identificatore univoco anonimo. I cookie vengono inviati al vostro browser da un sito web e memorizzati sul vostro dispositivo. Altre tecnologie di tracciamento utilizzate sono anche beacon, tag e script per raccogliere e tenere traccia delle informazioni e per migliorare e analizzare il nostro Servizio.</p>
                        <p>Potete chiedere al vostro browser di rifiutare tutti i cookie o di indicare quando viene inviato un cookie. Tuttavia, se non si accettano i cookie, potrebbe non essere possibile utilizzare alcune parti del nostro Servizio.</p>
                        <p>Esempi di cookie che utilizziamo:</p>
                        <ul>
                            <li><strong>Cookie di sessione.</strong> Utilizziamo i cookie di sessione per gestire il nostro servizio.</li>
                            <li><strong>Cookie di preferenza.</strong> Utilizziamo i cookie di preferenza per ricordare le vostre preferenze e varie impostazioni.</li>
                            <li><strong>Cookie di sicurezza.</strong> Utilizziamo i cookie di sicurezza per motivi di sicurezza.</li>
                        </ul>

                        <h2>Uso dei dati</h2> 
                        <p>myLists utilizza i dati raccolti per vari scopi:</p>    
                        <ul>
                            <li>Per fornire e mantenere il nostro Servizio</li>
                            <li>Per comunicare agli utenti variazioni apportate al servizio che offriamo</li>
                            <li>Per permettere agli utenti di fruire, a propria discrezione, di funzioni interattive del nostro servizio</li>
                            <li>Per fornire un servizio ai clienti</li>
                            <li>Per raccogliere analisi o informazioni preziose in modo da poter migliorare il nostro Servizio</li>
                            <li>Per monitorare l'utilizzo del nostro Servizio</li>
                            <li>Per rilevare, prevenire e affrontare problemi tecnici</li>
                        </ul>
                        <h2>Trasferimento dei dati</h2>
                        <p>Le vostre informazioni, compresi i Dati personali, possono essere trasferite a - e mantenute su - computer situati al di fuori del vostro stato, provincia, nazione o altra giurisdizione governativa dove le leggi sulla protezione dei dati possono essere diverse da quelle della vostra giurisdizione.</p>
                        <p>Se ci si trova al di fuori di Italy e si sceglie di fornire informazioni a noi, si ricorda che trasferiamo i dati, compresi i dati personali, in Italy e li elaboriamo lì.</p>
                        <p>Il vostro consenso alla presente Informativa sulla privacy seguito dall'invio di tali informazioni rappresenta il vostro consenso al trasferimento.</p>
                        <p>myLists adotterà tutte le misure ragionevolmente necessarie per garantire che i vostri dati siano trattati in modo sicuro e in conformità con la presente Informativa sulla privacy e nessun trasferimento dei vostri Dati Personali sarà effettuato a un'organizzazione o a un paese a meno che non vi siano controlli adeguati dei vostri dati e altre informazioni personali.</p>
                        <h2>Divulgazione di dati</h2>
                        <h3>Prescrizioni di legge</h3>
                        <p>myLists può divulgare i vostri Dati personali in buona fede, ritenendo che tale azione sia necessaria per:</p>
                        <ul>
                            <li>Rispettare un obbligo legale</li>
                            <li>Proteggere e difendere i diritti o la proprietà di myLists</li>
                            <li>Prevenire o investigare possibili illeciti in relazione al Servizio</li>
                            <li>Proteggere la sicurezza personale degli utenti del Servizio o del pubblico</li>
                            <li>Proteggere contro la responsabilità legale</li>
                        </ul>
                        <h2>Sicurezza dei dati</h2>
                        <p>La sicurezza dei vostri dati è importante per noi, ma ricordate che nessun metodo di trasmissione su Internet o metodo di archiviazione elettronica è sicuro al 100%. Pertanto, anche se adotteremo ogni mezzo commercialmente accettabile per proteggere i vostri Dati personali, non possiamo garantirne la sicurezza assoluta.</p>
                        <h2>Fornitori di servizi</h2>
                        <p>Potremmo impiegare società e individui di terze parti per facilitare il nostro Servizio ("Fornitori di servizi"), per fornire il Servizio per nostro conto, per eseguire servizi relativi ai Servizi o per aiutarci ad analizzare come viene utilizzato il nostro Servizio.</p>
                        <p>Le terze parti hanno accesso ai vostri Dati personali solo per eseguire queste attività per nostro conto e sono obbligate a non rivelarle o utilizzarle per altri scopi.</p>
                        <h2>Privacy dei minori</h2>
                        <p>Il nostro servizio non si rivolge a minori di 18 anni ("Bambini").</p>
                        <p>Non raccogliamo consapevolmente informazioni personali relative a utenti di età inferiore a 18 anni. Se siete un genitore o tutore e siete consapevoli che vostro figlio ci ha fornito Dati personali, vi preghiamo di contattarci. Se veniamo a conoscenza del fatto che abbiamo raccolto Dati personali da minori senza la verifica del consenso dei genitori, adotteremo provvedimenti per rimuovere tali informazioni dai nostri server.</p>
                        <h2>Modifiche alla presente informativa sulla privacy</h2>
                        <p>Potremmo aggiornare periodicamente la nostra Informativa sulla privacy. Ti informeremo di eventuali modifiche pubblicando la nuova Informativa sulla privacy in questa pagina.</p>
                        <p>Vi informeremo via e-mail e / o un avviso di rilievo sul nostro Servizio, prima che la modifica diventi effettiva e aggiorneremo la "data di validità" nella parte superiore di questa Informativa sulla privacy.</p>
                        <p>Si consiglia di rivedere periodicamente la presente Informativa sulla privacy per eventuali modifiche. Le modifiche a tale informativa sulla privacy entrano in vigore nel momento in cui vengono pubblicate su questa pagina.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <!--######################################################-->

    <!-- restore password Modal -->
    <div class="modal fade" id="restorePassword" tabindex="-1" role="dialog" aria-labelledby="restorePassword" aria-hidden="true"></div>
    <!--######################################################-->

    <!-- new password Modal -->
    <div class="modal fade" id="newPassword" tabindex="-1" role="dialog" aria-labelledby="newPassword" aria-hidden="true"></div>
    <!--######################################################-->


    <div class="modal fade" id="CreateListModal" tabindex="-1" role="dialog" aria-labelledby="CreateShopListform" aria-hidden="true" enctype="multipart/form-data"></div>

    <script type="text/javascript" src="http://maps.google.com/maps/api/js?key=AIzaSyBEDfNcQRmKQEyulDN8nGWjLYPm8s4YB58&libraries=places"></script>
    <!--<script type="text/javascript" src="http://maps.google.com/maps/api/js"></script>-->
    <script src="Pages/js/selectize.min.js"></script>
    <script src="Pages/js/masonry.pkgd.min.js"></script>
    <script src="Pages/js/icheck.min.js"></script>
    <script src="Pages/js/jquery.validate.min.js"></script>
    <script src="Pages/js/custom.js"></script>
    <script src="Pages/js/vari.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $("#alert").hide();

            $("#alert").fadeTo(10000, 500).slideUp(500, function () {
                $("#alert").slideUp(500);
            });

        });
    </script>

    <script>
        $(document).ready(function () {
        <%if (request.getParameter("restorePasswordOf") != null) {%>
            $('#newPassword').modal('show');
        <%}%>
        });
    </script>

    <script>

        function deleteFromArray(idDiv, array) {
            $.ajax({
                type: "POST",
                url: "/Lists/deleteNotificationsFromArray",
                cache: false,
                data: {"array": array, "user": '${user.email}'},
                success: function () {
                    $("#" + idDiv).hide();
                },
                error: function () {
                    alert("Errore notificationArray");
                }
            });
        }
    </script>
    <script>

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
    <script type="text/javascript">
        function validate() {
            var passw = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,20}$/;
            var n1 = document.getElementById("passwordRegister");
            var n2 = document.getElementById("pswrt2");
            if (n1.value != "" && n2.value != "") {
                if ((n1.value == n2.value)) {
                    if (n1.value.match(passw)) {
                        return true;
                    }
                }
            }
            alert("password can't be empty and has to be equal to Conferma Password, 6 to 20 characters which contain at least one numeric digit, one uppercase and one lowercase letter");
            return false;
        }
    </script>


    <!--###############################################################################################################################
                        Import templates ajax
    ###############################################################################################################################-->            
    <script>
        $(document).ready(function () {

            //LoginModal
            $.ajax({
                type: "GET",
                url: "/Lists/Pages/template/loginTemplate.jsp",
                cache: false,
                success: function (response) {
                    $("#LoginModal").html(response);
                },
                error: function () {
                    alert("Errore LoginModalImport");
                }
            });

            //RegisterModal
            $.ajax({
                type: "GET",
                url: "/Lists/Pages/template/registerTemplate.jsp",
                cache: false,
                success: function (response) {
                    $("#RegisterModal").html(response);
                },
                error: function () {
                    alert("Errore RegisterModalImport");
                }
            });

            //Restore password
            $.ajax({
                type: "GET",
                url: "/Lists/Pages/template/restorePasswordTemplate.jsp",
                cache: false,
                success: function (response) {
                    $("#restorePassword").html(response);
                },
                error: function () {
                    alert("Errore restorePasswordTemplate");
                }
            });

            //New password
            $.ajax({
                type: "GET",
                url: "/Lists/Pages/template/newPasswordTemplate.jsp",
                cache: false,
                success: function (response) {
                    $("#newPassword").html(response);
                },
                error: function () {
                    alert("Errore newPasswordTemplate");
                }
            });

            //Create List
            $.ajax({
                type: "GET",
                url: "/Lists/Pages/template/createListTemplate.jsp",
                cache: false,
                success: function (response) {
                    $("#CreateListModal").html(response);
                },
                error: function () {
                    alert("Errore createListTemplate");
                }
            });

            /*Footer
            $.ajax({
                type: "GET",
                url: "/Lists/Pages/template/footerTemplate.jsp",
                cache: false,
                success: function (response) {
                    $("footer").html(response);
                },
                error: function () {
                    alert("Errore footerTemplate");
                }
            });*/

            //Navbar
            $.ajax({
                type: "GET",
                url: "/Lists/Pages/template/navbarTemplate.jsp",
                cache: false,
                success: function (response) {
                    $("#navbar").html(response);
                },
                error: function () {
                    alert("Errore navbarTemplate");
                }
            });
            
            
        });
    </script>
    <!--###############################################################################################################################-->

</body>
</html>

