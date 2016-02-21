# Description:
#   「次はいつ？」の問いかけに対して次回開催日を返答する
#
request = require('request');
moment = require('moment')
moment.locale('ja')

YMD = 'YYYYMMDD'

module.exports = (robot) ->
    robot.respond /(つぎ|次|今度)(は)?(いつ)?[？?]/, (msg) ->
        getNextEvent( (result) ->
            now = moment().format(YMD)
            beforeNext = moment(result).add(-1, 'days').format(YMD)
            next = moment(result).format(YMD)

            if now is next
                msg.send moment(result).format('次の開催予定は 今日 の HH:mm です。')
            else if now is beforeNext
                msg.send moment(result).format('次の開催予定は 明日 M月D日(ddd) の HH:mm です。')
            else
                msg.send moment(result).format('次の開催予定は M月D日(ddd) の HH:mm です。')
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
