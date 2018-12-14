<?php

	function step($langs)
	{

		$result = [
			'html' => render('step_lang', [
				'langs' => $langs,
			]),
		];

		return $result;

	}
