# Description:
#   決められた日時になったら実施する処理
#
cronJob = require('cron').CronJob
moment = require('moment')


module.exports = (robot) ->
    cronjob = new cronJob(
        cronTime: '0 0 * * * *'     # 毎時00分00秒（秒 分 時 日 月 週）
        start:    true              # すぐにcronのjobを実行するか
        timeZone: 'Asia/Tokyo'      # タイムゾーン指定
        onTick: ->                  # 時間が来た時に実行する処理
            message = moment().format('YYYY年M月D日 H時になりました。')
            robot.send {room: 'test'}, message
        )
