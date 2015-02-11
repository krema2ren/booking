<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<html>
<head>
    <script src="<c:url value="/resources/core/bootstrap.min.js" />"></script>
    <script src="<c:url value="/resources/core/jquery.1.10.2.min.js" />"></script>
    <script src="<c:url value="/resources/core/jquery.autocomplete.min.js" />"></script>
    <link href="<c:url value="/resources/core/bootstrap.min.css" />" rel="stylesheet">
    <link href="<c:url value="/resources/core/main.css" />" rel="stylesheet">
    <title>Kajakker</title>
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
                <li class=""><a href="/booking">Reservationer<span class="sr-only">(current)</span></a></li>
                <li><a href="/booking/kayaks">Kajakker</a></li>
                <li><a href="/booking/persons">Medlemmer</a></li>
                <li><a href="/booking/admin">Admin</a></li>
            </ul>

            <ul class="nav navbar-nav navbar-collapse">
                <div class="search">
                    <form:form class="navbar-form navbar-left" method="POST" action="/filter_kayaks.html" commandName="filterKayaksForm">
                        <fieldset>
                            <div class="form-group">
                                <div class="">
                                    <form:input type="text" class="form-control" id="w-input-kayak" placeholder="Kajak eller plads" path="filter"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <button type="submit" class="btn btn-default" id="book">Filtrér</button>
                            </div>
                        </fieldset>
                    </form:form>
                </div>
            </ul>
        </div>
    </div>
</nav>


<!----------------------->
<!-- Show all kayaks -->
<!----------------------->
<div class="container-fluid col-lg-offset-1">
    <c:forEach items="${kayaks}" var="kayak">
        <div class="btn-group">
            <c:choose>
                <c:when test="${fn:containsIgnoreCase(kayak.type, 'kap')}">
                    <button type="button"  class="btn-fixed-width-booking btn btn-warning dropdown-toggle" data-toggle="dropdown" aria-expanded="false">${kayak}</button>
                </c:when>
                <c:when test="${fn:containsIgnoreCase(kayak.type, 'hav')}">
                    <button type="button"  class="btn-fixed-width-booking btn btn-success dropdown-toggle" data-toggle="dropdown" aria-expanded="false">${kayak}</button>
                </c:when>
                <c:otherwise>
                    <button type="button"  class="btn-fixed-width-booking btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-expanded="false">${kayak}</button>
                </c:otherwise>
            </c:choose>
            <ul class="dropdown-menu" role="menu">
                <li><a data-toggle="modal" data-target="#editKayakModal" data-kayak-id="${kayak.id}">Redigér</a></li>
                <li class="divider"></li>
                <li><a href="delete_kayak.html?id=${kayak.id}">Slet</a></li>
            </ul>
        </div>
    </c:forEach>
</div>


<%--<div class="container">--%>

    <%--<form class="form-narrow form-horizontal" method="POST" action="upload_persons.html" enctype="multipart/form-data">--%>
        <%--<div class="field">--%>
            <%--<p><input id="uploaded" type="file" name="uploaded"/>--%>
                <%--<input type="submit" value="Import Personer"/>--%>
            <%--<dd class="errorMsg">--%>
                <%--<strong><c:out value="${parseError}"/></strong>--%>
            <%--</dd>--%>
            <%--</p>--%>
        <%--</div>--%>
    <%--</form>--%>

    <%--<form class="form-narrow form-horizontal" method="POST" action="upload_kayaks.html" enctype="multipart/form-data">--%>
        <%--<div class="field">--%>
            <%--<p><input id="uploaded" type="file" name="uploaded"/>--%>
                <%--<input type="submit" value="Import Kajakker"/>--%>
            <%--<dd class="errorMsg">--%>
                <%--<strong><c:out value="${parseError}"/></strong>--%>
            <%--</dd>--%>
            <%--</p>--%>
        <%--</div>--%>
    <%--</form>--%>


<%--</div>--%>

<script>
    //triggered when modal is about to be shown
    $('#editKayakModal').on('show.bs.modal', function(e) {

        //get data-id attribute of the clicked element
        var bookId = $(e.relatedTarget).data('kayak-id');

        //populate the textbox
        $(e.currentTarget).find('input[name="kayakId"]').val(bookId);
    });
</script>
</body>
</html>