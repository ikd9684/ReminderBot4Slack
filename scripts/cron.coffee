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

roomName = 'test'

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
    #         today = moment().format('YYYY-MM-DD HH:mm:ss')
    #         robot.logger.debug 'cron test: ' + today
    # )

    cronjobA = new cronJob(
        cronTime: '00 00 07 * * *'  # 毎日07:00:00に以下の処理を実施（秒 分 時 日 月 週）
        start:    true              # すぐにcronのjobを実行するか
        timeZone: 'Asia/Tokyo'      # タイムゾーン指定
        onTick: ->                  # 時間が来た時に実行する処理
            robot.logger.debug 'cron07'
            getNextEvent( (result) ->
                today = moment().format(YMD)
                next = moment(result).format(YMD)

                robot.logger.debug 'cron07: today=' + today + ' ? next=' + next
                if today is next
                    # 今日がBandroid開催日ならメッセージを出力
                    md = moment(result).format('M月D日(ddd)')
                    hm = moment(result).format('HH:mm')
                    message = '今日 ' + md + ' は Bandroid の開催日です！\n開始予定時刻は ' + hm + ' です。'
                    robot.send {room: roomName}, message
            )
    )

    cronjobB = new cronJob(
        cronTime: '00 00 18 * * *'  # 毎日18:00:00に以下の処理を実施（秒 分 時 日 月 週）
        start:    true              # すぐにcronのjobを実行するか
        timeZone: 'Asia/Tokyo'      # タイムゾーン指定
        onTick: ->                  # 時間が来た時に実行する処理
            robot.logger.debug 'cron18'
            getNextEvent( (result) ->
                today = moment().format(YMD)
                beforeNext = moment(result).add(-1, 'days').format(YMD)
                next = moment(result).format(YMD)

                robot.logger.debug 'cron18: today=' + today + ' ? beforeNext=' + beforeNext
                if today is beforeNext
                    # 明日がBandroid開催日ならメッセージを出力
                    md = moment(result).format('M月D日(ddd)')
                    hm = moment(result).format('HH:mm')
                    message = '明日 ' + md + ' は Bandroid の開催日です！\n開始予定時刻は ' + hm + ' です。'
                    robot.send {room: roomName}, message
            )
    )

getNextEvent = (func) ->
    uri = 'https://www.googleapis.com/calendar/v3/calendars/excite-software.net_uvouli16riv9sq2s89liof0n4s@group.calendar.google.com/events'
    query = {
        key: 'AIzaSyDrsxDDJrf8liR4IKfkOfCPFCByMMq3OJY',
        timeMin: moment().format('YYYY-MM-DD') + 'T18:00:00.000Z',
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
