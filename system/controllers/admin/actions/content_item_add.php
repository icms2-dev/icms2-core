<?php

class actionAdminContentItemAdd extends cmsAction {

    public function run($ctype_id, $category_id=1){

	    $ctype = $this->model_content->getContentType($ctype_id);
	    if (!$ctype) {
		    return cmsCore::error404();
	    }

	    $this->cms_template->addCSS('templates/'.$this->cms_template->getName().'/controllers/admin/styles.css');

	    $this->cms_core->uri_controller = 'content';
	    $this->cms_core->uri_action = $ctype['name'];
	    $this->cms_core->uri = $ctype['name'].'/add'.($category_id ? '/'.$category_id : '');
	    $this->current_params = array($category_id);
	    $this->cms_core->runController();
    }

}
