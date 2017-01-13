package fi.javaguru.socialcomments.web.portlet;

import com.liferay.application.list.BasePanelApp;
import com.liferay.application.list.PanelApp;
import com.liferay.application.list.constants.PanelCategoryKeys;
import com.liferay.portal.kernel.model.Portlet;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

@Component(
		immediate = true,
		property = {
				"panel.category.key=" + PanelCategoryKeys.SITE_ADMINISTRATION_CONFIGURATION,
				"service.ranking:Integer=100"
		},
		service = PanelApp.class
)
public class SocialCommentsPanelApp extends BasePanelApp {

	@Override
	public String getPortletId() {
		return "fi_javaguru_socialcomments_web_portlet_SocialCommentsPortlet";
	}

	@Override
	@Reference(
			target = "(javax.portlet.name=fi_javaguru_socialcomments_web_portlet_SocialCommentsPortlet)",
			unbind = "-"
	)
	public void setPortlet(Portlet portlet) {
		super.setPortlet(portlet);
	}
}
