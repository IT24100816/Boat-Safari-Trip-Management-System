<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:forEach var="driver" items="${drivers}">
  <option value="${driver.id}" data-name="${driver.firstName} ${driver.lastName}" data-license="${driver.licenseNumber}" data-phone="${driver.phone}">${driver.firstName} ${driver.lastName}</option>
</c:forEach>