<?php

	function step($is_submit)
	{

		if ($is_submit) {
			return check_agree();
		}

		$license_text = file_get_contents(PATH . '/languages/' . LANG . '/license.txt');

		$result = [
			'html' => render('step_license', [
				'license_text' => $license_text,
			]),
		];

		return $result;

	}

	function check_agree()
	{

		$error = !isset($_POST['agree']);

		return [
			'error'   => $error,
			'message' => LANG_LICENSE_ERROR,
		];

	}
