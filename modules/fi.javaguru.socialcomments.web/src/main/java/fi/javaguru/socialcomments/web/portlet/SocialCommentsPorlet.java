package fi.javaguru.socialcomments.web.portlet;

import com.liferay.portal.kernel.model.Group;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.service.GroupService;
import com.liferay.portal.kernel.service.ServiceContext;
import com.liferay.portal.kernel.service.ServiceContextFactory;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.util.PropertiesParamUtil;
import com.liferay.portal.kernel.util.UnicodeProperties;

import java.io.IOException;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.Portlet;
import javax.portlet.PortletException;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

@Component(
	immediate = true,
	property = {
		"com.liferay.portlet.add-default-resource=true",
		"com.liferay.portlet.css-class-wrapper=portlet-controlpanel",
		"com.liferay.portlet.display-category=category.hidden",
		"com.liferay.portlet.instanceable=false",
		"javax.portlet.display-name=Social Comments",
		"javax.portlet.icon=/icon.png",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=fi_javaguru_socialcomments_web_portlet_SocialCommentsPortlet",
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=user"
	},
	service = Portlet.class
)
public class SocialCommentsPorlet extends MVCPortlet {

	public void updateConfiguration(
			ActionRequest actionRequest, ActionResponse actionResponse)
		throws IOException, PortletException {

		try {
			ServiceContext serviceContext =
				ServiceContextFactory.getInstance(actionRequest);

			long scopeGroupId = serviceContext.getScopeGroupId();

			Group scopeGroup = _groupService.getGroup(scopeGroupId);

			if (scopeGroup.isStagingGroup()) {
				scopeGroup = scopeGroup.getLiveGroup();
			}

			UnicodeProperties typeSettingsProperties =
				scopeGroup.getTypeSettingsProperties();

			UnicodeProperties properties = PropertiesParamUtil.getProperties(
				actionRequest, "settings--");

			typeSettingsProperties.putAll(properties);

			_groupService.updateGroup(
				scopeGroup.getGroupId(), scopeGroup.getTypeSettings());
		}
		catch (Exception e) {
			SessionErrors.add(actionRequest, e.getClass().getName());
		}
	}

	@Reference(unbind = "-")
	public void setGroupService(GroupService groupService) {
		_groupService = groupService;
	}

	private GroupService _groupService;

}