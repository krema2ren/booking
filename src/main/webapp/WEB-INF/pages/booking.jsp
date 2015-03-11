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

<!---------------->
<!-- Navigation -->
<!---------------->
<nav class="navbar navbar-default" style="margin-top: -50px; height: 53px;">
    <div class="container-fluid">
        <!-- Brand and toggle get grouped for better mobile display -->
        <%--<div class="navbar-header">--%>
            <%--<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">--%>
                <%--<span class="sr-only">Toggle navigation</span>--%>
                <%--<span class="icon-bar"></span>--%>
                <%--<span class="icon-bar"></span>--%>
                <%--<span class="icon-bar"></span>--%>
            <%--</button>--%>
            <%--<a class="navbar-brand" href="#"></a>--%>
        <%--</div>--%>

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
                    <form:form class="navbar-form navbar-left" method="POST" action="/book.html" commandName="bookingForm" acceptCharset="utf-8">
                        <fieldset>
                            <div class="form-group">
                                <div style="width: 310px;">
                                    <form:input type="text" class="form-control" id="w-input-kayak" placeholder="Kajak eller plads" path="kayakName"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <div style="width: 310px;">
                                    <form:input type="text" class="form-control" id="w-input-name" placeholder="Navn" path="personName"/>
                                </div>
                            </div>

                            <%--<c:choose>--%>
                                <%--<c:when test="${status.error}">--%>
                                    <%--<div class="form-group has-error">--%>
                                <%--</c:when>--%>
                                <%--<c:otherwise>--%>
                                    <%--<div class="form-group">--%>
                                <%--</c:otherwise>--%>
                            <%--</c:choose>--%>
                            <div class="form-group">
                                <div style="width: 310px;">

                                    <form:input type="text" class="form-control" id="w-input-trip" placeholder="Rejsemål" path="destination"/>

                                </div>
                            </div>
                            <div class="form-group">
                                <button type="submit" class="btn btn-primary" id="book">Start</button>
                            </div>
                        </fieldset>
                        <fieldset>
                            <div class="form-group">
                                <div style="width: 310px;">
                                    <form:errors class="alert alert-danger alert-dismissable" role="alert" path="kayakName" element="div"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <div style="width: 310px;">
                                    <form:errors class="alert alert-danger alert-dismissable" role="alert" path="personName" element="div"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <div style="width: 310px;">
                                    <form:errors class="alert alert-danger alert-dismissable" role="alert" path="destination" element="div"/>
                                </div>
                            </div>
                        </fieldset>
                    </form:form>
                </div>
            </ul>
        </div>
    </div>
</nav>


<!----------------------->
<!-- Show all trips -->
<!----------------------->
<img src="resources/images/waves.jpg" style="margin-top: -25px;">
<div class="container-fluid col-lg-offset-1" style="margin-top: -100px;">
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
                <li><a data-toggle="modal" data-target="#finishModal" data-trip-id="${trip.id}" data-distance-id="${trip.destination.distance}">Afslut</a></li>
                <c:if test="${trip.kayak.seats > fn:length(trip.persons)}">
                    <li><a data-toggle="modal" data-target="#addPersonModal" data-trip-id="${trip.id}">Tilføj Person</a></li>
                </c:if>
                <li class="divider"></li>
                <li><a href="delete_trip.html?id=${trip.id}">Slet</a></li>
            </ul>
        </div>
    </c:forEach>
</div>

<!---------------------------------->
<!-- Add person to trip modal  -->
<!---------------------------------->
<div class="modal fade" id="addPersonModal" aria-hidden="true">
    <div class="modal-dialog">
        <div class="">
            <div class="">
                <form:form class="" method="POST" action="/add_person.html" commandName="addPersonForm" acceptCharset="utf-8">
                    <fieldset>
                        <div class="form-group">
                            <div>
                                <form:input type="text" class="form-control" id="addPersonModalName" placeholder="Navn" path="name"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <div>
                                <form:input type="hidden" class="form-control" id="addPersonModalBookingId" placeholder="Navn" path="bookingId"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <input type="submit" class="btn btn-primary" id="addPerson" role="button" value="Tilføj"/>
                        </div>
                    </fieldset>
                </form:form>
            </div>
        </div>
    </div>
</div>


<!---------------------------------->
<!-- Finish trip modal  -->
<!---------------------------------->
<div class="modal fade" id="finishModal" aria-hidden="true">
    <form:form class="" method="POST" action="/finish.html" commandName="finishForm" acceptCharset="utf-8">
    <div class="modal-dialog">
        <div class="">
            <div class="">
                    <fieldset>
                        <div class="form-group">
                            <div>
                                <form:input type="text" class="form-control" id="finishModalDistanceId"  placeholder="Distance" path="distance"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <div>
                                <form:input type="hidden" class="form-control" id="finishModalBookingId"  path="bookingId"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <div>
                                <input type="submit" class="btn btn-primary" id="finish" role="button" value="Indtast Distance"/>
                            </div>
                        </div>
                    </fieldset>
            </div>
        </div>
    </div>
    </form:form>
</div>

<!----------------------->
<!-- Trip of kayaks -->
<!----------------------->
<div class="modal fade" id="bookingModal" aria-hidden="true">
<div class="modal-body">
    <div class="text-right">
      <div class="search">
          <form:form class="form-narrow form-horizontal" method="POST" action="/book.html" commandName="bookingForm">
              <fieldset>
               <div class="form-group">
                  <label class="col-lg-2 control-label">Kajak</label>
                  <div class="col-lg-10">
                      <form:input type="text" class="form-control" id="w-input-kayak" placeholder="Kajak eller plads" path="kayakName"/>
                  </div>
              </div>
              <div class="form-group">
                  <label class="col-lg-2 control-label">Navn</label>
                  <div class="col-lg-10">
                      <form:input type="text" class="form-control" id="w-input-name" placeholder="Navn" path="personName"/>
                  </div>
              </div>
              <div class="form-group">
                  <label class="col-lg-2 control-label">Rejsem&#229;l</label>
                  <div class="col-lg-10">
                      <form:input type="text" class="form-control" id="w-input-trip" placeholder="Rejsemål" path="destination"/>
                  </div>
              </div>
              <div>
                  <input type="submit" class="btn btn-primary" id="book" role="button" value="Reserver"/>
              </div>
              </fieldset>
          </form:form>
      </div>
    </div>
</div>
</div>

<div class="panel-footer text-center">&copy; 2015 K&#248;ge Kano &amp; Kajak Klub</div>

<script>
$(document).ready(function() {
    $('#addPersonModalName').autocomplete({
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

	$('#w-input-kayak').autocomplete({
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
	$('#w-input-name').autocomplete({
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


	$('#w-input-trip').autocomplete({
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


    $('#addPersonModal').on('show.bs.modal', function(event) {
        $("#addPersonModalName").select();
        $("#addPersonModalBookingId").val($(event.relatedTarget).data('trip-id'));
    });

    $('#finishModal').on('show.bs.modal', function(event) {
        $("#finishModalDistanceId").select();
        $("#finishModalDistanceId").focus();
        $("#finishModalDistanceId").val($(event.relatedTarget).data('distance-id'));
        $("#finishModalBookingId").val($(event.relatedTarget).data('trip-id'));
    });



});
</script>
</body>
</html>