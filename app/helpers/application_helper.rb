module ApplicationHelper
	def nav_link(link_text, link_path)
		content_tag(:div, class: current_page?(link_path) ? 'nav-item current' : 'nav-item') do
	    	link_to link_text, link_path
	  	end
	end
end
