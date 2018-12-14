<?php

class onUsersUserPrivacyTypes extends cmsAction {

    public function run(){

        $types = array();

        $types['users_profile_view'] = array(
            'title'   => LANG_USERS_PRIVACY_PROFILE_VIEW,
            'options' => array('anyone', 'friends')
        );


        return $types;

    }

}
