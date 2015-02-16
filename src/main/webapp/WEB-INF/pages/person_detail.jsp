<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<html>
<head>
    <script src="<c:url value="/resources/core/jquery.1.10.2.min.js" />"></script>
    <script src="<c:url value="/resources/core/jquery.autocomplete.min.js" />"></script>
    <script src="<c:url value="/resources/core/bootstrap.min.js" />"></script>

    <link href="<c:url value="/resources/core/bootstrap.min.css" />" rel="stylesheet"/>
    <link href="<c:url value="/resources/core/main.css" />" rel="stylesheet"/>

    <title>Person Detaljer</title>
</head>
<html>
<body>

<!---------------->
<!-- Navigation -->
<!---------------->
<nav class="navbar navbar-default">
    <div class="container-fluid">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#"></a>
        </div>

        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li class=""><a href="/trip">Reservationer<span class="sr-only">(current)</span></a></li>
                <li><a href="/trip/kayaks">Kajakker</a></li>
                <li><a href="/trip/persons">Medlemmer</a></li>
                <li><a href="/trip/admin">Admin</a></li>
            </ul>

            <%--<ul class="nav navbar-nav navbar-collapse">--%>
                <%--<div class="search">--%>
                    <%--<form:form class="navbar-form navbar-left" method="POST" action="/filter_persons.html" commandName="filterForm">--%>
                        <%--<fieldset>--%>
                            <%--<div class="form-group">--%>
                                <%--<div class="">--%>
                                    <%--<form:input type="text" class="form-control" id="filter" placeholder="Navn" path="filter"/>--%>
                                <%--</div>--%>
                            <%--</div>--%>
                            <%--<div class="form-group">--%>
                                <%--<button type="submit" class="btn btn-default">Filtrér</button>--%>
                            <%--</div>--%>
                        <%--</fieldset>--%>
                    <%--</form:form>--%>
                <%--</div>--%>
            <%--</ul>--%>
        </div>
    </div>
</nav>


<div class="col-md-12">
    <div class="row">
        <div class="col-sm-2">
            <div class="btn-group">
                <c:choose>
                    <c:when test="${birthYear > 1997}">
                        <a role="button" data-toggle="modal" data-target="#editPersonModal" class="btn-fixed-width-trip btn btn-success">${person}</a>
                    </c:when>
                    <c:when test="${birthYear < 1954}">
                        <a role="button" data-toggle="modal" data-target="#editPersonModal" class="btn-fixed-width-trip btn btn-warning">${person}</a>
                    </c:when>
                    <c:otherwise>
                        <a role="button" data-toggle="modal" data-target="#editPersonModal" class="btn-fixed-width-trip btn btn-primary">${person}</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="col-sm-2">
        </div>
        <div class="col-sm-2">
            <!----------------------->
            <!-- Show all trips -->
            <!----------------------->
            <div class="container-fluid col-lg-offset-1">
                <c:forEach items="${trips}" var="trip">
                    <div class="btn-group">
                        <c:choose>
                            <c:when test="${fn:containsIgnoreCase(trip.kayak.type, 'kap')}">
                                <button type="button"  class="btn-fixed-width-trip btn btn-warning dropdown-toggle" data-toggle="dropdown" aria-expanded="false">${trip}</button>
                            </c:when>
                            <c:when test="${fn:containsIgnoreCase(trip.kayak.type, 'hav')}">
                                <button type="button"  class="btn-fixed-width-trip btn btn-success dropdown-toggle" data-toggle="dropdown" aria-expanded="false">${trip}</button>
                            </c:when>
                            <c:otherwise>
                                <button type="button"  class="btn-fixed-width-trip btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-expanded="false">${trip}</button>
                            </c:otherwise>
                        </c:choose>
                        <ul class="dropdown-menu" role="menu">
                            <%--<li><a data-toggle="modal" data-target="#finishModal" data-trip-id="${trip.id}">Afslut</a></li>--%>
                            <%--<c:if test="${trip.kayak.seats > fn:length(trip.persons)}">--%>
                                <%--<li><a data-toggle="modal" data-target="#addPersonModal" data-trip-id="${trip.id}">Tilføj Person</a></li>--%>
                            <%--</c:if>--%>
                            <li><a href="edit_booking.html?id=${trip.id}">>Redigér</a></li>
                            <li class="divider"></li>
                            <li><a href="delete_booking.html?id=${trip.id}">Slet</a></li>
                        </ul>
                    </div>
                </c:forEach>
            </div>

        </div>
    </div>
</div>




<div class="modal" id="editPersonModal" >
    <form:form method="POST" action="/save_person.html?filter=${filterForm.filter}" commandName="editPersonForm" cssClass="form-narrow form-horizontal">
        <div class="modal-header">
            <a href="#" data-dismiss="modal" aria-hidden="true" class="close">×</a>
            <h3>Person Oplysninger</h3>
        </div>

        <div class="modal-body">
            <div class="control-group">
                <label class="control-label" for="name">Navn</label>
                <div class="controls">
                    <form:input type="text" class="form-control" id="name" placeholder="Navn" path="person.name" />
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="address">Addresse</label>
                <div class="controls">
                    <form:input type="text" class="form-control" id="address" placeholder="Vejnavn Husnummer, Postnummer By" path="person.address"/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="mobile">Mobil</label>
                <div class="controls">
                    <form:input type="text" class="form-control" id="mobile" placeholder="Mobil" path="person.mobile"/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="phone">Telefon</label>
                <div class="controls">
                    <form:input type="text" class="form-control" id="phone" placeholder="Telefon" path="person.phone"/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="mail">Mail</label>
                <div class="controls">
                    <form:input type="text" class="form-control" id="mail" placeholder="Mail" path="person.email"/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="facebookProfileId">Facebook Id</label>
                <div class="controls">
                    <form:input type="text" class="form-control" id="facebookProfileId" placeholder="Facebook Id" path="person.facebookProfileId"/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="dayOfBirth">Fødselsdag</label>
                <div class="controls">
                    <form:input type="text" class="form-control" id="dayOfBirth" placeholder="YYYY-MM-DD" path="person.dayOfBirth"/>
                </div>
            </div>



            <div class="control-group">
                <label class="control-label" for="flatwaterLevel">EPP Niveau Tur</label>
                <div class="controls">
                    <form:input type="text" class="form-control" id="flatwaterLevel" placeholder="EPP2" path="person.flatwaterLevel"/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="flatwaterLevel">EPP Niveau Hav</label>
                <div class="controls">
                    <form:input type="text" class="form-control" id="openwaterLevel" placeholder="EPP2" path="person.openwaterLevel"/>
                </div>
            </div>

            <br>

            <div class="control-group">
                <div class="controls">
                    <label for="male">Mand&nbsp&nbsp<label>
                            <form:radiobutton path="person.female" id="male" value="false" cssClass="radio-inline"/>
                        <label for="female">Kvinde&nbsp</label>
                            <form:radiobutton path="person.female" id="female" value="true" cssClass="radio-inline"/>
                </div>
            </div>

        </div>
        <form:input type="hidden" path="person.id" />
        <form:input type="hidden" path="person.created" />
        <div class="modal-footer pull-center">
            <div class="btn-group pull-right">
                <div class="">
                    <input type="submit" class="btn-fixed-width-sm btn btn-primary btn-group" role="button" value="Opdater"/>

                </div>
            </div>
            <div class="btn-group pull-right">
                <div class="">
                    <a href="delete_person.html?id=${person.id}" class="btn-fixed-width-sm btn btn-danger btn-group" role="button">Slet</a>
                </div>
            </div>
        </div>
    </form:form>
</div>




<%--<h4 class="col-lg-12">Person Oplysninger</h4>--%>
<%--<div class="modal fade" id="editPersonModal" aria-hidden="true">--%>
    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>--%>
    <%--<form:form class="form-narrow form-horizontal" method="POST" action="/save_person.html" commandName="editPersonForm">--%>
        <%--<fieldset class="">--%>
            <%--<div class="form-group">--%>
                <%--<label class="control-label">Navn</label>--%>
                <%--<div class="col-sm-18">--%>
                    <%--<form:input type="text" class="form-control" id="name" placeholder="Navn" path="person.name" />--%>
                <%--</div>--%>
            <%--</div>--%>
            <%--<div class="form-group">--%>
                <%--<label class="control-label">Addresse</label>--%>
                <%--<div class="col-sm-18">--%>
                    <%--<form:input type="text" class="form-control" id="address" placeholder="Vejnavn Husnummer, Postnummer By" path="person.address"/>--%>
                <%--</div>--%>
            <%--</div>--%>
            <%--<div class="form-group">--%>
                <%--<label class="control-label">Mobil</label>--%>
                <%--<div class="col-sm-6">--%>
                    <%--<form:input type="text" class="form-control" id="mobile" placeholder="Mobil" path="person.mobile"/>--%>
                <%--</div>--%>
                <%--<label class="control-label">Telefon</label>--%>
                <%--<div class="col-sm-6">--%>
                    <%--<form:input type="text" class="form-control" id="phone" placeholder="Telefon" path="person.phone"/>--%>
                <%--</div>--%>
            <%--</div>--%>
            <%--&lt;%&ndash;<div class="form-group">&ndash;%&gt;--%>
            <%--&lt;%&ndash;</div>&ndash;%&gt;--%>
            <%--<div class="form-group">--%>
                <%--<label class="control-label">Mail</label>--%>
                <%--<div class="col-sm-18">--%>
                    <%--<form:input type="text" class="form-control" id="mail" placeholder="Mail" path="person.email"/>--%>
                <%--</div>--%>
            <%--</div>--%>
            <%--<div class="form-group">--%>
                <%--<label class="control-label">Fødselsdag</label>--%>
                <%--<div class="col-sm-18">--%>
                    <%--<form:input type="text" class="form-control" id="dayOfBirth" placeholder="YYYY-MM-DD" path="person.dayOfBirth"/>--%>
                <%--</div>--%>
            <%--</div>--%>
                <%--<div class="">--%>
<%--<div class="btn-group pull-right">--%>
<%--<input type="submit" class="btn-fixed-width-sm btn btn-primary btn-group" role="button" value="Opdater"/>--%>

                <%--</div>--%>
            <%--</div>--%>
            <%--<div class="btn-group pull-right">--%>
                <%--<div class="">--%>
                    <%--<a href="delete_person.html?id=${person.id}" class="btn-fixed-width-sm btn btn-danger btn-group" role="button">Slet</a>--%>
                <%--</div>--%>
            <%--</div>--%>
        <%--</fieldset>--%>
    <%--</form:form>--%>
<%--</div>--%>

<%--<script>--%>
    <%--$(document).ready(function() {--%>
        <%--$('#editPersonModal').on('show.bs.modal', function(event) {--%>
            <%--$("#filter").val($(event.relatedTarget).data('filter-string'));--%>
        <%--});--%>
    <%--});--%>
<%--</script>--%>



</body>
</html>