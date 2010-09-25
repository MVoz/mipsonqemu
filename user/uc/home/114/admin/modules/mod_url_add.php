<?php
/**
 * 网站收录
 *
 * @since 2009-7-13
 * @copyright http://www.114la.com
 */
!defined('PATH_ADMIN') &&exit('Forbidden');
class mod_url_add
{
	/**
	 * 返回列表
	 *
	 * @param int $type
	 * @param int $start[optional]
	 * @param int $page_rows[optional]
	 * @return array
	 */
	public static function get_list($type, $start = 0, $num = 0)
	{
		$limit = '';
		if ($start > -1 && $num > 0)
		{
			$limit = " LIMIT {$start}, {$num}";
		}
		if ($type == -1)
		{
		    $data = app_db::select('ylmf_urladd', 'SQL_CALC_FOUND_ROWS *', "1 {$limit}");
		}
		else
		{
		    $data = app_db::select('ylmf_urladd', 'SQL_CALC_FOUND_ROWS *', "`type` = {$type}{$limit}");
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
		foreach ($output['data'] as &$row)
		{
		    $tmp = unserialize($row['info']);
		    $row = array_merge($row, $tmp);
		    unset($row['info']);
		}
		return $output;
	}


	/**
	 * 获取一条记录
	 *
	 * @param int $id
	 * @return array
	 */
	public static function get_one($id)
	{
		$id = (int)$id;
		if ($id < 1)
		{
			return false;
		}

		$data = app_db::select('ylmf_urladd', '*', "id = {$id}");
		if (empty($data))
		{
		    return false;
		}
		$data = array_merge($data[0], unserialize($data[0]['info']));
		unset($data['info']);
		return $data;
	}


	/**
	 * 获取处于某一种状态的记录数量，0: 未审核，1: 通过审核，2: 未通过审核
	 *
	 * @param int $type
	 */
	public static function get_total($type = 0)
	{
	    $type = (int)$type;
	    if ($type < 0 || $type > 2)
	    {
	        return false;
	    }

        return app_db::get_rows_num('ylmf_urladd',  "`type` = {$type}");
	}
	/**
	 * 获取一个站点的信息
	 */
	public static function get_one_link($id)
	{
		if ($id < 1)
		{
			return false;
		}
		$id = (int)$id;

		$data = app_db::select('ylmf_link', '*', "linkid = {$id}");

		return (empty($data)) ? false : $data[0];
	}
	public static function get_one_site($id)
	{
		if ($id < 1)
		{
			return false;
		}
		$id = (int)$id;

		$data = app_db::select('ylmf_site', '*', "id = {$id}");
		return (empty($data)) ? false : $data[0];
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
		 $result = self::get_one_site($id);
	
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
			 app_db::query("UPDATE ylmf_sitetag SET totalnum=totalnum-1 WHERE tagid IN (".simplode(array_keys($need_delete_tags)).")");
		}
		//获取现在有二old_tag没有的
		 $need_add_tags =   array_diff($now_tag,$intersect_tag);
		 
		 if(empty($need_add_tags))
			 return  $tagarr;
		//记录已存在的tag
		$vtags = array();
		
		$sql = "SELECT tagid, tagname, close FROM ylmf_sitetag WHERE tagname IN (".simplode($need_add_tags).")";
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
					'taghash' => qhash($tagname),
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
		if($updatetagids) app_db::query("UPDATE ylmf_sitetag SET totalnum=totalnum+1 WHERE tagid IN (".simplode($updatetagids).")");
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