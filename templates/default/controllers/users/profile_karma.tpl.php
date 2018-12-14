<?php

    $this->setPageTitle($tab['title'], $profile['nickname']);
    $this->setPageDescription($profile['nickname'].' — '.$tab['title']);

    $this->addBreadcrumb(LANG_USERS, $this->href_to(''));
    $this->addBreadcrumb($profile['nickname'], $this->href_to($profile['id']));
    $this->addBreadcrumb($tab['title']);

?>

<div id="user_profile_header">
    <?php $this->renderChild('profile_header', array('profile'=>$profile, 'tabs'=>$tabs)); ?>
</div>

<div id="users_karma_log_window">

    <?php if ($log){ ?>

        <div id="users_karma_log_list" class="striped-list list-32">

            <?php foreach($log as $entry){ ?>

                <div class="item">

                    <div class="icon">
                        <?php echo html_avatar_image($entry['user']['avatar'], 'micro', $entry['user']['nickname']); ?>
                    </div>

                    <div class="value <?php echo html_signed_class($entry['points']); ?>">
                        <span>
                            <?php echo html_signed_num($entry['points']); ?>
                        </span>
                    </div>

                </div>

            <?php } ?>

        </div>

    <?php } ?>

    <?php if (!$log){ ?>
        <p><?php echo LANG_USERS_KARMA_LOG_EMPTY; ?></p>
    <?php } ?>

</div>

<?php if ($perpage < $total) { ?>
    <?php echo html_pagebar($page, $perpage, $total); ?>
<?php } ?>
