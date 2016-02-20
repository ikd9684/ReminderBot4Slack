###
 * http://usejsdoc.org/
 * 毎分、時刻をつぶやきます。
###
http = require('http');
moment = require('moment');


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
        msg.send moment(nextTime).format('次の開催予定は YYYY年 M月 D日 の HH:mm です。')
