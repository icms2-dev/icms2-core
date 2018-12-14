<?php

	function is_ajax_request()
	{
		if (!isset($_SERVER['HTTP_X_REQUESTED_WITH'])) {
			return false;
		}

		return $_SERVER['HTTP_X_REQUESTED_WITH'] == 'XMLHttpRequest';
	}

	function render($template_name, $data = [])
	{
		extract($data, EXTR_SKIP);
		ob_start();
		include PATH . '/templates/' . $template_name . '.php';

		return ob_get_clean();
	}

	function run_step($step, $is_submit = false)
	{
		require PATH . '/steps/' . $step['id'] . '.php';
		$result = step($is_submit);

		return $result;
	}

	function is_config_exists()
	{
		return is_readable(PATH_ROOT . '/system/config/config.php');
	}

	function get_site_config()
	{

		static $cfg = null;

		if ($cfg !== null) {
			return $cfg;
		}

		$cfg_file = PATH_ROOT . '/system/config/config.php';

		if (!is_readable($cfg_file)) {
			return false;
		}

		$cfg = include $cfg_file;

		return $cfg;

	}

	function is_db_connected()
	{
		$cfg = get_site_config();

		if ($cfg) {

			$mysqli = @new mysqli($cfg['db_host'], $cfg['db_user'], $cfg['db_pass'], $cfg['db_base']);

			if (!$mysqli->connect_error) {
				return true;
			}
		}

		return false;
	}

	function get_db_list()
	{
		$cfg = get_site_config();

		if ($cfg) {

			$mysqli = @new mysqli($cfg['db_host'], $cfg['db_user'], $cfg['db_pass'], $cfg['db_base']);

			if (!$mysqli->connect_error) {

				$r = $mysqli->query('SHOW DATABASES');
				if (!$r) {
					return false;
				}

				$list = [];

				while ($data = $r->fetch_assoc()) {
					if (in_array($data['Database'], ['information_schema', 'mysql', 'performance_schema', 'phpmyadmin', 'sys'])) {
						continue;
					}
					$list[$data['Database']] = $data['Database'];
				}

				return $list;

			}
		}

		return false;
	}

	function get_version($show_date = false)
	{

		$file = PATH_ROOT . '/system/config/version.ini';

		if (!function_exists('parse_ini_file') || !is_readable($file)) {
			return '';
		}

		$version = parse_ini_file($file);

		if (!$show_date && isset($version['date'])) {
			unset($version['date']);
		}

		$type = isset($version['type']) ? '-' . $version['type'] : '';

		unset($version['type']);

		return implode('.', $version) . $type;

	}

	function html_bool_span($value, $condition)
	{
		$html = '<span class="positive">' . $value . '</span>';

		if (!$condition) {
			$html = '<span class="negative">' . $value . '</span>';
		}

		return $html;
	}

	function get_langs()
	{

		$dir         = PATH . '/languages';
		$dir_context = opendir($dir);

		$list = [];

		while ($next = readdir($dir_context)) {

			if (in_array($next, ['.', '..'])) {
				continue;
			}
			if (strpos($next, '.') === 0) {
				continue;
			}
			if (!is_dir($dir . '/' . $next)) {
				continue;
			}

			$list[] = $next;

		}

		return $list;

	}

	function copy_folder($dir_source, $dir_target)
	{

		if (is_dir($dir_source)) {

			@mkdir($dir_target);
			$d = dir($dir_source);

			while (false !== ($entry = $d->read())) {
				if ($entry == '.' || $entry == '..') {
					continue;
				}
				copy_folder("$dir_source/$entry", "$dir_target/$entry");
			}

			$d->close();

		} else {
			@copy($dir_source, $dir_target);
		}

	}

	function execute_command($command, $postfix = ' 2>&1')
	{
		if (!function_exists('exec')) {
			return false;
		}
		$buffer = [];
		$err    = '';
		$result = exec($command . $postfix, $buffer, $err);
		if ($err !== 127) {
			if (!isset($buffer[0])) {
				$buffer[0] = $result;
			}
			// проверяем, что команда такая есть
			$b = mb_strtolower($buffer[0]);
			if (mb_strstr($b, 'error') || mb_strstr($b, ' no ') || mb_strstr($b, 'not found') || mb_strstr($b, 'No such file or directory')) {
				return false;
			}
		} else {
			// команда не найдена
			return false;
		}

		return $buffer;
	}

	function get_program_path($program)
	{
		if (stripos(PHP_OS, 'WIN') === 0) {
			//$which = 'where';
			return false;
		} else {
			$which = '/usr/bin/which';
		}
		$data = execute_command($which . ' ' . $program);
		if (!$data) {
			return false;
		}

		return !empty($data[0]) ? $data[0] : false;
	}
