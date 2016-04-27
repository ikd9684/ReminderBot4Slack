# Description:
#   決められた日時になったら実施する処理
#
Log = require('log')
@logger = new Log process.env.HUBOT_LOG_LEVEL or 'info'

request = require('request')
cronJob = require('cron').CronJob
moment = require('moment')
moment.locale('ja')

YMD = 'YYYYMMDD'

# module.exports = (robot) ->
#     cronjob = new cronJob(
#         cronTime: '0 0 * * * *'     # 毎時00分00秒（秒 分 時 日 月 週）
#         start:    true              # すぐにcronのjobを実行するか
#         timeZone: 'Asia/Tokyo'      # タイムゾーン指定
#         onTick: ->                  # 時間が来た時に実行する処理
#             message = moment().format('YYYY年M月D日 H時になりました。')
#             robot.send {room: 'test'}, message
#         )

module.exports = (robot) ->
    # cronjobTest = new cronJob(
    #     cronTime: '* * * * * *'     # 毎日07:00:00に以下の処理を実施（秒 分 時 日 月 週）
    #     start:    true              # すぐにcronのjobを実行するか
    #     timeZone: 'Asia/Tokyo'      # タイムゾーン指定
    #     onTick: ->                  # 時間が来た時に実行する処理
    #         now = moment().format('YYYY-MM-DD HH:mm:ss')
    #         robot.logger.debug 'cron test: ' + now
    # )

    cronjobA = new cronJob(
        cronTime: '00 00 07 * * *'  # 毎日07:00:00に以下の処理を実施（秒 分 時 日 月 週）
        start:    true              # すぐにcronのjobを実行するか
        timeZone: 'Asia/Tokyo'      # タイムゾーン指定
        onTick: ->                  # 時間が来た時に実行する処理
            robot.logger.debug 'cron07'
            getNextEvent( (result) ->
                now = moment().format(YMD)
                nextDate = moment(result)
                next = nextDate.format(YMD)

                robot.logger.debug 'cron07: now=' + now + ' ? next=' + next
                if now is next
                    # 今日がBandroid開催日ならメッセージを出力
                    md = nextDate.format('M月D日(ddd)')
                    hm = nextDate.format('HH:mm')
                    message = '今日 ' + md + ' は Bandroid の開催日です！\n開始予定時刻は ' + hm + ' です。'
                    robot.send {room: 'test'}, message
            )
    )

    cronjobB = new cronJob(
        cronTime: '00 00 18 * * *'  # 毎日18:00:00に以下の処理を実施（秒 分 時 日 月 週）
        start:    true              # すぐにcronのjobを実行するか
        timeZone: 'Asia/Tokyo'      # タイムゾーン指定
        onTick: ->                  # 時間が来た時に実行する処理
            robot.logger.debug 'cron18'
            getNextEvent( (result) ->
                now = moment().format(YMD)
                nextDate = moment(result)
                beforeNext = nextDate.add(-1, 'days').format(YMD)
                next = nextDate.format(YMD)

                robot.logger.debug 'cron18: now=' + now + ' ? beforeNext=' + beforeNext
                if now is beforeNext
                    # 明日がBandroid開催日ならメッセージを出力
                    md = nextDate.format('M月D日(ddd)')
                    hm = nextDate.format('HH:mm')
                    message = '明日 ' + md + ' は Bandroid の開催日です！\n開始予定時刻は ' + hm + ' です。'
                    robot.send {room: 'test'}, message
            )
    )

getNextEvent = (func) ->
    uri = 'https://www.googleapis.com/calendar/v3/calendars/excite-software.net_uvouli16riv9sq2s89liof0n4s@group.calendar.google.com/events'
    query = {
        key: 'AIzaSyDrsxDDJrf8liR4IKfkOfCPFCByMMq3OJY',
        timeMin: moment().format('YYYY-MM-DD') + 'T20:00:00.000Z',
        maxResult: 1,
        orderBy: 'startTime',
        singleEvents: true,
    }
    request( { url: uri, qs: query }, (err, res, body) ->
        if err
            console.log err
        else
            json = JSON.parse body
            if 0 < Object.keys(json).length
                func(json['items'][0]['start']['dateTime'])
    )
