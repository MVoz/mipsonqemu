<?php
/**
 * 名站导航
 *
 * @since 2009-7-13
 * @copyright http://www.114la.com
 */
!defined('PATH_ADMIN') && exit('Forbidden');

class ctl_collect_site
{
/**
 * 返回的消息
 * @var string
 */
    private static $message = '';

    public function index()
    {
        app_tpl::assign( 'npa', array('网址管理', '待录站点列表') );
        $this->collect_site_list();
    }

    /**
     * 名站导航
     * 显示列表
     */
    public function collect_site_list()
    {
        try
        {
            $data = mod_collect_site::collect_site_list();
            app_tpl::assign('data',$data);
        }
        catch (Exception $e)
        {
						;
        }
        $sys=array('goback'=>'?c=collect_site',   'subform'=>'?c=collect_site&a=collect_site_submit');
        app_tpl::assign('sys', $sys);
        app_tpl::display('collect_site_list.tpl');//更改模板
    }

    /**
     * 添加信息
     */
    public function famous_nav_add()
    {
        try
        {
            app_tpl::assign( 'npa', array('网址管理', '添加站点') );
            $step=(empty($_POST['step']))?'':$_POST['step'];
            if($step==2)//save  反向,为了测试

            {
                $data=$_POST;
                mod_collect_site::collect_site_add($data);
                mod_make_html::auto_update('index');
                mod_login::message("添加数据成功!",'?c=collect_site');
                exit;
            }
        }
        catch (Exception $e)
        {
            if($step==2)
            {
                app_tpl::assign('data', $_POST);
            }
            app_tpl::assign('error', $e->getMessage());
        }
        $sys=array('goback'=>'?c=famous_nav',   'subform'=>'?c=collect_site&a=collect_site_add');
        app_tpl::assign('sys', $sys);
        app_tpl::display('collect_site_add.tpl');//更改模板
    }

    /**
     * 删除信息
     */
    public function collect_site_delete()
    {
        $data=(!is_array($_POST['id']))?array():$_POST['id'];
        $data = mod_collect_site::collect_site_delete($data);
        mod_make_html::auto_update('index');
        mod_login::message("删除数据成功.",'?c=collect_site');
        exit;
    }
    
    /**
     * 保存信息
     */
    public function collect_site_save()
    {
        try
        {
            app_tpl::assign( 'npa', array('网址管理', '编辑名站') );
            $data=array();
            $step=(empty($_POST['step']))?'':$_POST['step'];
            if($step==2)//save
            {
                $data=$_POST;
                collect_site_nav::collect_site_save($data,'save');
                mod_make_html::auto_update('index');
                mod_login::message("修改数据成功!",'?c=collect_site');
                exit;
            }
            else//select

            {
                $data['id']=(empty($_GET['id']))?'':$_GET['id'];
                $data=mod_collect_site::collect_site_save($data,'select');
                mod_make_html::auto_update('index');
                app_tpl::assign('data',$data);
            }

        }
        catch (Exception $e)
        {
            $step=(empty($_POST['step']))?'':$_POST['step'];
            if($step==2)
            {
                app_tpl::assign('data', $_POST);
            }
            app_tpl::assign('error', $e->getMessage());
        }
        $sys=array('goback'=>'?c=collect_site',   'subform'=>'?c=collect_site&a=collect_site_save');
        app_tpl::assign('sys', $sys);
        app_tpl::display('collect_site_add.tpl');//更改模板
    }

    /**
     * 排序,删除
     */
    public function collect_site_submit()
    {
        try
        {
            $action=(empty($_POST['action']))?'':$_POST['action'];
            $step=(empty($_POST['step']))?'':$_POST['step'];
            if($action=='order')
            {
                $this->collect_site_order();
            }
            elseif($action=='delete')
            {
                $this->collect_site_delete();
            }
            elseif($step==2)
            {
                throw new Exception("没有您执行的动作");
            }
        }
        catch (Exception $e)
        {
            app_tpl::assign('error', $e->getMessage());
        }
        $this->collect_site_list();
    }
    /**
     * 排序信息
     */
    public function collect_site_order()
    {
            $data=(!is_array($_POST['orderby']))?array():$_POST['orderby'];
            $data = mod_collect_site::collect_site_order($data);
            mod_make_html::auto_update('index');
            mod_login::message("排序设置成功.",'?c=collect_site');
            exit;
    }




}
?>
