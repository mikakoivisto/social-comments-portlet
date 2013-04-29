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

<%@ include file="/html/taglib/init.jsp" %>

<%@ page import="com.liferay.portal.kernel.util.DigesterUtil" %>
<%@ page import="com.liferay.portal.kernel.util.StringBundler" %>
<%@ page import="com.liferay.portal.kernel.util.StringPool" %>
<%@ page import="com.liferay.portal.util.PortalUtil" %>
<%@ page import="com.liferay.portal.kernel.util.GetterUtil" %>
<%@ page import="com.liferay.portal.kernel.util.HtmlUtil" %>
<%@ page import="com.liferay.portal.kernel.util.HttpUtil" %>
<%@ page import="com.liferay.portlet.blogs.model.BlogsEntry" %>
<%@ page import="com.liferay.portal.model.Group" %>
<%@ page import="com.liferay.portal.kernel.util.UnicodeProperties" %>

<%
String className = (String)request.getAttribute("liferay-ui:discussion:className");
long classPK = GetterUtil.getLong((String)request.getAttribute("liferay-ui:discussion:classPK"));
String subject = (String)request.getAttribute("liferay-ui:discussion:subject");
String redirect = (String)request.getAttribute("liferay-ui:discussion:redirect");

Group scopeGroup = themeDisplay.getScopeGroup();

UnicodeProperties typeSettingsProperties = scopeGroup.getTypeSettingsProperties();

boolean liferayEnabled = GetterUtil.getBoolean(typeSettingsProperties.getProperty("social-comments-liferay-enabled"), true);

boolean disqusEnabled = GetterUtil.getBoolean(typeSettingsProperties.getProperty("social-comments-disqus-enabled"));
String disqusShortName = typeSettingsProperties.getProperty("social-comments-disqus-short-name");

String livefyreSiteId = typeSettingsProperties.getProperty("social-comments-livefyre-site-id");
String livefyreSiteSecret = typeSettingsProperties.getProperty("social-comments-livefyre-site-secret");
boolean livefyreEnabled = GetterUtil.getBoolean(typeSettingsProperties.getProperty("social-comments-livefyre-enabled"));

boolean gplusEnabled = GetterUtil.getBoolean(typeSettingsProperties.getProperty("social-comments-gplus-enabled"));
int gplusWidth = GetterUtil.getInteger(typeSettingsProperties.getProperty("social-comments-gplus-width", "642"));

String articleId = className.concat(String.valueOf(classPK));
String articleUrl = redirect;

if (className.equals(BlogsEntry.class.getName())) {
	articleUrl = PortalUtil.getPortalURL(request).concat("/c/blogs/find_entry?entryId=").concat(String.valueOf(classPK));
}

StringBundler sb = new StringBundler(4);

sb.append(articleId);
sb.append(StringPool.COMMA);
sb.append(articleUrl);
sb.append(StringPool.COMMA);
sb.append(subject);
sb.append(StringPool.COMMA);
sb.append(livefyreSiteSecret);

String livefyreSig = DigesterUtil.digestHex("MD5", sb.toString());
%>
<c:if test="<%= liferayEnabled %>">
		<liferay-util:include page="/html/taglib/ui/discussion/page.portal.jsp" />
</c:if>
<c:if test="<%= disqusEnabled %>">
	<div id="disqus_thread"></div>
		<noscript>
			Please enable JavaScript to view the <a
				href="http://disqus.com/?ref_noscript">comments powered by
				Disqus.</a>
		</noscript>
		<a href="http://disqus.com" class="dsq-brlink">comments powered by
			<span class="logo-disqus">Disqus</span>
		</a>
	<liferay-util:html-bottom outputKey="taglib_ui_discussion_disqus">
		<script type="text/javascript">
			var disqus_shortname = '<%= disqusShortName %>';
			var disqus_identifier = '<%= articleId %>';
			var disqus_url = '<%= HtmlUtil.escapeJS(articleUrl) %>';
			var disqus_title = '<%= HtmlUtil.escapeJS(subject) %>';

			(function() {
				var dsq = document.createElement('script');
				dsq.type = 'text/javascript';
				dsq.async = true;
				dsq.src = '<%= HttpUtil.getProtocol(request) %>://' + disqus_shortname + '.disqus.com/embed.js';
				(document.getElementsByTagName('head')[0] || document
						.getElementsByTagName('body')[0]).appendChild(dsq);
			})();
		</script>
	</liferay-util:html-bottom>
</c:if>
<c:if test="<%= livefyreEnabled %>">
	<div id="livefyre"></div>

	<liferay-util:html-bottom outputKey="taglib_ui_discussion_livefyre">
		<script type='text/javascript' src='http://zor.livefyre.com/wjs/v1.0/javascripts/livefyre_init.js'></script>
		<script type='text/javascript'>
			LF({
				site_id: <%= livefyreSiteId %>,
				article_id: "<%= articleId %>",
				conv_meta: {
					article_url: "<%= HtmlUtil.escapeJS(articleUrl) %>",
					title: "<%= HtmlUtil.escapeJS(subject) %>",
					sig: "<%= livefyreSig %>"
				}
			});
		</script>
	</liferay-util:html-bottom>
</c:if>

<c:if test="<%= gplusEnabled %>">
	<div class="g-comments"
    	data-href="<%= articleUrl %>"
    	data-width="<%= gplusWidth %>"
    	data-first_party_property="BLOGGER"
    	data-view_type="FILTERED_POSTMOD">
	</div>

	<liferay-util:html-bottom outputKey="taglib_ui_discussion_gplus">
		<script src="https://apis.google.com/js/plusone.js"></script>
	</liferay-util:html-bottom>
</c:if>