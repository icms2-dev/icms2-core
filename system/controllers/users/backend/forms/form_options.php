<?php

class formUsersOptions extends cmsForm {

    public $is_tabbed = true;

    public function init() {

        return array(

            array(
                'type' => 'fieldset',
                'title' => LANG_USERS_LIST,
                'childs' => array(

                    new fieldCheckbox('is_ds_online', array(
                        'title' => sprintf(LANG_USERS_OPT_DS_SHOW, LANG_USERS_DS_ONLINE),
                    )),
                    new fieldCheckbox('is_ds_popular', array(
                        'title' => sprintf(LANG_USERS_OPT_DS_SHOW, LANG_USERS_DS_POPULAR),
                    )),
                    new fieldCheckbox('is_filter', array(
                        'title' => LANG_USERS_OPT_FILTER_SHOW,
                    )),
                    new fieldNumber('limit', array(
                        'title' => LANG_LIST_LIMIT,
                        'default' => 15,
                        'rules' => array(
                            array('required')
                        )
                    ))

                )
            ),

            array(
                'type' => 'fieldset',
                'title' => LANG_USERS_PROFILE,
                'childs' => array(

                    new fieldCheckbox('is_auth_only', array(
                        'title' => LANG_USERS_OPT_AUTH_ONLY,
                    )),

                    new fieldCheckbox('is_themes_on', array(
                        'title' => LANG_USERS_OPT_THEME,
                        'hint' => LANG_USERS_OPT_THEME_HINT,
                    )),

                    new fieldNumber('max_tabs', array(
                        'title' => LANG_USERS_OPT_MAX_TABS,
                        'hint' => LANG_USERS_OPT_MAX_TABS_HINT,
                        'default' => 6
                    )),

                )
            )

        );

    }

}
