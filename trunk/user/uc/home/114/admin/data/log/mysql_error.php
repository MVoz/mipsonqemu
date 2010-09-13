<?die;?>||/114/admin/index.php?c=login&amp;a=login|SELECT yl_value FROM `uchome_config` WHERE yl_name = 'yl_path_html'|1054Unknown column 'yl_value' in 'field list'|1283741755|192.168.115.1|Array|
<?die;?>|1|/114/admin/index.php?c=config&amp;a=info|select yl_value from `uchome_config` where `yl_name` = 'yl_sysname'|1054Unknown column 'yl_value' in 'field list'|1283742402|192.168.115.1|NO_POSTDATA|
<?die;?>|1|/114/admin/index.php?c=class&amp;a=index&amp;type=2|SELECT * FROM `uchome_class` WHERE 1 ORDER BY displayorder|1054Unknown column 'displayorder' in 'order clause'|1283742495|192.168.115.1|NO_POSTDATA|
<?die;?>|1|/114/admin/index.php?c=make_html&amp;action=make|SELECT p.`classname` AS p_classname,
                                             s.`classid` AS s_classid, s.`classname` AS s_classname, s.`path` AS s_path
                                      FROM ylmfsite_class AS p
                                      INNER JOIN ylmfsite_class AS s ON s.parentid = p.classid
                                      WHERE p.parentid = 0
                                      ORDER BY p.displayorder, p.classid, s.displayorder|1146Table 'uc_db.ylmfsite_class' doesn't exist|1283747920|192.168.115.1|Array|
<?die;?>|1|/114/admin/index.php?c=famous_site|SELECT SQL_CALC_FOUND_ROWS a.id, b.classid, b.classname, a.name, a.url, a.displayorder,
                       a.good, a.starttime, a.endtime, a.namecolor
                FROM uchome_mingzhan AS a, uchome_linktoolbartype AS b
                WHERE  a.classid = b.class  ORDER BY b.displayorder, a.displayorder LIMIT 0, 20|1054Unknown column 'a.good' in 'field list'|1283751864|192.168.115.1|NO_POSTDATA|
<?die;?>|1|/114/admin/index.php?c=famous_site|SELECT SQL_CALC_FOUND_ROWS a.id, b.classid, b.classname, a.name, a.url, a.displayorder,
                       a.good, a.starttime, a.endtime, a.namecolor
                FROM uchome_mingzhan AS a, uchome_linktoolbartype AS b
                WHERE  a.classid = b.class  ORDER BY b.displayorder, a.displayorder LIMIT 0, 20|1054Unknown column 'a.good' in 'field list'|1283751865|192.168.115.1|NO_POSTDATA|
<?die;?>|1|/114/admin/index.php?c=famous_site|SELECT SQL_CALC_FOUND_ROWS a.id, b.classid, b.classname, a.name, a.url, a.displayorder,
                       a.good, a.starttime, a.endtime, a.namecolor
                FROM uchome_mingzhan AS a, uchome_linktoolbartype AS b
                WHERE  a.classid = b.classid  ORDER BY b.displayorder, a.displayorder LIMIT 0, 20|1054Unknown column 'a.good' in 'field list'|1283751942|192.168.115.1|NO_POSTDATA|
<?die;?>|1|/114/admin/index.php?c=famous_site|SELECT SQL_CALC_FOUND_ROWS a.id, b.classid, b.classname, a.name, a.url, a.displayorder,
                       a.good, a.starttime, a.endtime, a.namecolor
                FROM uchome_mingzhan AS a, uchome_linktoolbartype AS b
                WHERE  a.classid = b.classid  ORDER BY b.displayorder, a.displayorder LIMIT 0, 20|1054Unknown column 'a.good' in 'field list'|1283751943|192.168.115.1|NO_POSTDATA|
<?die;?>|1|/114/admin/index.php?c=famous_site|SELECT SQL_CALC_FOUND_ROWS a.id, b.classid, b.classname, a.name, a.url, a.displayorder,
                       a.good, a.starttime, a.endtime, a.namecolor
                FROM uchome_mingzhan AS a, uchome_linktoolbartype AS b
                WHERE  a.classid = b.classid  ORDER BY b.displayorder, a.displayorder LIMIT 0, 20|1054Unknown column 'a.good' in 'field list'|1283751944|192.168.115.1|NO_POSTDATA|
<?die;?>|1|/114/admin/index.php?c=famous_site|SELECT SQL_CALC_FOUND_ROWS a.id, b.classid, b.classname, a.name, a.url, a.displayorder,
                       a.good, a.starttime, a.endtime, a.namecolor
                FROM uchome_mingzhan AS a, uchome_linktoolbartype AS b
                WHERE  a.classid = b.classid  ORDER BY b.displayorder, a.displayorder LIMIT 0, 20|1054Unknown column 'a.good' in 'field list'|1283751945|192.168.115.1|NO_POSTDATA|
<?die;?>|1|/114/admin/index.php?c=famous_site&amp;classid=1|SELECT SQL_CALC_FOUND_ROWS a.id, b.classid, b.classname, a.name, a.url, a.displayorder,
                       a.good, a.starttime, a.endtime, a.namecolor
                FROM uchome_mingzhan AS a, uchome_linktoolbartype AS b
                WHERE  a.classid = b.classid  AND `class` = 1 ORDER BY b.displayorder, a.displayorder LIMIT 0, 20|1054Unknown column 'class' in 'where clause'|1283752449|192.168.115.1|NO_POSTDATA|
<?die;?>|1|/114/admin/index.php?c=famous_site&amp;classid=1|SELECT SQL_CALC_FOUND_ROWS a.id, b.classid, b.classname, a.name, a.url, a.displayorder,
                       a.good, a.starttime, a.endtime, a.namecolor
                FROM uchome_mingzhan AS a, uchome_linktoolbartype AS b
                WHERE  a.classid = b.classid  AND `class` = 1 ORDER BY b.displayorder, a.displayorder LIMIT 0, 20|1054Unknown column 'class' in 'where clause'|1283752591|192.168.115.1|NO_POSTDATA|
<?die;?>|1|/114/admin/index.php?c=famous_site&amp;classid=1|SELECT SQL_CALC_FOUND_ROWS a.id, b.classid, b.classname, a.name, a.url, a.displayorder,
                       a.good, a.starttime, a.endtime, a.namecolor
                FROM uchome_mingzhan AS a, uchome_linktoolbartype AS b
                WHERE  a.classid = b.classid  AND `class` = 1 ORDER BY b.displayorder, a.displayorder LIMIT 0, 20|1054Unknown column 'class' in 'where clause'|1283752596|192.168.115.1|NO_POSTDATA|
<?die;?>|1|/114/admin/index.php?c=collect_site&amp;a=collect_site_save&amp;id=5|SELECT * FROM uchome_link WHERE id='5'|1054Unknown column 'id' in 'where clause'|1284347457|192.168.115.1|NO_POSTDATA|
<?die;?>|1|/114/admin/index.php?c=collect_site&amp;a=collect_site_save&amp;id=5|SELECT * FROM uchome_link WHERE id='5'|1054Unknown column 'id' in 'where clause'|1284347636|192.168.115.1|NO_POSTDATA|
