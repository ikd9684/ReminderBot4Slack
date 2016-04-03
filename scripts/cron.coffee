# Description:
#   決められた日時になったら実施する処理
#
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
    cronjob = new cronJob(
        cronTime: '00 00 07 * * *'  # 毎日07:00:00に以下の処理を実施（秒 分 時 日 月 週）
        start:    true              # すぐにcronのjobを実行するか
        timeZone: 'Asia/Tokyo'      # タイムゾーン指定
        onTick: ->                  # 時間が来た時に実行する処理
            getNextEvent( (result) ->
                now = moment().format(YMD)
                next = moment(result).format(YMD)

                if now is next
                    # 今日がBandroid開催日ならメッセージを出力
                    robot.send {room: 'test'}, next.format('今日 M月D日(ddd) は Bandroid の開催日です！\n開始予定時刻は HH:mm です。')
            )
    )

module.exports = (robot) ->
    cronjob = new cronJob(
        cronTime: '00 00 18 * * *'  # 毎日18:00:00に以下の処理を実施（秒 分 時 日 月 週）
        start:    true              # すぐにcronのjobを実行するか
        timeZone: 'Asia/Tokyo'      # タイムゾーン指定
        onTick: ->                  # 時間が来た時に実行する処理
            getNextEvent( (result) ->
                now = moment().format(YMD)
                beforeNext = moment(result).add(-1, 'days').format(YMD)
                next = moment(result).format(YMD)

                if now is beforeNext
                    # 明日がBandroid開催日ならメッセージを出力
                    robot.send {room: 'test'}, next.format('明日 M月D日(ddd) は Bandroid の開催日です！\n開始予定時刻は HH:mm です。')
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
