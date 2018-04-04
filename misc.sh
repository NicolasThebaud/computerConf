u_prettyjson2() {
  [[ ! -z "$2" ]] && python -m json.tool $1 >> $2 || python -m json.tool $1
}

u_prettyjson() {
  tmpfile=$(mktemp /tmp/json.XXXXXX.js);
  echo -n 'const j = ' >> $tmpfile;
  cat $1 >> $tmpfile;
  echo ';' >> $tmpfile;
  echo 'console.log(JSON.stringify(j, null, 2));' >> $tmpfile;
  [[ ! -z "$2" ]] && node $tmpfile >> $2 || node $tmpfile;
}

u_minjson() {
	tmpfile=$(mktemp /tmp/json.XXXXXX.js);
	echo -n 'const j = `' >> $tmpfile;
	cat $1 >> $tmpfile;
	echo '`;' >> $tmpfile;
	echo 'console.log(JSON.stringify(JSON.parse(j)));' >> $tmpfile;
	[[ ! -z "$2" ]] && node $tmpfile >> $2 || node $tmpfile;
}
