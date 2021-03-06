<%@page pageEncoding="UTF-8" contentType="application/json" trimDirectiveWhitespaces="true"%>
<%@include file="../../bundle/initialization.jspf" %>

<c:set var="currentStore" value="${kapp.getForm(param.store)}" scope="request" />
<c:set var="fields" value="${AdminHelper.getDatastoreColumns(currentStore, 'Datastore Configuration')}" scope="request" />
<c:set var="orderColumn" value="${0}" />
<json:object>
  <json:array name="columns">
    <json:object>
      <json:property name="title" value=""/>
      <json:property name="defaultContent" value="&nbsp;"/>
      <json:property name="visible" value="${true}"/>
      <json:property name="class" value="control ignore-export all"/>
      <json:property name="orderable" value="${false}"/>
    </json:object>
    <c:forEach var="field" items="${fields}" varStatus="status">
      <json:object>
        <json:property name="title" value="${field.title}"/>
        <json:property name="data" value="${field.data}"/>
        <json:property name="renderType" value="${field.renderType}"/>
        <json:property name="visible" value="${field.visible}"/>
        <json:property name="searchable" value="${field.searchable}"/>
        <json:property name="orderable" value="${field.orderable}"/>
        <c:if test="${orderColumn eq 0 && field.visible eq true}">
            <c:set var="orderColumn" value="${status.index+1}" />
        </c:if>
      </json:object>
    </c:forEach>
    <json:object>
      <json:property name="title" value="Datastore Record ID"/>
      <json:property name="data" value="ID"/>
      <json:property name="visible" value="${false}"/>
    </json:object>
    <json:object>
      <json:property name="title" value=""/>
      <json:property name="data" value=""/>
      <json:property name="visible" value="${true}"/>
      <json:property name="renderType" value="actionButtons"/>
      <json:property name="class" value="actions ignore-export all"/>
      <json:property name="orderable" value="${false}"/>
      <json:property name="defaultContent" value=""/>
    </json:object>
  </json:array>
  <json:array name="order">
    <json:array>
      <json:property value="${orderColumn}"/>
      <json:property value="asc"/>
    </json:array>
  </json:array>
</json:object>