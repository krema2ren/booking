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
    <script src="<c:url value="/resources/core/chart.min.js" />"></script>

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
            <!----------------------->
            <!-- Show person info  -->
            <!----------------------->
            <div class="container-fluid col-lg-offset-1">
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

            <!----------------------->
            <!-- Show all trips -->
            <!----------------------->
            <div class="container-fluid col-lg-offset-1">
                <c:forEach items="${tripList}" var="trip">
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
                            <li><a href="edit_booking.html?id=${trip.id}">Redigér</a></li>
                            <li class="divider"></li>
                            <li><a href="delete_booking.html?id=${trip.id}">Slet</a></li>
                        </ul>
                    </div>
                </c:forEach>
            </div>


        </div>
        <div class="col-sm-1">
        </div>
        <div class="col-sm-6">
            <h1 style="color: #777;">Oversigt ${year} - ${person.name}</h1>
            <canvas id="myChart"></canvas>

            <div class="col-sm-9">
                <div class="progress">
                    <div class="progress-bar progress-bar-danger" style="width: 100%; text-align: left; font-weight: bold;"><span style="position: absolute; text-align: center; padding-top: 1px;">&nbsp;&nbsp;&nbsp;&nbsp;Total ${sumTotal} km&nbsp;&nbsp;-&nbsp;&nbsp;100%<span>
                    </div>
                </div>
                <div class="progress">
                    <div class="progress-bar progress-bar-success" style="width: ${oceanTotal / sumTotal * 100}%; text-align: left; font-weight: bold"><span style="position: absolute; text-align: center; padding-top: 1px;">&nbsp;&nbsp;&nbsp;&nbsp;Hav ${oceanTotal} km&nbsp;&nbsp;-&nbsp;&nbsp;<fmt:formatNumber value="${oceanTotal / sumTotal * 100}" maxFractionDigits="1" />%</span>
                    </div>
                </div>
                <div class="progress">
                    <div class="progress-bar" style="width: ${tourTotal / sumTotal * 100}%;text-align: left; font-weight: bold"><span style="position: absolute; text-align: center; padding-top: 1px;">&nbsp;&nbsp;&nbsp;&nbsp;Tur ${tourTotal} km&nbsp;&nbsp;-&nbsp;&nbsp;<fmt:formatNumber value="${tourTotal / sumTotal * 100}"  maxFractionDigits="1" />%</span>
                    </div>
                </div>
                <div class="progress">
                    <div class="progress-bar progress-bar-warning" style="width: ${sprintTotal / sumTotal * 100}%; text-align: left; font-weight: bold"><span style="position: absolute; text-align: center; padding-top: 1px;">&nbsp;&nbsp;&nbsp;&nbsp;Kap ${sprintTotal} km&nbsp;&nbsp;-&nbsp;&nbsp;<fmt:formatNumber value="${sprintTotal / sumTotal * 100}"  maxFractionDigits="1" /> %</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-sm-1">
            <h1 style="color: #777;">Placering</h1>
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


<script type="text/javascript">


    window.onload = function () {

        var canvas = document.getElementById("myChart");
        canvas.height = 400;
        canvas.width = 800;
        canvas.offsetLeft = 20;
        var ctx = canvas.getContext("2d");

        var data = {
            labels: ["Januar", "Februar", "Marts", "April", "Maj", "Juni", "Juli", "August", "September", "Oktober", "November", "December"],
            datasets: [
                {
                    label: "Total",
                    fillColor: "rgba(215,84,82,0.5)",
                    strokeColor: "rgba(215,84,82,0.8)",
                    highlightFill: "rgba(215,84,82,0.75)",
                    highlightStroke: "rgba(215,84,82,1)",
                    data: ${sum}
                },
                {
                    label: "Hav",
                    fillColor: "rgba(94,183,96,0.5)",
                    strokeColor: "rgba(94,183,96,0.8)",
                    highlightFill: "rgba(94,183,96,0.75)",
                    highlightStroke: "rgba(94,183,96,1)",
                    data: ${ocean}
                },
                {
                    label: "Tur",
                    fillColor: "rgba(70,140,200,0.5)",
                    strokeColor: "rgba(70,140,200,0.8)",
                    highlightFill: "rgba(70,140,200,0.75)",
                    highlightStroke: "rgba(70,140,200,1)",
                    data: ${tour}
                },
                {
                    label: "Kap",
                    fillColor: "rgba(238,172,87,0.5)",
                    strokeColor: "rgba(238,172,87,0.8)",
                    highlightFill: "rgba(238,172,87,0.75)",
                    highlightStroke: "rgba(238,172,87,1)",
                    data: ${sprint}
                }
            ]
        };

        var myBarChart = new Chart(ctx).Bar(data, {
            scaleBeginAtZero : true,
            scaleShowGridLines : true,
            scaleGridLineColor : "rgba(0,0,0,.05)",
            scaleGridLineWidth : 1,
            scaleShowHorizontalLines: true,
            scaleShowVerticalLines: true,
            barShowStroke : true,
            barStrokeWidth : 2,
            barValueSpacing : 10,
            barDatasetSpacing : 1,
            multiTooltipTemplate: function(valuesObject){
                return valuesObject.datasetLabel + " : " + valuesObject.value + " km";
            }

        });

    }

</script>

</body>
</html>