<?php

class actionContentItemView extends cmsAction {

    public function run(){

        $props = $props_values = false;
        $props_fieldsets = $props_fields = false;

        $ctype_name = $this->request->get('ctype_name', '');

        // Получаем название типа контента и сам тип
        $ctype = $this->model->getContentTypeByName($ctype_name);

		// Получаем SLUG записи
        $slug = $this->request->get('slug', '');

		if (!$ctype) {
			if ($this->cms_config->ctype_default){
				$ctype = $this->model->getContentTypeByName($this->cms_config->ctype_default);
				if (!$ctype) { return cmsCore::error404(); }
                $slug = $ctype_name.'/'.$slug;
			} else {
				return cmsCore::error404();
			}
		} else {
			if ($this->cms_config->ctype_default && $this->cms_config->ctype_default == $this->cms_core->uri_action){
				$this->redirect(href_to($slug . '.html'), 301);
			}
            // если название переопределено, то редиректим со старого на новый
            $mapping = cmsConfig::getControllersMapping();
            if($mapping){
                foreach($mapping as $name=>$alias){
                    if ($name == $ctype['name'] && !$this->cms_core->uri_controller_before_remap) {
                        $this->redirect(href_to($alias.'/'. $slug.'.html'), 301);
                    }
                }
            }
		}

		if (!$ctype['options']['item_on']) { return cmsCore::error404(); }

        list($ctype, $this->model) = cmsEventsManager::hook('content_item_filter', array($ctype, $this->model));

        // Получаем запись
        $item = $this->model->getContentItemBySLUG($ctype['name'], $slug);
        if (!$item) { return cmsCore::error404(); }

        if ($slug !== $item['slug']){
            $this->redirect(href_to($ctype['name'], $item['slug'] . '.html'), 301);
        }

        // добавляем Last-Modified
        if(!$this->cms_user->is_logged){
            cmsCore::respondIfModifiedSince($item['date_last_modified']);
        }

        // на модерации или в черновиках
        if (!$item['is_approved']){

            $item_view_notice = $item['is_draft'] ? LANG_CONTENT_DRAFT_NOTICE : '';

            if ($this->cms_user->id != $item['user_id']){

                return cmsCore::errorForbidden($item_view_notice, true);

            }
            cmsUser::addSessionMessage($item_view_notice, 'info');

        }

        // общие права доступа на просмотр
        if($this->cms_user->id != $item['user_id']){

            if(!$this->checkListPerm($ctype['name'])){
                return cmsCore::errorForbidden();
            }

        }

        // Проверяем публикацию
        if (!$item['is_pub']){
            if ($this->cms_user->id != $item['user_id']){ return cmsCore::error404(); }
        }

        // Проверяем, что не удалено
        if ($item['is_deleted']){

            $allow_restore = (cmsUser::isAllowed($ctype['name'], 'restore', 'all') ||
                (cmsUser::isAllowed($ctype['name'], 'restore', 'own') && $item['user_id'] == $this->cms_user->id));

            if (!$allow_restore){ return cmsCore::error404(); }

            cmsUser::addSessionMessage(LANG_CONTENT_ITEM_IN_TRASH, 'info');

        }

        // Проверяем ограничения доступа из других контроллеров
        if ($item['is_parent_hidden'] || $item['is_private']){

            $is_parent_viewable_result = cmsEventsManager::hook('content_view_hidden', array(
                'viewable'     => true,
                'item'         => $item,
                'ctype'        => $ctype
            ));

            if (!$is_parent_viewable_result['viewable']){

                if(isset($is_parent_viewable_result['access_text'])){

                    cmsUser::addSessionMessage($is_parent_viewable_result['access_text'], 'error');

                    if(isset($is_parent_viewable_result['access_redirect_url'])){
                        $this->redirect($is_parent_viewable_result['access_redirect_url']);
                    } else {
                        $this->redirect(href_to($ctype['name']));
                    }

                }

                cmsUser::goLogin();
            }
        }

        $item['ctype_name'] = $ctype['name'];

        if ($ctype['is_cats'] && $item['category_id'] > 1){

            $item['category'] = $this->model->getCategory($ctype['name'], $item['category_id']);

            if(!empty($ctype['options']['is_cats_multi'])){
                $item['categories'] = $this->model->getContentItemCategoriesList($ctype['name'], $item['id']);
            }

        }

        // Получаем поля для данного типа контента
        $fields = $this->model->getContentFields($ctype['name']);

        // Парсим значения полей
        foreach($fields as $name=>$field){
            $fields[ $name ]['html'] = $field['handler']->setItem($item)->parse( $item[$name] );
        }

        // формируем связи (дочерние списки)
        $childs = array(
            'relations' => $this->model->getContentTypeChilds($ctype['id']),
            'to_add'    => array(),
            'to_bind'   => array(),
            'to_unbind' => array(),
            'tabs'      => array(),
            'items'     => array()
        );

        if ($childs['relations']){

            foreach($childs['relations'] as $relation){

                // пропускаем все не контентные связи
                // их должен обработать хук content_before_childs
                if($relation['target_controller'] != 'content'){
                    continue;
                }

                $perm = cmsUser::getPermissionValue($relation['child_ctype_name'], 'add_to_parent');
                $is_allowed_to_add = ($perm &&
                        ($perm == 'to_all' ||
                        ($perm == 'to_own' && $item['user_id'] == $this->cms_user->id) ||
                        ($perm == 'to_other' && $item['user_id'] != $this->cms_user->id)
                )) || $this->cms_user->is_admin;

                $perm = cmsUser::getPermissionValue($relation['child_ctype_name'], 'bind_to_parent');
                $is_allowed_to_bind = ($perm && (
                    ($perm == 'all_to_all' || $perm == 'own_to_all' || $perm == 'other_to_all') ||
                    (($perm == 'all_to_own' || $perm == 'own_to_own' || $perm == 'other_to_own') && ($item['user_id'] == $this->cms_user->id)) ||
                    (($perm == 'all_to_other' || $perm == 'own_to_other' || $perm == 'other_to_other') && ($item['user_id'] != $this->cms_user->id))
                )) || $this->cms_user->is_admin;

                $is_allowed_to_unbind = cmsUser::isAllowed($relation['child_ctype_name'], 'bind_off_parent');

                if ($is_allowed_to_add && $item['is_approved']) {
                    $childs['to_add'][] = $relation;
                }
                if ($is_allowed_to_bind && $item['is_approved']) {
                    $childs['to_bind'][] = $relation;
                }
                if ($is_allowed_to_unbind && $item['is_approved']) {
                    $childs['to_unbind'][] = $relation;
                }

                $child_ctype = $this->model->getContentTypeByName($relation['child_ctype_name']);

                $filter =   "r.parent_ctype_id = {$ctype['id']} AND ".
                            "r.parent_item_id = {$item['id']} AND ".
                            "r.child_ctype_id = {$relation['child_ctype_id']} AND ".
                            "r.child_item_id = i.id";

                $this->model->joinInner('content_relations_bind', 'r', $filter);

                // применяем приватность
                $this->model->applyPrivacyFilter($child_ctype, cmsUser::isAllowed($ctype['name'], 'view_all'));

                $count = $this->model->getContentItemsCount($relation['child_ctype_name']);

                $is_hide_empty = $relation['options']['is_hide_empty'];

                if (($count || !$is_hide_empty) && $relation['layout'] == 'tab'){

                    $childs['tabs'][$relation['child_ctype_name']] = array(
                        'title'       => $relation['title'],
                        'url'         => href_to($ctype['name'], $item['slug'].'/view-'.$relation['child_ctype_name']),
                        'counter'     => $count,
                        'relation_id' => $relation['id'],
                        'ordering'    => $relation['ordering']
                    );

                }

                if (!$this->request->has('child_ctype_name') && ($count || !$is_hide_empty) && $relation['layout'] == 'list'){

                    if (!empty($relation['options']['limit'])){
                        $child_ctype['options']['limit'] = $relation['options']['limit'];
                    }

                    if (!empty($relation['options']['is_hide_filter'])){
                        $child_ctype['options']['list_show_filter'] = false;
                    }


                    if (!empty($relation['options']['dataset_id'])){

                        $dataset = cmsCore::getModel('content')->getContentDataset($relation['options']['dataset_id']);

                        if ($dataset){
                            $this->model->applyDatasetFilters($dataset);
                        }

                    }

                    $childs['lists'][] = array(
                        'title'       => empty($relation['options']['is_hide_title']) ? $relation['title'] : false,
                        'ctype_name'  => $relation['child_ctype_name'],
                        'html'        => $this->setListContext('item_view_relation_list')->
                            renderItemsList($child_ctype, href_to($ctype['name'], $item['slug'] . '.html')),
                        'relation_id' => $relation['id'],
                        'ordering'    => $relation['ordering']
                    );

                }

                $this->model->resetFilters();

            }

            list($ctype, $childs, $item) = cmsEventsManager::hook('content_before_childs', array($ctype, $childs, $item));

        }

        array_order_by($childs['tabs'], 'ordering');
        array_order_by($childs['lists'], 'ordering');

        // показываем вкладку связи, если передана
        if ($this->request->has('child_ctype_name')){

            $child_ctype_name = $this->request->get('child_ctype_name', '');

            // если связь с контроллером, а не с типом контента
            if ($this->isControllerInstalled($child_ctype_name) && $this->isControllerEnabled($child_ctype_name)){

                $child_controller = cmsCore::getController($child_ctype_name, $this->request);

                if($child_controller->isActionExists('item_childs_view')){

                    return $child_controller->runAction('item_childs_view', array(
                        'ctype'   => $ctype,
                        'item'    => $item,
                        'childs'  => $childs,
                        'content_controller' => $this,
                        'fields'  => $fields
                    ));

                }

            }

            return $this->runExternalAction('item_childs_view', array(
                'ctype'            => $ctype,
                'item'             => $item,
                'child_ctype_name' => $child_ctype_name,
                'childs'           => $childs,
                'fields'           => $fields
            ));

        }

        // Получаем поля-свойства
        if ($ctype['is_cats'] && $item['category_id'] > 1){

            $props = $this->model->getContentProps($ctype['name'], $item['category_id']);

            $props_values = array_filter((array)$this->model->getPropsValues($ctype['name'], $item['id']));

            if ($props && $props_values) {

                $props_fields = $this->getPropsFields($props);

                foreach ($props as $key => $prop) {

                    if (!isset($props_values[$prop['id']])) {
                        continue;
                    }

                    $prop_field = $props_fields[$prop['id']];

                    $props[$key]['html'] = $prop_field->setItem($item)->parse($props_values[$prop['id']]);

                }

                $props_fieldsets = cmsForm::mapFieldsToFieldsets($props, function($field, $user) use($props_values) {
                    if (!isset($props_values[$field['id']])) {
                        return false;
                    }
                    return true;
                });

            }

        }


        // Информация о модераторе для админа и владельца записи
        if ($item['approved_by'] && ($this->cms_user->is_admin || $this->cms_user->id == $item['user_id'])){
            $item['approved_by'] = cmsCore::getModel('users')->getUser($item['approved_by']);
        }

        list($ctype, $item, $fields) = cmsEventsManager::hook('content_before_item', array($ctype, $item, $fields));
        list($ctype, $item, $fields) = cmsEventsManager::hook("content_{$ctype['name']}_before_item", array($ctype, $item, $fields));

		if (!empty($ctype['options']['hits_on']) && $this->cms_user->id != $item['user_id'] && !$this->cms_user->is_admin){
			$this->model->incrementHitsCounter($ctype['name'], $item['id']);
		}

        $fields_fieldsets = cmsForm::mapFieldsToFieldsets($fields, function($field, $user) use ($item) {

            if (!$field['is_in_item'] || $field['is_system'] || $field['name'] == 'title') { return false; }

            if ((empty($item[$field['name']]) || empty($field['html'])) && $item[$field['name']] !== '0') { return false; }

            // проверяем что группа пользователя имеет доступ к чтению этого поля
            if ($field['groups_read'] && !$user->isInGroups($field['groups_read'])) {
                // если группа пользователя не имеет доступ к чтению этого поля,
                // проверяем на доступ к нему для авторов
                if (!empty($item['user_id']) && !empty($field['options']['author_access'])){
                    if (!in_array('is_read', $field['options']['author_access'])){ return false; }
                    if ($item['user_id'] == $user->id){ return true; }
                }
                return false;
            }
            return true;
        });

        // кешируем запись для получения ее в виджетах
        cmsModel::cacheResult('current_ctype', $ctype);
        cmsModel::cacheResult('current_ctype_item', $item);
        cmsModel::cacheResult('current_ctype_fields', $fields);
        cmsModel::cacheResult('current_ctype_fields_fieldsets', $fields_fieldsets);
        cmsModel::cacheResult('current_ctype_props', $props);
        cmsModel::cacheResult('current_ctype_props_fields', $props_fields);
        cmsModel::cacheResult('current_ctype_props_props_fieldsets', $props_fieldsets);

        // SEO параметры
        $seo_desc = $seo_keys = '';
        $seo_title = $item['title'];

        if (!empty($ctype['seo_keys'])){ $seo_keys = $ctype['seo_keys']; }
        if (!empty($ctype['seo_desc'])){ $seo_desc = $ctype['seo_desc']; }
        if (!empty($item['seo_keys'])){ $seo_keys = $item['seo_keys']; }
        if (!empty($item['seo_desc'])){ $seo_desc = $item['seo_desc']; }
        if (!empty($item['seo_title'])){ $seo_title = $item['seo_title']; }

        $this->cms_template->setPageKeywords($seo_keys);
        $this->cms_template->setPageDescription($seo_desc);
        $this->cms_template->setPageTitle($seo_title);

        // глубиномер
        if (empty($ctype['options']['item_off_breadcrumb']) && empty($item['off_breadcrumb'])){

            if ($item['parent_id'] && !empty($ctype['is_in_groups'])){

                $this->cms_template->addBreadcrumb(LANG_GROUPS, href_to('groups'));
                $this->cms_template->addBreadcrumb($item['parent_title'], rel_to_href(str_replace('/content/'.$ctype['name'], '', $item['parent_url'])));
                if ($ctype['options']['list_on']){
                    $this->cms_template->addBreadcrumb((empty($ctype['labels']['profile']) ? $ctype['title'] : $ctype['labels']['profile']), rel_to_href($item['parent_url']));
                }

            } else {

                if ($ctype['options']['list_on']){

                    $list_header = empty($ctype['labels']['list']) ? $ctype['title'] : $ctype['labels']['list'];

                    $this->cms_template->addBreadcrumb($list_header, href_to($ctype['name']));

                    if (isset($item['category'])){

                        $base_url = $this->cms_config->ctype_default == $ctype['name'] ? '' : $ctype['name'];

                        foreach($item['category']['path'] as $c){
                            $this->cms_template->addBreadcrumb($c['title'], href_to($base_url, $c['slug']));
                        }

                    }
                }

            }

            $this->cms_template->addBreadcrumb($item['title']);

        }

        $tool_buttons = $this->getToolButtons($ctype, $item, false, $childs);

        if($tool_buttons){
            $this->cms_template->addMenuItems('toolbar', $tool_buttons);
        }

        if (!empty($childs['tabs'])){

            $this->cms_template->addMenuItem('item-menu', array(
                'title' => string_ucfirst($ctype['labels']['one']),
                'url'   => href_to($ctype['name'], $item['slug'] . '.html')
            ));

            $this->cms_template->addMenuItems('item-menu', $childs['tabs']);

        }

        return $this->cms_template->render('item_view', array(
            'ctype'            => $ctype,
            'fields'           => $fields,
            'fields_fieldsets' => $fields_fieldsets,
            'props'            => $props,
            'props_values'     => $props_values,
            'props_fields'     => $props_fields,
            'props_fieldsets'  => $props_fieldsets,
            'item'             => $item,
            'user'             => $this->cms_user,
            'childs'           => $childs
        ));

    }

    private function getToolButtons($ctype, $item, $is_moderator, $childs) {

        $tool_buttons = array();



        if ($item['is_approved'] || $item['is_draft'] || $is_moderator){

            if (!empty($childs['to_add'])){
                foreach($childs['to_add'] as $relation){

                    $tool_buttons['add_'.$relation['child_ctype_name']] = array(
                        'title'   => sprintf(LANG_CONTENT_ADD_ITEM, $relation['child_labels']['create']),
                        'options' => array('class' => 'add'),
                        'url'     => href_to($relation['child_ctype_name'], 'add') . "?parent_{$ctype['name']}_id={$item['id']}".($item['parent_type']=='group' ? '&group_id='.$item['parent_id'] : '')
                    );

                }
            }

            if (!empty($childs['to_bind'])){
                foreach($childs['to_bind'] as $relation){

                    $tool_buttons['bind_'.$relation['child_ctype_name']] = array(
                        'title'   => sprintf(LANG_CONTENT_BIND_ITEM, $relation['child_labels']['create']),
                        'options' => array('class' => 'newspaper_add ajax-modal'),
                        'url'     => href_to($ctype['name'], 'bind_form', array($relation['child_ctype_name'], $item['id']))
                    );

                }
            }

            if (!empty($childs['to_unbind'])){
                foreach($childs['to_unbind'] as $relation){

                    $tool_buttons['unbind_'.$relation['child_ctype_name']] = array(
                        'title'   => sprintf(LANG_CONTENT_UNBIND_ITEM, $relation['child_labels']['create']),
                        'options' => array('class' => 'newspaper_delete ajax-modal'),
                        'url'     => href_to($ctype['name'], 'bind_form', array($relation['child_ctype_name'], $item['id'], 'unbind'))
                    );

                }
            }

            $allow_edit = cmsUser::isAllowed($ctype['name'], 'edit', 'all') || cmsUser::isAllowed($ctype['name'], 'edit', 'premod_all');
            if($item['user_id'] == $this->cms_user->id && !$allow_edit){
                $allow_edit = cmsUser::isAllowed($ctype['name'], 'edit', 'own') || cmsUser::isAllowed($ctype['name'], 'edit', 'premod_own');
            }

            if ($allow_edit){

                $tool_buttons['edit'] = array(
                    'title'   => sprintf(LANG_CONTENT_EDIT_ITEM, $ctype['labels']['create']),
                    'options' => array('class' => 'edit'),
                    'url'     => href_to($ctype['name'], 'edit', $item['id'])
                );

            }

            $allow_delete = (cmsUser::isAllowed($ctype['name'], 'delete', 'all') ||
                (cmsUser::isAllowed($ctype['name'], 'delete', 'own') && $item['user_id'] == $this->cms_user->id));

            if ($allow_delete){
                if ($item['is_approved'] || $item['is_draft']){

                    $tool_buttons['delete'] = array(
                        'title'   => sprintf(LANG_CONTENT_DELETE_ITEM, $ctype['labels']['create']),
                        'options' => array('class' => 'delete', 'confirm' => sprintf(LANG_CONTENT_DELETE_ITEM_CONFIRM, $ctype['labels']['create'])),
                        'url'     => href_to($ctype['name'], 'delete', $item['id']).'?csrf_token='.cmsForm::getCSRFToken()
                    );
                }

            }

        }

        if ($item['is_approved'] && !$item['is_deleted']){

            if (cmsUser::isAllowed($ctype['name'], 'move_to_trash', 'all') ||
            (cmsUser::isAllowed($ctype['name'], 'move_to_trash', 'own') && $item['user_id'] == $this->cms_user->id)){

                $tool_buttons['basket_put'] = array(
                    'title'   => ($allow_delete ? LANG_BASKET_DELETE : sprintf(LANG_CONTENT_DELETE_ITEM, $ctype['labels']['create'])),
                    'options' => array('class' => 'basket_put', 'confirm' => sprintf(LANG_CONTENT_DELETE_ITEM_CONFIRM, $ctype['labels']['create'])),
                    'url'     => href_to($ctype['name'], 'trash_put', $item['id'])
                );

            }

        }

        if ($item['is_approved'] && $item['is_deleted']){

            if (cmsUser::isAllowed($ctype['name'], 'restore', 'all') ||
            (cmsUser::isAllowed($ctype['name'], 'restore', 'own') && $item['user_id'] == $this->cms_user->id)){

                $tool_buttons['basket_remove'] = array(
                    'title'   => LANG_RESTORE,
                    'options' => array('class' => 'basket_remove'),
                    'url'     => href_to($ctype['name'], 'trash_remove', $item['id'])
                );

            }

        }

        $buttons_hook = cmsEventsManager::hook('ctype_item_tool_buttons', array(
            'params'  => array($ctype, $item, $is_moderator, $childs),
            'buttons' => $tool_buttons
        ));

        $buttons_hook = cmsEventsManager::hook($ctype['name'].'_ctype_item_tool_buttons', array(
            'params'  => array($ctype, $item, $is_moderator, $childs),
            'buttons' => $buttons_hook['buttons']
        ));

        return $buttons_hook['buttons'];

    }

}
