<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<nav class="navbar navbar-default" style="margin-top: -50px; height: 53px;">
    <div class="container-fluid">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                    data-target="#bs-example-navbar-collapse-1">
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
        </div>
    </div>
</nav>


<div class="col-md-12">
    <div class="row">
        <div class="col-sm-2">
            <!----------------------->
            <!-- Show person info  -->
            <!----------------------->
            <div class="container-fluid col-lg-offset-1" style="margin-left: 12px;">
                <fmt:formatDate value="${person.dayOfBirth}" pattern="yyyy" var="birthYear"/>


                <c:choose>
                <c:when test="${birthYear > 1997}">
                <button data-toggle="modal" data-target="#editPersonModal" type="button"
                        class="btn btn-success btn-fixed-width-trip dropdown-toggle" data-toggle="dropdown"
                        aria-expanded="false">
                    </c:when>
                    <c:when test="${birthYear < 1954}">
                    <button data-toggle="modal" data-target="#editPersonModal" type="button"
                            class="btn btn-primary btn-fixed-width-trip dropdown-toggle" data-toggle="dropdown"
                            aria-expanded="false">
                        </c:when>
                        <c:otherwise>
                        <button data-toggle="modal" data-target="#editPersonModal" type="button"
                                class="btn btn-warning btn-fixed-width-trip dropdown-toggle" data-toggle="dropdown"
                                aria-expanded="false">
                            </c:otherwise>
                            </c:choose>

                            <div class="media">
                                <div class="media-body">
                                    <b><u>${person.name}</u></b> <br>
                                    <small>${person.address}</small>
                                    <br>
                                    <small>Mobil: ${person.mobile}</small>
                                    <br>
                                    <small>Telefon: ${person.phone}</small>
                                    <br>
                                    <small>Mail: <a style="color: #ffffff"
                                                    href="mailto:${person.email}">${person.email}</a></small>
                                    <br>
                                    <small>Født: ${person.dayOfBirth}</small>
                                    <br>
                                    <small>Oprette: ${person.created}</small>
                                    <br>
                                </div>
                                <div style="float: right">
                                    <a>
                                        <c:if test="${empty person.facebookProfileId}">
                                            <c:if test="${person.female}">
                                                <img class="media-object custom-media" style="margin-top: 8px"
                                                     src="resources/images/woman.jpg">
                                            </c:if>
                                            <c:if test="${not person.female}">
                                                <img class="media-object custom-media" style="margin-top: 8px"
                                                     src="resources/images/man.jpg">
                                            </c:if>
                                        </c:if>
                                        <c:if test="${not empty person.facebookProfileId}">
                                            <img class="media-object custom-media"
                                                 style="margin-top: 8px; float: right;"
                                                 src="//graph.facebook.com/${person.facebookProfileId}/picture">
                                        </c:if>
                                    </a><br><br><br><br>
                                    <c:if test="${person.ranking == 2147483647}">
                                        <small>Placering: -</small>
                                        <br>
                                    </c:if>
                                    <c:if test="${person.ranking != 2147483647}">
                                        <small>Placering: ${person.ranking}</small>
                                        <br>
                                    </c:if>
                                    <small>Distance: <fmt:formatNumber maxFractionDigits="1" minFractionDigits="1"
                                                                       value="${person.distance}"/> km
                                    </small>
                                </div>
                            </div>
                        </button>
            </div>
            <!----------------------->
            <!-- Show all trips -->
            <!----------------------->
            <div class="container-fluid col-lg-offset-1">
                <c:forEach items="${tripList}" var="trip">
                    <div class="btn-group">
                        <c:choose>
                            <c:when test="${fn:containsIgnoreCase(trip.kayak.type, 'kap')}">
                                <button type="button" class="btn-fixed-width-trip btn btn-warning dropdown-toggle"
                                        data-toggle="dropdown" aria-expanded="false">${trip}</button>
                            </c:when>
                            <c:when test="${fn:containsIgnoreCase(trip.kayak.type, 'hav')}">
                                <button type="button" class="btn-fixed-width-trip btn btn-success dropdown-toggle"
                                        data-toggle="dropdown" aria-expanded="false">${trip}</button>
                            </c:when>
                            <c:otherwise>
                                <button type="button" class="btn-fixed-width-trip btn btn-primary dropdown-toggle"
                                        data-toggle="dropdown" aria-expanded="false">${trip}</button>
                            </c:otherwise>
                        </c:choose>
                        <ul class="dropdown-menu" role="menu">
                            <li><a data-toggle="modal" data-target="#editTripModal" class="dropdown" aria-expanded="false"
                                   data-trip-id="${trip.id}"
                                   data-person-id="${person.id}"
                                   data-first-name="${trip.persons[0].name}"
                                   data-kayak-name="${trip.kayak.location} ${trip.kayak.name} ${trip.kayak.type} ${trip.kayak.level} ${trip.kayak.owner}"
                                   data-start-time="<fmt:formatDate value="${trip.bookingDate.toDate()}" pattern="yyyy-MM-dd HH:mm"/>"
                                   data-end-time="<fmt:formatDate value="${trip.returnDate.toDate()}" pattern="yyyy-MM-dd HH:mm"/>"
                                   data-destination-name="${trip.destination.name}"
                                   data-distance="${trip.distance}"
                                   data-no-of-seats="${trip.kayak.seats}"
                                    <c:if test="${trip.kayak.seats > 1 && trip.persons.size() > 1}">
                                        data-second-name="${trip.persons[1].name}"
                                    </c:if>
                                    <c:if test="${trip.kayak.seats > 2 && trip.persons.size() > 2}">
                                        data-third-name="${trip.persons[2].name}"
                                    </c:if>
                                    <c:if test="${trip.kayak.seats > 3 && trip.persons.size() > 3}">
                                        data-fourth-name="${trip.persons[3].name}"
                                    </c:if>
                                    >Redigér</a></li>
                            <li class="divider"></li>
                            <li><a href="delete_trip.html?id=${trip.id}">Slet</a></li>
                        </ul>
                    </div>
                </c:forEach>
            </div>
        </div>
        <div class="col-sm-2"></div>
        <div class="col-sm-7">
            <h1 style="color: #777; margin-top: -5px;">Oversigt ${year} - ${person.name}</h1>

            <canvas id="summary"></canvas>

            <div class="col-sm-9" style="float: left">
                <div class="col-sm-7">
                    <h4 style="color: #777">Favorit Kajakker</h4>
                    <c:forEach items="${kayaks}" var="kayak">
                        <div class="progress" style="margin-bottom: 5px;">
                            <c:choose>
                                <c:when test="${fn:containsIgnoreCase(kayak.type, 'kap')}">
                                    <div class="progress-bar progress-bar-warning"
                                         style="width: 100%; text-align: left; font-weight: bold;"><span
                                            style="position: absolute; text-align: center; padding-top: 1px;">&nbsp;&nbsp;&nbsp;&nbsp;${kayak.location} ${kayak.name} ${kayak.type} ${kayak.level}</span><span
                                            style="float: right; margin-right: 10px;"><fmt:formatNumber
                                            maxFractionDigits="0" value="${kayak.distance}"/> km</span></div>
                                </c:when>
                                <c:when test="${fn:containsIgnoreCase(kayak.type, 'hav')}">
                                    <div class="progress-bar progress-bar-success"
                                         style="width: 100%; text-align: left; font-weight: bold;"><span
                                            style="position: absolute; text-align: center; padding-top: 1px;">&nbsp;&nbsp;&nbsp;&nbsp;${kayak.location} ${kayak.name} ${kayak.type} ${kayak.level}</span><span
                                            style="float: right; margin-right: 10px;"><fmt:formatNumber
                                            maxFractionDigits="0" value="${kayak.distance}"/> km<span></div>
                                </c:when>
                                <c:otherwise>
                                    <div class="progress-bar progress-bar-primary"
                                         style="width: 100%; text-align: left; font-weight: bold;"><span
                                            style="position: absolute; text-align: center; padding-top: 1px;">&nbsp;&nbsp;&nbsp;&nbsp;${kayak.location} ${kayak.name} ${kayak.type} ${kayak.level}</span><span
                                            style="float: right; margin-right: 10px;"><fmt:formatNumber
                                            maxFractionDigits="0" value="${kayak.distance}"/> km<span></div>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </c:forEach>
                </div>

                <div class="col-sm-4">
                    <h4 style="color: #777; margin-top: 14px;">Distance</h4>
                    <canvas id="distribution"></canvas>
                    <div class="donut-inner">
                        <h4 style="width: 300px; text-align: center">Total</h4>
                        <h4 style="width: 300px; text-align: center"><fmt:formatNumber maxFractionDigits="0"
                                                                                       value="${sumTotal}"/> km</h4>
                    </div>
                </div>
            </div>
            <div class="col-sm-1">
            </div>
        </div>
    </div>
</div>


<div class="modal" id="editPersonModal">
    <form:form method="POST" action="/save_person.html?filter=${filterForm.filter}" commandName="editPersonForm"
               cssClass="form-narrow form-horizontal">
        <div class="modal-body">
            <div class="control-group" style="margin-top: -40px;">
                <label class="control-label" for="name">Navn</label>

                <div class="controls">
                    <form:input type="text" class="form-control" id="name" placeholder="Navn" path="person.name"/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="address">Addresse</label>

                <div class="controls">
                    <form:input type="text" class="form-control" id="address"
                                placeholder="Vejnavn Husnummer, Postnummer By" path="person.address"/>
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
                    <form:input type="text" class="form-control" id="facebookProfileId" placeholder="Facebook Id"
                                path="person.facebookProfileId"/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="dayOfBirth">Fødselsdag</label>

                <div class="controls">
                    <form:input type="text" class="form-control" id="dayOfBirth" placeholder="YYYY-MM-DD"
                                path="person.dayOfBirth"/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="flatwaterLevel">EPP Tur</label>

                <div class="controls">
                    <form:input type="text" class="form-control" id="flatwaterLevel" placeholder="EPP2"
                                path="person.flatwaterLevel"/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="flatwaterLevel">EPP Hav</label>

                <div class="controls">
                    <form:input type="text" class="form-control" id="openwaterLevel" placeholder="EPP2"
                                path="person.openwaterLevel"/>
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
                <div style="margin-top: -50px;">
                    <div class="btn-group pull-right">
                        <div class="">
                            <input type="submit" class="btn-fixed-width-sm btn btn-primary btn-group" role="button"
                                   value="Opdater"/>
                        </div>
                    </div>
                    <div class="btn-group pull-right" style="">
                        <div class="">
                            <a href="delete_person.html?id=${person.id}"
                               class="btn-fixed-width-sm btn btn-danger btn-group" role="button">Slet</a>
                        </div>
                    </div>

                </div>

            </div>

        </div>
        <form:input type="hidden" path="person.id"/>
        <form:input type="hidden" path="person.created"/>
    </form:form>
</div>


<div class="modal" id="editTripModal">

    <form:form method="POST" action="/trip/trip_detail.html" modelAttribute="editTripForm" acceptCharset="utf-8"  cssClass="form-narrow form-horizontal">
        <form:errors path="*" cssClass="errorblock" element="div" />
        <form:input type="hidden" id="tripId" path="tripId"/>
        <form:input type="hidden" id="personId" path="personId"/>
        <form:input type="hidden" id="noOfSeats" path="noOfSeats"/>

        <div class="">
            <div><b>Navne</b></div>
            <form:input style="margin-bottom: 2px;" type="text" class="form-control" id="firstName" placeholder="Navn" path="firstName"/>
            <form:input style="margin-bottom: 2px;" type="text" class="form-control" id="secondName" placeholder="Navn"  path="secondName"/>
            <form:input style="margin-bottom: 2px;" type="text" class="form-control" id="thirdName" placeholder="Navn"  path="thirdName"/>
            <form:input style="margin-bottom: 12px;" type="text" class="form-control" id="fourthName" placeholder="Navn"  path="fourthName"/>
        </div>
        <div class="">
            <div><b>Rejsemål</b></div>
            <form:input style="margin-bottom: 12px;" type="text" class="form-control" id="destinationName" placeholder="Rejsemål" path="destinationName"/>
        </div>
        <div class="">
            <div><b>Distance</b></div>
            <form:input style="margin-bottom: 12px;" type="text" class="form-control" id="distance" placeholder="Distance i km" path="distance"/>
        </div>
        <div class="">
            <div><b>Kajak</b></div>
            <form:input style="margin-bottom: 12px;" type="text" class="form-control" id="kayakName" placeholder="Kajak" path="kayakName"/>
        </div>
        <div class="">
            <div><b>Startet</b></div>
            <form:input style="margin-bottom: 12px;" type="text" class="form-control" id="startTime" placeholder="Start tidspunkt" path="startTime"/>
        </div>
        <div class="">
            <div><b>Afsluttet</b></div>
            <form:input style="margin-bottom: 12px;" type="text" class="form-control" id="endTime" placeholder="Afslut tidspunkt" path="endTime"/>
        </div>
        <div>
            <input style="margin-bottom: 12px;" type="submit" class="btn btn-primary pull-right" id="update" role="button" value="Opdater"/>
        </div>
        <br>
    </form:form>
</div>

<script type="text/javascript">


    window.onload = function () {

        var summaryCanvas = document.getElementById("summary");
        summaryCanvas.height = 400;
        summaryCanvas.width = 800;
        summaryCanvas.offsetLeft = 20;
        var summaryCtx = summaryCanvas.getContext("2d");

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

        var summaryChart = new Chart(summaryCtx).Bar(data, {
            scaleBeginAtZero: true,
            scaleShowGridLines: true,
            scaleGridLineColor: "rgba(0,0,0,.05)",
            scaleGridLineWidth: 1,
            scaleShowHorizontalLines: true,
            scaleShowVerticalLines: true,
            barShowStroke: true,
            barStrokeWidth: 2,
            barValueSpacing: 10,
            barDatasetSpacing: 1,
            multiTooltipTemplate: function (valuesObject) {
                return valuesObject.datasetLabel + " : " + valuesObject.value + " km";
            }

        });

        var distributionCanvas = document.getElementById("distribution");
        distributionCanvas.height = 300;
        distributionCanvas.width = 300;
        distributionCanvas.offsetLeft = 20;
        distributionCanvas.offsetTop = 20;
        var distributionCtx = distributionCanvas.getContext("2d");

        var distributionData = [
            {
                value: ${oceanTotal},
                color: "rgba(94,183,96,0.5)",
                highlight: "rgba(94,183,96,0.75)",
                label: "Hav"
            },
            {
                value: ${tourTotal},
                color: "rgba(70,140,200,0.5)",
                highlight: "rgba(70,140,200,0.75)",
                label: "Tur"
            },
            {
                value: ${sprintTotal},
                color: "rgba(238,172,87,0.5)",
                highlight: "rgba(238,172,87,0.75)",
                label: "Kap"
            }
        ]

        var distributionChart = new Chart(distributionCtx).Doughnut(distributionData, {
            //Boolean - Whether we should show a stroke on each segment
            segmentShowStroke: true,

            //String - The colour of each segment stroke
            segmentStrokeColor: "#f4f4f4",

            //Number - The width of each segment stroke
            segmentStrokeWidth: 2,

            //Number - The percentage of the chart that we cut out of the middle
            percentageInnerCutout: 50, // This is 0 for Pie charts

            //Number - Amount of animation steps
            animationSteps: 150,

            //String - Animation easing effect
            animationEasing: "easeOutBounce",

            //Boolean - Whether we animate the rotation of the Doughnut
            animateRotate: true,

            //Boolean - Whether we animate scaling the Doughnut from the centre
            animateScale: true,

            toolTipTemplate: function (valuesObject) {
                return valuesObject.datasetLabel + " : " + valuesObject.value + " km";
            }


        });

        $('#kayakName').autocomplete({
            serviceUrl: '${pageContext.request.contextPath}/findKayaks',
            paramName: "tagName",
            delimiter: ",",
            transformResult: function(response) {
                return {
                    suggestions: $.map($.parseJSON(response), function(item) {
                        return { value: item.tagName, data: item.id };
                    })
                };
            }
        });

        $('.autocomplete-suggestions').css('width','400px');


        $('#firstName').autocomplete({
            serviceUrl: '${pageContext.request.contextPath}/findNames',
            paramName: "tagName",
            delimiter: ",",
                transformResult: function(response) {
                    return {
                        suggestions: $.map($.parseJSON(response), function(item) {
                            return { value: item.tagName, data: item.id };
                    })
                };
            }
        });

        $('.autocomplete-suggestions').css('width','400px');

        $('#secondName').autocomplete({
            serviceUrl: '${pageContext.request.contextPath}/findNames',
            paramName: "tagName",
            delimiter: ",",
            transformResult: function(response) {
                return {
                    suggestions: $.map($.parseJSON(response), function(item) {
                        return { value: item.tagName, data: item.id };
                    })
                };
            }
        });

        $('.autocomplete-suggestions').css('width','400px');

        $('#thirdName').autocomplete({
            serviceUrl: '${pageContext.request.contextPath}/findNames',
            paramName: "tagName",
            delimiter: ",",
            transformResult: function(response) {
                return {
                    suggestions: $.map($.parseJSON(response), function(item) {
                        return { value: item.tagName, data: item.id };
                    })
                };
            }
        });

        $('.autocomplete-suggestions').css('width','400px');

        $('#fourthName').autocomplete({
            serviceUrl: '${pageContext.request.contextPath}/findNames',
            paramName: "tagName",
            delimiter: ",",
            transformResult: function(response) {
                return {
                    suggestions: $.map($.parseJSON(response), function(item) {
                        return { value: item.tagName, data: item.id };
                    })
                };
            }
        });

        $('.autocomplete-suggestions').css('width','400px');

        $('#destinationName').autocomplete({
            serviceUrl: '${pageContext.request.contextPath}/findDestinations',
            paramName: "tagName",
            delimiter: ",",
            transformResult: function(response) {
                return {
                    suggestions: $.map($.parseJSON(response), function(item) {
                        return { value: item.tagName, data: item.id };
                    })
                };
            }
        });

        $('.autocomplete-suggestions').css('width','400px');

        $('#editTripModal').on('show.bs.modal', function(event) {
            $("#tripId").val($(event.relatedTarget).data('trip-id'));
            $("#personId").val($(event.relatedTarget).data('person-id'));
            $("#firstName").val($(event.relatedTarget).data('first-name'));
            $("#secondName").val($(event.relatedTarget).data('second-name'));
            $("#thirdName").val($(event.relatedTarget).data('third-name'));
            $("#fourthName").val($(event.relatedTarget).data('fourth-name'));
            $("#kayakName").val($(event.relatedTarget).data('kayak-name'));
            $("#startTime").val($(event.relatedTarget).data('start-time'));
            $("#endTime").val($(event.relatedTarget).data('end-time'));
            $("#destinationName").val($(event.relatedTarget).data('destination-name'));
            $("#distance").val($(event.relatedTarget).data('distance'));
            $("#noOfSeats").val($(event.relatedTarget).data('no-of-seats'));
        });


    }

</script>

</body>
</html>