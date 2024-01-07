; graphical whois... larryw@innocent.com / nyteg on efnet
whois { unset %wi.* | .raw whois $1- }
alias wiw {
  window -afp @whois 150 150 487 175
  drawpic @whois 1 1 $scriptdirgraphics\whois.bmp
  drawtext -o @whois 13 Verdana 18 335 8 %wi.nick
  drawtext -o @whois 13 Verdana 18 129 43 %wi.userhost
  drawtext -o @whois 13 Verdana 18 127 65 %wi.realname
  drawtext -o @whois 13 Verdana 18 90 87 %wi.using
  drawtext -o @whois 13 Verdana 18 86 109 %wi.ircop
  drawtext -o @whois 13 Verdana 18 89 131 %wi.away
  drawtext -o @whois 13 Verdana 12 123 151 %wi.channels
  unset %wi.*
}
raw 311:*:%wi.nick = $2 | %wi.userhost = $3 $+ @ $+ $4 | %wi.realname = *6 | %wi.away = no | %wi.ircop = no
raw 301:*:%wi.away = $3-
raw 312:*:%wi.using = $3
raw 313:*:%wi.ircop = yes
raw 319:*:%wi.channels = $parm3*
raw 318:*:wiw
; eof