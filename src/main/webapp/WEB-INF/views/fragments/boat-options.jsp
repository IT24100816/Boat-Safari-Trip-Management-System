<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:forEach var="boat" items="${boats}">
  <option value="${boat.id}" data-name="${boat.boatName}" data-registration="${boat.registrationNumber}" data-capacity="${boat.capacity}">${boat.boatName}</option>
</c:forEach>