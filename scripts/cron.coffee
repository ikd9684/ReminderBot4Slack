###
 * http://usejsdoc.org/
 * 毎分、時刻をつぶやきます。
###
cronJob = require('cron').CronJob;
moment = require('moment');


module.exports = (robot) ->
  cronjob = new cronJob(
    cronTime: '0 0 * * * *'     # 毎時00分00秒
    start:    true              # すぐにcronのjobを実行するか
    timeZone: 'Asia/Tokyo'      # タイムゾーン指定
    onTick: ->                  # 時間が来た時に実行する処理
      message = '時刻は ' + moment().format('YYYY-MM-DD HH:mm:ss');
      robot.send {room: 'test'}, message
    )
