@echo on

set HAVE_READLINE=no

make prefix="%PREFIX%" -j %CPU_COUNT% install-shared