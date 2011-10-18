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

namespace Puzzle
{
    /* Constants */
    public static const string[] AUTHORS = {
        "Kamil Prusko <kamilprusko@gmail.com>",
        null
        };

    public static const string[] DOCUMENTERS = null;

    public static const string COPYRIGHT = "Copyright © 2011 Kamil Prusko";

    public static const string LICENSE = "Puzzle! is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.\n\nPuzzle! is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.\n\nYou should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.";
    
    //You should have received a copy of the GNU General Public License along with Puzzle!; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA";

    
    private static Gtk.IconFactory icon_factory = null;

    public void init ()
    {
        /* Custom icons */
        var icon_theme = Gtk.IconTheme.get_default();
        icon_theme.append_search_path (GLib.Path.build_filename (Config.PACKAGE_DATADIR, "icons"));

        icon_factory = new Gtk.IconFactory ();
        register_icon (Config.PACKAGE_NAME);

        //File icons_dir = get_resources_dir().get_child("icons");
        //add_stock_icon(icons_dir.get_child("object-rotate-right.png"), ROTATE_LEFT);
        //add_stock_icon(icons_dir.get_child("object-rotate-left.png"), ROTATE_RIGHT);
        //add_stock_icon(icons_dir.get_child("object-flip-horizontal.svg"), MIRROR);
        //add_stock_icon(icons_dir.get_child("crop.svg"), CROP);
        //add_stock_icon(icons_dir.get_child("redeye.png"), REDEYE);
        //add_stock_icon(icons_dir.get_child("pin-toolbar.svg"), PIN_TOOLBAR);
        //add_stock_icon(icons_dir.get_child("return-to-page.svg"), RETURN_TO_PAGE);
        //add_stock_icon(icons_dir.get_child("make-primary.svg"), MAKE_PRIMARY);
        //add_stock_icon(icons_dir.get_child("import.svg"), IMPORT);
        //add_stock_icon(icons_dir.get_child("import-all.png"), IMPORT_ALL);

        icon_factory.add_default();


        /* Class defaults */
        Gtk.Window.set_default_icon_name (Config.PACKAGE_NAME);


        /* GValue transform functions */
        GLib.Value.register_transform_func (typeof(Clutter.Color), typeof(Gdk.RGBA),
                (ValueTransform) Utils.transform_color_to_rgba
                );
        GLib.Value.register_transform_func (typeof(Gdk.RGBA), typeof(Clutter.Color),
                (ValueTransform) Utils.transform_rgba_to_color
                );
    }




    public void register_icon (string icon_name)
    {
        if (icon_factory != null)
        {
            var icon_source = new Gtk.IconSource ();
            icon_source.set_icon_name (icon_name);

            var icon_set = new Gtk.IconSet ();
            icon_set.add_source (icon_source);

            icon_factory.add (icon_name, icon_set);
        }
    }

/*
    public Gdk.Pixbuf? get_icon (string name, int scale = 24) {
        //File icons_dir = get_resources_dir().get_child("icons");
        var icons_dir = Path.build_filename (PKGDATA_DIR, "icons", "hicolor", "%dx%d".printf(scale,scale), name);
        
        Gdk.Pixbuf pixbuf = null;
        try {
            pixbuf = new Gdk.Pixbuf.from_file(icons_dir.get_child(name).get_path());
        } catch (Error err) {
            critical("Unable to load icon %s: %s", name, err.message);
        }

        if (pixbuf == null)
            return null;
        
        return (scale > 0) ? scale_pixbuf(pixbuf, scale, Gdk.InterpType.BILINEAR) : pixbuf;
    }

    private void add_stock_icon (File file, string stock_id) {
        Gdk.Pixbuf pixbuf = null;
        try {
            pixbuf = new Gdk.Pixbuf.from_file(file.get_path());
        } catch (Error err) {
            error("%s", err.message);
        }
        
        Gtk.IconSet icon_set = new Gtk.IconSet.from_pixbuf(pixbuf);
        factory.add(stock_id, icon_set);
    }
*/    
}


