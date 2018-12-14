<?php

	function step($is_submit)
	{

		$info = check_requirements();

		$result = [
			'html' => render('step_php', [
				'info' => $info,
			]),
		];

		return $result;

	}

	function check_requirements()
	{

		$min_php_version  = '5.6.0';
		$func             = ['parse_ini_file'];
		$vars             = ['magic_quotes_gpc' => 0, 'register_globals' => 0];
		$extensions       = ['date', 'gd', 'json', 'mbstring', 'mysqli', 'session', 'filter', 'fileinfo'];
		$extensions_extra = ['ftp', 'memcache', 'zip', 'curl'];

		sort($extensions);
		sort($extensions_extra);

		$info = [];

		$info['valid'] = true;

		$info['php'] = [
			'version' => implode('.', [PHP_MAJOR_VERSION, PHP_MINOR_VERSION, PHP_RELEASE_VERSION]),
			'valid'   => version_compare(PHP_VERSION, $min_php_version) >= 0,
		];

		$info['valid'] = $info['valid'] && $info['php']['valid'];

		foreach ($vars as $var => $req) {
			$set                = ini_get($var);
			$info['vars'][$var] = [
				'req' => $req,
				'set' => $set,
			];
			$info['valid']      = $info['valid'] && ($req == $set);
		}

		foreach ($func as $f) {
			$info['vars'][$f] = [
				'req' => true,
				'set' => function_exists($f),
			];

			$info['valid'] = $info['valid'] && ($req == $set);
		}

		foreach ($extensions as $ext) {
			$loaded            = extension_loaded($ext);
			$info['ext'][$ext] = $loaded;
			$info['valid']     = $info['valid'] && $loaded;
		}

		foreach ($extensions_extra as $ext) {
			$info['ext_extra'][$ext] = extension_loaded($ext);
		}

		return $info;

	}
