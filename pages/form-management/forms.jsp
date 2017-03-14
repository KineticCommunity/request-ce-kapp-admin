<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../../bundle/initialization.jspf" %>
<c:set var="console" value="${form}" scope="request"/>
<c:set var="currentKapp" value="${space.getKapp(param.kapp)}" scope="request"/>

<!-- Show page content only if selected Kapp exists. -->
<c:choose>
    <c:when test="${empty currentKapp}">
        <script>window.location.replace("${bundle.kappLocation}/${form.slug}");</script>
    </c:when>
    <c:otherwise>
    
        <bundle:layout page="${bundle.path}/layouts/layout.jsp">
            <!-- Imports js and css specific to this console. -->
            <bundle:variable name="head">
                <c:import url="${bundle.path}/partials/form-management/head.jsp" charEncoding="UTF-8"/>
            </bundle:variable>
            
            <!-- BREADCRUMBS START HERE. Remove if not needed. ------------------------------------------->
            <bundle:variable name="breadcrumb">
                <li><a href="${bundle.kappLocation}/${form.slug}">${form.name}</a></li>
                <li class="active">${text.escape(currentKapp.name)}</li>
            </bundle:variable>
            <!-- BREADCRUMBS END HERE. ------------------------------------------------------------------->

            <!-- PAGE CONTENT STARTS HERE ---------------------------------------------------------------->
            
            <div class="page-header">
                <div class="row">
                    <div class="col-xs-12">
                        <h3>
                            <span>${text.escape(currentKapp.name)}</span>
                            <small>Forms</small>
                            <div class="pull-right">
                                <button class="hidden btn btn-tertiary pull-right add-category btn-sm">
                                    <span class="fa fa-plus"></span> Add Category
                                </button>
                            </div>
                        </h3>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-xs-12 table-responsive">
                    <table class="table table-sm table-hover table-striped form-management-forms" 
                           data-table-dom data-table-name="Forms"> 
                        <thead>
                            <tr>
                                <th>Form Name</th>
                                <th>Approver</th>
                                <th>Approval SLA</th>
                                <th>Approval Form</th>
                                <th>Task SLA</th>
                                <th>Task Form</th>
                                <th>Task Assignee Team</th>
                                <th>Task Assignee Individual</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="form" items="${currentKapp.forms}">
                                <tr>
                                    <td><a href="${bundle.kappLocation}/${console.slug}?page=form-management/form&kapp=${currentKapp.slug}&form=${form.slug}">${text.escape(form.name)}</a></td>
                                    <td>${form.getAttributeValue('Approver')}</td>
                                    <td>${form.getAttributeValue('Approval Days Due')}</td>
                                    <td>${form.getAttributeValue('Approval Form Slug')}</td>
                                    <td>${form.getAttributeValue('Task Days Due')}</td>
                                    <td>${form.getAttributeValue('Task Form')}</td>
                                    <td>${form.getAttributeValue('Task Assignee Team')}</td>
                                    <td>${form.getAttributeValue('Task Assignee Individual')}</td>
                                    <td>
                                        <a href="${bundle.kappLocation}/${console.slug}?page=form-management/formActivity&kapp=${currentKapp.slug}&form=${form.slug}" class="btn btn-xs btn-tertiary">
                                            <span class="fa fa-line-chart"></span>
                                        </a>
                                    </td>
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
                <h4>${currentKapp.name}</h4>
                <p>This is a listing of all forms in the <b class="nowrap">${currentKapp.name} </b> Kapp.</p>
                <hr class="border-color-white" />
                <h4>Instructions</h4>
                <p>To update a form's attributes click the link to the form in the first column.</p>
                <hr class="border-color-white" />
                <h4>Advanced Management</h4>
                <p>The <span class="strong">Kinetic Request</span> Management Console is for advanced configuration of portals and forms. Most common configurations can be made using this Admin Console.</p>
                <a target="_blank" href="${bundle.spaceLocation}/app/#/${currentKapp.slug}/author/forms" class="btn btn-block btn-default">
                    <span class="glyphicon glyphicon-cog pull-left" aria-hidden="true"></span> Kinetic Request
                </a>
                <p/>
            </bundle:variable>
            <!-- RIGHT SIDEBAR CONTENT ENDS HERE. -------------------------------------------------------->
            
        </bundle:layout>
        
    </c:otherwise>
</c:choose>