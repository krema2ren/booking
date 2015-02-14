<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<html>
<head >
    <script src="<c:url value="/resources/core/jquery.1.10.2.min.js" />"></script>
    <script src="<c:url value="/resources/core/jquery.autocomplete.min.js" />"></script>
    <script src="<c:url value="/resources/core/bootstrap.min.js" />"></script>

    <link href="<c:url value="/resources/core/bootstrap.min.css" />" rel="stylesheet"/>
    <link href="<c:url value="/resources/core/main.css" />" rel="stylesheet"/>
</head>
<body>

<div class="container text-center">
    <div class="row">
        <div class="span12">
            <div class="hero-unit center">
                <h1>Uuups, der er sket en fejl...</h1>
                <br />
                <p>...undskyld, men prøv igen og må gode tanker og karma hjælpe dig!</p>
                <a href="/booking" class="btn btn-large btn-primary">Tilbage</a>
                <a data-toggle="modal" data-target="#showExceptionModal" class="btn btn-large btn-danger">Vis Fejl</a>
            </div>
            <br />
        </div>
    </div>
</div>

<div class="modal fade" id="showExceptionModal" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body">
                <div class="panel panel-danger">
                    <div class="panel-heading" style="word-wrap: break-word;">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <p><b>URL: ${url}</b></p>
                        <p>Exception: ${cause}</p>
                        <p>Message: ${exception.message}</p>
                    </div>
                    <div class="panel-body" style="word-wrap: break-word;">
                        <c:forEach items="${exception.stackTrace}" var="ste">
                            ${ste}
                            <br/>
                        </c:forEach>
                    </div>
                </div>
                <button type="button" class="btn btn-danger" data-dismiss="modal">Luk</button>
            </div>
        </div>
    </div>
</div>

<div class="panel-footer text-center">&copy; 2015 K&#248;ge Kano &amp; Kajak Klub</div>
</body>
</html>