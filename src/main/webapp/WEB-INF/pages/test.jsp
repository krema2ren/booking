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




<h1>TEST</h1>

<button type="button"  class="btn btn-fixed-width-booking btn-success dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
    <div class="media">
        <a class="" href="#">
            <img class="media-object custom-media" src="//graph.facebook.com/krema2ren/picture">
        </a>
        <div class="media-body">
            <b>Dennis Nielsen [ 19:00 - 23:00 ]</b> <br>
            <small>3. Hus Strøby Egede 21km</small><br>
            <small>13-1 Tirana Tur B KKKK</small><br>
        </div>
    </div>
</button>


<br>

<button type="button"  class="btn btn-fixed-width-booking btn-primary dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
    <div class="media" style="margin-left: -8px;">
        <img class="media-object custom-media" src="//graph.facebook.com/krema2ren/picture">
        <div class="media-body">
            <b>Dennis Nielsen [ 19:00 - 23:00 ]</b> <br>
            <small>3. Hus Strøby Egede 21km</small><br>
            <small>13-1 Tirana Tur B KKKK</small>
        </div>
    </div>
    <div class="media" style="margin-top: -5px; margin-left: -8px;">
        <img class="media-object custom-media" src="//graph.facebook.com/famhauge/picture">
        <div class="media-body">
            <b>Anders Hauge Sørensen [ 19:00 - 23:00 ]</b> <br>
            <small>3. Hus Strøby Egede 21km</small><br>
            <small>13-1 Tirana Tur B KKKK</small><br>
        </div>
    </div>
</button>





<button type="button"  class="btn btn-fixed-width-booking btn-success dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
<div class="col-xs-12 col-md-6">
    <div class="col-md-1">
        <img class="image" src="//graph.facebook.com/krema2ren/picture">
    </div>
    <div class="col-md-6 alignme">
        <span class="bold">Product Name</span>
        <button name="remove" value="1" type="submit" class="font-tiny btn-link">Remove</button>

        <br>

        <span class="small text-light">From "Company Name"</span>
    </div>

</div>
</button>

<div class="row">
    <div class="span4 media top-buffer">
        <div class="row">

        </div>
        <a href="#">
            <img class="media-object" src="//graph.facebook.com/krema2ren/picture">

        </a>
    </div>
    <div class="media-body">
        <h5 class="media-heading">Dennis Nielsen</h5>
        ...
    </div>
</div>


<div class="row">
    <div class="span12 media top-buffer">
        <div class="row">
            <p class="media-object">
                <img src="//graph.facebook.com/krema2ren/picture">
            </p>
            <div class="media-body span6">
                <h3 class="media-heading clearfix">Dennis Nielsen<i class="icon-circle addToFoo-yes-org"></i> <button class="addToFoo-org btn btn-flat pull-right"><i class="icon-plus-sign"></i> Add to My Foo</button><br />
                </h3>

                <p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>
            </div>
        </div>
    </div>
</div>


<%--<button type="button"  class="btn-fixed-width-booking btn btn-warning dropdown-toggle" data-toggle="dropdown" aria-expanded="false">--%>
<%--<div class="paragraphs">--%>
    <%--<div class="row">--%>
        <%--<div class="span4">--%>
            <%--<img class="pull-left" src="//graph.facebook.com/krema2ren/picture">--%>
            <%--<div class="content-heading"><h4>&nbspDennis Nielsen</h4>Bølgebryderen 18km</div>--%>
            <%--<p style="clear:both">Donec id elit non mi porta gravida at eget metus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui.</p>--%>
        <%--</div>--%>
    <%--</div>--%>
<%--</div>--%>
<%--</button>--%>
<%--<div class="panel">--%>
    <%--<div class="page-header">--%>
        <%--<img src="//graph.facebook.com/krema2ren/picture">--%>
        <%--<p>Dennis Nielsen</p>--%>
    <%--</div>--%>

<%--</div>--%>
</body>
</html>