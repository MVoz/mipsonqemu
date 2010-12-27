<?php
/**
 * 网站收录
 *
 * @since 2009-7-13
 * @copyright http://www.114la.com
 */
!defined('PATH_ADMIN') && exit('Forbidden');

class ctl_site_report
{
    /**
     * 列表
     *
     * @return void
     */
    public static function index()
    {
        try
        {
            app_tpl::assign( 'npa', array('管理首页', '查看举报情况') );
            $type = (isset($_GET['type'])) ? (int)$_GET['type'] : -1;

            $start = (empty($_GET['start'])) ? 0 : (int)$_GET['start'];
            $result = mod_site_report::get_list($type, $start, PAGE_ROWS);

            if (!empty($result))
            {
                app_tpl::assign('page_url', "?c=site_report");
                app_tpl::assign('pages', mod_pager::get_page_number_list($result['total'], $start, PAGE_ROWS));

                app_tpl::assign('list', $result['data']);
                app_tpl::assign('referer', $_SERVER['REQUEST_URI']);
            }
        }
        catch (Exception $e)
        {

        }
        app_tpl::display('site_report_list.tpl');
    }


	/**
     * 显示单条记录
     *
     * @return void
     */
    public static function show()
    {
        try
        {
            app_tpl::assign( 'npa', array('管理首页', '收录管理') );
            $id = (empty($_GET['id']))  ? 0 : (int)$_GET['id'];
            if ($id < 1)
            {
                throw new Exception('操作失败', 10);
            }

            $result = mod_site_report::get_one($id);
            if (empty($result))
            {
                throw new Exception('操作失败', 10);
            }

            app_tpl::assign('data', $result);
            app_tpl::assign('back', (empty($_SERVER['HTTP_REFERER'])) ? '?c=site_report' : $_SERVER['HTTP_REFERER']);
            unset($result);

            app_tpl::assign( 'class_list', mod_class::get_subclass_list(0));
        }
        catch (Exception $e)
        {
            mod_login::message($e->getMessage(), '?a=site_report');
        }
        app_tpl::display('url_add_show.tpl');
    }


    /**
	 * 没有经过审核
	 *
	 * @return void
     */
    public static function delete()
    {
        try
        {
            if (!empty($_POST['delete']))
            {
                $condition = '';
                foreach ($_POST['delete'] as $key => $val)
                {
                    $condition .= (empty($condition)) ? $key : ", {$key}";
                }
                if (!empty($condition))
                {
                    app_db::delete('ylmf_urladd', "id IN ({$condition})");
                    mod_login::message('删除成功', (empty($_POST['referer'])) ? '?c=url_add' : $_POST['referer']);
                }
            }
            else
            {
                mod_login::message('请选择需要删除的行', (empty($_POST['referer'])) ? '?c=url_add' : $_POST['referer']);
            }
        }
        catch (Exception $e)
        {

        }
    } 
}
?>
