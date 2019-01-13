# bash_database_history
save your bash history to mysql or sqlite

see bashrc_trap.sh

1) create databases you like (see `bashrc_trap.sh` for templates)
2) comment/uncomment what you need to use (mysql/sqlite3)
3) put bashrc_trap.sh to the bottom of your .bashrc
4) enjoy your upgraded history using some aliases

```
mysql> select count(command), cwd from bash.history group by cwd order by 1 desc limit 10
+----------------+--------------------------------------+
| count(command) | cwd                                  |
+----------------+--------------------------------------+
|            715 | /home/user                           |
|            393 | /home/user/b/chtest                  |
|            325 | /home/user/b/hubble                  |
|            319 | /home/user/b/dump-clickhouse         |
|            311 | /home/user/b/chtest/scripts          |
|            297 | /home/user/d/afd                     |
|            171 | /home/user/b/afonline                |
|            112 | /home/user/d/afd/src/rules/asn/build |
|             83 | /home/user/d                         |
|             81 | /home/user/temp                      |
+----------------+--------------------------------------+
10 rows in set (0.06 sec)


mysql> select count(command), date(created)  from bash.history group by command, date(created) order by 1 desc limit 20;
+----------------+---------------+
| count(command) | date(created) |
+----------------+---------------+
|             57 | 2018-11-14    |
|             51 | 2018-11-20    |
|             50 | 2018-12-04    |
|             47 | 2018-11-29    |
|             41 | 2018-11-26    |
|             35 | 2018-12-06    |
|             33 | 2018-11-11    |
|             33 | 2018-11-25    |

```
Some example aliases

```
@his(){
	limit=""
	command="select oid, created, command, cwd, tag from bash.history where command like '%$1%' "
	if [[ -z "$2" ]]
	then
		1=1
	else
		limit="order by created desc limit $2"
	fi;
	
	mysql -e "$command$limit"
	echo "run @ NUMBER to repeat command"
}

function hitag(){
	export HISTORY_TAG=$1
}

function hiuntag(){
	export HISTORY_TAG=''
}

# alias historyMysqlDel="mysql -e "use bash; truncate history""
```
