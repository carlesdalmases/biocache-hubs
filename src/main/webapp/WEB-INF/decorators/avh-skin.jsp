<%--
    Document   : avh-skin.jsp (sitemesh decorator file)
    Created on : 01/09/2010, 11:57
    Author     : dos009
--%><%@
taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %><%@
taglib prefix="page" uri="http://www.opensymphony.com/sitemesh/page" %><%@
include file="/common/taglibs.jsp" %>
<c:set var="avhUrl" value="http://avh.ala.org.au/sp/"/>
<!DOCTYPE html>
<html dir="ltr" lang="en-US">    
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<link href="http://www.naa.gov.au/recordkeeping/gov_online/agls/1.1" rel="schema.AGLS" />
	<meta name="DC.Title" content="Partners" lang="en" />	<meta name="DC.Function" content="Public information" />
	<meta name="DC.Description" content="Australia's Virtual Herbarium (AVH) is an online resource that provides immediate access to the wealth of plant specimen information held by Australian herbaria. AVH is a collaborative project of the state, Commonwealth and territory herbaria, developed under the auspices of the Council of Heads of Australasian Herbaria (CHAH), representing the major Australian collections." />
	<meta name="DC.Creator" content="jurisdiction:Australian Government Departmental Consortium;corporateName:Council of Heads of Australasian Herbaria" />
	<meta name="DC.Publisher" content="jurisdiction:Australian Government Departmental Consortium;corporateName:Council of Heads of Australasian Herbaria" />
	<meta name="DC.Type.Category" content="document" />
	<meta name="DC.Format" content="text/html" />
	<meta name="DC.Language" content="en_AU" scheme="RFC3066" />
	<meta name="DC.Coverage.Jurisdiction" content="Australian Government Departmental Consortium" />
	<meta name="DC.Coverage.PlaceName" content="Australia, world" />
	<meta name="DC.Audience" content="Botanists, horticulturalists, biologists, ecologists, environmentalists, conservationists, land managers, educators, students, historians, general public" />
	<meta name="DC.Availability" content="Freely available. Some parts of this resource are username and password restricted" />
	<meta name="DC.Rights" content="(c) Council of Heads of Australasian Herbaria, 2010" />
	<meta name="DC.Rights" content="Unless other stated, Intellectual Property associated with this resource resides with the Council of Heads of Australasian Herbaria and individual herbaria. Applications, source code and data are freely available for research, non-commercial and public good purposes" />

    <title><decorator:title default="AVH"/></title>
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/static/images/avh/favicon.ico" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/avh/reset.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/avh/screen.css" />    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/js/fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />
    
    <%@ include file="commonJS.jspf" %>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/autocomplete.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/base.css" type="text/css" media="screen" />
    <!-- CIRCLE PLAYER -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/circle.skin/circle.player.css" type="text/css" media="screen" />
    <decorator:head />
</head>

<body>
<div id="container">
	<div id="banner">
		<div id="logo">
			<a title="Australia's Virtual Herbarium (Home)" href="${pageContext.request.contextPath}/">
				<img src="${pageContext.request.contextPath}/static/css/avh/images/AVHlogo_web.gif" alt="Australia&rsquo;s Virtual Herbarium logo" height="100" width="249" style="border:0px" />
			</a>
		</div>
        <div id="header">
<!--        <h1>
            Partners<br />
        </h1>-->
    </div>
    	<div id="mainmenu">
            <div><a href="${pageContext.request.contextPath}/">Home</a></div>
            <div><a href="${pageContext.request.contextPath}/query">Search</a></div>
            <div><a href="${avhUrl}about.html">About AVH</a></div>
            <div><a href="${avhUrl}help.html">Help</a></div>
            <div><a href="${avhUrl}avh_data.html">AVH Data</a></div>            
            <div><a href="${avhUrl}partners.html">Partners</a></div>            
            <div><a href="${avhUrl}links.html">Links</a></div>
            <div class="rightMenu">
                <c:set var="returnUrlPath" value="${initParam.serverName}${pageContext.request.requestURI}${not empty pageContext.request.queryString ? '?' : ''}${pageContext.request.queryString}"/>
                <ala:loginLogoutLink returnUrlPath="${returnUrlPath}"/>
            </div>
            <c:if test="${clubView}">
                <div class="rightMenu" id="clubView"><span>Club View</span></div>
            </c:if>
            <div class="rightMenu">
                <a href="http://www.ala.org.au/my-profile/"><ala:loggedInUserId/></a>
            </div>
        </div>
    </div>
	<div id="main_content" class="">
        <decorator:body />
    </div>
    <div id="footer">
        <div id="bottombanner">
            <div id="participants">
                <div>
                    <a href="http://www.dec.wa.gov.au/content/category/41/831/1821/">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_WA.jpg" alt="Western Australian Herbarium, Department of Environment and Conservation" width="80" height="100" />
                    </a>
                </div>
                <div>
                    <a href="http://www.nt.gov.au/nreta/wildlife/plants/herbarium/index.html">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_NT.jpg" alt="NT logo" height="100" width="80" />
                    </a>
                </div>
                <div>
                    <a href="http://www.environment.sa.gov.au/science/state-herbarium/overview.html">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_SA.jpg" alt="State Herbarium of South Australia, Plant Biodiversity Centre" width="80" height="100" />
                    </a>
                </div>
                <div>
                    <a href="http://www.derm.qld.gov.au/wildlife-ecosystems/plants/queensland_herbarium/">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_BRI.jpg" alt="Queensland Herbarium, Environmental Protection Agency" height="100" width="80" />
                    </a>
                </div>
                <div>
                    <a href="http://www.rbgsyd.nsw.gov.au/science/Herbarium_and_resources">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_NSW.jpg" alt="NSW logo" height="100" width="80" />
                    </a>
                </div>
                <div>
                    <a href="http://www.cpbr.gov.au/cpbr/">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_CPBR.jpg" alt="Australian National Herbarium, Centre for Plant Biodiversity Research" height="100" width="80" />
                    </a>
                </div>
                <div>
                    <a href="http://www.rbg.vic.gov.au/science/information-and-resources/national-herbarium-of-victoria">
                        <img alt="National Herbarium of Victoria, Royal Botanic Gardens Melbourne"  src="${pageContext.request.contextPath}/static/css/avh/images/logo_MEL.jpg" height="100" width="80" />
                    </a>
                </div>
                <div>
                    <a href="http://www.tmag.tas.gov.au/">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_TAS.jpg" width="80" height="100" alt="Tasmanian Herbarium, Tasmanian Museum and Art Gallery" />
                    </a>
                </div>
                <div>
                    <a href="http://www.ath.org.au/">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_ATH.jpg" alt="ATH logo" width="80" height="100" />
                    </a>
                </div>
                <div>
                    <a href="http://www.environment.gov.au/biodiversity/abrs/">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_ABRS.jpg" alt="Australian Biological Resources Study" width="80" height="100" />
                    </a>
                </div>
                <div>
                    <a href="http://www.virtualherbarium.org.nz/index.jsp">
                        <img src="${pageContext.request.contextPath}/static/css/avh/images/logo_NZVH.jpg" alt="DEH logo" width="80" height="100" />
                    </a>
                </div>
            </div>
            <div class="spacer">&nbsp;</div>
        </div>
        <div id="footer_left">
            <a href="/sp/termsofuse.html">Terms of Use</a>
        </div>
        <div id="footer_right">
           <a href="mailto:avh@ala.org.au">avh@ala.org.au</a>
        </div>
        <div style="margin:-6px auto 0 auto;width:200px"><a href="http://www.ala.org.au/" target="_black"><img src="${pageContext.request.contextPath}/static/images/atlas-poweredby_rgb-lightbg.png" alt=""/></a></div>
    </div>
</div>
<script type="text/javascript">
    var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
    document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
    var pageTracker = _gat._getTracker("UA-4355440-1");
    pageTracker._initData();
    pageTracker._trackPageview();
</script>
</body>
</html>
