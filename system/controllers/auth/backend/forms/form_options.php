<?php

class formAuthOptions extends cmsForm {

    public $is_tabbed = true;

    public function init() {

        $auth_redirect_items = array(
            'none'        => LANG_REG_CFG_AUTH_REDIRECT_NONE,
            'index'       => LANG_REG_CFG_AUTH_REDIRECT_INDEX,
            'profile'     => LANG_REG_CFG_AUTH_REDIRECT_PROFILE,
            'profileedit' => LANG_REG_CFG_AUTH_REDIRECT_PROFILEEDIT
        );

        return array(

            array(
                'type' => 'fieldset',
                'title' => LANG_REGISTRATION,
                'childs' => array(

                    new fieldCheckbox('is_reg_enabled', array(
                        'title' => LANG_REG_CFG_IS_ENABLED,
                    )),

                    new fieldString('reg_reason', array(
                        'title' => LANG_REG_CFG_DISABLED_NOTICE,
                    )),

                    new fieldCheckbox('reg_captcha', array(
                        'title' => LANG_REG_CFG_REG_CAPTCHA,
                    )),

                    new fieldCheckbox('reg_auto_auth', array(
                        'title'   => LANG_REG_CFG_REG_AUTO_AUTH,
                        'default' => 1
                    )),

                    new fieldListGroups('def_groups', array(
                        'title' => LANG_REG_CFG_DEF_GROUP_ID,
                        'show_all' => false,
						'default' => array(3)
                    )),

                    new fieldCheckbox('verify_email', array(
                        'title' => LANG_REG_CFG_VERIFY_EMAIL,
                        'hint' => LANG_REG_CFG_VERIFY_EMAIL_HINT,
                    )),

                    new fieldNumber('verify_exp', array(
                        'title'   => LANG_REG_CFG_VERIFY_EXPIRATION,
                        'default' => 48,
                        'rules' => array(
                            array('required'),
                            array('min', 1)
                        )
                    ))

                )
            ),

            array(
                'type' => 'fieldset',
                'title' => LANG_AUTHORIZATION,
                'childs' => array(

                    new fieldCheckbox('auth_captcha', array(
                        'title' => LANG_REG_CFG_AUTH_CAPTCHA,
                    )),

                    new fieldList('first_auth_redirect', array(
                        'title'   => LANG_REG_CFG_FIRST_AUTH_REDIRECT,
                        'default' => 'profileedit',
                        'items'   => $auth_redirect_items
                    )),

                    new fieldList('auth_redirect', array(
                        'title'   => LANG_REG_CFG_AUTH_REDIRECT,
                        'default' => 'none',
                        'items'   => $auth_redirect_items
                    )),

                )
            ),

            array(
                'type' => 'fieldset',
                'title' => LANG_AUTH_RESTRICTIONS,
                'childs' => array(

                    new fieldCheckbox('is_site_only_auth_users', array(
                        'title' => LANG_CP_SETTINGS_SITE_ONLY_TO_USERS,
                    )),

                    new fieldList('guests_allow_controllers', array(
                        'title'     => LANG_REG_CFG_GUESTS_ALLOW_CONTROLLERS,
                        'default'   => array('auth', 'geo'),
                        'is_chosen_multiple' => true,
                        'generator' => function ($item){
                            $admin_model = cmsCore::getModel('admin');
                            $controllers = $admin_model->getInstalledControllers();
                            $items = array('' => '');
                            foreach($controllers as $controller){
                                $items[$controller['name']] = $controller['title'];
                            }
                            return $items;
                        },
                        'visible_depend' => array('is_site_only_auth_users' => array('show' => array('1')))
                    )),

                    new fieldText('restricted_emails', array(
                        'title' => LANG_AUTH_RESTRICTED_EMAILS,
                        'hint' => LANG_AUTH_RESTRICTED_EMAILS_HINT,
                    )),

                    new fieldText('restricted_names', array(
                        'title' => LANG_AUTH_RESTRICTED_NAMES,
                        'hint' => LANG_AUTH_RESTRICTED_NAMES_HINT,
                    )),

                    new fieldText('restricted_ips', array(
                        'title' => LANG_AUTH_RESTRICTED_IPS,
                        'hint' => LANG_AUTH_RESTRICTED_IPS_HINT,
                    )),

                )
            )
        );

    }

}
