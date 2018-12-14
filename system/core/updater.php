<?php

class cmsUpdater {

    private $update_info_url = 'https://api.github.com/repos/icms2-dev/icms2-core/tags';
    private $cache_file = 'cache/update.dat';

    const UPDATE_CHECK_ERROR = 0;
    const UPDATE_DOWNLOAD_ERROR = 1;
    const UPDATE_NOT_AVAILABLE = 2;
    const UPDATE_AVAILABLE = 3;
    const UPDATE_SUCCESS = 4;

    public function __construct() {
        $this->cache_file = cmsConfig::get('root_path') . $this->cache_file;
    }

    public function checkUpdate($only_cached = false){

        $current_version = cmsCore::getVersionArray();

        $update_info = $this->getUpdateFileContents($only_cached);

        if (!$update_info) { return self::UPDATE_CHECK_ERROR; }

        list($next_version, $date, $url) = explode("\n", trim($update_info));

        if (version_compare($next_version, $current_version['version'], '<=')) {
            $this->deleteUpdateFile();
            return self::UPDATE_NOT_AVAILABLE;
        }

        return array(
            'current_version' => $current_version,
            'version'         => $next_version,
            'date'            => $date,
            'url'             => $url
        );

    }

    public function getUpdateFileContents($only_cached){

        if (file_exists($this->cache_file)){
            return file_get_contents($this->cache_file);
        } else if ($only_cached) {
            return false;
        }

        $tags = file_get_contents_from_url($this->update_info_url, 2, true);
	    if ($tags === false) { return false; }

        $commit = file_get_contents_from_url($tags[0]['commit']['url'], 2, true);
	    if ($commit === false) { return false; }

		$data = implode("\n",[
			'version'=>$tags[0]['name'],
			'date'=>$commit['commit']['author']['date'],
			'url'=>$tags[0]['zipball_url']
		]);

        file_put_contents($this->cache_file, $data);

        return $data;
    }

    public function deleteUpdateFile(){
        @unlink($this->cache_file);
    }

}
