<?php

class actionContentItemDelete extends cmsAction {

    public function run(){

        // Получаем тип контента
        $ctype = $this->model->getContentTypeByName($this->request->get('ctype_name', ''));
        if (!$ctype) { cmsCore::error404(); }

        $item = $this->model->getContentItem($ctype['name'], $this->request->get('id', 0));
        if (!$item) { cmsCore::error404(); }

        // проверяем наличие доступа
        if (!cmsUser::isAllowed($ctype['name'], 'delete')) { cmsCore::error404(); }
        if (!cmsUser::isAllowed($ctype['name'], 'delete', 'all') && $item['user_id'] != $this->cms_user->id) { cmsCore::error404(); }

        if (!cmsForm::validateCSRFToken($this->request->get('csrf_token', ''))){ cmsCore::error404(); }

        $back_action = '';

        if ($ctype['is_cats'] && $item['category_id']){

            $category = $this->model->getCategory($ctype['name'], $item['category_id']);
            $back_action = $category['slug'];

        }

        $this->model->deleteContentItem($ctype['name'], $item['id']);

        cmsUser::addSessionMessage(LANG_DELETE_SUCCESS, 'success');

        $back_url = $this->request->get('back', '');

        if ($back_url){
            $this->redirect($back_url);
        } else {
            if ($ctype['options']['list_on']){
                $this->redirectTo($ctype['name'], $back_action);
            } else {
                $this->redirectToHome();
            }
        }

    }

}
