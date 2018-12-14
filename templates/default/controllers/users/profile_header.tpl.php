<?php $this->addJS('templates/default/js/users.js'); ?>
<?php $user = cmsUser::getInstance(); ?>
<div id="user_profile_title">

    <div class="avatar">
        <?php echo html_avatar_image($profile['avatar'], 'micro', $profile['nickname'], $profile['is_deleted']); ?>
    </div>

    <div class="name<?php if (!empty($profile['status'])){ ?> name_with_status<?php } ?>">

        <h1>
            <?php if (!empty($this->controller->options['tag_h1'])) { ?>
                <?php echo string_replace_keys_values_extended($this->controller->options['tag_h1'], $profile); ?>
            <?php } else { ?>
                <?php html($profile['nickname']); ?>
            <?php } ?>
            <?php if ($profile['is_locked']){ ?>
                <span class="is_locked"><?php echo LANG_USERS_LOCKED_NOTICE_PUBLIC; ?></span>
            <?php } ?>
            <?php if ($profile['is_deleted']){ ?>
                <span class="is_locked"><?php echo LANG_USERS_IS_DELETED; ?></span>
            <?php } ?>
            <sup title="<?php echo LANG_USERS_PROFILE_LOGDATE; ?>">
                <?php echo $profile['is_online'] ? '<span class="online">'.LANG_ONLINE.'</span>' : string_date_age_max($profile['date_log'], true); ?>
            </sup>
        </h1>
    </div>
</div>

<?php if (!isset($is_can_view) || $is_can_view){ ?>

    <?php if (empty($tabs)){ $tabs = $this->controller->getProfileMenu($profile); } ?>

	<?php if (count($tabs)>1){ ?>

		<?php $this->addMenuItems('profile_tabs', $tabs); ?>

		<div id="user_profile_tabs">
			<div class="tabs-menu">
				<?php $this->menu('profile_tabs', true, 'tabbed', $this->controller->options['max_tabs']); ?>
			</div>
		</div>

	<?php } ?>

<?php } ?>
