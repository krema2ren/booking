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
                    <a shref="person_detail.html?id=${person.id}&filter=${filterForm.filter}">${person}</a>
                </c:when>
                <c:when test="${birthYear < 1954}">
                    <a href="person_detail.html?id=${person.id}&filter=${filterForm.filter}">${person}</a>
                </c:when>
                <c:otherwise>
                    <a href="person_detail.html?id=${person.id}&filter=${filterForm.filter}">${person}</a>
                </c:otherwise>
            </c:choose>



    </c:forEach>
</div>
</body>
</html>