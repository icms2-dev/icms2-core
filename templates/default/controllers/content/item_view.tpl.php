<?php

    $this->addHead('<link rel="canonical" href="'.href_to_abs($ctype['name'], $item['slug'] . '.html').'"/>');

    $this->renderContentItem($ctype['name'], array(
        'item'             => $item,
        'ctype'            => $ctype,
        'fields'           => $fields,
        'fields_fieldsets' => $fields_fieldsets,
        'props'            => $props,
        'props_values'     => $props_values,
        'props_fields'     => $props_fields,
        'props_fieldsets'  => $props_fieldsets,
    ));

    if (!empty($childs['lists'])){
        foreach($childs['lists'] as $list){
            if ($list['title']){ ?><h2><?php echo $list['title']; ?></h2><?php }
            echo $list['html'];
        }
    }

?>

