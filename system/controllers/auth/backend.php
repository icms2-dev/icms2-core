<?php

class backendAuth extends cmsBackend{

    public $useDefaultOptionsAction = true;
    public $useSeoOptions = true;

    public function actionIndex(){
        $this->redirectToAction('options');
    }

    public function getBackendMenu(){
        return array(
            array(
                'title' => LANG_OPTIONS,
                'url'   => href_to($this->root_url, 'options')
            )
        );
    }

}
