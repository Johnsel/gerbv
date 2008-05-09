#!/bin/sh
rm -f confdefs.h config.* configure aclocal.m4 stamp-h* install-sh missing mkinstalldirs ltmain.sh
rm -rf autom4te.cache
find . -name Makefile -exec rm {} \;
find . -name Makefile.in -exec rm {} \;

############################################################################
#
# libtoolize (libtool)
#

echo "Checking libtoolize version..."
lt_ver=`libtoolize --version | awk '{print $NF; exit}'`
lt_maj=`echo $lt_ver | sed 's;\..*;;g'`
lt_min=`echo $lt_ver | sed -e 's;^[0-9]*\.;;g'  -e 's;\..*$;;g'`
lt_teeny=`echo $lt_ver | sed -e 's;^[0-9]*\.[0-9]*\.;;g'`
echo "    $lt_ver"

case $lt_maj in
    0)
        echo "You must have libtool >= 1.4.0 but you seem to have $lt_ver"
        exit 1
	;;

    1)
        if test $lt_min -lt 4 ; then
            echo "You must have libtool >= 1.4.0 but you seem to have $lt_ver"
            exit 1
        fi
        ;;

    *)
        echo "You are running a newer libtool than gerbv has been tested with."
	echo "It will probably work, but this is a warning that it may not."
	;;
esac
													echo "Running libtoolize..."
libtoolize --force --copy --automake || exit 1

############################################################################
#
# aclocal

echo "Running aclocal..."
aclocal $ACLOCAL_FLAGS || exit 1
echo "... done with aclocal."

############################################################################
#
# autoheader

echo "Running autoheader..."
autoheader || exit 1
echo "... done with autoheader."

############################################################################
#
# automake

echo "Running automake..."
automake --force --copy --add-missing || exit 1
echo "... done with automake."

############################################################################
#
# autoconf

echo "Running autoconf..."
autoconf || exit 1
echo "... done with autoconf."
