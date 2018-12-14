<?php

	function step($is_submit)
	{

		$result = [
			'html' => render('step_start', [
				'lang'  => LANG,
			]),
		];

		return $result;

	}
