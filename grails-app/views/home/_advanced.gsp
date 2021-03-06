<%@ page import="au.org.ala.biocache.hubs.FacetsName; org.apache.commons.lang.StringUtils" contentType="text/html;charset=UTF-8" %>
<form name="advancedSearchForm" id="advancedSearchForm" action="${request.contextPath}/advancedSearch" method="POST">
    <input type="text" id="solrQuery" name="q" style="position:absolute;left:-9999px;" value="${params.q}"/>
    <input type="hidden" name="nameType" value="matched_name_children"/>
    <b><g:message code="advancedsearch.title01" default="Find records that have"/></b>
    <table border="0" width="100" cellspacing="2" class="compact">
        <thead/>
        <tbody>
        <tr>
            <td class="labels"><g:message code="advancedsearch.table01col01.title" default="ALL of these words (full text)"/></td>
            <td>
                <input type="text" name="text" id="text" class="dataset" placeholder="" size="80" value="${params.text}"/>
            </td>
        </tr>
        </tbody>
    </table>
    %{--<b><g:message code="advancedsearch.title02" default="Find records for ANY of the following taxa (matched/processed taxon concepts)"/></b>
    <table border="0" width="100" cellspacing="2" class="compact">
        <thead/>
        <tbody>
        <g:each in="${1..4}" var="i">
            <g:set var="lsidParam" value="lsid_${i}"/>
            <tr style="" id="taxon_row_${i}">
                <td class="labels"><g:message code="advancedsearch.table02col01.title" default="Species/Taxon"/></td>
                <td>
                    <input type="text" value="" id="taxa_${i}" name="taxonText" class="name_autocomplete" size="60">
                    <input type="hidden" name="lsid" class="lsidInput" id="taxa_${i}" value=""/>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>--}%
    <b><g:message code="advancedsearch.title03" default="Find records that specify the following scientific name (verbatim/unprocessed name)"/></b>
    <table border="0" width="100" cellspacing="2" class="compact">
        <thead/>
        <tbody>
        <tr>
            <td class="labels"><g:message code="advancedsearch.table03col01.title" default="Raw Scientific Name"/></td>
            <td>
                <input type="text" name="raw_taxon_name" id="raw_taxon_name" class="dataset" placeholder="" size="60" value=""/>
            </td>
        </tr>
        </tbody>
    </table>
    <b><g:message code="advancedsearch.title04" default="Find records from the following species group"/></b>
    <table border="0" width="100" cellspacing="2" class="compact">
        <thead/>
        <tbody>
        <tr>
            <td class="labels"><g:message code="advancedsearch.table04col01.title" default="Species Group"/></td>
            <td>
                <select class="species_group" name="species_group" id="species_group">
                    <option value=""><g:message code="advancedsearch.table04col01.option.label" default="-- select a species group --"/></option>
                    <g:each var="group" in="${request.getAttribute("species_group")}">
                        <g:each var="hierarchy" in="${[['Animals', 'Birds', 'Reptiles', 'Amphibians', 'Fish', 'Molluscs', 'Arthropods', 'Crustaceans', 'Arthropods', 'Crustaceans', 'Insects', 'Plants', 'Bryophytes', 'Bryophytes', 'Gymnosperms', 'FernsAndAllies', 'Angiosperms', 'Monocots', 'Dicots', 'Fungi', 'Chromista', 'Protozoa', 'Bacteria', 'Algae']]}">
                            <g:if test="${group.value} == it">
                                <option value="${group.key}"><g:message code="global.hierarchy.${group.value.toLowerCase()}"/></option>
                            </g:if>
                        </g:each>
                    </g:each>
                </select>
            </td>
        </tr>
        </tbody>
    </table>
    <b><g:message code="advancedsearch.title05" default="Find records from the following institution or collection"/></b>
    <table border="0" width="100" cellspacing="2" class="compact">
        <thead/>
        <tbody>
        <tr>
            <td class="labels"><g:message code="advancedsearch.table05col01.title" default="Institution or Collection"/></td>
            <td>
                <select class="institution_uid collection_uid" name="institution_collection" id="institution_collection">
                    <option value=""><g:message code="advancedsearch.table05col01.option01.label" default="-- select an institution or collection --"/></option>
                    <g:each var="inst" in="${request.getAttribute("institution_uid")}">
                        <optgroup label="${inst.value}">
                            <option value="${inst.key}"><g:message code="advancedsearch.table05col01.option02.label" default="All records from"/> ${inst.value}</option>
                            <g:each var="coll" in="${request.getAttribute("collection_uid")}">
                                <g:if test="${inst.key == 'in13' && StringUtils.startsWith(coll.value, inst.value)}">
                                    <option value="${coll.key}">${StringUtils.replace(StringUtils.replace(coll.value, inst.value, ""), " - " ,"")} <g:message code="advancedsearch.table05col01.option03.label" default="Collection"/></option>
                                </g:if>
                                <g:elseif test="${inst.key == 'in6' && StringUtils.startsWith(coll.value, 'Australian National')}">
                                    <%-- <option value="${coll.key}">${fn:replace(coll.value,"Australian National ", "")}</option> --%>
                                    <option value="${coll.key}">${coll.value}</option>
                                </g:elseif>
                                <g:elseif test="${StringUtils.startsWith(coll.value, inst.value)}">
                                    <option value="${coll.key}">${StringUtils.replace(coll.value, inst.value, "")}</option>
                                </g:elseif>
                            </g:each>
                        </optgroup>
                    </g:each>
                </select>
            </td>
        </tr>
        </tbody>
    </table>
    <b><g:message code="advancedsearch.title06" default="Find records from the following regions"/></b>
    <table border="0" width="100" cellspacing="2" class="compact">
        <thead/>
        <tbody>
        <tr>
            <td class="labels"><g:message code="advancedsearch.table06col01.title" default="Country"/></td>
            <td>
                <select class="country" name="country" id="country">
                    <option value=""><g:message code="advancedsearch.table06col01.option.label" default="-- select a country --"/></option>
                    <g:each var="country" in="${request.getAttribute("country")}">
                        <option value="${country.key}">${country.value}</option>
                    </g:each>
                </select>
            </td>
        </tr>
        <tr>
            <td class="labels"><g:message code="advancedsearch.table06col02.title" default="State/Territory"/></td>
            <td>
                <select class="state" name="state" id="state">
                    <option value=""><g:message code="advancedsearch.table06col02.option.label" default="-- select a state/territory --"/></option>
                    %{--<g:each var="state" in="${request.getAttribute("state")}">
                        <option value="${state.key}">${state.value}</option>
                    </g:each>--}%
                    <option disabled>─────España─────</option>
                    <option value="Álava">Álava</option>
                    <option value="Albacete">Albacete</option>
                    <option value="Alicante">Alicante</option>
                    <option value="Almería">Almería</option>
                    <option value="Asturias">Asturias</option>
                    <option value="Ávila">Ávila</option>
                    <option value="Badajoz">Badajoz</option>
                    <option value="Baleares">Baleares</option>
                    <option value="Barcelona">Barcelona</option>
                    <option value="Burgo">Burgos</option>
                    <option value="Cáceres">Cáceres</option>
                    <option value="Cádiz">Cádiz</option>
                    <option value="Cantabria">Cantabria</option>
                    <option value="Castellón">Castellón</option>
                    <option value="Ceuta">Ceuta</option>
                    <option value="Ciudad Real">Ciudad Real</option>
                    <option value="Córdoba">Córdoba</option>
                    <option value="Cuenca">Cuenca</option>
                    <option value="Gerona">Gerona</option>
                    <option value="Granada">Granada</option>
                    <option value="Guadalajara">Guadalajara</option>
                    <option value="Guipúzcoa">Guipúzcoa</option>
                    <option value="Huelva">Huelva</option>
                    <option value="Huesca">Huesca</option>
                    <option value="Jaén">Jaén</option>
                    <option value="La Coruña">La Coruña</option>
                    <option value="La Rioja">La Rioja</option>
                    <option value="Las Palmas">Las Palmas</option>
                    <option value="León">León</option>
                    <option value="Lérida">Lérida</option>
                    <option value="Lugo">Lugo</option>
                    <option value="Madrid">Madrid</option>
                    <option value="Málaga">Málaga</option>
                    <option value="Melilla">Melilla</option>
                    <option value="Murcia">Murcia</option>
                    <option value="Navarra">Navarra</option>
                    <option value="Orense">Orense</option>
                    <option value="Palencia">Palencia</option>
                    <option value="Pontevedra">Pontevedra</option>
                    <option value="Salamanca">Salamanca</option>
                    <option value="Santa Cruz de Tenerife">Santa Cruz de Tenerife</option>
                    <option value="Segovia">Segovia</option>
                    <option value="Sevilla">Sevilla</option>
                    <option value="Soria">Soria</option>
                    <option value="Tarragona">Tarragona</option>
                    <option value="Teruel">Teruel</option>
                    <option value="Toledo">Toledo</option>
                    <option value="Valencia">Valencia</option>
                    <option value="Valladolid">Valladolid</option>
                    <option value="Vizcaya">Vizcaya</option>
                    <option value="Zamora">Zamora</option>
                    <option value="Zaragoza">Zaragoza</option>
                    <option disabled>─────Portugal─────</option>
                    <option disabled>─────Distritos─────</option>
                    <option value="Acores">Acores</option>
                    <option value="Aveiro">Aveiro</option>
                    <option value="Beja">Beja</option>
                    <option value="Braga">Braga</option>
                    <option value="Braganca">Braganca</option>
                    <option value="Castelo Branco">Castelo Branco</option>
                    <option value="Coimbra">Coimbra</option>
                    <option value="Évora">Évora</option>
                    <option value="Faro">Faro</option>
                    <option value="Guarda">Guarda</option>
                    <option value="Leiria">Leiria</option>
                    <option value="Lisboa">Lisboa</option>
                    <option value="Madeira">Madeira</option>
                    <option value="Portalegre">Portalegre</option>
                    <option value="Porto">Porto</option>
                    <option value="Santarém">Santarém</option>
                    <option value="Setúbal">Setúbal</option>
                    <option value="Viana do Castelo">Viana do Castelo</option>
                    <option value="Vila Real">Vila Real</option>
                    <option value="Viseu">Viseu</option>
                    <option disabled>─────Provincias tradicionales─────</option>
                    <option value="Alto Alentejo">Alto Alentejo</option>
                    <option value="Algarve">Algarve</option>
                    <option value="Baixo Alentejo">Baixo Alentejo</option>
                    <option value="Beira Alta">Beira Alta</option>
                    <option value="Beira Baixa">Beira Baixa</option>
                    <option value="Beira Litoral">Beira Litoral</option>
                    <option value="Douro Litoral">Douro Litoral</option>
                    <option value="Estremadura">Estremadura</option>
                    <option value="Minho">Minho</option>
                    <option value="Ribadetejo">Ribadetejo</option>
                    <option value="Trás os Montes">Trás os Montes</option>
                </select>
            </td>
        </tr>
        %{--}<g:set var="autoPlaceholder" value="start typing and select from the autocomplete drop-down list"/>
        <g:if test="${request.getAttribute("cl1048") && request.getAttribute("cl1048").size() > 1}">
        <tr>
            <td class="labels"><abbr title="Interim Biogeographic Regionalisation of Australia">IBRA</abbr> <g:message code="advancedsearch.table06col03.title" default="region"/></td>
            <td>
                <select class="biogeographic_region" name="ibra" id="ibra">
                    <option value=""><g:message code="advancedsearch.table06col03.option.label" default="-- select an IBRA region --"/></option>
                    <g:each var="region" in="${request.getAttribute("cl1048")}">
                        <option value="${region.key}">${region.value}</option>
                    </g:each>
                </select>
            </td>
        </tr>
        </g:if>
        <g:if test="${request.getAttribute("cl21") && request.getAttribute("cl21").size() > 1}">
        <tr>
            <td class="labels"><abbr title="Integrated Marine and Coastal Regionalisation of Australia">IMCRA</abbr> <g:message code="advancedsearch.table06col04.title" default="region"/></td>
            <td>
                <select class="biogeographic_region" name="imcra" id="imcra">
                    <option value=""><g:message code="advancedsearch.table06col04.option.label" default="-- select an IMCRA region --"/></option>
                    <g:each var="region" in="${request.getAttribute("cl21")}">
                        <option value="${region.key}">${region.value}</option>
                    </g:each>
                </select>
            </td>
        </tr>
        </g:if>
        <g:if test="${request.getAttribute("cl959") && request.getAttribute("cl959").size() > 1}">
        <tr>
            <td class="labels"><g:message code="advancedsearch.table06col05.title" default="Local Govt. Area"/></td>
            <td>
                <select class="lga" name="lga" id="lga">
                    <option value=""><g:message code="advancedsearch.table06col05.option.label" default="-- select local government area--"/></option>
                    <g:each var="region" in="${request.getAttribute("cl959")}">
                        <option value="${region.key}">${region.value}</option>
                    </g:each>
                </select>
            </td>
        </tr>
        </g:if>--}%
        </tbody>
    </table>
    <g:if test="${request.getAttribute("type_status") && request.getAttribute("type_status").size() > 1}">
        <b><g:message code="advancedsearch.title07" default="Find records from the following type status"/></b>
        <table border="0" width="100" cellspacing="2" class="compact">
            <thead/>
            <tbody>
            <tr>
                <td class="labels"><g:message code="advancedsearch.table07col01.title" default="Type Status"/></td>
                <td>
                    <select class="type_status" name="type_status" id="type_status">
                        <option value=""><g:message code="advancedsearch.table07col01.option.label" default="-- select a type status --"/></option>
                        <g:each var="type" in="${request.getAttribute("type_status")}">
                            <g:each var="t_status" in="${[['allolectotype', 'allotype', 'allotype|lectotype', 'allotype|paratype', 'cotype', 'cotype|lectotype', 'cotype|paralectotype', 'cotype|paratype', 'cotype|type', 'epitype', 'hapantotype', 'holotype', 'holotype|allotype', 'holotype|isotype', 'holotype|lectotype', 'holotype|neotype', 'holotype|paratype', 'holotype|syntype', 'holotype|syntype|lectotype', 'holotype|syntype|paralectotype', 'holotype|syntype|type', 'holotype|type', 'iconotype', 'isolectotype', 'isoneotype','isotype','isotype|lectotype','lectotype','lectotype|paralectotype','lectotype|syntype','lectotype|syntype|paralectotype','lectotype|type','neotype','neotype|holotype','neotype|paratype','neotype|syntype|lectotype','paralectotype|paratype','paralectotype|syntype','paralectotype|type','paralectotype|type|paratype','paraneotype','paratype','paratypes','paratype|allotype','paratype|cotype','paratype|holotype','paratype|lectotype','paratype|syntype','paratype|topotype','paratype|type','plastoholotype','syntype','syntype|allotype','syntype|allotype|paratype','syntype|cotype','syntype|holotype','syntype|holotype|lectotype','syntype|holotype|paratype','syntype|lectotype','syntype|lectotype|holotype','syntype|lectotype|paralectotype','syntype|lectotype|type','syntype|paralectotype','syntype|paralectotype|type','syntype|paratype','syntype|type','topotype','type','type|cotype','type|holotype','type|holotype|lectotype','type|lectotype','type|lectotype|paralectotype','type|paralectotype','type|syntype','type|syntype|paralectotype']]}">
                                <g:if test="${type.value} == it">
                                    <option value="${type.key}"><g:message code="global.typestatus.${type.value.toLowerCase()}"/></option>
                                </g:if>
                            </g:each>
                        %{--<option value="${type.key}">${type.value}</option>--}%
                    </g:each>
                </select>
            </td>
        </tr>
        </tbody>
    </table>
</g:if>
<g:if test="${request.getAttribute("basis_of_record") && request.getAttribute("basis_of_record").size() > 1}">
    <b><g:message code="advancedsearch.title08" default="Find records from the following basis of record (record type)"/></b>
    <table border="0" width="100" cellspacing="2" class="compact">
        <thead/>
        <tbody>
        <tr>
            <td class="labels"><g:message code="advancedsearch.table08col01.title" default="Basis of record"/></td>
            <td>
                <select class="basis_of_record" name="basis_of_record" id="basis_of_record">
                    <option value=""><g:message code="advancedsearch.table08col01.option.label" default="-- select a basis of record --"/></option>
                    <g:each var="bor" in="${request.getAttribute("basis_of_record")}">
                        <g:each var="basisOfRecord" in="${[['FossilSpecimen', 'GenomicDNA', 'MaterialSample', 'Occurrence', 'HumanObservation', 'Image', 'Literature', 'LivingSpecimen', 'MachineObservation', 'NomenclaturalChecklist', 'PreservedSpecimen', 'Sound']]}">
                            <g:if test="${bor.value.trim()} == it">
                                ${bor.value.trim()}
                                <option value="${bor.key}"><g:message code="global.basisofrecord.${bor.value.trim()}"/></option>
                            </g:if>
                        </g:each>

                        %{--}<option value="${bor.key}"><g:message code="${bor.value}"/></option>--}%
                    </g:each>
                </select>
            </td>
        </tr>
        </tbody>
    </table>
</g:if>
<b><g:message code="advancedsearch.title09" default="Find records with the following dataset fields"/></b>
<table border="0" width="100" cellspacing="2" class="compact">
    <thead/>
    <tbody>
    <g:if test="${request.getAttribute("data_resource_uid") && request.getAttribute("data_resource_uid").size() > 1}">
        <tr>
            <td class="labels"><g:message code="advancedsearch.dataset.col.label" default="dataset name"/></td>
            <td>
                <select class="dataset bscombobox" name="dataset" id="dataset">
                    <option value=""></option>
                    <g:each var="region" in="${request.getAttribute("data_resource_uid")}">
                        <option value="${region.key}">${region.value}</option>
                    </g:each>
                </select>
            </td>
        </tr>
    </g:if>
    <tr>
        <td class="labels"><g:message code="advancedsearch.table09col01.title" default="Catalogue Number"/></td>
        <td>
            <input type="text" name="catalogue_number" id="catalogue_number" class="dataset" placeholder="" value=""/>
        </td>
    </tr>
    <tr>
        <td class="labels"><g:message code="advancedsearch.table09col02.title" default="Record Number"/></td>
        <td>
            <input type="text" name="record_number" id="record_number" class="dataset" placeholder="" value=""/>
        </td>
    </tr>
    <%--<tr>
        <td class="labels">Collector Name</td>
        <td>
             <input type="text" name="collector" id="collector" class="dataset" placeholder="" value=""/>
        </td>
    </tr> --%>
    </tbody>
</table>
<b><g:message code="advancedsearch.title10" default="Find records within the following date range"/></b>
<table border="0" width="100" cellspacing="2" class="compact">
    <thead/>
    <tbody>
    <tr>
        <td class="labels"><g:message code="advancedsearch.table10col01.title" default="Begin Date"/></td>
        <td>
            <input type="text" name="start_date" id="startDate" class="occurrence_date" placeholder="" value=""/>
            <g:message code="advancedsearch.table10col01.des" default="(YYYY-MM-DD) leave blank for earliest record date"/>
        </td>
    </tr>
    <tr>
        <td class="labels"><g:message code="advancedsearch.table10col02.title" default="End Date"/></td>
        <td>
            <input type="text" name="end_date" id="endDate" class="occurrence_date" placeholder="" value=""/>
            <g:message code="advancedsearch.table10col02.des" default="(YYYY-MM-DD) leave blank for most recent record date"/>
        </td>
    </tr>
    </tbody>
</table>
<input type="submit" value=<g:message code="advancedsearch.button.submit" default="Search"/> class="btn btn-primary" />
&nbsp;&nbsp;
<input type="reset" value="${g.message(code:"advancedsearch.button.value", default: "Clear all")}" id="clearAll" class="btn" onclick="$('input#solrQuery').val(''); $('input.clear_taxon').click(); return true;"/>
</form>
<r:script>
$(document).ready(function() {
    $('.bscombobox').combobox({bsVersion: '2'});
});

</r:script>