# Description:
#   「次はいつ？」の問いかけに対して次回開催日を返答する
#
http = require('http')
moment = require('moment')
moment.locale('ja')

YMD = 'YYYYMMDD'

module.exports = (robot) ->
    robot.respond /(つぎ|次|今度)(は)?(いつ)?[？?]/, (msg) ->
        uri = 'https://www.googleapis.com/calendar/v3/calendars/excite-software.net_uvouli16riv9sq2s89liof0n4s@group.calendar.google.com/events'

        request = msg.http(uri)
                     .query(key: 'AIzaSyDrsxDDJrf8liR4IKfkOfCPFCByMMq3OJY')
                     .query(timeMin: moment().format('YYYY-MM-DD') + 'T00:00:00.000Z')
                     .query(maxResult: 1)
                     .query(orderBy: 'startTime')
                     .query(singleEvents: true)
                     .get()
        request (err, res, body) ->
            json = JSON.parse body
            if 0 < Object.keys(json).length
                result = json['items'][0]['start']['dateTime']

                now = moment().format(YMD)
                beforeNext = moment(result).add(-1, 'days').format(YMD)
                next = moment(result).format(YMD)

                if now is next
                    msg.send moment(result).format('次の開催予定は 今日 の HH:mm です。')
                else if now is beforeNext
                    msg.send moment(result).format('次の開催予定は 明日 M月D日(ddd) の HH:mm です。')
                else
                    msg.send moment(result).format('次の開催予定は M月D日(ddd) の HH:mm です。')
