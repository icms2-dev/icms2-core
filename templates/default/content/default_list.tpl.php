<?php
    if( $ctype['options']['list_show_filter'] ) {
        $this->renderAsset('ui/filter-panel', array(
            'css_prefix'   => $ctype['name'],
            'page_url'     => $page_url,
            'fields'       => $fields,
            'props_fields' => $props_fields,
            'props'        => $props,
            'filters'      => $filters,
            'ext_hidden_params' => $ext_hidden_params,
            'is_expanded'  => $ctype['options']['list_expand_filter']
        ));
    }
?>

<?php if ($items){ ?>

    <div class="content_list default_list <?php echo $ctype['name']; ?>_list">

        <?php foreach($items as $item){ ?>

            <?php $stop = 0; ?>

			<div class="content_list_item <?php echo $ctype['name']; ?>_list_item<?php if (!empty($item['is_vip'])){ ?> is_vip<?php } ?>">

                <?php if (!empty($item['fields']['photo'])){ ?>
                    <div class="photo">
                        <?php if (!empty($item['is_private_item'])) { ?>
                            <?php echo html_image(default_images('private', $fields['photo']['options']['size_teaser']), $fields['photo']['options']['size_teaser'], $item['title']); ?>
                        <?php } else { ?>
                            <a href="<?php echo href_to($ctype['name'], $item['slug'].'.html'); ?>">
                                <?php echo html_image($item['photo'], $fields['photo']['options']['size_teaser'], $item['title']); ?>
                            </a>
                        <?php } ?>
                        <?php unset($item['fields']['photo']); ?>
                    </div>
                <?php } ?>

                <div class="fields">

                <?php foreach($item['fields'] as $field){ ?>

                    <?php if ($stop === 2) { break; } ?>

                    <div class="field ft_<?php echo $field['type']; ?> f_<?php echo $field['name']; ?>">

                        <?php if ($field['label_pos'] != 'none'){ ?>
                            <div class="title_<?php echo $field['label_pos']; ?>">
                                <?php echo $field['title'] . ($field['label_pos']=='left' ? ': ' : ''); ?>
                            </div>
                        <?php } ?>

                        <?php if ($field['name'] == 'title' && $ctype['options']['item_on']){ ?>
                            <h2 class="value">
                            <?php if (!empty($this->menus['list_actions_menu'])){ ?>
                                <div class="list_actions_menu controller_actions_menu dropdown_menu">
                                    <input tabindex="-1" type="checkbox" id="menu_label_<?php echo $item['id']; ?>">
                                    <label for="menu_label_<?php echo $item['id']; ?>" class="group_menu_title"></label>
                                    <ul class="list_actions menu">
                                        <?php foreach($this->menus['list_actions_menu'] as $menu){ ?>
                                            <li>
                                                <a class="<?php echo isset($menu['options']['class']) ? $menu['options']['class'] : ''; ?>" href="<?php echo string_replace_keys_values($menu['url'], $item); ?>" title="<?php html($menu['title']); ?>">
                                                    <?php echo $menu['title']; ?>
                                                </a>
                                            </li>
                                        <?php } ?>
                                    </ul>
                                </div>
                            <?php } ?>
                            <?php if ($item['parent_id']){ ?>
                                <a class="parent_title" href="<?php echo rel_to_href($item['parent_url']); ?>"><?php html($item['parent_title']); ?></a>
                                &rarr;
                            <?php } ?>

                            <?php if (!empty($item['is_private_item'])) { $stop++; ?>
                                <?php html($item[$field['name']]); ?> <span class="is_private" title="<?php html($item['private_item_hint']); ?>"></span>
                            <?php } else { ?>
                                <a href="<?php echo href_to($ctype['name'], $item['slug'].'.html'); ?>"><?php html($item[$field['name']]); ?></a>
                                <?php if ($item['is_private']) { ?>
                                    <span class="is_private" title="<?php echo LANG_PRIVACY_HINT; ?>"></span>
                                <?php } ?>
                            <?php } ?>
                            </h2>
                        <?php } else { ?>
                            <div class="value">
                                <?php if (!empty($item['is_private_item'])) { ?>
                                    <div class="private_field_hint"><?php echo $item['private_item_hint']; ?></div>
                                <?php } else { ?>
                                    <?php echo $field['html']; ?>
                                <?php } ?>
                            </div>
                        <?php } ?>

                    </div>

                <?php } ?>

                </div>

                <?php
					$show_bar = $fields['date_pub']['is_in_list'] ||
								$fields['user']['is_in_list'] ||
								!empty($ctype['options']['hits_on']) ||
								!$item['is_pub'];
                ?>

                <?php if($show_bar){ ?>
                    <div class="info_bar">
                        <?php if ($fields['date_pub']['is_in_list']){ ?>
                            <div class="bar_item bi_date_pub<?php if(!empty($item['is_new'])){ ?> highlight_new<?php } ?>" title="<?php echo $fields['date_pub']['title']; ?>">
                                <?php echo $fields['date_pub']['handler']->parse( $item['date_pub'] ); ?>
                            </div>
                        <?php } ?>
                        <?php if (!$item['is_pub']){ ?>
                            <div class="bar_item bi_not_pub">
                                <?php echo LANG_CONTENT_NOT_IS_PUB; ?>
                            </div>
                        <?php } ?>
                        <?php if ($fields['user']['is_in_list']){ ?>
                            <div class="bar_item bi_user" title="<?php echo $fields['user']['title']; ?>">
                                <?php echo $fields['user']['handler']->parse( $item['user'] ); ?>
                            </div>
                            <?php if (!empty($item['folder_title'])){ ?>
                                <div class="bar_item bi_folder">
                                    <a href="<?php echo href_to('users', $item['user']['id'], array('content', $ctype['name'], $item['folder_id'])); ?>"><?php echo $item['folder_title']; ?></a>
                                </div>
                            <?php } ?>
                        <?php } ?>
                        <?php if (!empty($ctype['options']['hits_on'])){ ?>
                            <div class="bar_item bi_hits" title="<?php echo LANG_HITS; ?>">
                                <?php echo $item['hits_count']; ?>
                            </div>
                        <?php } ?>
                    </div>
                <?php } ?>

            </div>

        <?php } ?>

    </div>

    <?php if ($perpage < $total) { ?>
        <?php echo html_pagebar($page, $perpage, $total, $page_url, array_merge($filters, $ext_hidden_params)); ?>
    <?php } ?>

<?php } else {

    if(!empty($ctype['labels']['many'])){
        echo sprintf(LANG_TARGET_LIST_EMPTY, $ctype['labels']['many']);
    } else {
        echo LANG_LIST_EMPTY;
    }

}
