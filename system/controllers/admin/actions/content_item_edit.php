<?php

class actionAdminContentItemEdit extends cmsAction {

    public function run($ctype_name, $id) {

        $ctype = $this->model_content->getContentTypeByName($ctype_name);
        if (!$ctype) {
            return cmsCore::error404();
        }

	    $this->cms_template->addCSS('templates/'.$this->cms_template->getName().'/controllers/admin/styles.css');

        $this->cms_core->uri_controller = 'content';
        $this->cms_core->uri_action = $ctype['name'];
        $this->cms_core->uri = $ctype['name'].'/edit/'.$id;
        $this->current_params = array($id);
        $this->cms_core->runController();

        return;

    }

}
