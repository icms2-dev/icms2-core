<?php

    $this->addJS('templates/default/js/jquery-ui.js');
    $this->addCSS('templates/default/css/jquery-ui.css');

    $this->setPagePatternTitle($profile, 'nickname');
    $this->setPagePatternDescription($profile, 'nickname');

    $this->addBreadcrumb(LANG_USERS, href_to('users'));
    $this->addBreadcrumb($profile['nickname']);

    $this->addToolButtons($tool_buttons);

?>

<div id="user_profile_header">
    <?php $this->renderChild('profile_header', array('profile'=>$profile, 'tabs'=>$tabs)); ?>
</div>

<div id="user_profile">

    <div id="left_column" class="column">

        <?php if ($fields['avatar']['is_in_item']){ ?>
            <div id="avatar" class="block">
                <?php echo html_avatar_image($profile['avatar'], $fields['avatar']['options']['size_full'], $profile['nickname'], $profile['is_deleted']); ?>
            </div>
        <?php } ?>
        <div class="block">
            <ul class="details">
                <li>
                    <strong><?php echo LANG_USERS_PROFILE_REGDATE; ?>:</strong>
                    <?php echo string_date_age_max($profile['date_reg'], true); ?>
                </li>
                <?php if ($profile['inviter_id']) { ?>
                <li>
                    <strong><?php echo LANG_USERS_PROFILE_INVITED_BY; ?>:</strong>
                    <a href="<?php echo href_to('users', $profile['inviter_id']); ?>"><?php html($profile['inviter_nickname']); ?></a>
                </li>
                <?php } ?>
                <?php if ($user->is_admin) { ?>
                <li>
                    <strong><?php echo LANG_USERS_PROFILE_LAST_IP; ?>:</strong>
                    <?php html($profile['ip']); ?>
                </li>
                <?php } ?>
            </ul>
        </div>
        <?php if ($content_counts) { ?>
            <div class="block">
                <ul class="content_counts">
                    <?php foreach($content_counts as $ctype_name=>$count){ ?>
                        <?php if (!$count['is_in_list']) { continue; } ?>
                        <li>
                            <a href="<?php echo href_to('users', $profile['id'], array('content', $ctype_name)); ?>">
                                <?php html($count['title']); ?>
                                <span class="counter"><?php html($count['count']); ?></span>
                            </a>
                        </li>
                    <?php } ?>
                </ul>
            </div>
        <?php } ?>
    </div>

    <div id="right_column" class="column">

            <div id="information" class="content_item block">

                <?php foreach($fieldsets as $fieldset){ ?>

                    <?php if (!$fieldset['fields']) { continue; } ?>

                    <div class="fieldset">

                    <?php if ($fieldset['title']){ ?>
                        <div class="fieldset_title">
                            <h3><?php echo $fieldset['title']; ?></h3>
                        </div>
                    <?php } ?>

                    <?php foreach($fieldset['fields'] as $field){ ?>

                        <?php
                            if (!isset($field['options']['label_in_item'])) {
                                $label_pos = 'none';
                            } else {
                                $label_pos = $field['options']['label_in_item'];
                            }
                        ?>

                        <div class="field ft_<?php echo $field['type']; ?> f_<?php echo $field['name']; ?>">

                            <?php if ($label_pos != 'none'){ ?>
                                <div class="title title_<?php echo $label_pos; ?>"><?php echo $field['title']; ?>: </div>
                            <?php } ?>

                            <div class="value">
                                <?php
                                    echo $field['handler']->setItem($profile)->parse( $profile[$field['name']] );
                                ?>
                            </div>

                        </div>

                    <?php } ?>

                    </div>

                <?php } ?>

            </div>

    </div>

</div>

