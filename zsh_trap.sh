#!/usr/bin/env bash
# catches original bash, writes them to mysql or sqlite3 file
# place it to the end of ~/.bashrc
# need to find original author of preexec_invoke_exec, google it :)
# 

#-------------------------------------------------------------------
# MYSQL EXAMPLE
#-------------------------------------------------------------------
# create database if not exists bash ;
# use bash ;
# -- drop table `history`;
# CREATE TABLE `history` (
#   `oid` bigint(20) NOT NULL AUTO_INCREMENT,
#   `command` TEXT,
#   `arguments` TEXT,
#   `cwd` TEXT,
#   `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
#   `tag` TEXT,
#   PRIMARY KEY (`oid`),
#   KEY `created` (`created`)
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ;


#-------------------------------------------------------------------
# SQLITE EXAMPLE
#-------------------------------------------------------------------
# sqlite3 ~/.bashdb.sqlite3
## type:
#    CREATE TABLE history (
#     oid INTEGER PRIMARY KEY,
#     command TEXT NOT NULL,
#     arguments TEXT NOT NULL,
#     cwd text NOT NULL,
#     tag text NOT NULL,
#     created  DATETIME DEFAULT (datetime('now','localtime'))
#    );


preexec () {
  # leaving this var name as is, so code for bash/zsh don't diverge too much
    BASH_COMMAND=$1
    if [[ -z "$HISTORY_TAG" ]]
    then
        HISTORY_TAG=''
    else
        echo TAG: $HISTORY_TAG
    fi;

    [ -n "$COMP_LINE" ] && return  # do nothing if completing
    #[ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return # don't cause a preexec for $PROMPT_COMMAND

    # get CURRENT command
    local this_command=`echo $1| sed -e "s/^[ ]*[0-9]*[ ]*//g"`;
    cwd=$(pwd)
    #optional: ignore alias for mysql history search
    [[ "$BASH_COMMAND" =~ historyMysql* ]] && return
    #optional: ignore pyenv
    [[ "$BASH_COMMAND" =~ _pyenv_virtualenv_hook* ]] && return

    # place ESCAPED $BASH_COMMAND into $BASH_COMMAND_ESCAPE variable
    printf -v BASH_COMMAND_ESCAPE "%q" "$BASH_COMMAND" # from https://stackoverflow.com/a/4383994/5006740

    # here we trap and WRITE:
    (mysql -e "INSERT INTO bash.history (oid, command, arguments, cwd, created, tag) values (0, '${BASH_COMMAND_ESCAPE}', '', '$cwd', NOW(), '$HISTORY_TAG' )")
    # (sqlite3 ~/.bashdb.sqlite3 "INSERT INTO history (command, arguments, cwd, tag) values ( '${BASH_COMMAND_ESCAPE}', '', '$cwd', '')")

    #preexec "$this_command"
}
