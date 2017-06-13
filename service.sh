#!/bin/sh

PATH=/sbin:/usr/sbin:/bin:/usr/bin

###########################################################################################################################
#  变量说明 以下的5个变量需要针对不同的程序做修改
#  NAME   可执行二进制文件名，注意只是文件名不是路径
#  DAEMON 可执行文件的绝对路径,或者相对路径，但是相对路径需要指定CHDIR
#  DESC   应用名全称，这个全称将出现在启动日志当中
#  USER   你想以哪个用户的身份运行该二进制程序 例如使用 root 用户则 USER=root 但是注意尽量不要这样做。
#  	以root身份执行一个对外提供web服务的软件是危险的，因为一旦该软件出现漏洞，黑客可以很容易的获取到root权限
#  	较为合适的办法是建立一个用户，以非特权用户的身份运行该软件，即使出现漏洞黑客也只能获取到该用户的权限。
#  GROUP 你想以哪个用户组运行该二进制程序 
#  OPTIONS 命令行参数 注意只填命令行参数，没有的话可以选择不填
#  CHDIR 在执行DAEMON时,脚本会自动切换到该目录下
###########################################################################################################################


NAME="python"
DAEMON=./python
DESC="Python Simple Http Server"
USER=root      
GROUP=root
OPTIONS="-m SimpleHTTPServer 8000"
CHDIR="/usr/bin/"

 
PID_FILE=/tmp/${NAME}.pid

test -x ${CHDIR}${DAEMON} || exit 0

. /lib/lsb/init-functions

case "$1" in
  start)
    log_daemon_msg "Starting $DESC" "$NAME"
	#daemon -X "$DAEMON $OPTIONS" --pidfile=$PID_FILE --user=$USER --chdir=${CHDIR}
	start-stop-daemon --start --quiet  --background -m --user $USER --chdir $CHDIR --pidfile $PID_FILE  --group $GROUP --exec $DAEMON -- $OPTIONS  
    case "$?" in
        0) log_end_msg 0 ;;
        *) log_end_msg 1; exit 1 ;;
    esac
        ;;
  stop)
    log_daemon_msg "Stopping $DESC" "$NAME"
        #killproc -p $PID_FILE
    start-stop-daemon --stop --quiet   -m --user $USER --chdir $CHDIR --pidfile $PID_FILE  --group $GROUP --exec $DAEMON -- $OPTIONS  
    case "$?" in
        0) log_end_msg 0 ;;
        *) log_end_msg 1; exit 1 ;;
    esac
        ;;
  status)
    status_of_proc -p $PID_FILE $DAEMON $NAME && exit 0 || exit $?
   ;;
  restart|force-reload)
        $0 stop
        $0 start
        ;;
  *)
    echo "Usage: /etc/init.d/$NAME {start|stop|restart|force-reload}" >&2
        exit 1
        ;;
esac

exit 0

