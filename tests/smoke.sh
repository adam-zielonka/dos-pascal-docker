#!/bin/sh
set -eu
mkdir -p /tmp/smoke-source /tmp/smoke-work
printf "program Hello; begin writeln('SMOKE_OK'); end.\n" > /tmp/smoke-source/HELLO.PAS
printf 'Compiler smoke test\n' > /tmp/smoke-source/README.TXT
cd /tmp/smoke-work
timeout 45 compile.sh HELLO.PAS /tmp/smoke-source /tmp/smoke-work
test -s build/HELLO.EXE
timeout 45 dosbox -c 'MOUNT C: /tmp/smoke-work/build' -c 'C:' -c 'HELLO.EXE > RESULT.TXT' -c EXIT
grep -q SMOKE_OK build/RESULT.TXT
website.sh HELLO
test -s build/index.html
test -s build/HELLO.ZIP
