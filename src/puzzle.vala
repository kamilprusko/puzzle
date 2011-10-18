/*
 * Puzzle!
 * Copyright © 2011 Kamil Prusko <kamilprusko@gmail.com>
 *
 * Puzzle! is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Puzzle! is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this game.  If not, see <http://www.gnu.org/licenses/>.
 */

using GLib;

namespace Puzzle
{
    private bool show_version;
    private bool verbose;

    [NoArrayLength]
    private string[] uris;
    
    private static const GLib.OptionEntry[] options = {
        {"version", 0, 0, OptionArg.NONE, ref show_version, "Show version", null},
        {"verbose", 0, 0, OptionArg.NONE, ref verbose, "Be more verbose", null},
        {"", 0, 0, OptionArg.FILENAME_ARRAY, ref uris, "", "[FILE|URI...]"},
        {null}
    };


	private void action_enabled_changed (Gtk.Application application, string action_name, bool enabled)
	{
	}

    private void on_application_action_state_changed (Gtk.Application application, string action_name, GLib.Variant value)
    {
        /* This signal is emitted when a non-primary process for a given application is invoked while your application is running; for example, when a file browser launches your program to open a file. The raw operating system arguments are passed in the variant application. */
    }

    // --------------

    private void on_application_action (Gtk.Application application, string action_name)
    {
        /* This signal is emitted when an action is activated. The action name is passed as the first argument, but also as signal detail, so it is possible to connect to this signal for individual actions. */
    }
    
    private void on_application_activate () //, string action_name, GLib.Variant value)
    {
        /* This signal is emitted when a non-primary process for a given application is invoked while your application is running; for example, when a file browser launches your program to open a file. The raw operating system arguments are passed in the variant application. */
    }
    
    private void on_application_open (GLib.File[] files, string hint)
    {
    }

//    private int on_application_command_line (void command_line)
//    {
//        return 0;
//    }

    private void on_application_startup ()
    {
    }
    
    private bool on_application_quit ()
    {
        /* if some_condition is TRUE, do not quit */
        if (false)
            return true;
        /* this will cause the application to quit */
        return false;
    }

    public int main (string[] args)
    {
        /* Init */
//        GLib.Environment.set_application_name (_(Config.PACKAGE_FULL_NAME));        
//        Intl.bindtextdomain (Config.GETTEXT_PACKAGE, Config.PACKAGE_LOCALEDIR);
//        Intl.bind_textdomain_codeset (Config.GETTEXT_PACKAGE, "UTF-8");

        if (GtkClutter.init (ref args) != Clutter.InitError.SUCCESS)
            error ("Unable to initialize GtkClutter");

        var application = new Gtk.Application ("org.gtk.Puzzle",
                ApplicationFlags.HANDLES_OPEN); // TODO: ApplicationFlags.HANDLES_COMMAND_LINE);
        
        application.open.connect (on_application_open);
//        application.action.connect (on_application_action);
        application.activate.connect (on_application_activate);
//        application.command_line.connect (on_application_command_line);
//        application.quit.connect (on_application_quit);
        application.startup.connect (on_application_startup);
            /* TODO
            application.set_action_group (actions);
            
            open-action
            about-dialog-action
            quit-action

            builder.connect_signals (application);
            */
        
        //"application-id", "org.gnome.games.Puzzle",
        //"flags", ApplicationFlags.HANDLES_OPEN | ApplicationFlags.HANDLES_COMMAND_LINE

        //Gtk.init (ref args);
        
        if (Clutter.init (ref args) != Clutter.InitError.SUCCESS)
            error ("Unable to initialize Clutter");
            

        Puzzle.init ();


        /* Command line args */
        var context = new GLib.OptionContext ("");
        context.add_main_entries (options, Config.GETTEXT_PACKAGE);
        context.add_group (Gtk.get_option_group (true));
        context.add_group (Clutter.get_option_group ());        

        try{
            context.parse (ref args);
        }
        catch (GLib.OptionError e){
            stdout.printf ("%s\n", e.message);
            stdout.printf ("Run '%s --help' to see a full list of available command line options.\n", args[0]);
            return 0;
        }

        if (show_version) {
            stdout.printf ("%s\n", Config.PACKAGE_STRING);
            return 0;
        }
        
        
        /* Resources & Theme */
        var preferences = new Puzzle.Preferences ();
        //preferences.load ();
        //g_set_application_name (_("Gurilla"));
        
    
        print ("Features:\n");
        print (" * Sync to VBlank: %s\n", Clutter.FeatureFlags.SYNC_TO_VBLANK.is_available () ? "yes" : "no");
        print (" * Shaders GLSL: %s\n", Clutter.FeatureFlags.SHADERS_GLSL.is_available () ? "yes" : "no");
        print (" * Stage cursor: %s\n", Clutter.FeatureFlags.STAGE_CURSOR.is_available () ? "yes" : "no");
        print (" * Multiple stages: %s\n", Clutter.FeatureFlags.STAGE_MULTIPLE.is_available () ? "yes" : "no");
        print (" * Stage user resize: %s\n", Clutter.FeatureFlags.STAGE_USER_RESIZE.is_available () ? "yes" : "no");
        print ("\n");
  
        /* Game */
        var game = new Puzzle.Game ();
  
        /* Window */
        var window = new Puzzle.Window (game);

        
        game.new_game ("file:///home/user/Projects/My/Puzzle/image.jpg");

        
        //window.destroy.connect (Gtk.main_quit);
        //window.destroy.connect (application.quit); // no need for that.. done automaticaly

    /*
        if (uris.length == 0)
        {
            // TODO: Set dir from Preferences
            window.uris.prepend (Environment.get_user_special_dir (GLib.UserDirectory.PICTURES));
        }
        else
        {
            foreach (var uri in uris) {
                window.uris.prepend (uri);
            }
        }
    */
        //window.set_application (application);
        application.add_window (window);
        
        window.show ();
 
        //window.present ();        
//        Gtk.main ();
 
        application.run ();
       
        return 0;
    }

}
