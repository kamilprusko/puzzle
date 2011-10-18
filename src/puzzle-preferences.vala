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

public class Puzzle.Preferences : Object //: Gtk.Dialog
{
    /* Paths */
    public string default_uri { get; set; }

    /* Gaming */
    public bool   animations { get; set; default=true; }
    public bool   gestures   { get; set; default=true; }
    public bool   physics    { get; set; default=true; }

    public uint   pieces_limit  { get; set; default=300; }
    public uint   edges_limit   { get; set; default=20; }
    public bool   rotations     { get; set; default=true; }
    public uint   snap_distance { get; set; default=11; }    
    
    /* Appearence */
    public Clutter.Color background_color { get; set; }
    public Clutter.Color border_color     { get; set; }
    public bool   highlights       { get; set; default=true; }
    public bool   shadows          { get; set; default=true; }

    /* Window */
    public bool   start_with_toolbar { get; set; default=true; }
 
    private Gtk.Builder builder;

    construct {
        Preferences.instance = this;
        
        this.background_color = Clutter.Color.from_pixel (0x222222FF);
        this.border_color     = Clutter.Color.from_pixel (0x11111133);        
        this.revert_default_uri ();
        
        this.builder = new Gtk.Builder ();
    }

    private static weak Preferences instance;

    public static Preferences get_default () {
        return Preferences.instance;
    }


    
    private void revert_default_uri ()
    {
        string[] uris = {
                Environment.get_user_special_dir (GLib.UserDirectory.PICTURES),
                Environment.get_home_dir ()
                };
        
        foreach (var uri in uris)
        {
            try
            {
                this.default_uri = Filename.to_uri (uri);
                break;
            }
            catch (GLib.ConvertError e)
            {
                //warning (e.message);
            }
        }
    }

    public bool load ()
    {
        return false;
    }

    public bool save ()
    {
        return false;
    }
    
    
    private Gtk.Dialog dialog;

    
    private Gtk.Dialog? create_dialog ()
    {
        Gtk.Dialog      dialog = null;

        Gtk.HBox        placeholder;
        Gtk.SizeGroup   sizegroup;
        Gtk.ColorButton colorbutton;
 
        var binding_flags = BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE;

        try
        {
            builder.add_from_file ("/home/user/Projects/My/Puzzle/data/ui/puzzle-preferences.ui");
            //builder.add_from_file ("/home/user/Projects/My/Puzzle/data/ui/puzzle-preferences.ui");
            
            dialog = builder.get_object ("preferences-dialog") as Gtk.Dialog;
            dialog.response.connect (this.on_dialog_response);
            
            /* Game Tab */
            {
                var pieces_adjustment    = builder.get_object ("pieces-limit-adjustment") as Gtk.Adjustment;
                var edges_adjustment     = builder.get_object ("edges-limit-adjustment") as Gtk.Adjustment;
                var rotation_switch      = new Gtk.Switch ();
                var folder_button        = builder.get_object ("folder-filechooserbutton") as Gtk.FileChooserButton;
                var folder_revert_button = builder.get_object ("folder-revert-button") as Gtk.Button;

                this.bind_property ("pieces-limit",
                                    pieces_adjustment, "value", binding_flags);
                this.bind_property ("edges-limit",
                                    edges_adjustment, "value", binding_flags);
                this.bind_property ("rotations",
                                    rotation_switch, "active", binding_flags);

                placeholder = builder.get_object ("rotations-switch") as Gtk.HBox;
                placeholder.pack_start (rotation_switch, false, false);

                sizegroup = builder.get_object ("game-sizegroup") as Gtk.SizeGroup;
                sizegroup.add_widget (builder.get_object ("pieces-limit-hscale") as Gtk.Widget);
                sizegroup.add_widget (builder.get_object ("edges-limit-hscale") as Gtk.Widget);

                folder_revert_button.clicked.connect (this.revert_default_uri);

                folder_button.set_uri (this.default_uri); /* TODO: Make binding between folder_button & this.default_uri */
                folder_button.file_set.connect (() => {  // on 'Open' button
                    this.default_uri = folder_button.get_uri();
                   });
                folder_button.current_folder_changed.connect (() => { // on selecting via combobox
                    this.default_uri = folder_button.get_uri();
                });
                this.notify["default-uri"].connect (() => {
                        //SignalHandler.block_by_func (folder_button, this.on_dialog_folder_filechooserbutton_changed);
                        //Signal.stop_emission_by_name (this, "notify::dafault-uri");
                    if (folder_button.get_uri() != this.default_uri) // prevent from recursion
                        folder_button.set_uri (this.default_uri);
                        //SignalHandler.unblock_by_func (folder_button, this.on_dialog_folder_filechooserbutton_changed);
                });
            }
            
            /* Appearance Tab */
            {
                var animations_switch      = new Gtk.Switch ();
                var gestures_switch        = new Gtk.Switch ();
                var physics_switch         = new Gtk.Switch ();
                var background_colorbutton = builder.get_object ("background-colorbutton") as Gtk.ColorButton;
                var border_colorbutton     = builder.get_object ("border-colorbutton") as Gtk.ColorButton;

                this.bind_property ("animations",
                                    animations_switch, "active", binding_flags);
                this.bind_property ("gestures",
                                    gestures_switch, "active", binding_flags);
                this.bind_property ("physics",
                                    physics_switch, "active", binding_flags);

                placeholder = builder.get_object ("animations-switch") as Gtk.HBox;
                placeholder.pack_start (animations_switch, false, false);

                placeholder = builder.get_object ("gestures-switch") as Gtk.HBox;
                placeholder.pack_start (gestures_switch, false, false);

                placeholder = builder.get_object ("physics-switch") as Gtk.HBox;
                placeholder.pack_start (physics_switch, false, false);



                colorbutton = builder.get_object ("background-colorbutton") as Gtk.ColorButton;
                this.bind_property ("background-color", 
                            colorbutton, "rgba", binding_flags);
//                colorbutton.set_rgba (
//                                gdk_rgba_from_pixel(this.background_color.to_pixel())
//                                );
//                colorbutton.color_set.connect (() => {
//                    this.background_color = Clutter.Color.from_pixel (gdk_rgba_get_pixel(colorbutton.rgba));
//                    });


                colorbutton = builder.get_object ("border-colorbutton") as Gtk.ColorButton;
                this.bind_property ("border-color", 
                            colorbutton, "rgba", binding_flags);
//                colorbutton.set_rgba (
//                                gdk_rgba_from_pixel(this.border_color.to_pixel())
//                                );
//                colorbutton.color_set.connect (() => {
//                    this.border_color = Clutter.Color.from_pixel (gdk_rgba_get_pixel(colorbutton.rgba));
//                    });
            }

            /* Show all */
            var notebook = builder.get_object ("notebook") as Gtk.Notebook;
            notebook.show_all ();

            /* TODO: Fix response_ids in .ui file to Gtk.ResponseType.CLOSE & Gtk.ResponseType.HELP
             *       ..currently using application specific ids
             */
        }
        catch (Error e)
        {
            critical (e.message);
        }
        
        return dialog;
    }

        
    private void on_dialog_response (int response_id)
    {
        switch (response_id)
        {
            case Gtk.ResponseType.HELP:
            case 1:
                    /* TODO: open Help */
                    print ("Show help\n");
                    break;
            
            case Gtk.ResponseType.CLOSE:
            case Gtk.ResponseType.DELETE_EVENT:
            case 2:
                    this.dialog.destroy ();
                    this.dialog = null;
                    //dialog.hide ();
                    break;
        }
    }
    
    
    public void show_dialog (Gtk.Window? parent_window)
    {
        if (this.dialog == null)
            this.dialog = this.create_dialog ();
        
        if (this.dialog != null)
        {
            this.dialog.set_transient_for (parent_window);
            //this.dialog.show_all ();
            this.dialog.present ();
        }
    }

}
