<?php
/**
 * 网站管理类
 *
 * @copyright http://www.114la.com
 * @version    $Id: mod_site_manage.php 1541 2009-12-11 07:54:41Z syh $
 */
!defined('PATH_ADMIN') &&exit('Forbidden');
class mod_collect_site
{
	/**
	 * 返回搜索结果
	 *
	 * @param string $keyword
	 * @param string $search_type
	 * @param int $start[optional]
	 * @param int $num[optional]
	 * @return array
	 */
	public static function search($keyword, $search_type, $start = 0, $num = 0)
	{
		if ($search_type != 'url' && $search_type != 'name')
		{
			return false;
		}

		$condition = " AND a.`{$search_type}` LIKE '%{$keyword}%'";
		if ($start > -1 && $num > 0)
		{
			$condition .= " LIMIT {$start}, {$num}";
		}

	    $sql = 'SELECT SQL_CALC_FOUND_ROWS a.id, b.classid AS class_id, b.classname AS class_name, a.name, a.url, a.displayorder,
                       a.gooddisplayorder, a.starttime, a.endtime, a.namecolor, a.adduser, a.good
                FROM ylmf_site AS a, ylmf_siteclass AS b
                WHERE a.class = b.classid ' . $condition;
		$query = app_db::query($sql);


		$data = array();
		while ($rt = app_db::fetch_one($query))
		{
		    $data[] = $rt;
		}
		if (empty($data))
		{
			return false;
		}
		/*
		$data = app_db::select('ylmf_site', 'SQL_CALC_FOUND_ROWS *', $contition);
		if (empty($data))
		{
			return false;
		}*/

		$output = array();
		$total = app_db::query('SELECT FOUND_ROWS() AS rows');
		$total = app_db::fetch_one();
		$output['total'] = $total['rows'];
		$output['data'] = $data;
		return $output;
	}


	/**
	 * 获取列表
	 *
	 * @param int $class_id
	 * @param int $isend
	 * @param int $start[optional]
	 * @param int $num[optional]
	 * @return array
	 */
	public static function get_list($class_id = 0, $isend = false, $start = 0, $num = 20)
	{
		$condition = '';

		$cache_main_class = mod_class::get_class_list();
		/*
		// 分类
		if ($class_id > 0)
		{
			if ($cache_main_class[$class_id]['parentid'] == 0)
			{
				$tmp = '';
				foreach ($cache_main_class as $key => $val)
				{
					if (!empty($cache_main_class[$val['parentid']]) && $cache_main_class[$val['parentid']]['parentid'] == $class_id)
					{
						$tmp .= $key . ',';
					}
				}
				if ($tmp != '')
				{
					$tmp = substr($tmp, 0, -1);
					$condition .= (!empty($condition)) ? " AND `class` IN({$tmp})" :
														" AND `class` IN({$tmp})";
				}
			}
			//2级分类
			elseif ($cache_main_class[$cache_main_class[$class_id]['parentid']]['parentid'] == 0)
			{
				$tmp = '';
				foreach ($cache_main_class as $key => $val)
				{
					if ($val['parentid'] == $class_id)
					{
						$tmp .= $key . ',';
					}
				}
				if ($tmp != '')
				{
					$tmp = substr($tmp, 0, -1);
					$condition .= (!empty($condition)) ? " AND `class` IN({$tmp})" :
														" AND `class` IN({$tmp})";
				}
			}
			//3级分类
			else
			{
				$condition .= (!empty($condition)) ? " AND `class` = {$class_id}" :
													" AND `class` = {$class_id}";
			}
		}

		// 过期
		if ($isend)
		{
			$condition .= (!empty($condition)) ? ' AND `endtime` > 0 AND `endtime` < ' . time() :
												 ' AND `endtime` > 0 AND `endtime` < ' . time();
		}
		*/
		$condition .= ' ORDER BY link_dateline DESC';
		if ($start > -1 && $num > 0)
		{
			$condition .= " LIMIT {$start}, {$num}";
		}

	    $sql = 'SELECT SQL_CALC_FOUND_ROWS a.linkid AS id,  a.link_subject as name, a.url, 
                       a.link_dateline as time, a.username as adduser
                FROM ylmf_link AS a WHERE a.siteid=0 ' . $condition;
		$query = app_db::query($sql);

		$data = array();
		while ($rt = app_db::fetch_one())
		{
			if(!preg_match("/^https?:\/\/[a-zA-Z0-9~`!@#$%^&*()_+|\\{}[\]:;<?,-.=']+$/", $rt['url'])) continue;
		    $data[] = $rt;
		}
		if (empty($data))
		{
			return false;
		}

		$output = array();
		$total = app_db::query('SELECT FOUND_ROWS() AS rows');
		$total = app_db::fetch_one();
		$output['total'] = $total['rows'];
		$output['data'] = $data;
		return $output;
	}


	/**
	 * 获取一个站点的信息
	 */
	public static function get_one($id)
	{
		if ($id < 1)
		{
			return false;
		}
		$id = (int)$id;

		$data = app_db::select('ylmf_link', '*', "linkid = {$id}");

		return (empty($data)) ? false : $data[0];
	}


	/**
	 * 检查网站是否已存在
	 *
	 * @param int $class_id
	 * @param int $site 网站名或 URL
	 */
	public static function check_exists($class_id, $site)
	{
		$class_id = (int)$class_id;
		$data = app_db::select('ylmf_site', 'id', "`class` = {$class_id} AND (`name` = '{$site}' OR url = '{$site}')");
		return (empty($data)) ? false : true;
	}


	/**
	 * 删除分类的所有网站
	 *
	 * @param int $class_id 分类ID
	 */
	public static function delete_by_class($class_id)
	{
		$class_id = (int)$class_id;
		if ($class_id < 1)
		{
			return false;
		}

		return app_db::delete('ylmf_site', "class = {$class_id}");
	}


	/**
	 * 批量添加网站
	 *
	 * @param array $sites 网址数组
	 */
	public static function multi_add($sites)
	{
        if(is_array($sites) && !empty($sites))
        {
            $class = intval($sites['classid']);
            if(!empty($sites['sites']))
            {
                foreach($sites['sites'] as $site)
                {
                    $name = htmlspecialchars(trim($site['name']));
                    $url = htmlspecialchars(trim($site['url']));
                    if(empty($name) || empty($url))
                    {
                        continue;
                    }
                    $remark = htmlspecialchars(trim($site['remark']));
                    app_db::query("INSERT INTO `ylmf_site` ( `name` , `url` , `class` , `remark` ) VALUES ( '$name', '$url', '$class', '$remark')");
                }
            }
        }
	}

    /**
	 * 批量导入网站
	 *
	 * @param array $data 网址数组
	 */
	public static function import($data)
	{
        $sites['classid'] = $data['classid'];
        //解析字符串
        preg_match_all("/<a.*?href=.?[\'\"](.*?).?[\'\"].*?>(.*?)<\/a>/is", $data['sites'], $result);
        foreach($result[2] as $i => $name)
        {
            $name = trim(strip_tags($name));
            $url = $result[1][$i];
            if(empty($name) || empty($url))
            {
                unset($result[1][$i]);
                unset($result[2][$i]);
                continue;
            }
            $sites['sites'][] = array('name' => $name, 'url' => $url, 'remark' => '');
        }
        self::multi_add($sites);
	}
	public static function simplode($ids) {
		return "'".implode("','", $ids)."'";
	}
	public static function getUnicodeFromOneUTF8($word) {   
	  if (is_array( $word))   
		$arr = $word;   
	  else     
		$arr = str_split($word);    
	  $bin_str = '';   
	  foreach ($arr as $value)   
		$bin_str .= decbin(ord($value));   
	  $bin_str = preg_replace('/^.{4}(.{4}).{2}(.{6}).{2}(.{6})$/','$1$2$3', $bin_str);   
	  return bindec($bin_str); 
	}
	public static function mbStringToArray ($string) {
		$strlen = mb_strlen($string);
		while ($strlen) {
			$array[] = mb_substr($string,0,1,"UTF-8");
			$string = mb_substr($string,1,$strlen,"UTF-8");
			$strlen = mb_strlen($string);
		}
		return $array;
	}
	public static function _qhash($p, $n)
	{
		$h = 0;
		$g;
		  $i=0;
		while ($n--) {
			$h = (($h) << 4) + self::getUnicodeFromOneUTF8($p[$i]);
			if (($g = ($h & 0xf0000000)) != 0)
				$h ^= $g >> 23;
			$h &= ~$g;
					$i++;
		}
		return $h;
	}

	public static function qhash($str){
	  $t=self::mbStringToArray($str);
	  return self::_qhash($t,count($t));
	}
	/**
		process tag
	**/
	public static function batch_tag($id,$tags)
	{
		$mtime = explode(' ', microtime());
		$timesec = $mtime[1];
		$tagarr = array();
		$now_tag = empty($tags)?array():array_unique(explode(' ', $tags));
		
		//if(empty($now_tag)) return $tagarr;
		//获取原来的tags
		 $result = self::get_one($id);
	
         if (empty($result))
         {
              throw new Exception('没有找到数据', 10);
         }
		
		 //修正tag显示
		 $old_tags = empty($result['tag'])?array():unserialize($result['tag']);
		
		 $need_delete_tags=array();
		 $need_add_tags=array();
		 $tagarr = $intersect_tag = array_intersect($old_tags,$now_tag);
		//获取old_tag有而现在没有的			
		 $need_delete_tags = array_diff($old_tags,$intersect_tag);
		//清除tag
		if(!empty($need_delete_tags)) {
			  foreach($need_delete_tags as $k=>$v){
				 app_db::query("DELETE  from ylmf_sitetagsite WHERE siteid=".$id.' AND tagid='.$k);			
			  }	  
			 app_db::query("UPDATE ylmf_sitetag SET totalnum=totalnum-1 WHERE tagid IN (".self::simplode(array_keys($need_delete_tags)).")");
		}
		//获取现在有二old_tag没有的
		 $need_add_tags =   array_diff($now_tag,$intersect_tag);
		 
		 if(empty($need_add_tags))
			 return  $tagarr;
		//记录已存在的tag
		$vtags = array();
		
		$sql = "SELECT tagid, tagname, close FROM ylmf_sitetag WHERE tagname IN (".self::simplode($need_add_tags).")";
		$query = app_db::query($sql);
	
		while ($rt = app_db::fetch_one())
		{
			$rt['tagname'] = addslashes($rt['tagname']);
		    $vkey = md5($rt['tagname']);
			$vtags[$vkey] = $rt;
		}

		
		$updatetagids = array();
		foreach ($need_add_tags as $tagname) {
			if(!preg_match('/^([\x7f-\xff_-]|\w){3,20}$/', $tagname)) continue;
			
			$vkey = md5($tagname);
			if(empty($vtags[$vkey])) {
				$setarr = array(
					'tagname' => $tagname,
					'taghash' => self::qhash($tagname),
					'dateline' => $timesec,
					'totalnum' => 1
				);
				if (app_db::insert('ylmf_sitetag', array_keys($setarr), array_values($setarr)))
				{
					
					$tagid = @mysql_result(app_db::query("SELECT last_insert_id()"), 0);
					$tagarr[$tagid] = $tagname;
				}
			} else {
				if(empty($vtags[$vkey]['close'])) {
					$tagid = $vtags[$vkey]['tagid'];
					$updatetagids[] = $tagid;
					$tagarr[$tagid] = $tagname;
				}
			}
		}
		if($updatetagids) app_db::query("UPDATE ylmf_sitetag SET totalnum=totalnum+1 WHERE tagid IN (".self::simplode($updatetagids).")");
		$tagids = array_keys($tagarr);
		$inserts = array();
		foreach ($tagids as $tagid) {
			$inserts[] = "('$tagid','$id')";
		}
		if($inserts) app_db::query("REPLACE INTO ylmf_sitetagsite (tagid,siteid) VALUES ".implode(',', $inserts));

		return $tagarr;
		
	}
}
?>
