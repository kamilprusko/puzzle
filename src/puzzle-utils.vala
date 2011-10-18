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

namespace Puzzle.Utils
{
//    public void init ()
//    {
//        GLib.Value.register_transform_func (typeof(Clutter.Color), typeof(Gdk.RGBA), (ValueTransform) transform_color_to_rgba);
//        GLib.Value.register_transform_func (typeof(Gdk.RGBA), typeof(Clutter.Color), (ValueTransform) transform_rgba_to_color);
//    }

    private void transform_color_to_rgba (Value source_value, out Value target_value)
    {
        var color = (Clutter.Color) source_value; //.get_boxed ();        
        target_value = gdk_rgba_from_pixel (color.to_pixel());
    }

    private void transform_rgba_to_color (Value source_value, out Value target_value)
    {
        var rgba = (Gdk.RGBA) source_value; //.get_boxed ();
        target_value = Clutter.Color.from_pixel (gdk_rgba_get_pixel(rgba));
    }

    /* TODO include this to transform_* functions? */
    private Gdk.RGBA gdk_rgba_from_pixel (uint32 pixel)
    {
        var rgba   = Gdk.RGBA ();
        rgba.red   = (pixel & 0xff000000) / 4294967295.0;
        rgba.green = (pixel & 0x00ff0000) / 16777215.0;
        rgba.blue  = (pixel & 0x0000ff00) / 65535.0;
        rgba.alpha = (pixel & 0x000000ff) / 255.0;
        return rgba;
    }
    
    private uint32 gdk_rgba_get_pixel (Gdk.RGBA rgba)
    {
        var pixel = (
                (uint32)(rgba.red   * 0xff) << 24 |
                (uint32)(rgba.green * 0xff) << 16 |
                (uint32)(rgba.blue  * 0xff) <<  8 |
                (uint32)(rgba.alpha * 0xff)
                );
        return pixel;
    }
}
    
namespace Puzzle
{
    
    public Cogl.Texture pixbuf_to_texture (Gdk.Pixbuf pixbuf)
    {
	    var format = pixbuf.has_alpha ?
			    Cogl.PixelFormat.RGBA_8888_PRE : Cogl.PixelFormat.RGB_888;

	    var texture = new Cogl.Texture.from_data (pixbuf.width, pixbuf.height,
			    Cogl.TextureFlags.NO_AUTO_MIPMAP | Cogl.TextureFlags.NO_SLICING | Cogl.TextureFlags.NO_ATLAS, format, format,
			    pixbuf.rowstride, (uchar[]) pixbuf.pixels);			

	    return texture;
    }

    public static void actor_box_clamp_to_pixels (Clutter.ActorBox box)
    {
	    box.x1 = (float) Math.floor (box.x1);
	    box.y1 = (float) Math.floor (box.y1);
	    box.x2 = (float) Math.floor (box.x2);
	    box.y2 = (float) Math.floor (box.y2);
    }

    /* Utility function to modify a child allocation box with respect to the
     * x/y-fill child properties. Expects childbox to contain the available
     * allocation space.
     */
    /*
    public static void allocate_align_fill (Clutter.Actor child, Clutter.ActorBox childbox, float x_align, float y_align, bool x_fill, bool y_fill)
    {
	    float natural_width, natural_height;
	    float min_width, min_height;
	    float child_width, child_height;
	    float available_width, available_height;
	    Clutter.RequestMode request;
	    Clutter.ActorBox allocation = { 0, };
    //	double x_align, y_align;

	    x_align = x_align.clamp (0.0f, 1.0f);
	    y_align = y_align.clamp (0.0f, 1.0f);

	    available_width  = childbox->x2 - childbox->x1;
	    available_height = childbox->y2 - childbox->y1;

	    if (available_width < 0)
		    available_width = 0;

	    if (available_height < 0)
		    available_height = 0;

	    if (x_fill)
	    {
		    allocation.x1 = childbox->x1;
		    allocation.x2 = (int)(allocation.x1 + available_width);
	    }

	    if (y_fill)
	    {
		    allocation.y1 = childbox->y1;
		    allocation.y2 = (int)(allocation.y1 + available_height);
	    }

	    // if we are filling horizontally and vertically then we're done 
	    if (x_fill && y_fill)
	    {
		    *childbox = allocation;
		    return;
	    }

	    request = CLUTTER_REQUEST_HEIGHT_FOR_WIDTH;
	    g_object_get (G_OBJECT (child), "request_mode", &request, NULL);

	    if (request == CLUTTER_REQUEST_HEIGHT_FOR_WIDTH)
	    {
		    clutter_actor_get_preferred_width (child, available_height,
					                         &min_width,
					                         &natural_width);

		    child_width = CLAMP (natural_width, min_width, available_width);

		    if (!y_fill)
		    {
		      clutter_actor_get_preferred_height (child, child_width,
					                              &min_height,
					                              &natural_height);

		      child_height = CLAMP (natural_height, min_height, available_height);
		    }
	    }
	    else
	    {
		    clutter_actor_get_preferred_height (child, available_width,
					                          &min_height,
					                          &natural_height);

		    child_height = CLAMP (natural_height, min_height, available_height);

		    if (!x_fill)
		    {
		      clutter_actor_get_preferred_width (child, child_height,
					                             &min_width,
					                             &natural_width);

		      child_width = CLAMP (natural_width, min_width, available_width);
		    }
	    }

	    if (!x_fill)
	    {
		    allocation.x1 = childbox->x1 + (int)((available_width - child_width) * x_align);
		    allocation.x2 = allocation.x1 + (int) child_width;
	    }

	    if (!y_fill)
	    {
		    allocation.y1 = childbox->y1 + (int)((available_height - child_height) * y_align);
		    allocation.y2 = allocation.y1 + (int) child_height;
	    }

	    *childbox = allocation;
    }
    */
}
