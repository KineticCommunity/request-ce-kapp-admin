<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../../bundle/initialization.jspf" %>
<%@include file="../../bundle/router.jspf" %>

<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <!-- Sets title and imports js and css specific to this console. -->
    <bundle:variable name="head">
        <c:import url="${bundle.path}/partials/form-management/head.jsp" charEncoding="UTF-8"/>
    </bundle:variable>
    
    <!-- BREADCRUMBS START HERE. Remove if not needed. ------------------------------------------->
    <bundle:variable name="breadcrumb">
        <li class="active">${form.name}</li>
    </bundle:variable>
    <!-- BREADCRUMBS END HERE. ------------------------------------------------------------------->

    <!-- PAGE CONTENT STARTS HERE ---------------------------------------------------------------->
    
    <div class="page-header">
        <h3>${text.escape(form.name)}</h3>
    </div>
    
    <div class="row">
        <div class="col-xs-12">
            <table class="table table-hover table-striped form-management-kapps" 
                   data-table-dom data-table-name="Kapps"> 
                <thead>
                    <tr>
                        <th>Kapp Name</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="kapp" items="${space.kapps}">
                        <tr>
                            <td><a href="${bundle.kappLocation}/${form.slug}?page=form-management/forms&kapp=${kapp.slug}">${text.escape(kapp.name)}</a></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- PAGE CONTENT ENDS HERE ------------------------------------------------------------------>
    
    <!-- RIGHT SIDEBAR CONTENT STARTS HERE. Remove if not needed. -------------------------------->
    <bundle:variable name="aside">
        <h3>${form.name}</h3>
        <p>${form.description}</p>
        <hr class="border-color-white" />
        <h4>
            Instructions
        </h4>
        <p>
            To manage a Kapp's forms, click the name of the Kapp.
        </p>
        <hr class="border-color-white" />
        <h4>
            Advanced Management
        </h4>
        <p>
            The <span class="strong">Kinetic Request</span> Management Console is for advanced configuration of portals and forms. Most common configurations can be made using this Admin Console.
        </p>
        <a target="_blank" href="${bundle.spaceLocation}/app" class="btn btn-block btn-default">
            <span class="glyphicon glyphicon-cog pull-left" aria-hidden="true"></span> Kinetic Request
        </a>
        <p/>
    </bundle:variable>
    <!-- RIGHT SIDEBAR CONTENT ENDS HERE. -------------------------------------------------------->
    
</bundle:layout>