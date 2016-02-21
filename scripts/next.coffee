# Description:
#   「次はいつ？」の問いかけに対して次回開催日を返答する
#
http = require('http')
moment = require('moment')

moment.locale('ja', {
  weekdays: ["日曜日","月曜日","火曜日","水曜日","木曜日","金曜日","土曜日"],
  weekdaysShort: ["日","月","火","水","木","金","土"],
})

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
        nextTime = json['items'][0]['start']['dateTime']
        msg.send moment(nextTime).format('次の開催予定は YYYY年M月D日(ddd) の HH:mm です。')
