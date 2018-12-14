<?php
    $config = cmsConfig::getInstance();
?>
<!DOCTYPE html>
<html>
<head>
	<title><?php echo ERR_SITE_OFFLINE; ?> &mdash; <?php echo $config->sitename; ?></title>
	<?php $this->addMainTplCSSName('theme-errors'); ?>
	<?php $this->addMainTplCSSName('theme-modal'); ?>
	<?php $this->addMainTplCSSName('theme-gui'); ?>
	<?php $this->addMainTplCSSName('theme-text'); ?>
	<?php $this->addMainTplJSName('jquery'); ?>
	<?php $this->addMainTplJSName('jquery-modal'); ?>
	<?php $this->addMainTplJSName('core'); ?>
	<?php $this->addMainTplJSName('modal'); ?>
	<?php $this->head(false); ?>
</head>
<body>

    <?php
    $messages = cmsUser::getSessionMessages();
    if ($messages){ ?>
        <div class="sess_messages">
            <?php foreach($messages as $message){ ?>
                <div class="<?php echo $message['class']; ?>"><?php echo $message['text']; ?></div>
             <?php } ?>
        </div>
    <?php } ?>

    <div id="error-maintenance">
        <h1><?php echo ERR_SITE_OFFLINE; ?></h1>
        <?php if ($reason) { ?>
            <p><?php echo $reason; ?></p>
        <?php } ?>
    </div>

    <div id="error-maintenance-footer">
        <span>
            <a class="ajaxlink ajax-modal" href="<?php echo href_to('auth', 'login'); ?>"><?php echo LANG_LOGIN_ADMIN; ?></a>
        </span>
    </div>

</body>
