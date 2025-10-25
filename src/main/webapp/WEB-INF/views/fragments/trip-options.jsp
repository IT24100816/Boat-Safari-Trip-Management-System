<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:forEach var="trip" items="${trips}">
  <option value="${trip.id}" data-name="${trip.name}">${trip.name}</option>
</c:forEach>