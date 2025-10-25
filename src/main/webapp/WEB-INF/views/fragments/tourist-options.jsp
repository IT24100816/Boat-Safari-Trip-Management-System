<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:forEach var="tourist" items="${tourists}">
    <option value="${tourist.id}" data-name="${tourist.firstName} ${tourist.lastName}" data-nic="${tourist.nic}">${tourist.firstName} ${tourist.lastName}</option>
</c:forEach>