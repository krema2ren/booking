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

    <title>Medlemmer</title>
</head>
<html>
<body>

<!---------------->
<!-- Navigation -->
<!---------------->
<nav class="navbar navbar-default" style="margin-top: -50px; height: 53px;">
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
                <li class=""><a href="/trip">Turer<span class="sr-only">(current)</span></a></li>
                <li><a href="/trip/kayaks">Kajakker</a></li>
                <li><a href="/trip/persons">Medlemmer</a></li>
                <%--<li><a href="/trip/admin">Admin</a></li>--%>
            </ul>

            <ul class="nav navbar-nav navbar-collapse">
                <div class="search">
                    <form:form class="navbar-form navbar-left" method="POST" action="/filter_persons.html" commandName="filterForm">
                        <fieldset>
                            <div class="form-group">
                                <div class="">
                                    <form:input type="text" class="form-control" id="filter" placeholder="Navn" path="filter"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <button type="submit" class="btn btn-default">Filtrér</button>
                            </div>
                        </fieldset>
                    </form:form>
                </div>
            </ul>
        </div>
    </div>
</nav>

<div class="container-fluid col-lg-offset-1">${fn:length(persons)} medlemmer fundet.</div>

<!----------------------->
<!-- Show all persons  -->
<!----------------------->
<div class="container-fluid col-lg-offset-1">
    <c:forEach items="${persons}" var="person">
        <fmt:formatDate value="${person.dayOfBirth}" pattern="yyyy" var="birthYear" />


        <c:choose>
            <c:when test="${birthYear > 1997}">
                <button onclick="location.href='person_detail.html?id=${person.id}&filter=${filterForm.filter}'" type="button" class="btn btn-success btn-fixed-width-trip dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
            </c:when>
            <c:when test="${birthYear < 1954}">
                <button onclick="location.href='person_detail.html?id=${person.id}&filter=${filterForm.filter}'" type="button" class="btn btn-primary btn-fixed-width-trip dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
            </c:when>
            <c:otherwise>
                <button onclick="location.href='person_detail.html?id=${person.id}&filter=${filterForm.filter}'" type="button" class="btn btn-warning btn-fixed-width-trip dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
            </c:otherwise>
        </c:choose>

            <div class="media">
                <div class="media-body">
                    <b><u>${person.name}</u></b> <br>
                    <small>${person.address}</small><br>
                    <small>Mobil: ${person.mobile}</small><br>
                    <small>Telefon: ${person.phone}</small><br>
                    <small>Mail: <a style="color: #ffffff" href="mailto:${person.email}">${person.email}</a></small><br>
                    <small>Født: ${person.dayOfBirth}</small><br>
                    <small style="float: left">Oprette: ${person.created}</small><br>
                </div>
                <div style="float: right">
                    <a>
                        <c:if test="${empty person.facebookProfileId}">
                            <c:if test="${person.female}">
                                <img class="media-object custom-media" style="margin-top: 8px; float: right;" src="resources/images/woman.jpg">
                            </c:if>
                            <c:if test="${not person.female}">
                                <img class="media-object custom-media" style="margin-top: 8px; float: right;" src="resources/images/man.jpg">
                            </c:if>
                        </c:if>
                        <c:if test="${not empty person.facebookProfileId}">
                            <img class="media-object custom-media" style="margin-top: 8px; float: right;" src="//graph.facebook.com/${person.facebookProfileId}/picture">
                        </c:if>
                    </a><br><br><br><br>
                    <c:if test="${person.ranking == 2147483647}">
                        <small>Placering: -</small><br>
                    </c:if>
                    <c:if test="${person.ranking != 2147483647}">
                        <small>Placering: ${person.ranking}</small><br>
                    </c:if>
                    <small>Distance: <fmt:formatNumber maxFractionDigits="1" minFractionDigits="1" value="${person.distance}"/> km</small>
                </div>
            </div>
        </button>
    </c:forEach>
</div>
</body>
</html>