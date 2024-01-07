td return $1
tmo %i = 0 | %xtmp = 0 | :start | inc %i | if (%file [ $+ [ %i ] ] == $null) goto next | %xtmp = %xtmp + $lof(%file [ $+ [ %i ] ] ) | goto start | :next | %tmp1 = %xtmp / 1024000 | %tmo = $gettok(%tmp1,1-1,46) $+ . $+ $left($gettok(%tmp1,2-2,46),2) | unset %tmp* %xtmp | halt
offer set %record 0 | set %lrecord 0 | set %numpacks $$?="Number of Packs:" | set %num 0 | :start | inc %num | if (%num > %numpacks) { set %showsum $$?="Show Summary Line? y for Yes, n for No" | decho Xdcc offer has been set. | xdcc on | tmo } | set %get [ $+ [ %num ] ] 0 | set %filedesc [ $+ [ %num ] ] $$?="Pack Description for [ [ %num ] $+ ] :" | set %fcomment [ $+ [ %num ] ] $?="Comment for [ %num ] Press Cancel for None:" | set %file [ $+ [ %num ] ] $dir="File for Pack [ %num ] "  *.* | goto start
cq write -c $tp(queue.txt)
cs set %i 0 | :start | inc %i | if ($send(%i) == $null) goto end | if ($send(%i).status == inactive) close -s $send(%i) $send(%i).file | psend $read -l1 $tp(queue.txt) queue | goto start | :end
psend if $send(0) > %xdcc.slots { /notice $1 Sorry, $1 my slots ( $+ %xdcc.slots $+ ) are full! | /halt } | if (($2 > %numpacks) || ($2 == $null)) halt | .quote notice $1 :Sending you  $+ %filedesc [ $+ [ $2 ] ] $+ , which is one file. | inc %get [ $+ [ $2 ] ] | .timer 1 %xdcc.chksnd checksend $1 [ $nopath(%file [ $+ [ $2 ] ] ) ] | if (%minsp [ $+ [ $2 ] ] != $null) .timer 1 20 checkspeed $1 $nopath(%file [ $+ [ $2 ] ] ) [ %minsp [ $+ [ $2 ] ] ] | else { if (%msall == on) .timer 1 20 checkspeed $1 $nopath(%file [ $+ [ $2 ] ] ) %allspeed } | dcc send $1 [ " $+ [ %file [ $+ [ $2 ] ] ] $+ " ]
checksend set %i 0 | :start | inc %i | if ($send(%i) == $null) halt | if ($send(%i) == $1 && $send(%i).file == $2 && $send(%i).status == waiting) { close -s $1 $2 | .quote notice $1 :Timeout: $2 | decho One or more DCC SENDs to $1 have timed out. | if ($lines($tp(queue.txt)) >= 1 && $send(0) <= %maxslots) psend $read -l1 $tp(queue.txt) queue | halt } | goto start
tml set %g 0 | set %tml 0 | set %tmp01 0 | :begin | inc %g | if (%g <= %numpacks) { %tmp02 = %get [ $+ [ %g ] ] * $lof(%file [ $+ [ %g ] ] ) | inc %tmp01 %tmp02 | set %tmp03 $lof(%file [ $+ [ %g ] ] ) | inc %ofmegs %tmp03 | goto begin } | %tml = %tmp01 / 1024000 | %tml = $gettok(%tml,1-1,46) $+ . $+ $left($gettok(%tml,2-2,46),2) | if ($gettok(%tml,2-2,46) == $null) %tmp = 0.0 | unset %tmp* | return %tml
pmin if (($1 == $null) || ($2 == $null) || ($1 > %numpacks)) { decho Syntax: /pmin <pack #> <minspeed in kb/s> | halt } | if ($2 == 0) { unset %minsp [ $+ [ $1 ] ] | decho Removed minspeed for pack $hc($1) $+ . | halt } | set %minsp [ $+ [ $1 ] ] [ $2 * 1000 ] | decho Minspeed for Pack $1 $+ : $2 $+ kb/s.
minspeed if ($1 == $null) { decho Syntax: /minspeed <minspeed in kb/s> | halt } | if ($1 == 0) { set %msall off | unset %allspeed | decho Removed minspeed. | halt } | set %msall on | %allspeed = $1 * 1000 | decho Minspeed is now: $1 $+ kb/s 
doffer unset %pack %nopath %ngets %qds %numpacks %num %showsum %xtmp %tmo %xc %fsize %g %tml %msall %allspeed %minsp* %file* %fcomment* %record %lrecord %get* | decho All packs have been deleted. | cq 
addpack { :start | set %num $pls(1,%numpacks) | set %get [ $+ [ %num ] ] 0 | set %file [ $+ [ %num ] ] $dir="Select File for Pack [ %num ] "  *.* | set %filedesc [ $+ [ %num ] ] $$?="Pack Description for [ [ %num ] $+ ] :" | set %fcomment [ $+ [ %num ] ] $?="Comment for [ %num ] Press Cancel for None:" | set %numpacks %num | if ((%filedesc [ $+ [ %num ] ] == $null) || (%file [ $+ [ %num ] ] == $null)) goto start | decho Pack $hc(%num) has been added. | tmo }
pls %tmp = $1 + $2 | return %tmp
div %tmp = $1 / $2 | return %tmp
sub %tmp = $1 - $2 | return %tmp
mpy %tmp = $1 * $2 | return %tmp
editpack if ($1 == $null) halt | set %num $1 | set %get [ $+ [ %num ] ] 0 | set %filedesc [ $+ [ %num ] ] $$?="Pack Description for [ [ %num ] $+ ] :" | set %fcomment [ $+ [ %num ] ] $?="Comment for [ %num ] Press Cancel for None:" | set %file [ $+ [ %num ] ] $dir="Select File for Pack [ %num ] "  *.* | set %numpacks %num | decho Pack $hc(%num) has been edited. | tmo
fsize {
  %file.n = %file [ $+ [ %num ] ] 
  if ($lof(%file [ $+ [ %num ] ] ) < 1024) { %fsize = $lof(%file [ $+ [ %num ] ] ) $+ b }
  elseif ($lof(%file [ $+ [ %num ] ] ) < 1024000)  { %fsize = $lof(%file [ $+ [ %num ] ] ) / 1024 | %fsize = $gettok(%fsize,1-1,46) $+ . $+ $left($gettok(%fsize,2-2,46),1) $+ k }
  else { %fsize = $lof(%file [ $+ [ %num ] ] ) / 1024000 | %fsize = $gettok(%fsize,1-1,46) $+ . $+ $left($gettok(%fsize,2-2,46),1) $+ m }
  return %fsize
}
xd66 {
  set %pack $remove($3,$chr(35))  
  if ((%numpacks == $null) || (%numpacks == 0)) { .quote notice $nick :No files offered. | halt }
  elseif (%pack > %numpacks) { .quote notice $nick :File  $+ $3 $+  does not exist. /CTCP $me XDCC LIST. | halt } 
  if (($2 == list) && ($3)) { %nopath = $nopath(%file [ $+ [ %pack ] ] ) | %ngets = %get [ $+ [ %pack ] ] | .quote notice %xnick :Pack: %filedesc [ $+ [ %pack ] ] | .quote notice %xnick :Size $str($chr(32),5) File | .quote notice %xnick : $+ $fix(10,$lof(%file [ $+ [ %pack ] ] )) %nopath | .quote notice %xnick :---------- ------------------------------------------------- | .quote notice %xnick : $+ $fix(10,$lof(%file [ $+ [ %pack ] ] )) 1 file(s) :: %ngets Snags | halt }
  if ($2 == send) { psend %xnick %pack | halt }
  if ($2 == queue) { .quote notice %xnick :Queue Length: $lines($tp(queue.txt)) / %maxqueue | halt }
  if ($2 == list) { nlist1 %xnick | halt }
  if ($2 == help) { .quote notice %xnick :/CTCP $me XDCC LIST - to get the list of offered packs. | .quote notice %xnick :/CTCP $me XDCC LIST #<N> - to get more info on pack #<N>. | .quote notice %xnick :/CTCP $me XDCC SEND #<N> - to send pack #<N>. | halt }
  else { .quote notice %xnick :Unrecognized request. Try /CTCP $me XDCC HELP. | halt }
}
nlist if ((%numpacks == 0) || (%numpacks == $null)) { decho You have no packs to offer. | halt } | if ($1 != $null) { decho $hc(NLIST) sent to $hc($1) at $hc($atime) $+ . | /set %xc notice $1 } | sdcc
nlist1 if ((%numpacks == 0) || (%numpacks == $null)) { decho You have no packs to offer. | halt } | if ($1 != $null) { decho $hc(NLIST) sent to $hc($1) at $hc($atime) $+ . | /set %xc notice $1 } | sdcc
hc return  $+ %col2 $+  $+ *1 $+ 
plist if ((%numpacks == 0) || (%numpacks == $null)) { decho You have no packs to offer. | halt } | if ($1 == $null) { decho $hc(PLIST) sent to all channels at $hc($atime) $+ . | set %xc amsg } | else { decho $hc(PLIST) sent to $hc($1) at $hc($atime) $+ . | /set %xc msg $1 } | sdcc
rm return $remove($remove($remove($remove($remove($remove($remove($remove($remove($remove($1,1),2),3),4),5),6),7),8),9),0)
sdcc {
  %xc -/ %numpacks xdcc packs. best: %record $+ kps
  set %num 0 | :start | inc %num
  if (%num > %numpacks) { if (%showsum != y) halt | else %xc  -\ offered %tmo $+ m - sent $tml $+ m | halt }
  set %tmp %get [ $+ [ %num ] ]
  if ($fsize(%num) == $null) { %xc $chr(35) $+ %num -- file no longer exists! -- | goto start }
  %xc %pipe $chr(35) $+ %num - dls( $+ %tmp $+ x $+ ) - $fsize(%num) $+ -- %filedesc [ $+ [ %num ] ] 
  if (%fcomment [ $+ [ %num ] ] == $null) goto start | else %xc $chr(32) $+ $chr(32) $+ `->  %fcomment [ $+ [ %num ] ] | goto start
}
checkspeed { 
  set %i 0 | :start | inc %i | if ($send(%i) == $null) halt | if ($send(%i) == $1 && $send(%i).file == $2) {
    if ($send(%i).status == waiting) { .quote notice $1 :You have DCCs pending. Type /DCC GET $me $+ . | .timer 1 20 checkspeed *1 | halt } | if ($send(%i).cps < $3) { set %mstime $div($send(%i).cps,1000) | close -s $1 $2 | .quote notice $1 :MINSPEED: %mstime $+ kb/sec less than $div($3,1000)  $+ kb/sec: Closing connection. | if (($lines($tp(queue.txt)) >= 1) && ($send(0) <= %maxslots)) psend $read -l1 $tp(queue.txt) queue | halt }
  }
  goto start 
}
xdccload {
  if ($1 == $null) halt
  if (($readini xdcc.txt $1 numpacks == $null)) { decho No such offer in xdcc save. | halt } | set %i 0 | %numpacks = $readini xdcc.txt $1 numpacks | :start | inc %i | if (%i > %numpacks) { decho XDCC offer $hc($1) has been loaded. | xdcc on | halt }
  set %file [ $+ [ %i ] ] $readini $td(xdcc.txt) $1 file [ $+ [ %i ] ] | set %filedesc [ $+ [ %i ] ] $readini $td(xdcc.txt) $1 desc [ $+ [ %i ] ] | set %get [ $+ [ %i ] ] $readini $td(xdcc.txt) $1 get [ $+ [ %i ] ] |  if ($readini $td(xdcc.txt) $1 fc [ $+ [ %i ] ] == yes) set %fcomment [ $+ [ %i ] ] $readini $td(xdcc.txt) $1 comment [ $+ [ %i ] ] | goto start
}
xdccsave {
  if (($1 == $null) || (%numpacks == 0) || (%numpacks == $null)) { decho No offer to save. | halt } | set %i 0 | writeini $td(xdcc.txt) $1 numpacks %numpacks | :start | inc %i | if (%i > %numpacks) { decho XDCC offer $hc($1) has been saved. | halt } 
  writeini $td(xdcc.txt) $1 file [ $+ [ %i ] ] %file [ $+ [ %i ] ] | writeini $td(xdcc.txt) $1 get [ $+ [ %i ] ] %get [ $+ [ %i ] ] | if (%fcomment [ $+ [ %i ] ] != $null) { writeini $td(xdcc.txt) $1 comment [ $+ [ %i ] ] %fcomment [ $+ [ %i ] ] | writeini $td(xdcc.txt) $1 fc [ $+ [ %i ] ] yes } |  writeini $td(xdcc.txt) $1 desc [ $+ [ %i ] ] " $+ %filedesc [ $+ [ %i ] ] $+ " | goto start
}
qs if ($lines($tp(queue.txt)) == 0) .timer300 off | set %i 0 | :start | inc %i | if (%i > $lines($tp(queue.txt))) { cs | halt } | %qs = $read -l [ $+ [ %i ] ] $tp(queue.txt) | .quote notice $rm(%qs) :You are in queue position %i of %maxqueue $+ . | goto start
pchannels if ($1 ischan) { .timer 0 %tc plist $1 | decho Sending PLIST to $hc($1) every $hc($div(%tc,60)) minutes. } | else { .timer 0 %tc plist $?="enter channel to send plist to (cancel for all):" | decho Sending PLIST to $hc($!) every $hc($div(%tc,60)) minutes. }
pmsg set %pmsg $?="enter channel to send pmsg to (cancel for all)" | if (%pmsg == $null) set %pmg ame | else set %pmg describe %pmsg | .timer 0 %tc %pmg is offering  $+ %numpacks $+  pack(s). Type '/CTCP $me XDCC LIST' for a complete listing. | decho Sending offer message to $hc($!) every $hc($div(%tc,60)) minutes.
poff if ($1) { set %i 0 | :start | inc %i | if ($timer(%i) == $null) { decho Unable to locate PLIST timer for $hc($1) $+ . | halt } | elseif (( $1 isin $timer(%i).com )) { .timer $+ $timer(%i) off | decho PLIST timer for $hc($1) has been halted. | halt } | goto start } | else { .timers off | if (%chanprot == on) .timer 0 600 cclr | if ((%idcheck == on) && (%idauto == on)) .timer4 0 300 idchk }
timelimit set %chsend $mpy(60,$$1) | decho XDCC Send Timeout set to $hc($1) minutes.
maxslots set %maxslots $$1 | decho maximum  xdcc slots set to $hc($1) slots.
qmax set %maxqueue $$1 | decho Queue size set to $hc($1) slots. 
ptime set %tc $mpy($$1,60) | decho PLIST timer set to every $hc($1) minutes.
