<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../../bundle/initialization.jspf" %>
<c:set var="i18nKapp" value="${space.getKapp(text.escape(param.slug))}" scope="request" />
<c:set var="i18nBaseUrl" value="${bundle.kappLocation}/${form.slug}" scope="request" />
<c:set var="i18nKappUrl" value="${i18nBaseUrl}?slug=${text.escape(param.slug)}" scope="request" />
<c:set var="i18nApiUrl" value="${bundle.spaceLocation}/app/apis/translations/v1/kapps/${i18nKapp.slug}" scope="request" />

<!-- Show page content only if selected Kapp exists. -->
<c:choose>
    <c:when test="${empty i18nKapp}">
        <script>window.location.replace("${i18nBaseUrl}");</script>
    </c:when>
    <c:otherwise>
    
        <c:set scope="request" var="translationSnapshot"
               value="${translationManager.getSnapshot(i18nKapp)}" />
        <c:set scope="request" var="publishedSnapshot"
               value="${translationManager.getCachedSnapshot(i18nKapp)}" />
        <c:set var="pendingChanges" 
               value="${translationManager.getChanges(i18nKapp, publishedSnapshot, translationSnapshot)}"/>

        <bundle:layout page="${bundle.path}/layouts/layout.jsp">
            <!-- Sets title and imports js and css specific to this console. -->
            <bundle:variable name="head">
                <c:import url="${bundle.path}/partials/translations/head.jsp" charEncoding="UTF-8"/>
            </bundle:variable>
            
            <!-- BREADCRUMBS START HERE. Remove if not needed. ------------------------------------------->
            <bundle:variable name="breadcrumb">
                <li><a href="${i18nBaseUrl}">${form.name}</a></li>
                <li class="active">${text.escape(i18nKapp.name)}</li>
            </bundle:variable>
            <!-- BREADCRUMBS END HERE. ------------------------------------------------------------------->

            <!-- PAGE CONTENT STARTS HERE ---------------------------------------------------------------->
            
            <c:if test="${pendingChanges.size() > 0}">
                <a href="${i18nKappUrl}&page=translations/publish" class="pending-publish btn btn-info">
                    <span class="fa fa-lg fa-cloud-upload"></span>
                    <span>There are ${pendingChanges.size()} translations waiting to be published in the ${text.escape(i18nKapp.name)} Kapp.</span>
                </a>
            </c:if>
            
            <div class="page-header" data-clear-entry-table-states="${i18nKapp.slug}">
                <div class="row">
                    <div class="col-xs-12">
                        <h2>
                            <span>${text.escape(i18nKapp.name)}</span>
                            <small>Translations</small>
                            <div class="pull-right">
                                <a class="btn btn-default" href="${i18nApiUrl}/translations.csv">
                                    <span class="fa fa-download fa-fw"></span> Export
                                </a>
                                <button class="btn btn-default import-translations-btn fileinput-button">
                                    <span class="fa fa-upload fa-fw"></span> Import
                                    <input id="fileupload" type="file" accept=".csv"/>
                                </button>
                                <a class="btn btn-tertiary" 
                                   href="${i18nKappUrl}&page=translations/add">
                                    <span class="fa fa-plus fa-fw"></span> Add Entries
                                </a>
                            </div>
                        </h2>
                    </div>
                            
                    <div class="col-xs-12">
                        <c:set var="allMissingTranslations" 
                               value="${translationSnapshot.getMissingEntries(i18nKapp)}"/>
                        <c:if test="${allMissingTranslations.size() > 0}">
                            <a class="btn btn-xs btn-warning m-t-1" 
                               href="${i18nKappUrl}&page=translations/missing">
                                <span class="fa fa-fw fa-exclamation-triangle"></span>
                                Missing ${allMissingTranslations.size()} Translations
                            </a>
                        </c:if>

                        <c:set var="unexpectedContexts" 
                               value="${translationSnapshot.getUnexpectedContextNames(i18nKapp)}"/>
                        <c:if test="${unexpectedContexts.size() > 0}">
                            <a class="btn btn-xs btn-warning m-t-1" 
                               href="${i18nKappUrl}&page=translations/unexpectedContext">
                                <span class="fa fa-fw fa-exclamation-triangle"></span>
                                Found ${unexpectedContexts.size()} Unexpected Contexts
                            </a>
                        </c:if>
                        
                        <c:set var="unexpectedLocales" 
                               value="${translationSnapshot.getUnexpectedLocaleCodes()}"/>
                        <c:if test="${unexpectedLocales.size() > 0}">
                            <a class="btn btn-xs btn-warning m-t-1" 
                               href="${i18nKappUrl}&page=translations/unexpectedLocale">
                                <span class="fa fa-fw fa-exclamation-triangle"></span>
                                Found ${unexpectedLocales.size()} Unexpected Locales
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
                
            <div class="row">
                <div class="col-xs-12">
                    <h4>Locales</h4>
                </div>
                <div class="col-xs-12">
                    <table class="table table-hover" data-sort="false" data-dom="t" data-table-dom> 
                        <thead>
                            <tr>
                                <th style="width:15%;">Default Locale</th>
                                <th>
                                    Enabled Locales
                                </th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <c:set var="defaultLocale" value="${translationManager.getDefaultLocale(i18nKapp)}"/>
                                    <c:choose>
                                        <c:when test="${defaultLocale != null}">
                                            <a class="btn btn-xs btn-info" 
                                               data-tooltip title="${defaultLocale.name}"
                                               href="${i18nKappUrl}&page=translations/locale&locale=${defaultLocale.code}">
                                                ${defaultLocale.code}
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a class="btn btn-xs btn-warning" 
                                               href="${i18nKappUrl}&page=translations/locales">
                                                <span class="fa fa-exclamation-triangle fa-fw"></span> Not Set
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${translationManager.getEnabledLocales(i18nKapp).size() > 0}">
                                            <c:forEach var="locale" items="${translationManager.getEnabledLocales(i18nKapp)}">
                                                <a class="btn btn-xs btn-success" 
                                                   data-tooltip title="${locale.name}"
                                                   href="${i18nKappUrl}&page=translations/locale&locale=${locale.code}">
                                                    ${locale.code}
                                                </a>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <a class="btn btn-xs btn-warning" 
                                               href="${i18nKappUrl}&page=translations/locales">
                                                <span class="fa fa-exclamation-triangle fa-fw"></span> No Enabled Locales
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-right">
                                    <a class="btn btn-xs btn-default pull-right" 
                                       href="${i18nKappUrl}&page=translations/locales">
                                        <span class="fa fa-cog fa-fw"></span>
                                        <span class="hidden-xs">Manage Locales</span>
                                    </a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <hr /><br />
            
            <div class="row">

                <div class="col-xs-12 overflow-auto">
                    <table class="table table-hover" 
                           data-table-dom data-table-name="Core Contexts"> 
                        <thead>
                            <tr>
                                <th>Context Name</th>
                                <th data-orderable="false">Available Locales</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <a href="${i18nKappUrl}&page=translations/context&context=bundle">bundle</a>
                                    <c:set var="missingBundleTranslations" 
                                           value="${translationSnapshot.getMissingEntriesByContext(i18nKapp, 'bundle')}"/>
                                    <c:if test="${missingBundleTranslations.size() > 0}">
                                        <a class="btn btn-xs btn-warning pull-right" 
                                           href="${i18nKappUrl}&page=translations/missing&context=bundle">
                                            <span class="fa fa-fw fa-exclamation-triangle"></span>
                                            Missing ${missingBundleTranslations.size()}
                                        </a>
                                    </c:if>
                                </td>
                                <td>
                                    <c:forEach var="localeCode" items="${translationSnapshot.getAvailableLocaleCodes('bundle')}">
                                        <a class="btn btn-xs btn-success"
                                           data-tooltip title="${TranslationLocale.get(localeCode).name}"
                                           href="${i18nKappUrl}&page=translations/context&context=bundle&locale=${localeCode}">
                                            ${localeCode}
                                        </a>
                                    </c:forEach>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <a href="${i18nKappUrl}&page=translations/context&context=shared">shared</a>
                                    <c:set var="missingSharedTranslations" 
                                           value="${translationSnapshot.getMissingEntriesByContext(i18nKapp, 'shared')}"/>
                                    <c:if test="${missingSharedTranslations.size() > 0}">
                                        <a class="btn btn-xs btn-warning pull-right" 
                                           href="${i18nKappUrl}&page=translations/missing&context=shared">
                                            <span class="fa fa-fw fa-exclamation-triangle"></span>
                                            Missing ${missingSharedTranslations.size()}
                                        </a>
                                    </c:if>
                                </td>
                                <td>
                                    <c:forEach var="localeCode" items="${translationSnapshot.getAvailableLocaleCodes('shared')}">
                                        <a class="btn btn-xs btn-success" 
                                           data-tooltip title="${TranslationLocale.get(localeCode).name}"
                                           href="${i18nKappUrl}&page=translations/context&context=shared&locale=${localeCode}">
                                            ${localeCode}
                                        </a>
                                    </c:forEach>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <hr /><br />
            
            <div class="row">
                <div class="col-xs-12 overflow-auto">
                    <table class="table table-hover" 
                           data-table-dom data-table-name="Form Contexts"
                           data-empty-message="No form contexts found. Add forms to your Kapp to see form contexts."> 
                        <thead>
                            <tr>
                                <th>Context Name</th>
                                <th>Form Name</th>
                                <th style="width:15%;">Type</th>
                                <th data-orderable="false">Available Locales</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="translationForm" items="${i18nKapp.forms}">
                                <tr>
                                    <td>
                                        <a href="${i18nKappUrl}&page=translations/context&context=form.${translationForm.slug}">
                                            form.${translationForm.slug}
                                        </a>
                                        <c:set var="missingTranslations" 
                                               value="${translationSnapshot.getMissingEntriesByContext(i18nKapp, 'form.'.concat(translationForm.slug))}"/>
                                        <c:if test="${missingTranslations.size() > 0}">
                                            <a class="btn btn-xs btn-warning pull-right" 
                                               href="${i18nKappUrl}&page=translations/missing&context=form.${translationForm.slug}">
                                                <span class="fa fa-fw fa-exclamation-triangle"></span>
                                                Missing ${missingTranslations.size()}
                                            </a>
                                        </c:if>
                                    </td>
                                    <td>${text.escape(translationForm.name)}</td>
                                    <td>${text.escape(translationForm.typeName)}</td>
                                    <td>
                                        <c:forEach var="localeCode" items="${translationSnapshot.getAvailableLocaleCodes('form.'.concat(translationForm.slug))}">
                                            <a class="btn btn-xs btn-success" 
                                               data-tooltip title="${TranslationLocale.get(localeCode).name}"
                                               href="${i18nKappUrl}&page=translations/context&context=form.${translationForm.slug}&locale=${localeCode}">
                                                ${localeCode}
                                            </a>
                                        </c:forEach>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <hr /><br />
            
            <div class="row">
                <div class="col-xs-12 overflow-auto">
                    <table class="table table-hover" 
                           data-table-dom data-table-name="Custom Contexts"
                           data-empty-message="No custom contexts found. You may create custom contexts below."> 
                        <thead>
                            <tr>
                                <th>Context Name</th>
                                <th data-orderable="false">Available Locales</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="customContextName" items="${translationSnapshot.getCustomContextNames()}"> 
                                <tr>
                                    <td>
                                        <a href="${i18nKappUrl}&page=translations/context&context=${text.escape(customContextName)}">
                                            ${text.escape(customContextName)}
                                        </a>
                                        <c:set var="missingTranslations" 
                                               value="${translationSnapshot.getMissingEntriesByContext(i18nKapp, customContextName)}"/>
                                        <c:if test="${missingTranslations.size() > 0}">
                                            <a class="btn btn-xs btn-warning pull-right" 
                                               href="${i18nKappUrl}&page=translations/missing&context=${text.escape(customContextName)}">
                                                <span class="fa fa-fw fa-exclamation-triangle"></span>
                                                Missing ${missingTranslations.size()}
                                            </a>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:forEach var="localeCode" items="${translationSnapshot.getAvailableLocaleCodes(customContextName)}">
                                            <a class="btn btn-xs btn-success" 
                                               data-tooltip title="${TranslationLocale.get(localeCode).name}"
                                               href="${i18nKappUrl}&page=translations/context&context=${text.escape(customContextName)}&locale=${localeCode}">
                                                ${localeCode}
                                            </a>
                                        </c:forEach>
                                    </td>
                                </tr>
                            </c:forEach> 
                        </tbody>
                    </table>
                </div>
                <div class="col-xs-12">
                    <table class="table">
                        <tbody>
                            <tr>
                                <td class="col-xs-12 col-sm-9">
                                    <div class="input-group input-group-sm">
                                        <span class="input-group-addon custom-context-prefix">custom.</span>
                                        <input type="text" class="form-control custom-context-name" placeholder="Custom Context Name">
                                    </div>
                                </td>
                                <td class="text-right col-xs-12 col-sm-3">
                                    <button class="btn btn-success add-custom-context-btn" type="button" disabled>
                                        <span class="fa fa-plus"></span>
                                        Add Custom Context
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        
            <!-- PAGE CONTENT ENDS HERE ------------------------------------------------------------------>
    
            <!-- RIGHT SIDEBAR CONTENT STARTS HERE. Remove if not needed. -------------------------------->
            <bundle:variable name="aside">
                <h3>${form.name}</h3>
                <h5>${i18nKapp.name}</h5>
                <hr class="border-color-white" />
                <p>A <b>context</b> is a collection of translations that applies in a specific situation. All translations exist within a context.</p>
                <p>A locale is considered <b>available</b> for a certain context if at least one translation entry exists for that locale.</p>
                <p>
                    Translations are considered <b>missing</b> if the existing keys are not translated in every available language. 
                    Translations in the default language are never considered missing, as they default to the key.
                </p>
                <hr class="border-color-white" />
                <p>To export all translations for this Kapp, click the <b class="nowrap"><span class="fa fa-download"></span> Export</b> button.</p>
                <p>To import translations for this Kapp, click the <b class="nowrap"><span class="fa fa-upload"></span> Import</b> button.</p>
                <p>To add new translation entries, click the <b class="nowrap"><span class="fa fa-plus"></span> Add Entries</b> button.</p>
                <p>
                    To view all the translations for a context, click on the context name. 
                    To view the translations for a context and a specific locale, click on the locale label in the Available Locales column.
                </p>
                <hr class="border-color-white" />
                <p>The <b>Locales</b> table displays the default and enabled locales for this Kapp.</p>
                <div class="p-l-2">
                    <p>To manage the locales, click the <b class="nowrap"><span class="fa fa-cog"></span> Manage Locales</b> button.</p>
                    <p>To view all the translations for a locale, click on the locale label in the Locales table.</p>
                </div>
                <hr class="border-color-white" />
                <p>The <b>Core Contexts</b> table displays the built in contexts.</p>
                <div class="p-l-2">
                    <p>
                        The <b>shared</b> context stores translations that are shared by all other contexts. 
                        Every other context inherits the translations from the shared context for keys that are not translated in the local context.
                    </p>
                    <p>The <b>bundle</b> context stores translations that are used on the portal pages.</p>
                </div>
                <hr class="border-color-white" />
                <p>The <b>Form Contexts</b> table displays the contexts for every form in the Kapp.</p>
                <div class="p-l-2">
                    <p>Every form has its own context that stores translations specific to that form.</p>
                </div>
                <hr class="border-color-white" />
                <p>The <b>Custom Contexts</b> table displays any special contexts that have been created by an administrator.</p>
                <div class="p-l-2">
                    <p>To create a custom context, enter a name for the context and click the <b class="nowrap"><span class="fa fa-plus"></span> Add Custom Context</b> button.</p>
                    <p>Custom contexts must be explicitely referenced when building any application components which require these translations.</p>
                </div>
            </bundle:variable>
            <!-- RIGHT SIDEBAR CONTENT ENDS HERE. -------------------------------------------------------->
            
        </bundle:layout>
        
    </c:otherwise>
</c:choose>