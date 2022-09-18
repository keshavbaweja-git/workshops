stack_name=AWSInstanceScheduler


scheduler-cli create-period --stack $stack_name --name mon-start-9am --weekdays mon --begintime 9:00 --endtime 23:59
scheduler-cli create-period --stack $stack_name --name tue-thu-full-day --weekdays tue-thu
scheduler-cli create-period --stack $stack_name --name fri-stop-5pm --weekdays fri --begintime 0:00 --endtime 17:00
 
scheduler-cli create-schedule --stack $stack_name \
--name mon-9am-fri-5pm \
--periods mon-start-9am,tue-thu-full-day,fri-stop-5pm \
--timezone Asia/Singapore \
--enforced
