<%--
/**
 * Copyright (c) 2012 Mika Koivisto <mika@javaguru.fi>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
--%>

<%@ include file="init.jsp" %>

<%
Group scopeGroup = themeDisplay.getScopeGroup();

if (scopeGroup.isStagingGroup()) {
	scopeGroup = scopeGroup.getLiveGroup();
}

UnicodeProperties typeSettingsProperties = scopeGroup.getTypeSettingsProperties();

boolean liferayEnabled = GetterUtil.getBoolean(typeSettingsProperties.getProperty("social-comments-liferay-enabled"), true);

String disqusShortName = typeSettingsProperties.getProperty("social-comments-disqus-short-name");
boolean disqusEnabled = GetterUtil.getBoolean(typeSettingsProperties.getProperty("social-comments-disqus-enabled"));

String livefyreSiteId = typeSettingsProperties.getProperty("social-comments-livefyre-site-id");
String livefyreSiteSecret = typeSettingsProperties.getProperty("social-comments-livefyre-site-secret");
boolean livefyreEnabled = GetterUtil.getBoolean(typeSettingsProperties.getProperty("social-comments-livefyre-enabled"));

%>
<portlet:actionURL name="updateConfiguration" var="updateConfigurationURL" />

<aui:form action="<%= updateConfigurationURL %>">

	<aui:fieldset label="liferay">
		<aui:input label="enabled" name="settings--social-comments-liferay-enabled--" type="checkbox" value="<%= String.valueOf(liferayEnabled) %>"/>
	</aui:fieldset>

	<aui:fieldset label="disqus">
		<aui:input label="enabled" name="settings--social-comments-disqus-enabled--" type="checkbox" value="<%= String.valueOf(disqusEnabled) %>"/>

		<aui:input label="short-name" name="settings--social-comments-disqus-short-name--" value="<%= disqusShortName %>"/>
	</aui:fieldset>

	<aui:fieldset label="livefyre">
		<aui:input label="enabled" name="settings--social-comments-livefyre-enabled--" type="checkbox" value="<%= String.valueOf(livefyreEnabled) %>"/>

		<aui:input label="site-id" name="settings--social-comments-livefyre-site-id--" value="<%= livefyreSiteId %>"/>

		<aui:input label="site-secret" name="settings--social-comments-livefyre-site-secret--" value="<%= livefyreSiteSecret %>"/>
	</aui:fieldset>

	<aui:button-row>
		<aui:button label="save" type="submit" />
	</aui:button-row>
</aui:form>