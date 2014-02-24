<%--
  Created by IntelliJ IDEA.
  User: dos009@csiro.au
  Date: 11/02/14
  Time: 10:52 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<g:set var="queryDisplay" value="${sr.queryTitle?:searchRequestParams.displayString}"/>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="${grailsApplication.config.ala.skin}"/>
    <title><g:message code="search.title" default="Search results"/> | ${hubDisplayName}</title>
    <script src="http://maps.google.com/maps/api/js?v=3.2&sensor=false"></script>
    <r:require modules="search, leaflet"/>
    <r:script type="text/javascript">
        // single global var for app conf settings
        <g:set var="fqParams" value="${(params.fq) ? "&fq=" + params.list('fq')?.join('&fq=') : ''}"/>
        <g:set var="searchString" value="${raw(sr?.urlParameters).encodeAsURL()}"/>
        var BC_CONF = {
            contextPath: "${request.contextPath}",
            serverName: "${grailsApplication.config.serverName}${request.contextPath}",
            searchString: "${searchString}", //  JSTL var can contain double quotes // .encodeAsJavaScript()
            facetQueries: "${fqParams.encodeAsURL()}",
            queryString: "${queryDisplay.encodeAsJavaScript()}",
            bieWebappUrl: "${grailsApplication.config.bieWebappContext}",
            biocacheServiceUrl: "${grailsApplication.config.biocacheRestService.biocacheUriPrefix?:grailsApplication.config.biocacheServicesUrl}",
            skin: "${grailsApplication.config.sitemesh.skin}",
            defaultListView: "${grailsApplication.config.defaultListView}",
            resourceName: "${grailsApplication.config.hubDisplayName}",
            facetLimit: "${grailsApplication.config.facetLimit?:50}",
            queryContext: "${grailsApplication.config.biocacheRestService.queryContext}",
            zoomOutsideScopedRegion: Boolean("${grailsApplication.config.zoomOutsideScopedRegion}"),
            mapDefaultCentreCoords:"${grailsApplication.config.mapDefaultCentreCoords}",
            mapDefaultZoom:"${grailsApplication.config.mapDefaultZoom}",
            hasMultimedia: ${hasImages?:'false'} // will be either true or false
        };
    </r:script>
</head>

<body>
    <div id="listHeader" class="row-fluid">
        <div class="span5">
            <h1><g:message code="heading.list" default="Search results"/><a name="resultsTop">&nbsp;</a></h1>
        </div>
        <div id="searchBoxZ" class="span7 text-right">
            <form action="${g.createLink(controller: 'occurrence', action: 'search')}" id="solrSearchForm" class="">
                <div id="advancedSearchLink"><a href="${g.createLink(controller: 'home', action: 'search')}#tab_advanceSearch">Advanced search</a></div>
                <div class="input-append">
                    <input type="text" id="taxaQuery" name="taxa" class="input-xlarge" value="${params.taxa}">
                    <button type="submit" id="solrSubmit" class="btn">Quick search</button>
                </div>
            </form>
        </div>
        <input type="hidden" id="userId" value="${userId}">
        <input type="hidden" id="userEmail" value="${userEmail}">
        <input type="hidden" id="lsid" value="${params.lsid}"/>
    </div>
    <g:if test="${errors}">
        <div class="searchInfo">
            <h2 style="padding-left: 15px;">Error</h2>
            <p>${errors}</p>
        </div>
    </g:if>
    <g:elseif test="${sr.totalRecords == 0}">
        <div class="searchInfo">
            <p>No records found for <span class="queryDisplay">${queryDisplay?:params.q}</span></p>
        </div>
    </g:elseif>
    <g:else>
        <!--  first row (#searchInfoRow), contains customise facets button and number of results for query, etc.  -->
        <div class="row-fluid clearfix" id="searchInfoRow">
            <!-- facet column -->
            <div class="span3">
                <div id="customiseFacetsButton" class="btn-group">
                    <a class="btn btn-small dropdown-toggle tooltips" data-toggle="dropdown" href="#" title="Customise the contents of this column">
                        <i class="icon-cog"></i>
                        <span class="caret"></span>
                    </a>
                    <div class="dropdown-menu" role="menu"> <%--facetOptions--%>
                        <h4>Select the filter categories that you want to appear in the &quot;Refine results&quot; column</h4>
                        <%-- <form:checkboxes path="facets" items="${defaultFacets}" itemValue="key" itemLabel="value" /> --%>
                        <div id="facetCheckboxes">
                            <input type="button" id="updateFacetOptions" class="btn btn-small" value="Update"/>
                            &nbsp;&nbsp;
                            Select:
                            <a href="#" id="selectAll">All</a> | <a href="#" id="selectNone">None</a>
                            <br/>
                        <div class="facetsColumn">
                            <g:each var="facet" in="${defaultFacets}" status="status">
                                <g:if test="${status.index > 0 && status.index % 18 == 0}">
                                    </div>
                                    <div class="facetsColumn">
                                </g:if>
                                <input type="checkbox" name="facets" class="facetOpts" value="${facet.key}"
                                    ${(facet.value) ? 'checked="checked"' : ''}>&nbsp;<g:message code="facet.${facet.key}"/><br>
                            </g:each>
                        </div>
                            <g:if test="${dynamicFacets}"><!-- Sandbox dynamic facets TODO: add to model -->
                                <div class="facetsColumn">
                                    <h4>Custom facets</h4>
                                    <g:each var="facet" in="${dynamicFacets}" status="status">
                                        <input type="checkbox" name="facets" class="facetOpts" value="${facet.name}"
                                            ${(facet.name) ? 'checked="checked"' : ''}>&nbsp;<alatag:formatDynamicFacetName fieldName="${facet.name}"/><br>
                                    </g:each>
                                </div>
                            </g:if>
                        </div>
                        <div class="clearfix"></div>
                    </div>
                </div>
            </div>
            <div class="span9 offset3">
                <a name="map" class="jumpTo"></a><a name="list" class="jumpTo"></a>
                <div id="resultsReturned">
                    <span id="returnedText"><strong><g:formatNumber number="${sr.totalRecords}" format="#,###,###"/></strong> results for</span>
                    <span class="queryDisplay"><strong>${queryDisplay}</strong></span>
                    <%-- jQuery template used for taxon drop-downs --%>
                    <div class="btn-group hide" id="template">
                        <a class="btn btn-small" href="" id="taxa_" title="view species page" target="BIE">placeholder</a>
                        <button class="btn btn-small dropdown-toggle" data-toggle="dropdown" title="click for more info on this query">
                            <span class="caret"></span>
                        </button>
                        <div class="dropdown-menu" aria-labelledby="taxa_">
                            <div class="taxaMenuContent">
                                The search results include records for synonyms and child taxa of
                                <b class="nameString">placeholder</b> (<span class="speciesPageLink">link placeholder</span>).

                                <form name="raw_taxon_search" class="rawTaxonSearch" action="${request.contextPath}/occurrences/search/taxa" method="POST">
                                    <div class="refineTaxaSearch">
                                        The result set contains records provided under the following names:
                                        <input type="submit" class="btn btn-small rawTaxonSumbit"
                                               value="Refine search" title="Restrict results to the selected names">
                                        <div class="rawTaxaList">placeholder taxa list</div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div><!-- /.span3 -->
        </div><!-- /#searchInfoRow -->
        <!--  Second row - facet column and results column -->
        <div class="row-fluid">
            <div class="span3">
                <g:render template="facets" />
            </div>
            <div id="content2" class="span9">
                <div id="alert" class="modal hide" tabindex="-1" role="dialog" aria-labelledby="alertLabel" aria-hidden="true">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                        <h3 id="myModalLabel">Email alerts</h3>
                    </div>
                    <div class="modal-body">
                        <div class="">
                            <a href="#alertNewRecords" id="alertNewRecords" class="btn tooltips" data-method="createBiocacheNewRecordsAlert"
                               title="Notify me when new records come online for this search">Get
                            email alerts for new <u>records</u> </a>
                        </div>
                        <br/>
                        <div class="">
                            <a href="#alertNewAnnotations" id="alertNewAnnotations" data-method="createBiocacheNewAnnotationsAlert"
                               class="btn tooltips" title="Notify me when new annotations (corrections, comments, etc) come online for this search">Get
                            email alerts for new <u>annotations</u></a>
                        </div>
                        <p>&nbsp;</p>
                        <p><a href="http://alerts.ala.org.au/notification/myAlerts">View your current alerts</a></p>
                    </div>
                    <div class="modal-footer">
                        <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
                        %{--<button class="btn btn-primary">Save changes</button>--}%
                    </div>
                </div><!-- /#alerts -->
                <g:render template="download"/>
                <div style="display:none">

                </div>
                <div class="tabbable">
                    <ul class="nav nav-tabs" data-tabs="tabs">
                        <li class="active"><a id="t1" href="#recordsView" data-toggle="tab">Records</a></li>
                        <li><a id="t2" href="#mapView" data-toggle="tab">Map</a></li>
                        <li><a id="t3" href="#chartsView" data-toggle="tab">Charts</a></li>
                        <li><a id="t4" href="#speciesImages" data-toggle="tab">Species images</a></li>
                        <g:if test="${showImages}">
                            <li><a id="t5" href="#recordImages" data-toggle="tab">Record images</a></li>
                        </g:if>
                    </ul>
                </div>
                <div class="tab-content clearfix">
                    <div class="tab-pane solrResults active" id="recordsView">
                        <div id="searchControls" class="row-fluid">
                            <div class="span4">
                                <div id="downloads" class="btn btn-small tooltips">
                                    <a href="#download" role="button" data-toggle="modal"  title="Download all ${g.formatNumber(number:sr.totalRecords, format:"#,###,###")} records OR species checklist"><i class="icon-download"></i> Downloads</a>
                                </div>
                                <div id="alerts" class="btn btn-small tooltips">
                                    <a href="#alert" role="button" data-toggle="modal" title="Get email alerts for this search"><i class="icon-bell"></i> Alerts</a>
                                </div>
                            </div>

                            <div id="sortWidgets" class="span8">
                                <span class="hidden-phone">per </span>page:
                                <select id="per-page" name="per-page" class="input-small">
                                    <g:set var="pageSizeVar" value="${params.pageSize?:params.max?:"20"}"/>
                                    <option value="10" <g:if test="${pageSizeVar == "10"}">selected</g:if>>10</option>
                                    <option value="20" <g:if test="${pageSizeVar == "20"}">selected</g:if>>20</option>
                                    <option value="50" <g:if test="${pageSizeVar == "50"}">selected</g:if>>50</option>
                                    <option value="100" <g:if test="${pageSizeVar == "100"}">selected</g:if>>100</option>
                                </select>&nbsp;
                                <g:set var="useDefault" value="${(!params.sort && !params.dir) ? true : false }"/>
                                sort:
                                <select id="sort" name="sort" class="input-small">
                                    <option value="score" <g:if test="${params.sort == 'score'}">selected</g:if>>Best match</option>
                                    <option value="taxon_name" <g:if test="${params.sort == 'taxon_name'}">selected</g:if>>Taxon name</option>
                                    <option value="common_name" <g:if test="${params.sort == 'common_name'}">selected</g:if>>Common name</option>
                                    <option value="occurrence_date" <g:if test="${params.sort == 'occurrence_date'}">selected</g:if>>${skin == 'avh' ? 'Collecting date' : 'Record date'}</option>
                                    <g:if test="${skin != 'avh'}">
                                        <option value="record_type" <g:if test="${params.sort == 'record_type'}">selected</g:if>>Record type</option>
                                    </g:if>
                                    <option value="first_loaded_date" <g:if test="${useDefault || params.sort == 'first_loaded_date'}">selected</g:if>>Date added</option>
                                    <option value="last_assertion_date" <g:if test="${params.sort == 'last_assertion_date'}">selected</g:if>>Last annotated</option>
                                </select>&nbsp;
                                order:
                                <select id="dir" name="dir" class="input-small">
                                    <option value="asc" <g:if test="${params.dir == 'asc'}">selected</g:if>>Ascending</option>
                                    <option value="desc" <g:if test="${useDefault || params.dir == 'desc'}">selected</g:if>>Descending</option>
                                </select>
                            </div><!-- sortWidget -->
                        </div><!-- searchControls -->
                        <div id="results">
                            <g:each var="occurrence" in="${sr.occurrences}">
                                <div class="recordRow" id="${occurrence.uuid}">
                                    <g:set var="rawScientificName" value="${alatag.rawScientificName(occurrence: occurrence)}"/>
                                    <g:if test="${skin == 'avh'}"><%-- AVH hubs --%>
                                        <p class="rowA">
                                            <span class="occurrenceNames">${rawScientificName}</span>
                                            <g:if test="${occurrence.raw_catalogNumber!= null && occurrence.raw_catalogNumber}">
                                                <span style="display:inline-block;float:right;">
                                                    <strong class="resultsLabel">Catalogue&nbsp;number:</strong>&nbsp;${occurrence.raw_catalogNumber}
                                                </span>
                                            </g:if>
                                        </p>
                                        <table class="avhRowB">
                                            <tr>
                                                <g:if test="${occurrence.stateProvince}">
                                                    <td><strong class="resultsLabel">State:</strong>&nbsp;${occurrence.stateProvince}</td>
                                                </g:if>
                                                <g:if test="${occurrence.lga}">
                                                    <td colspan="2"><strong class="resultsLabel">Locality:</strong>&nbsp;<g:message key="${occurrence.lga}"/></td>
                                                </g:if>
                                            </tr>
                                            <tr>
                                                <td><strong class="resultsLabel">Collector:</strong>&nbsp;${occurrence.collector}&nbsp;&nbsp;${occurrence.recordNumber}</td>
                                                <g:if test="${!occurrence.collectionName && occurrence.dataResourceName}">
                                                    <td><strong class="resultsLabel">Data&nbsp;Resource:</strong>&nbsp;${occurrence.dataResourceName}</td>
                                                </g:if>
                                                <g:if test="${occurrence.eventDate}">
                                                    <td><strong class="resultsLabel">Date:</strong>&nbsp;<g:formatDate value="${occurrence.eventDate}" pattern="yyyy-MM-dd"/></td>
                                                </g:if>
                                                <g:elseif test="${!occurrence.eventDate && occurrence.year}">
                                                    <td><strong class="resultsLabel">Date:</strong>&nbsp;${occurrence.year}</td>
                                                </g:elseif>
                                            </tr>
                                            <tr>
                                                <g:if test="${occurrence.collectionName}">
                                                    <td><strong class="resultsLabel">Herbarium:</strong>&nbsp;${occurrence.collectionName}</td>
                                                </g:if>
                                                <td class="viewRecord"><a href="<g:createLink url="${request.contextPath}/occurrences/${occurrence.uuid}"/>" class="occurrenceLink" style="margin-left: 15px;">View record</a></td>
                                            </tr>
                                        </table>
                                        <p class="rowB" style="display:none">
                                            <g:if test="${occurrence.stateProvince}">
                                                <span class="resultListItem"><strong class="resultsLabel">State:</strong>&nbsp;${occurrence.stateProvince}</span>
                                            </g:if>
                                            <g:if test="${occurrence.lga}">
                                                <span class="resultListItem"><strong class="resultsLabel">Locality:</strong>&nbsp;<g:message code="${occurrence.lga}"/></span>
                                            </g:if>
                                            <br/>
                                            <g:if test="${occurrence.collectionName}">
                                                <span class="resultListItem"><strong class="resultsLabel">Collection:</strong>&nbsp;${occurrence.collectionName}</span>
                                            </g:if>
                                            <g:if test="${!occurrence.collectionName && occurrence.dataResourceName}">
                                                <span class="resultListItem"><strong class="resultsLabel">Data&nbsp;Resource:</strong>&nbsp;${occurrence.dataResourceName}</span>
                                            </g:if>
                                            <g:if test="${occurrence.eventDate}">
                                                <span class="resultListItem"><strong class="resultsLabel">Date:</strong>&nbsp;<g:formatDate value="${occurrence.eventDate}" pattern="yyyy-MM-dd"/></span>
                                            </g:if>
                                            <g:elseif test="${occurrence.year}">
                                                <span class="resultListItem"><strong class="resultsLabel">Date:</strong>&nbsp;${occurrence.year}</span>
                                            </g:elseif>

                                            <span style="display:inline-block;float:right;">
                                                <a href="<g:createLink url="${request.contextPath}/occurrences/${occurrence.uuid}"/>" class="occurrenceLink" style="margin-left: 15px;">View record</a>
                                            </span>
                                        </p>
                                    </g:if>
                                    <g:else><%-- All other hubs --%>
                                        <p class="rowA">
                                            <g:if test="${occurrence.taxonRank && occurrence.scientificName}">
                                                <span style="text-transform: capitalize">${occurrence.taxonRank}</span>:&nbsp;<span class="occurrenceNames"><alatag:formatSciName rankId="6000" name="${occurrence.scientificName}"/></span>
                                            </g:if>
                                            <g:else>
                                                <span class="occurrenceNames">${occurrence.raw_scientificName}</span>
                                            </g:else>
                                            <g:if test="${occurrence.vernacularName}">&nbsp;|&nbsp;<span class="occurrenceNames">${occurrence.vernacularName}</span></g:if>
                                            <g:elseif test="${occurrence.raw_vernacularName}">&nbsp;|&nbsp;<span class="occurrenceNames">${occurrence.raw_vernacularName}</span></g:elseif>
                                            <span style="margin-left: 8px;">
                                                <g:if test="${occurrence.eventDate}">
                                                    <span style="text-transform: capitalize;"><strong class="resultsLabel">Date:</strong>&nbsp;<g:formatDate number="${occurrence.eventDate}" format="yyyy-MM-dd"/></span>
                                                </g:if>
                                                <g:elseif test="${occurrence.occurrenceYear}">
                                                    <span style="text-transform: capitalize;"><strong class="resultsLabel">Year:</strong>&nbsp;<g:formatDate number="${occurrence.occurrenceYear}" format="yyyy"/></span>
                                                </g:elseif>

                                                <g:if test="${occurrence.stateProvince}">
                                                    <span style="text-transform: capitalize;"><strong class="resultsLabel">State:</strong>&nbsp;<g:message code="region.${occurrence.stateProvince}"/></span>
                                                </g:if>
                                                <g:elseif test="${occurrence.country}">
                                                    <span style="text-transform: capitalize;"><strong class="resultsLabel">Country:</strong>&nbsp;<g:message code="${occurrence.country}"/></span>
                                                </g:elseif>
                                            </span>
                                        </p>
                                        <p class="rowB">
                                            <g:if test="${occurrence.institutionName}">
                                                <span style="text-transform: capitalize;"><strong class="resultsLabel">Institution:</strong>&nbsp;${occurrence.institutionName}</span>
                                            </g:if>
                                            <g:if test="${occurrence.collectionName}">
                                                <span style="text-transform: capitalize;"><strong class="resultsLabel">Collection:</strong>&nbsp;${occurrence.collectionName}</span>
                                            </g:if>
                                            <g:if test="${!occurrence.collectionName && occurrence.dataResourceName}">
                                                <span style="text-transform: capitalize;"><strong class="resultsLabel">Data&nbsp;Resource:</strong>&nbsp;${occurrence.dataResourceName}</span>
                                            </g:if>
                                            <g:if test="${occurrence.basisOfRecord}">
                                                <span style="text-transform: capitalize;"><strong class="resultsLabel">Basis&nbsp;of&nbsp;record:</strong>&nbsp;${occurrence.basisOfRecord}</span>
                                            </g:if>
                                            <g:if test="${occurrence.raw_catalogNumber!= null && occurrence.raw_catalogNumber}">
                                                <strong class="resultsLabel">Catalog&nbsp;number:</strong>&nbsp;${occurrence.raw_collectionCode}:${occurrence.raw_catalogNumber}
                                            </g:if>
                                            <a href="<g:createLink url="${request.contextPath}/occurrences/${occurrence.uuid}"/>" class="occurrenceLink" style="margin-left: 15px;">View record</a>
                                        </p>
                                    </g:else>
                                </div>
                            </g:each>
                        </div><!--close results-->
                        <div id="searchNavBar" class="pagination">
                            <g:paginate total="${sr.totalRecords}" max="${sr.pageSize}" offset="${sr.startIndex}" params="${[q:params.q, fq:params.fq]}"/>
                        </div>
                    </div><!--end solrResults-->
                    <div id="mapView" class="tab-pane">

                        <g:render template="map"
                                  model="[mappingUrl:grailsApplication.config.biocacheServicesUrl,
                                          searchString: searchString,
                                          queryDisplayString:queryDisplay,
                                          facets:sr.facetResults,
                                          defaultColourBy:defaultFacetMapColourBy
                                  ]"
                        />
                        <div id='envLegend'></div>
                    </div><!-- end #mapwrapper -->
                    <div id="chartsView" class="tab-pane">
                        <div id="charts"></div>
                    </div><!-- end #chartsWrapper -->
                    <div id="speciesImages" class="tab-pane">
                        <h3>Representative images of species</h3>
                        <div id="speciesGalleryControls">
                            Filter by group
                            <select id="speciesGroup">
                                <option>no species groups loaded</option>
                            </select>
                            &nbsp;
                            Sort by
                            <select id="speciesGallerySort">
                                <option value="common">Common name</option>
                                <option value="taxa">Scientific name</option>
                                <option value="count">Record count</option>
                            </select>
                        </div>
                        <div id="speciesGallery">[image gallery should appear here]</div>
                        <div id="loadMoreSpecies" style="display:none;">
                            <button class="btn">Show more images</button><img style="display:none;" src="${request.contextPath}/static/images/indicator.gif"/>
                        </div>
                    </div><!-- end #speciesWrapper -->
                    <g:if test="${showImages}">
                        <div id="recordImages" class="tab-pane">
                            <h3>Images from occurrence records</h3>
                            <%--<p>(see also <a href="#tab_speciesImages">representative species images</a>)</p>--%>
                            <div id="imagesGrid">
                                loading images...
                            </div>
                            <div id="loadMoreImages" style="display:none;">
                                <button class="btn">Show more images</button>
                            </div>
                        </div><!-- end #imagesWrapper -->
                    </g:if>
                </div><!-- end .css-panes -->
                <form name="raw_taxon_search" class="rawTaxonSearch" id="rawTaxonSearchForm" action="${request.contextPath}/occurrences/search/taxa" method="POST">
                        <%-- taxon concept search drop-down div are put in here via Jquery --%>
                    <div style="display:none;" >
                    </div>
                </form>
            </div>
        </div>
    </g:else>
</body>
<r:script type="text/javascript">
    $(function(){
        $('#t2').click(function(){
            initialiseMap();
        })
    })
</r:script>
</html>