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
                <li class=""><a href="/trip">Turer<span class="sr-only">(current)</span></a></li>
                <li><a href="/trip/kayaks">Kajakker</a></li>
                <li><a href="/trip/persons">Medlemmer</a></li>
                <li><a href="/trip/admin">Admin</a></li>
            </ul>

            <%--<ul class="nav navbar-nav navbar-collapse">--%>
                <%--<div class="search">--%>
                    <%--<form:form class="navbar-form navbar-left" method="POST" action="/filter_kayaks.html" commandName="filterKayaksForm">--%>
                        <%--<fieldset>--%>
                            <%--<div class="form-group">--%>
                                <%--<div class="">--%>
                                    <%--<form:input type="text" class="form-control" id="w-input-kayak" placeholder="Kajak eller plads" path="filter"/>--%>
                                <%--</div>--%>
                            <%--</div>--%>
                            <%--<div class="form-group">--%>
                                <%--<button type="submit" class="btn btn-default" id="book">Filtrér</button>--%>
                            <%--</div>--%>
                        <%--</fieldset>--%>
                    <%--</form:form>--%>
                <%--</div>--%>
            <%--</ul>--%>
        </div>
    </div>
</nav>


<div class="container col-lg-6 col-lg-offset-1">

    <form class="" method="POST" action="upload_persons.html" enctype="multipart/form-data">
        <div class="col-lg-6 col-sm-6 col-12">
            <h4>Importer Medlemmer</h4>
            <div class="input-group">
                    <span class="input-group-btn">
                        <span class="btn btn-primary btn-file">
                            Vælg...<input name="uploaded" type="file" multiple>
                        </span>
                    </span>
                <input type="text" class="form-control" readonly>
            </div>
            <br/>
            <input class="btn btn-primary" role="button" type="submit" value="Importer Medlemmer"/>
        </div>
    </form>

    <br/>
    <br/>
    <br/>
    <br/>
    <br/>
    <br/>
    <br/>

    <form method="POST" action="upload_kayaks.html" enctype="multipart/form-data">
        <div class="col-lg-6 col-sm-6 col-12">
            <h4>Importer Kajakker</h4>
            <div class="input-group">
                    <span class="input-group-btn">
                        <span class="btn btn-primary btn-file">
                            Vælg...<input name="uploaded" type="file" multiple>
                        </span>
                    </span>
                <input type="text" class="form-control" readonly>
            </div>
            <br/>
            <input class="btn btn-primary" role="button" type="submit" value="Importer Kajakker"/>
        </div>
    </form>


        <%--<div class="field">--%>
            <%--<p><input id="uploaded" type="file" name="uploaded"/>--%>
                <%--<input type="submit" value="Import Kajakker"/>--%>
            <%--<dd class="errorMsg">--%>
                <%--<strong><c:out value="${parseError}"/></strong>--%>
            <%--</dd>--%>
            <%--</p>--%>
        <%--</div>--%>
    <%--</form>--%>



    <form:form class="" method="POST" action="/create_data.html" commandName="testForm" acceptCharset="utf-8">
        <fieldset>
            <div class="form-group">
                <div>
                    <form:input type="text" class="form-control" id="" placeholder="Antal" path="noOfTrips"/>
                </div>
            </div>
            <div class="form-group">
                <input type="submit" class="btn btn-primary" id="addPerson" role="button" value="Opret tilfældige ture"/>
            </div>
        </fieldset>
    </form:form>





</div>

<script>
    $(document).on('change', '.btn-file :file', function() {
        var input = $(this),
                numFiles = input.get(0).files ? input.get(0).files.length : 1,
                label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
        input.trigger('fileselect', [numFiles, label]);
    });

    $(document).ready( function() {
        $('.btn-file :file').on('fileselect', function(event, numFiles, label) {

            var input = $(this).parents('.input-group').find(':text'),
                    log = numFiles > 1 ? numFiles + ' files selected' : label;

            if( input.length ) {
                input.val(log);
            } else {
                if( log ) alert(log);
            }

        });
    });

</script>
</body>
</html>