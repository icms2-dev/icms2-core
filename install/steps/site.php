<?php

	function step($is_submit)
	{

		if ($is_submit) {
			return check_data();
		}

		$result = [
			'html' => render('step_site', []),
		];

		return $result;

	}

	function check_data()
	{

		$sitename         = trim($_POST['sitename']);
		$hometitle        = trim($_POST['hometitle']);
		$metakeys         = trim($_POST['metakeys']);
		$metadesc         = trim($_POST['metadesc']);
		$is_check_updates = (int) (isset($_POST['is_check_updates']) ?: 0);

		if (!$sitename) {
			return [
				'error'   => true,
				'message' => LANG_SITE_SITENAME_ERROR,
			];
		}

		if (!$hometitle) {
			return [
				'error'   => true,
				'message' => LANG_SITE_HOMETITLE_ERROR,
			];
		}

		$_SESSION['install']['site'] = [
			'sitename'         => $sitename,
			'hometitle'        => $hometitle,
			'metakeys'         => $metakeys,
			'metadesc'         => $metadesc,
			'is_check_updates' => $is_check_updates,
		];

		return [
			'error' => false,
		];

	}
