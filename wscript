#! /usr/bin/env python
# encoding: utf-8

APPNAME = "puzzle"
VERSION = "0.1"

top = "."
out = "build"

import Build, Options, Utils
import os


def options (opt):
    def add_enable_option (option, desc, group=None, disable=False):
        if group == None:
            group = opt
        option_ = option.replace ('-', '_')
        group.add_option ('--enable-' + option, action='store_true',
            default=False, help='Enable ' + desc, dest='enable_' + option_)
        group.add_option ('--disable-' + option, action='store_true',
            default=disable, help='Disable ' + desc, dest='disable_' + option_)

    import optparse
    grp = opt.add_option_group('test options')
    grp.add_option('--gdb', action='store_true', default=False,
            help='Run the tests under gdb')
    grp.add_option('--gir', action='store_true', default=False,
            help='Run the gir tests')

    opt.tool_options ("vala misc")

    opt.tool_options ('compiler_cc')
    opt.get_option_group ('--check-c-compiler').add_option('-d', '--debug-level',
            action = 'store', default = '',
            help = 'Specify the debugging level. [\'none\', \'debug\', \'full\']',
            choices = ['', 'none', 'debug', 'full'], dest = 'debug_level')
    opt.add_option('--enable-maintainer-mode', action='store_true',
            dest='maintainer', default=False,
            help='Set correct paths to allow execution in src dir. [Default: False]')

#    opt.add_option('--enable-debug-output', action='store_true',
#            dest='debug_output', default=False,
#            help='Enable debugging output. [Default: False]')

    opt.tool_options ("gnu_dirs")
    opt.parser.remove_option ('--oldincludedir')
    opt.parser.remove_option ('--htmldir')
    opt.parser.remove_option ('--dvidir')
    opt.parser.remove_option ('--pdfdir')
    opt.parser.remove_option ('--psdir')

    opt.tool_options ('intltool')
    group = opt.add_option_group ('Localization and documentation', '')
    add_enable_option ('nls', 'native language support', group)
    group.add_option ('--update-po', action='store_true', default=False,
        help='Update localization files', dest='update_po')
    add_enable_option ('docs', 'informational text files', group)


def configure (conf):
    #import Options
    conf.check_tool ("compiler_cc vala gnu_dirs intltool")

    conf.load ('compiler_c vala')
    
    conf.check_cfg (package='glib-2.0', uselib_store='glib', args='--cflags --libs')
    #conf.check_cfg(package='gthread-2.0', uselib_store='GTHREAD', mandatory=1, args='--cflags --libs')
    #conf.check_cfg (package='gobject-introspection-1.0', uselib_store='gobject-introspection-1.0', atleast_version='0.6.5', args='--cflags --libs')
    conf.check_cfg (package='gio-2.0', uselib_store='gio', args='--cflags --libs')
    #conf.check_cfg (package='gdk-pixbuf-2.0', uselib_store='GDK_PIXBUF', atleast_version='2.0', args='--cflags --libs')
    conf.check_cfg (package='gtk+-3.0', uselib_store='gtk', args='--cflags --libs')
    conf.check_cfg (package='cairo', uselib_store='cairo', args='--cflags --libs')
    #conf.check_cfg (package='pango', uselib_store='pango', args='--cflags --libs')
    conf.check_cfg (package='clutter-1.0', uselib_store='clutter', args='--cflags --libs')
    conf.check_cfg (package='clutter-gtk-1.0', uselib_store='clutter-gtk', args='--cflags --libs')
    #conf.check_cfg (package='clutter-gesture-1.0', uselib_store='clutter-gesture', args='--cflags --libs', mandatory=False)
    #conf.check_cfg (package='cogl-1.0', uselib_store='cogl', args='--cflags --libs')


    #conf.define ("PACKAGE", APPNAME)
    conf.define ("VERSION", VERSION)

    conf.define ("PACKAGE_NAME", APPNAME)
    conf.define ("PACKAGE_FULL_NAME", "Puzzle!")
    conf.define ("PACKAGE_STRING", "Puzzle! "+VERSION)
    conf.define ("PACKAGE_VERSION", VERSION)
    #conf.define ('PACKAGE_BUGREPORT', '')
    #conf.define ('PACKAGE_URL', 'https://kamilprusko.org/project/puzzle')

    if Options.options.maintainer:
        conf.define ('PACKAGE_DATADIR', 'data')
        conf.define ('PACKAGE_LOCALEDIR', 'build/po')
    else:
        conf.define ('PACKAGE_DATADIR', os.path.join (conf.env['PREFIX'], 'share', APPNAME)) 
        conf.define ('PACKAGE_LOCALEDIR', os.path.join (conf.env['PREFIX'], 'share', 'locale'))

    #conf.define ('ENABLE_NLS', 1)
    #conf.define ('HAVE_BIND_TEXTDOMAIN_CODESET', 1)
    conf.define ('GETTEXT_PACKAGE', APPNAME)


#    if Options.options.debug_output:
#        conf.define ('DEBUG', 1)
#    else:
#        conf.define ('DEBUG', 0)

    # avoid case when we want to install globally (prefix=/usr) but sysconfdir
    # was not specified
    if conf.env['SYSCONFDIR'] == '/usr/etc':
        conf.define('SYSCONFDIR', '/etc')
    else:
        conf.define('SYSCONFDIR', conf.env['SYSCONFDIR'])

    conf.write_config_header ('config.h')

    conf.env.append_value ('CCFLAGS', '-DHAVE_CONFIG_H -include config.h'.split ())
    conf.env['VERSION'] = VERSION

#    # These are used in the .pc files
#    GLIB_REQUIRED_VERSION=glib_required_version
#    GTK_REQUIRED_VERSION=gtk_required_version

    conf.sub_config ("help")


def build (bld):		
    env = bld.env

    if env.INTLTOOL:
        bld.add_subdirs('po')

    bld.add_subdirs ("src")
    bld.add_subdirs ("data")


    bld.install_files ('${BINDIR}', "src/puzzle") #, chmod = 0755)
    

    # TODO
    # postinstall icons, GSettings schemas and user docs

#    def post(ctx):
#        postinstall_icons ()
#        #gnome.postinstall_scrollkeeper('puzzle') # Installing the user docs
#        #gnome.postinstall_schemas('puzzle') # Installing GConf schemas
#        gnome.postinstall_icons() # Updating the icon cache
#
#    bld.add_post_fun (post)


def postinstall_icons ():
    try:
        dir = Build.bld.get_install_path ('${DATADIR}/icons/hicolor')
        command = 'sudo gtk-update-icon-cache -q -f -t %s' % dir
        
        #if not Utils.exec_command (command):
        if not os.system (command): # FIXME: this requires sudo...
            print ("Updated Gtk icon cache.")
            pass
    except:
        print ("Failed to update icon cache.")
        print ("After install, run this:")
        print ("gtk-update-icon-cache -q -f -t %s" % dir)




'''
def postinstall_schemas(prog_name):
        if Build.bld.is_install:
                dir = Build.bld.get_install_path('${PREFIX}/etc/gconf/schemas/%s.schemas' % prog_name)
                if not Options.options.destdir:
                        # add the gconf schema
                        Utils.pprint('YELLOW', 'Installing GConf schema')
                        command = 'gconftool-2 --install-schema-file=%s 1> /dev/null' % dir
                        ret = Utils.exec_command(command)
                else:
                        Utils.pprint('YELLOW', 'GConf schema not installed. After install, run this:')
                        Utils.pprint('YELLOW', 'gconftool-2 --install-schema-file=%s' % dir)

def postinstall_scrollkeeper(prog_name):
        if Build.bld.is_install:
                # now the scrollkeeper update if we can write to the log file
                if os.access('/var/log/scrollkeeper.log', os.W_OK):
                        dir1 = Build.bld.get_install_path('${PREFIX}/var/scrollkeeper')
                        dir2 = Build.bld.get_install_path('${DATADIR}/omf/%s' % prog_name)
                        command = 'scrollkeeper-update -q -p %s -o %s' % (dir1, dir2)
                        ret = Utils.exec_command(command)
'''

def deb(ctx):
    """Build a debian package."""
    import datetime, Utils
    cargs = {
            'now': Utils.cmd_output('date --rfc-2822'),
            'version': VERSION
            }
    clog = file('debian/changelog', 'w')
    clog.write("""puzzle (%(version)s) none; urgency=low

  * Upstream-provided package.

 -- Kamil Prusko <kamilprusko@gmail.com>  %(now)s
""" % cargs)
    clog.close()
    Utils.exec_command ('dpkg-buildpackage -b -rfakeroot -uc')


