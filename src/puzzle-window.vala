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

public class Puzzle.Window : Gtk.Window
{
//    private Clutter.Actor    scene;

    private Gtk.Adjustment vadjustment;
    private Gtk.Adjustment hadjustment;
    private Gtk.MenuBar    menubar;
    private Gtk.Toolbar    toolbar;

    private Gtk.UIManager   ui_manager;
    private Gdk.WindowState window_state;

    private GLib.Timer timer; //{ get; set }
//    public  GLib.List<string> uris; //{ get; set }

    public Gtk.ActionGroup action_group;

//    public Puzzle.Canvas canvas;
    public GtkClutter.Embed canvas;

    public Puzzle.Viewport viewport;


/*
    private void on_settings_fullscreen (Gtk.Action action)
    {
    }
    private void on_settings_preferences (Gtk.Action action)
    {
    }
*/
    /* Actions */
    // TODO: Mark fields for translation
    private const Gtk.ActionEntry[] ACTION_ENTRIES = {
        { "game", null, "_Game" },
        { "game-new", Gtk.Stock.NEW, "_New Game", "<Ctrl>N", null, on_game_new },
        { "game-shuffle", null, "_Shuffle", null, null, on_game_shuffle },
        { "game-pause", Gtk.Stock.MEDIA_PAUSE, "_Pause", "Pause", null, on_game_pause },
        { "game-resume", Gtk.Stock.MEDIA_PLAY, "_Resume", "Pause", null, on_game_pause },
        { "game-quit", Gtk.Stock.QUIT, "_Quit", "<Ctrl>Q", null, on_game_quit },

        { "settings", null, "_Settings" },
        { "fullscreen", Gtk.Stock.FULLSCREEN, "_Fullscreen", "F11", null, on_settings_fullscreen },
        { "leave-fullscreen", Gtk.Stock.LEAVE_FULLSCREEN, "Leave _Fullscreen", "F11", null, on_settings_fullscreen },
        
        { "preferences", Gtk.Stock.PREFERENCES, "_Preferences", null, null, on_settings_preferences },

        { "help", null, "_Help" },
        { "help-about", Gtk.Stock.ABOUT, "_About", null, null, on_help_about },
        { "help-contents", Gtk.Stock.HELP, "_Contents", "F1", null, on_help_contents }
        
//        { "Copy", Gtk.Stock.COPY, "_Copy Photo Location", "<Ctrl>C", null, on_copy_action },
//        { "OpenWith", Gtk.Stock.OPEN, "Open _with", null, "Open the selected photo(s) with different application", on_open_with_action },
//        { "Print", Gtk.Stock.PRINT, "_Print...", "<Ctrl>P", "Print the selected photo(s)", on_print_action },
//        { "RotateLeft", Resources.STOCK_ROTATE_LEFT, "Rotate _Left", null, null, on_rotate_left_action },
//        { "RotateRight", Resources.STOCK_ROTATE_RIGHT, "Rotate _Right", null, null, on_rotate_right_action },
//        { "Remove", Resources.STOCK_NONE, "Move to _Trash", "Delete", null, on_remove_action },
//        { "TagAdd", Gtk.Stock.ADD, "_Attach Tag", null, null, on_tag_add_action },
//        { "TagRemove", Gtk.Stock.REMOVE, "Remo_ve Tag", null, null, on_tag_remove_action },
//        { "Reload", Gtk.Stock.REFRESH, "_Reload", "<Ctrl>R", null, on_reload_action },
//        { "SelectAll", Resources.STOCK_NONE, "Select _All", "<Ctrl>A", null, on_select_all_action },
//        { "Deselect", Resources.STOCK_NONE, "Deselect _All", "<Ctrl><Shift>A", null, on_deselect_action },
//        { "Order", Resources.STOCK_NONE, "Arran_ge Items", null, null, null },

/*
        { "ZoomIn", Gtk.Stock.ZOOM_IN, "Zoom _In", "<Ctrl>plus", null, zoom_in },
        { "ZoomOut", Gtk.Stock.ZOOM_OUT, "Zoom _Out", "<Ctrl>minus", null, zoom_out },
        { "ZoomNormal", Gtk.Stock.ZOOM_100, "Normal Si_ze", "<Ctrl>0", null, zoom_normal },

        { "CtrlEqual", Gtk.Stock.ZOOM_IN, "Zoom _In", "<Ctrl>equal", null, zoom_in },
        { "CtrlUnderscore", Gtk.Stock.ZOOM_OUT, "Zoom _Out", "<Ctrl>underscore", null, zoom_out },
        { "CtrlKpAdd", Gtk.Stock.ZOOM_IN, "Zoom _In", "<Ctrl>KP_Add", null, zoom_in },
        { "CtrlKpSub", Gtk.Stock.ZOOM_OUT, "Zoom _Out", "<Ctrl>KP_Subtract", null, zoom_out }
*/


        /*
        { "CommonQuit", Gtk.Stock.QUIT, "_Quit", "<Ctrl>Q", "Quit Shotwell", on_quit },
        { "CommonAbout", Gtk.Stock.ABOUT, "_About", null, "About Shotwell", on_about },
        { "CommonFullscreen", Gtk.Stock.FULLSCREEN, "_Fullscreen", "F11", "Use Shotwell at fullscreen", on_fullscreen },
        { "CommonFileImport", Resources.IMPORT, "_Import From Folder...", "<Ctrl>I", "Import photos from disk to library",  on_file_import },
        { "CommonSortEvents", null, "Sort _Events", null, null, on_sort_events },
        { "CommonHelpContents", Gtk.Stock.HELP, "_Contents", "F1", "More informaton on Shotwell", 
          on_help_contents }
        */    
    };

    private const Gtk.ToggleActionEntry[] TOGGLE_ACTION_ENTRIES = {
        { "toggle-toolbar", null, "Show _Toolbar", null, null, on_settings_toolbar_toggle, false },
        { "toggle-scrollbars", null, "Show _Scrollbars", null, null, on_settings_scrollbars_toggle, true }
    //    { "Reverse", null, "Re_versed Order", null, "Sort photos in reverse order", on_order_reverse_action, false }
    };

//    private const Gtk.RadioActionEntry[] ORDER_BY_ACTION_ENTRIES = {
//        { "Filename", null, "By _Filename", null, "Sort photos by filename", OrderType.FILENAME },
//        { "Size", null, "By _Size", null, "Sort photos by size", OrderType.SIZE },
//        { "Type", null, "By _Type", null, "Sort photos by type", OrderType.TYPE },
//        { "DateCreated", null, "By _Creation Date", null, "Sort photos by creation date", OrderType.DATE_CREATED },
//        { "DateModified", null, "By _Modification Date", null, "Sort photos by modification date", OrderType.DATE_MODIFIED }
//    };

    /* Target Entries for Drag & Drop */
    private const Gtk.TargetEntry[] TARGET_ENTRIES = {
        { "text/uri-list", 0, 0 }
    };

    private float _zoom = 1.0f;

    private float[] zoom_steps = {
        0.5f, 0.6666f, 1.0f, 1.5f, 2.0f, 3.0f, 4.0f
    };


    /*
     * Constructors
     */
    construct {
    }
        
        
    public Game game { get; private set; }
    
    public Window (Puzzle.Game game)
    {    
        // These should be set by Gtk.Application..
        this.title = _(Config.PACKAGE_FULL_NAME);
        this.icon_name = Config.PACKAGE_NAME;

        this.set_default_size (900, 600);
        //this.position = WindowPosition.CENTER;

        //this.setup_menu();

        //this.uris = new List<string> ();
        
     
        this.game = game;
        
        
        /* Scrollbars */
        //this.vadjustment = new Gtk.Adjustment (0.0, 0.0, 0.0, 1.0, 1.0, 0.0);
        //this.hadjustment = new Gtk.Adjustment (0.0, 0.0, 0.0, 1.0, 1.0, 0.0);

        /* Clutter */

        /* Menus */
        var action_group = new Gtk.ActionGroup ("main");        
        action_group.add_actions (ACTION_ENTRIES, this);
        //action_group.add_radio_actions (ORDER_BY_ACTION_ENTRIES, OrderType.FILENAME, on_order_changed_action);
        action_group.add_toggle_actions (TOGGLE_ACTION_ENTRIES, this);
        
        var ui_manager = new Gtk.UIManager ();

        try {
            ui_manager.add_ui_from_file ("/home/user/Projects/My/Puzzle/data/ui/puzzle-window-ui.xml"); // TODO
            //manager.add_ui_from_file (PACKAGE_DATADIR + "/ui/puzzle-window-ui.xml");
        }
        catch (GLib.Error e) {
            error ("Internal error: Couldn't create UIManager. %s", e.message);
        }

        ui_manager.insert_action_group (action_group, 0);



        this.add_accel_group (ui_manager.get_accel_group ());
        this.ui_manager = ui_manager;

//        if (true)
//        {
//            var action1 = action_group.get_action ("Fullscreen");
//            var action2 = action_group.get_action ("Leave Fullscreen");
//            action1.bind_property ("visible", action2, "visible", BindingFlags.INVERT_BOOLEAN);
//        }

        this.action_group = action_group;
        
        /* Set Toggle Actions */
//        var action = action_group.get_action ("Toolbar") as Gtk.ToggleAction;
//        //action.bind_property ("active", this.toolbar, "visible", BindingFlags.BIDIRECTIONAL);
//        this.toolbar.bind_property ("visible", action, "active", BindingFlags.BIDIRECTIONAL);
//        //action.active = this.toolbar.visible;

        
        
        this.menubar = ui_manager.get_widget ("/ui/menubar") as Gtk.MenuBar;
        this.menubar.show();

//        this.toolbar = ui_manager.get_widget ("/ui/toolbar") as Gtk.Toolbar;
//        this.toolbar.set_no_show_all (true);
//        this.toolbar.hide ();
//                
        this.unfullscreen ();


//        var view = new GtkClutter.Embed ();
//        view.has_focus = true;
//        this.view.set_size_request (900, 600);
//        this.view.show();

        


//        private bool on_configure_event (Gdk.EventConfigure event)
//        {
//            //base.configure_event (event);
//            
//            //Gtk.Allocation allocation;
//            //this.get_allocation (out allocation);
//            
//            //if ((event.width != this._width) || (event.height != this._height))
//                print ("Resized: %dx%d\n", event.width, event.height); 
//            
//            return true; /* TODO: why 'false'? */
//        }


//        view.allocation_changed.connect (() => {
//            
//        });


        this.canvas = new GtkClutter.Embed ();
//        this.canvas = new Puzzle.Canvas ();
        this.setup_canvas (this.canvas);
        this.canvas.has_focus = true;
        this.canvas.show ();


        this.viewport = new Puzzle.Viewport ();
        this.viewport.set_position (50.0f, 50.0f);

        var vscrollbar = new Gtk.Scrollbar (Gtk.Orientation.VERTICAL, viewport.vadjustment);
        var hscrollbar = new Gtk.Scrollbar (Gtk.Orientation.HORIZONTAL, viewport.hadjustment);

        vscrollbar.show ();
        hscrollbar.show ();

//        var x_adjustment = new Gtk.Adjustment (0.0, -1000.0, 1000.0, 1.0, 100.0, 0.0);
//        var y_adjustment = new Gtk.Adjustment (0.0, -1000.0, 1000.0, 1.0, 100.0, 0.0);
//        var z_adjustment = new Gtk.Adjustment (1.0, 0.5, 2.0, 0.5, 1.0, 0.0);

        var table = new Gtk.Table (2, 2, false);
        table.attach (this.canvas,
                        0, 1,
                        0, 1,
                        Gtk.AttachOptions.EXPAND | Gtk.AttachOptions.FILL,
                        Gtk.AttachOptions.EXPAND | Gtk.AttachOptions.FILL,
                        0, 0);
        table.attach (vscrollbar,
                        1, 2,
                        0, 1,
                        0, Gtk.AttachOptions.EXPAND | Gtk.AttachOptions.FILL,
                        0, 0);
        table.attach (hscrollbar,
                        0, 1,
                        1, 2,
                        Gtk.AttachOptions.EXPAND | Gtk.AttachOptions.FILL, 0,
                        0, 0);
        table.show ();
        


        var vbox = new Gtk.VBox (false, 0);
        vbox.pack_start (this.menubar, false, false);
        vbox.pack_start (this.toolbar, false, false);
        vbox.pack_start (table, true, true);
//        vbox.pack_start (canvas, true, true);
        vbox.show();

        

        this.add (vbox);




        /* Stage */    

        /* Events */
        //this.focus_in_event.connect (on_focus_in_event);
        //this.focus_out_event.connect (on_focus_out_event);
        this.button_press_event.connect (on_button_press_event);
        //this.button_release_event.connect (on_button_release_event);
//        this.key_press_event.connect (on_key_press_event);
        //this.key_release_event.connect (on_key_release_event);
//        this.scroll_event.connect (on_scroll_event);        
        //this.motion_notify_event.connect (on_motion_notify_event);
//        this.popup_menu.connect (on_popup_menu);

        this.delete_event.connect (this.on_delete_event);
        this.screen_changed.connect (this.on_screen_changed);

        this.window_state_event.connect ((event) => {
            this.window_state = event.new_window_state;
            if ((event.changed_mask &
                (Gdk.WindowState.MAXIMIZED | Gdk.WindowState.FULLSCREEN)) != 0)
            {
                bool fullscreen = ((event.new_window_state &
                           (Gdk.WindowState.MAXIMIZED | Gdk.WindowState.FULLSCREEN)) != 0);
                
                /* TODO: hide action Fulscreen & show action Leave Fullscreen */
                
            //    this.statusbar.set_has_resize_grip (!fullscreen);
            //    this.config_manager.set_boolean ("General", "full-screen", fullscreen);
            }
            return false;
        });
        
        // XXX: should these be in Puzzle.init() ?!
//        Gtk.AboutDialog.set_url_hook (this.on_about_link);
//        Gtk.AboutDialog.set_email_hook (this.on_about_link);

        Gtk.drag_dest_set (this, Gtk.DestDefaults.ALL, TARGET_ENTRIES, Gdk.DragAction.COPY);
        //this.connect ("drag-data-received", this.drag_data_received)

//        this.add_events (//Gdk.EventMask.FOCUS_CHANGE_MASK
//                        Gdk.EventMask.BUTTON_PRESS_MASK
//                        | Gdk.EventMask.BUTTON_RELEASE_MASK
//                        | Gdk.EventMask.KEY_PRESS_MASK
//                        | Gdk.EventMask.KEY_RELEASE_MASK
//                        | Gdk.EventMask.POINTER_MOTION_MASK
//                        | Gdk.EventMask.SCROLL_MASK
//                        //| Gdk.EventMask.STRUCTURE_MASK
//                        );

        /* Run */
//        this.set_size (256);

//        stage.allocation_changed.connect ((allocation, flags) => {    
//            //this.zoom = this.zoom;
//
//            /* Rearrange grid */
//            this.size_changed ();
//        });


        var stage = this.canvas.get_stage () as Clutter.Stage;

        stage.allocation_changed.connect ((box, flags) =>
        {
//           this.viewport.allocate_available_size (
//                    Math.roundf (box.x1),
//                    Math.roundf (box.y1),
//                    Math.roundf (box.x2 - box.x1),
//                    Math.roundf (box.y2 - box.y1),
//                    flags //Clutter.AllocationFlags.ABSOLUTE_ORIGIN_CHANGED
//                    );
            this.viewport.allocate_child (box, flags);
            
//            print ("%f, %f, %f, %f\n", box.x1, box.y1, box.x2, box.y2);
//            var geometry = Clutter.Geometry () {
//                    x      = (int) Math.round (box.x1),
//                    y      = (int) Math.round (box.y1),
//                    width  = (int) Math.round (box.x2 - box.x1),
//                    height = (int) Math.round (box.y2 - box.y1)
//                    };
//            
//            this.viewport.set_geometry (geometry);
        });


        /* Background */        
        var preferences = Puzzle.Preferences.get_default ();
        preferences.bind_property ("background-color",
                stage, "color", BindingFlags.SYNC_CREATE
                );

        
        /* Viewport */
/* XXX
        var rect = new Clutter.Rectangle.with_color (
                Clutter.Color.from_string ("#CC0000")
                );
        rect.set_size (400, 400);
        this.canvas.viewport.add_actor (rect);
*/
//      stage.allocation_changed (ActorBox p0, AllocationFlags p1)

//        var group = new Clutter.Group ();
//        stage.add_actor (group);


        stage.add_actor (this.viewport);

//        stage.reactive = true;
//        stage.scroll_event.connect ((event) => {
//            
//            if ((event.modifier_state & Clutter.ModifierType.CONTROL_MASK) > 0)
//            {
//                /* Zoom */
////                if ((event.modifier_state & Clutter.ModifierType.BUTTON4_MASK) > 0)
////                    print ("Zoom In\n");

////                if ((event.modifier_state & Clutter.ModifierType.BUTTON5_MASK) > 0)
////                    print ("Zoom Out\n");
//                
//            }
//            else
//            {
//                /* Pan */
//                switch (event.direction)
//                {
//                    case Clutter.ScrollDirection.UP:
//                            this.viewport.vadjustment.value -= this.viewport.vadjustment.get_step_increment();
//                            break;

//                    case Clutter.ScrollDirection.DOWN:
//                            this.viewport.vadjustment.value += this.viewport.vadjustment.get_step_increment();
//                            break;

//                    case Clutter.ScrollDirection.LEFT:
//                            this.viewport.hadjustment.value -= this.viewport.hadjustment.get_step_increment();
//                            break;

//                    case Clutter.ScrollDirection.RIGHT:
//                            this.viewport.hadjustment.value += this.viewport.hadjustment.get_step_increment();
//                            break;
//                }
//            }

//            //if (event.modifier_state == Clutter.ModifierType.BUTTON4_MASK)
//            
//            return true;
//        });
        
        
        game.started.connect (() => {
            
            this.viewport.child = game.stage;
            //var container = this.viewport.child as Clutter.Group;
            
//            for (var i=0; i < game.pieces.length; i++)
//            {
//                var group = new Puzzle.Group ();
//                group.add_actor (game.pieces[i]);
//                
//                container.add_actor (group);
//            }
        });


/*
        view.allocation_changed.connect ((box, flags) => {
            if self.temp_height != allocation.height or self.temp_width != allocation.width:
                self.temp_height = allocation.height
                self.temp_width = allocation.width
            print ("Embed size: %gx%g\n", box.x2, box.y2);             
        });        
            
        allocation = widget.get_allocation()
        if self.temp_height != allocation.height or self.temp_width != allocation.width:
            self.temp_height = allocation.height
            self.temp_width = allocation.width
            pixbuf = self.pixbuf.scale_simple(allocation.width, allocation.height, gtk.gdk.INTERP_BILINEAR)
            widget.set_from_pixbuf(pixbuf)
*/          


//            preferences.notify["background-color"].connect (() => {
//                stage.color = preferences.background_color; 
//                });
            
            
            

//            var viewport = new GtkClutter.Viewport (x_adjustment, y_adjustment, z_adjustment);
//            //var viewport = new GtkClutter.Viewport (null, null, null);
//            viewport.set_size (320f, 240f);
//            stage.add_actor (viewport);

            //this.zoom = 1.0f;
            //this.run ();
//        });


//        
//        this.vadjustment.value_changed.connect (() => {
//            print ("Vertical %g\n", this.vadjustment.value);
//        });
        
    //    this.hadjustment.value_changed.connect (() => {
    //        print ("Horizontal %g\n", this.vadjustment.value);
    //    });
    }



//    public unowned GLib.File get_current_folder ()
//    {
//    }
    
//    public bool set_current_folder (string path)
//    {
//    }

//    public bool set_current_folder_uri (string uri)
//    {
//    }

    
    private void setup_canvas (GtkClutter.Embed canvas)
    {
        canvas.add_events (Gdk.EventMask.FOCUS_CHANGE_MASK
                        | Gdk.EventMask.BUTTON_PRESS_MASK
                        | Gdk.EventMask.BUTTON_RELEASE_MASK
                        | Gdk.EventMask.KEY_PRESS_MASK
                        | Gdk.EventMask.KEY_RELEASE_MASK
                        | Gdk.EventMask.SCROLL_MASK
                        //| Gdk.EventMask.STRUCTURE_MASK
                        );    

//        canvas.configure_event.connect (this.on_configure_event);
//        canvas.button_press_event.connect (this.on_button_press);
        //this.button_release_event.connect (this.on_button_release);
        //this.focus_in_event.connect (on_focus_in_event);
        //this.focus_out_event.connect (on_focus_out_event);
//        this.key_press_event.connect (on_key_press_event);
        //this.key_release_event.connect (on_key_release_event);
//        this.scroll_event.connect (on_scroll_event);        
//        this.popup_menu.connect (on_popup_menu);
    }
      

//    double mouse_x;
//    double mouse_y;

//    private List<Gdk.Cursor> cursor_stack;

    private bool on_configure_event (Gtk.Widget widget, Gdk.EventConfigure event)
    {
        if (this.viewport.width  != event.width ||
            this.viewport.height != event.height)
        {
//            var allocation = Clutter.ActorBox () {x1=0.0f, y1=0.0f, x2=event.width, y2=event.height};

//            this.viewport.set_size (event.width, event.height);
//            this.viewport.allocate (allocation, Clutter.AllocationFlags.ABSOLUTE_ORIGIN_CHANGED);
            //this.viewport.allocate (allocation, Clutter.AllocationFlags.ALLOCATION_NONE);
            
//            var geometry = Clutter.Geometry() {
//                    x = 0,
//                    y = 0,
//                    width = event.width,
//                    height = event.height
//                    };
//            
//            this.viewport.set_geometry (geometry);

//            this.viewport.set_size (event.width, event.height);
        }
        return false;        
    }

    private bool on_button_press_event (Gtk.Widget widget, Gdk.EventButton event)
    {
        /* Ignore double-clicks and triple-clicks */

//        if ((event.button == 3) && (event.type == Gdk.EventType.BUTTON_PRESS))
//        {
//            this.do_popup_menu (event);
//            return true; // Event has been handled.
//        }

        
        if (event.type == Gdk.EventType.BUTTON_PRESS)
        {
            /* Middle button -- Pan */
            if (event.button == 2)
            {
                /*
                var action         = this.viewport.start_drag_action ();
                var default_cursor = event.window.get_cursor();

                action.drag_begin.connect (() => {
                    event.window.set_cursor (new Gdk.Cursor (Gdk.CursorType.FLEUR));
                });

                action.drag_end.connect (() => {
                    event.window.set_cursor (default_cursor);
                });*/                
            }
        }      
        return false;
    }

//    private bool on_button_release (Gdk.EventButton event)
//    {
//        return true;
//    }



    public bool on_motion_notify (Gdk.EventMotion event)
    {
        //if (this.selected == null)
        //    return false;
        
        //if ((bool)(event.modifier_state & Clutter.ModifierType.BUTTON1_MASK))

        //if ((event.button == 3) || (event.button == 1)) // if middle button or if no hit and left mouse button
        {
//            var dx = (event.x - mouse_x);
//            var dy = (event.y - mouse_y);
            
            //this.viewport.translate ()  TODO
            //(this.hscrollbar as Gtk.Scrollbar).get_adjustment ().value += dx;
            //(this.hscrollbar as Gtk.Scrollbar).get_adjustment ().value += dy;
            
/* FIXME            
            this.viewport.x_orgin -= (float) dx;
            this.viewport.y_orgin -= (float) dy;
            
            this.viewport.queue_redraw ();
            //print ("Pan %g, %g\n", dx, dy);
*/
        }
        
        //if (event.button == 1)
        {
        //    this.selected.x += (float) (event.x - mouse_x);
        //    this.selected.y += (float) (event.y - mouse_y);
//            mouse_x = event.x;
//            mouse_y = event.y;
            //this.selected.queue_redraw ();
            //this.queue_draw ();
            //this.queue_redraw ();
        }

        this.queue_draw ();
        return false;
    }


    public bool on_button_release (Gdk.EventButton event)
    {
        this.motion_notify_event.disconnect (this.on_motion_notify);
        this.button_release_event.disconnect (this.on_button_release);

        //

        //var display = this.get_display();
        //var window = this.get_window();
//        var cursor = this.cursor_stack.data as Gdk.Cursor;

        //if (cursor.cursor_type == Gdk.CursorType.FLEUR)
        //{
//            this.cursor_stack.remove (cursor);
//            event.window.set_cursor (
//                    this.cursor_stack.data as Gdk.Cursor
//                    );
        //}

        //this.selected = null;
        //this.motion_notify_event.disconnect (this.on_motion_notify_event);
        //this.button_release_event.disconnect (this.on_button_release_event);
        return false;
    }


    private bool on_scroll_event (Gdk.EventScroll event)
    {
        //var stage = this.viewport.get_stage ();

        //if (stage != null)
        //{
            if ((event.state & Gdk.ModifierType.CONTROL_MASK) > 0)
            {
                /* Zoom */
            //    if (event.direction == Gdk.ScrollDirection.UP)
            //        this.zoom_in ();
                
            //    if (event.direction == Gdk.ScrollDirection.DOWN)
            //        this.zoom_out ();
            }
            else
            {
                /* Scroll */
            //    if (event.direction == Gdk.ScrollDirection.UP)
            //        this.scroll_by (-60);

            //    if (event.direction == Gdk.ScrollDirection.DOWN)
            //        this.scroll_by (60);
                    //this.page.animate (AnimationMode.LINEAR, 80,
                    //        y: Math.round (this.page.y + 60)
                    //        );
            }
            
            return true;
        //}
        return false;
    }

















    /*
     * Game functions
     */
    
    public void open_uri (string uri)
    {
    }

//    public unowned GLib.List<Clutter.Actor> get_selection ()
//    {
//        return null;
//    }


    /*
     * Window functions
     */  
    public bool is_fullscreen ()
    {
        return ((this.window_state & Gdk.WindowState.FULLSCREEN) != 0);
    }

    public new void fullscreen ()
    {
        if (!this.is_fullscreen ())
            base.fullscreen ();
        
        var action1 = this.action_group.get_action ("fullscreen");            
        var action2 = this.action_group.get_action ("leave-fullscreen");
        action1.visible = false;
        action2.visible = true;

        this.menubar.hide ();
        this.toolbar.hide ();
    }

    public new void unfullscreen ()
    {
        if (this.is_fullscreen ())
            base.unfullscreen ();

        var action1 = this.action_group.get_action ("fullscreen");
        var action2 = this.action_group.get_action ("leave-fullscreen");            
        action1.visible = true;
        action2.visible = false;

        this.menubar.show ();

        var action3 = this.action_group.get_action ("toggle-toolbar") as Gtk.ToggleAction;
        if (action3.active)
            this.toolbar.show ();
    }

    public void show_popup_menu (Gdk.EventButton? event)
    {
    }
    
    public void show_uri (string url)
    {
        try {
            Gtk.show_uri (this.get_screen(), url, Gdk.CURRENT_TIME);
        } catch (Error e) {
            critical("Unable to load URL: %s", e.message);
        }
    }

    public void show_about_dialog ()
    {

//"Totem contains an exception to allow the use of proprietary GStreamer plugins."


//            "Puzzle! is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.\n\n"

//            "You should have received a copy of the GNU General Public License along with Puzzle!; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA"

//"Totem contains an exception to allow the use of proprietary GStreamer plugins."


        //Gtk.show_about (this, this);
        Gtk.show_about_dialog (this,
            "title",          _("About Puzzle!"),
            "program-name",   Config.PACKAGE_FULL_NAME,
            "authors",        Puzzle.AUTHORS,
            "comments",       _("...a small, time wasting game for GNOME desktop."),
            "copyright",      Puzzle.COPYRIGHT, //"Copyright © 2011 Kamil Prusko",
            "documenters",    Puzzle.DOCUMENTERS,
            "license",        Puzzle.LICENSE,
            "wrap-license",   true,
            "logo_icon_name", Config.PACKAGE_NAME,
            "translator-credits", _("translator-credits"),
            //"version",        Config.VERSION,
            "website",        _("http://kamilprusko.org/puzzle/"),
            "website-label",  _("Puzzle! Website"),
            null
            );
    }

    public void show_preferences_dialog ()
    {
        var preferences = Puzzle.Preferences.get_default();
        preferences.show_dialog (this);
    }

    private void set_busy_cursor() {
        //this.window.set_cursor (new Gdk.Cursor(Gdk.CursorType.WATCH));
    }

    private void set_normal_cursor() {
        //this.window.set_cursor (new Gdk.Cursor(Gdk.CursorType.ARROW));
    }



//    private async void list_directory ()
//    {
//    }

//    public float zoom { get; set }

    private void zoom_in ()
    {
    }

    private void zoom_out ()
    {
    }

    private void zoom_normal ()
    {
    }




    /*
     * Window Events
     */
    /* If screen changes, it could be possible we no longer got rgba colors */
    private void on_screen_changed (Gdk.Screen? previous_screen)
    {
    }
     
    private void on_map ()
    {
    }

    private void on_size_changed ()
    {    
    }
    
    private void on_drag_data_received (Gdk.DragContext context, int x, int y,
                                              Gtk.SelectionData selection_data, uint info, uint time)
    {
    }

    private bool on_delete_event () //Gdk.Event event)
    {
        return false; /* TODO */
    }

    /* This callback needs to be installed for the links to be active in the About dialog.
     * However, it doesn't actually have to do anything in order to activate the URL. */
    private void on_about_link (Gtk.AboutDialog about_dialog, string url) {
    }


    /*
     * Mouse & Keyboard
     */
    private bool on_key_press_event (Gdk.EventKey event)
    {
        return false; /* TODO */
    }

    private bool on_key_release_event (Gdk.EventKey event)
    {
        return false; /* TODO */
    }    

//    private bool on_button_press_event (Gdk.EventButton event)
//    {
//        /* TODO
//        /* Ignore double-clicks and triple-clicks *
//        if ((event.button == 3) && (event.type == Gdk.EventType.BUTTON_PRESS))
//        {
//            this.show_popup_menu (event);
//            return true; // Event has been handled.
//        }
//        // -----------
//        puzzle_t *puzzle = NULL;    
//        GList    *iter = g_list_last (layers);

//        gdouble x = event->x,    
//                y = event->y,
//                z = 0.0;

//        if (!mouse)
//            return FALSE;

//        {
//            mouse->time   = event->time;
//            mouse->x      = event->x;
//            mouse->y      = event->y;
//            mouse->button = event->button;
//            mouse->selected = NULL;

//            gl_unproject (&x, &y, &z);
//        }


//        switch (event->button)
//        {        
//            case 3:    /* Mouse Right Button *    
//            case 1:    /* Mouse Left Button *
//        
//                /* Get selected puzzle *
//                while (iter)
//                {
//                    puzzle = (puzzle_t*) iter->data;
//            
//                    if (puzzle_hit_test (puzzle, x, y))
//                    {
//                        mouse->selected   = iter->data;
//                        mouse->selected_x = puzzle->x;
//                        mouse->selected_y = puzzle->y;
//                        break;
//                    }
//                    iter = iter->prev;
//                }

//                if (event->button == 3)
//                    puzzle_ungroup (puzzle);

//                puzzle_to_front (puzzle);            
//                break;
//        }

//        /* expose *
//        if (mouse->selected)
//            gtk_widget_queue_draw (widget);
//        */
//        // -----------
//        return false;
//    }

//    private bool on_motion_notify_event (Gdk.EventMotion event)
//    {
//        /* TODO
//        puzzle_t      *puzzle     = NULL;
//    
//        if (!mouse)
//            return FALSE;
//    
//        /* make GL-context "current" *
//        if (!gdk_gl_drawable_gl_begin (gldrawable, glcontext))
//            return FALSE;

//        
//        gdouble from[] = {mouse->x, mouse->y, 0.0};
//        gdouble to[]   = {event->x, event->y, 0.0};
//        {
//            gl_unproject_v (from);
//            gl_unproject_v (to);            
//        }
//    
//        if (mouse->selected)
//            puzzle = (puzzle_t*) mouse->selected;
//    
//    
//        switch (mouse->button)
//        {    
//            case 1:
//            case 3:
//                    /* Translate Puzzle *
//                    if (puzzle)
//                    {
//                        puzzle_move_to (puzzle,
//                                mouse->selected_x + to[0] - from[0],
//                                mouse->selected_y + to[1] - from[1]
//                                );
//                    
//                        if (puzzle_align (puzzle, TRUE))
//                            ;
//                    }
//                    break;
//        
//            case 2:
//                    /* Translate Viewport *
//                    glTranslated ( 
//                            to[0] - from[0],
//                            to[1] - from[1],
//                            to[2] - from[2]
//                            );
//                    mouse->x = event->x;
//                    mouse->y = event->y;
//                    break;        
//        }
//    
//        /* end drawing to current GL-context *
//        gdk_gl_drawable_gl_end (gldrawable);
//    
//        /* expose *
//        gtk_widget_queue_draw (widget);

//        */
//        return true;
//    }

//    private bool on_button_release_event (Gdk.EventButton event)
//    {
//        /* TODO
//        if (mouse && mouse->selected)
//        {
//            GList *iter;
//            gboolean changed;
//        
//            /* Keep grouping like a mad man *
//            do{
//                changed = FALSE;
//                iter = g_list_last (all_groups);
//            
//                while (iter)
//                {                
//                    if (puzzle_group_to (mouse->selected, (GList*)iter->data))
//                        changed = TRUE; // keep grouping
//                
//                    iter = iter->prev;
//                }
//            }
//            while (changed);

//            /* check if solved *
//            puzzle_solved ();
//        
//            /* expose *
//            gtk_widget_queue_draw (widget);
//        }
//        */
//        return false;
//    }

//    private bool on_scroll_event (Gdk.EventScroll event)
//    {
//        return false; /* TODO */
//    }

    private bool on_popup_menu ()
    {
        /* Shift+F10 or Menu keys */
        this.show_popup_menu (null);
        return true;
    }




    /*
     * Action callbacks
     */
    private void on_game_new (Gtk.Action action)
    {
        this.game.show_dialog (this);
        /*
        var stage = this.view.get_stage () as Clutter.Stage;
        
        var rect = new Clutter.Rectangle.with_color (Clutter.Color.from_string("#EEAA00AA"));
        rect.width = 400.0f;
        rect.height = 300.0f;
        //stage.add_actor (rect);
        */
    }

    private void on_game_pause (Gtk.Action action)
    {
    }

    private void on_game_shuffle (Gtk.Action action)
    {
    }

    private void on_game_quit (Gtk.Action action)
    {
        this.destroy ();
    }

    private void on_settings_fullscreen ()
    {
        if (this.is_fullscreen())
            this.unfullscreen();
        else
            this.fullscreen();
    }

    private void on_settings_toolbar_toggle (Gtk.Action action)
    {
        this.toolbar.visible = (action as Gtk.ToggleAction).active;
    }

    private void on_settings_scrollbars_toggle (Gtk.Action action)
    {
        // (action as Gtk.ToggleAction).active;
    }

    private void on_settings_preferences ()
    {
        this.show_preferences_dialog ();
    }

    private void on_help_about () {
        this.show_about_dialog ();
    }

    private void on_help_contents () {
        show_uri ("ghelp:darkroom"); //Resources.HELP_URL);
    }

    private void on_help_online () {
        show_uri ("https://answers.launchpad.net/darkroom");
    }

    private void on_help_translate () {
        show_uri ("https://translations.launchpad.net/darkroom");
    }

    private void on_help_report () {
        show_uri ("https://bugs.launchpad.net/darkroom/+filebug");
    }

    
    /*
     * Signals
     */

}
