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

/*
class Puzzle.Mouse
{
    gdouble x;
    gdouble y;
        
    guint32 time;
    guint button;
    
    gpointer selected;    
    gdouble selected_x;    
    gdouble selected_y;
}
*/

/*
#define SNAP(a,b,c)  (\
        (ABS(a) < ABS(b))\
            ? (ABS(a) < ABS(c) ? (a) : (c))\
            : (ABS(b) < ABS(c) ? (b) : (c))\
        )

#define rand_range(a,b,step) \
    (a + (b-(a))*(rand() % (step)) / (step-1))
*/
    public enum Puzzle.PieceSide {
	    TOP = 0,
	    RIGHT,
	    BOTTOM,
	    LEFT
    }

//public class Puzzle.Piece : Clutter.CairoTexture //Actor
public class Puzzle.Piece : Clutter.Actor //Clutter.Texture //, Puzzle.Draggable //Actor
{
    // double x, y, width, height, padding;
//    public double width;
//    public double height;
//    public double padding;
    
    public float size;
    public Puzzle.Group group;

    private Puzzle.Edge edges[4];

//    public weak Puzzle.Piece peers[4];

    private Cogl.Material cogl_material { get; set; }
    public Cogl.Material shadow_cogl_material { get; set; }


//    public Padding border = {0.0f, 0.0f, 0.0f, 0.0f};
//    public Padding padding = {0.0f, 0.0f, 0.0f, 0.0f};
//    public bool is_hovered = true;

//    private Cogl.Texture             texture = null;


/*
puzzle_t*      puzzle_new         (puzzle_game_t *game, gint x, gint y);
puzzle_t*      puzzle_get         (gint id);
void           puzzle_free        (puzzle_t *self);
gboolean       puzzle_hit_test    (puzzle_t *puzzle, gdouble x, gdouble y);
void           puzzle_to_front    (puzzle_t *self);
void           puzzle_move_to     (puzzle_t *self, gdouble x, gdouble y);
gboolean       puzzle_align       (puzzle_t *self, gboolean snap);
gboolean       puzzle_align_to    (puzzle_t *self, GList *group, gboolean snap);
gboolean       puzzle_group_to    (puzzle_t *self, GList *group);
gboolean       puzzle_ungroup     (puzzle_t *self);
void           puzzle_draw_edges  (puzzle_t *self, cairo_t *cr);
gint           puzzle_edges_match (puzzle_t *self, puzzle_t *puzzle, gint side);
*/

    private Clutter.ActorBox texture_region;
    public Cairo.Path       path;



    public Piece (float size)
    {
        this.size = size;
        this.set_size (size, size);
        
        //this.edges = new Puzzle.Edge[4];
        for (var side=0; side < this.edges.length; side++)
        {
            this.edges[side] = new Puzzle.Edge (size);
            this.edges[side].piece = this;
        }

        this.texture_region = Clutter.ActorBox () { x1=0.0f, y1=0.0f, x2=1.0f, y2=1.0f };
    }


    public void set_texture (Cogl.Texture texture, float x1, float y1, float x2, float y2)
    {
        this.texture_region = Clutter.ActorBox () { x1=x1, y1=y1, x2=x2, y2=y2 };
        
//        var piece_size = x2 - x1;
//        var opacity = this.get_paint_opacity ();


        // Paint using the parent texture's material. It should already have
        // the cogl texture set as the first layer
        // for correct blending we need set a preumultiplied color here:
//        this.cogl_material.set_color4ub (opacity, opacity, opacity, opacity); // TODO

        // The default filter can pull from adjacent pixels which is not what we
        // want.
        
        /* Shadow */
//        this.cogl_material.set_layer (0, texture);
//        this.cogl_material.set_layer_filters (0,
//                                       Cogl.MaterialFilter.LINEAR, //_MIPMAP_LINEAR,
//                                       Cogl.MaterialFilter.LINEAR); //_MIPMAP_LINEAR);



        /*
         * Picture
         */
        //this.cogl_texture = texture;
        var matrix = Cogl.Matrix () { xx=1.0f, yy=1.0f, zz=1.0f };
        matrix.translate (
                x1 / texture.get_width(),
                y1 / texture.get_height(),
                0.0f);
        matrix.scale (
                (x2-x1) / texture.get_width(),
                (y2-y1) / texture.get_height(),
                1.0f);
        
                
        this.cogl_material = new Cogl.Material ();
        this.cogl_material.set_layer (0, texture);
        this.cogl_material.set_layer_filters (0,
                                       Cogl.MaterialFilter.LINEAR, //_MIPMAP_LINEAR,
                                       Cogl.MaterialFilter.LINEAR); //_MIPMAP_LINEAR);
        this.cogl_material.set_layer_matrix (0, matrix);




        /* Shadows are at different depth */
//        Cogl.Material.set_depth_test_enabled (this.cogl_material, true);
//        Cogl.Material.set_depth_range (this.cogl_material, 0.5f, 10.0f);
		//Cogl.Material.set_depth_writing_enabled (this.cogl_material, true);

        //this.cogl_material.set_alpha_test_function (alpha_test_func, 1.0f);
        //this.cogl_material.set_layer_combine (0, "");
        //this.cogl_material.set_blend ("");
        //this.cogl_material.set_color4f (1.0f, 1.0f, 1.0f, 0.0f);
        //this.cogl_material.set_blend_constant (Cogl.Color () {red=1.0f, , , alpha=}
        
        //this.cogl_material.set_blend (
        //        "RGBA = ADD(SRC_COLOR, DST_COLOR*(1-SRC_COLOR[A]))"
        //        );
        
        
//        this.prepare ();        

    
//        this.button_press_event.connect (button_press);



//        g_signal_connect (handle, "enter-event", G_CALLBACK (on_enter), NULL);
//        g_signal_connect (handle, "leave-event", G_CALLBACK (on_leave), NULL);




        
        
        /*
        action.drag_begin.connect ((actor, event_x, event_y, modifier) => {
            var is_copy = (modifiers & CLUTTER_SHIFT_MASK) ? TRUE : FALSE;
            Clutter.Actor drag_handle;

            if (is_copy)
            {
                var stage = actor.get_stage ();

                drag_handle = new Clutter.Rectangle ();
                drag_handle.set_size (48, 48);
                //drag_handle.set_color (Clutter.Color() { red=1.0f;);

                stage.add_actor (drag_handle);
                drag_handle.set_position (event_x, event_y);
            }
            else
                drag_handle = actor;

            action.set_drag_handle (drag_handle);

            // fully desaturate the actor
//            clutter_actor_animate (actor, CLUTTER_LINEAR, 150,
//                             "@effects.disable.factor", 1.0,
//                             NULL);        
        });
        
        action.drag_end.connect ((actor, event_x, event_y, modifier) => {
            ClutterActor *drag_handle;

            drag_handle = clutter_drag_action_get_drag_handle (action);
            if (actor != drag_handle)
            {
              gfloat real_x, real_y;
              ClutterActor *parent;

                // if we are dragging a copy we can destroy the copy now
                // and animate the real actor to the drop coordinates,
                // transformed in the parent's coordinate space
                //
              clutter_actor_animate (drag_handle, CLUTTER_LINEAR, 150,
                                     "opacity", 0,
                                     "signal-swapped-after::completed",
                                       G_CALLBACK (clutter_actor_destroy),
                                       drag_handle,
                                     NULL);

              parent = clutter_actor_get_parent (actor);
              clutter_actor_transform_stage_point (parent, event_x, event_y,
                                                   &real_x,
                                                   &real_y);

              clutter_actor_animate (actor, CLUTTER_EASE_OUT_CUBIC, 150,
                                     "@effects.disable.factor", 0.0,
                                     "x", real_x,
                                     "y", real_y,
                                     NULL);
            }
            else
                clutter_actor_animate (actor, CLUTTER_LINEAR, 150,
                                   "@effects.disable.factor", 0.0,
                                   NULL);
       
        });
        */
    }

    public unowned Edge get_edge (PieceSide side)
    {
        return this.edges[side];
    }

    public void set_edge (PieceSide side, Edge? edge)
    {
        this.edges[side] = edge;

        // TODO mark as dirty
        //this.prepare ();
    }

/*
    private void on_drag_begin (ClutterDragAction   *action,
                   ClutterActor        actor,
                   float               event_x,
                   float               event_y,
                   Clutter.ModifierType  modifiers)
    {
    }

    static void
    on_drag_end (ClutterDragAction   *action,
                 ClutterActor        *actor,
                 gfloat               event_x,
                 gfloat               event_y,
                 ClutterModifierType  modifiers)
    {
    }
*/
    
    public void prepare ()
    {
        var width  = this.width  + this.edges[PieceSide.LEFT].extent + this.edges[PieceSide.RIGHT].extent + 2; 
        var height = this.height + this.edges[PieceSide.TOP].extent  + this.edges[PieceSide.BOTTOM].extent + 2;

        //Cairo.Surface  surface;
        uchar[]        surface_data;

        /*
         * Mask
         */
        // TODO: use cr.extents() on edges to determine used piece size
        
        // NOTE: included +2px of padding for better texture antialiasing
        
//        var normal_map = new Cairo.ImageSurface (Cairo.Format.ARGB32, (int)width, (int)height);
//        var surface = new Cairo.ImageSurface (Cairo.Format.A8,     (int)width, (int)height);
        var surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, (int)width, (int)height);
        //new Cairo.ImageSurface (Cairo.Format.ARGB32, );
        var cr = new Cairo.Context (surface);


        //cr.new_path ();
        //cr.move_to (0.0, 0.0);

        /*
         * Puzzle shape
         */
        cr.translate (this.edges[PieceSide.LEFT].extent, this.edges[PieceSide.TOP].extent);

        cr.save ();
        cr.new_path ();

//        cr.move_to (0.0, 0.0);
        for (var side=0; side < 4; side++)
        {
            var edge = this.edges[side];
            
//            print ("\n**Path points: %d\n\n", edge.get_path().num_data);
//            cr.new_sub_path ();
//            cr.scale (0.5, 0.5);
//            unowned Clutter.Path edge_path = edge.get_path();

//            cr.append_path (side < (4/2)
//                    ? edge.get_path()            // for top and right edge
//                    : edge.get_path_opposite()); // for bottom and left edge

            cr.append_path (edge.get_path());
            
//            cr.append_path ((side == PieceSide.TOP) || (side == PieceSide.LEFT)
//                    ? edge.get_path() : edge.get_path_opposite()
//                    );


//            cr.append_path (edge_path.to_cairo_path(cr));
//            cr.scale (2.0, 2.0);
            
//            cr.move_to (edge.length, 0.0); // a fallback, if there something wrong with the path, draw a line

//            cr.append_path (side < (4/2)
//                    ? edge.get_path()            // for top and right edge
//                    : edge.get_path_opposite()); // for bottom and left edge

            cr.translate (edge.length, 0.0);
            cr.rotate (Math.PI_2);
        }

        cr.close_path ();
        this.path = cr.copy_path_flat ();

        //Cairo.Path path = cr.copy_path_flat ();


        cr.restore();

        cr.set_source_rgba (1.0, 1.0, 1.0, 1.0);
        cr.fill_preserve ();

        cr.set_line_join (Cairo.LineJoin.MITER);
        cr.set_line_cap (Cairo.LineCap.BUTT);
        //cr.set_line_cap (Cairo.LineCap.SQUARE);
        cr.set_line_width (2.0);
        cr.stroke ();


        /*
         * Normal map
         */
        /* TODO: works fine
        cr.set_source_rgba (0.0, 0.0, 1.0, 1.0);
        cr.fill ();

        cr.set_line_width (1.2);
              
        int i;
        double _x1 = 0.0;
        double _y1 = 0.0;
        double _x2 = 0.0;
        double _y2 = 0.0;
//        cairo_path_t *path;
        Cairo.PathData *data = null; //&path.data[0];
        
//        path = cairo_copy_path (cr);

        double depth = 1.0 - 0.9; // bump | depth
        
        for (i=0; i < path.num_data; i += data->header.length)
        {
            data = &path.data[i];
            
            switch (data->header.type)
            {
                case Cairo.PathDataType.MOVE_TO:
                    _x1 = data[1].point.x;
                    _y1 = data[1].point.y;
                    cr.move_to (_x1, _y1);
                    break;
                    
                case Cairo.PathDataType.LINE_TO:
                    _x2 = data[1].point.x;
                    _y2 = data[1].point.y;
                    
                    var norm = Math.sqrt((_x2-_x1)*(_x2-_x1) + (_y2-_y1)*(_y2-_y1) + depth);
                    //print ("norm = %f\n", 0.5 + 0.5 * (_x2 - _x1) / norm);
                    
                    cr.set_source_rgba (
                            0.5 + 0.5 * (_x2 - _x1) / norm,
                            0.5 + 0.5 * (_y2 - _y1) / norm,
                            0.5 + 0.5 * depth / norm, 
                            1.0);

                    cr.move_to (_x1, _y1);
                    cr.line_to (_x2, _y2);
                    cr.stroke ();
                    
                    _x1 = _x2;
                    _y1 = _y2;
                    break;
                 
            //case Cairo.PathDataType.CURVE_TO:
            //    //do_curve_to_things (data[1].point.x, data[1].point.y,
            //    //                 data[2].point.x, data[2].point.y,
            //    //                 data[3].point.x, data[3].point.y);
            //    break;

            //case Cairo.PathDataType.CLOSE_PATH:
            //    //do_close_path_things ();
            //    break;
            }
        }
        //cairo_path_destroy (path);
        */
        

//        cr.fill_preserve ();

//        cr.set_source_rgba (1.0, 0.0, 0.0, 1.0);
//        cr.stroke ();

//        var piece_pixbuf = new Gdk.Pixbuf (Gdk.Colorspace.RGB, true, 32, (int)(x2-x1), (int)(y2-y1));
//        pixbuf.copy_area ((int)x1, (int)y1, piece_pixbuf.get_width(), piece_pixbuf.get_height(),
//                            piece_pixbuf, 0, 0);
//        
//        try{
//            piece_pixbuf.save ("pice-pixbuf.png", "png");
//        }catch (Error e){
//            warning (e.message);
//        }


		// Background
		/*
            Gdk.cairo_set_source_pixbuf (cr, pixbuf, -x1, -y1);

            cr.append_path (path);

            cr.clip ();
            cr.paint ();
        */


//        cr.set_line_width (2.0);
//        cr.set_source_rgba (1.0, 1.0, 1.0, 1.0);
//        cr.stroke ();

//        gdk_cairo_set_source_pixbuf (cr, pixbuf,
//				(self->x < 0 ? ABS(self->x) : 0),
//				(self->y < 0 ? ABS(self->y) : 0)
//				);	
//		cairo_mask_surface (cr, mask, 0, 0);	
		        
        //cr.paint ();
//        cr.set_source_surface (pixbuf_surface, 0.0, 0.0);

        

//        surface.write_to_png ("puzzle-piece-%dx%d.png".printf(y, x));

        /* Mask */


        /* Outline */
        

        /* Draw Mask FIXME: Mask should be of format A_8 */
        var rowstride = (int)width;

        var surface_texture = new Cogl.Texture.from_data ((int)width, (int)height, Cogl.TextureFlags.NO_AUTO_MIPMAP, Cogl.PixelFormat.BGRA_8888_PRE, Cogl.PixelFormat.ANY, rowstride*4, surface.get_data());
//        var mask = new Cogl.Texture.from_data ((int)width, (int)height, Cogl.TextureFlags.NO_AUTO_MIPMAP, Cogl.PixelFormat.A_8, Cogl.PixelFormat.ANY, rowstride, surface.get_data());

        this.cogl_material.set_layer (1, surface_texture);
        this.cogl_material.set_layer_filters (1,
                                       Cogl.MaterialFilter.LINEAR,
                                       Cogl.MaterialFilter.LINEAR);

        try
        {
//            this.cogl_material.set_layer_combine (1,
//                    );

//            this.cogl_material.set_layer_combine (1,
//                    "RGBA = REPLACE (PREVIOUS)\nA = REPLACE(1-TEXTURE[A])");
            // A = REPLACE (TEXTURE)
        }
        catch(Error e)
        {
            warning ("--> %s", e.message);
        }


        /*
         * Highlights
         */
        surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, (int)width, (int)height);
        cr = new Cairo.Context (surface);

        /* Background */
        //cr.set_source_rgb (0.5, 0.5, 0.5);
        //cr.paint ();

        cr.translate (this.edges[PieceSide.LEFT].extent, this.edges[PieceSide.TOP].extent);
        cr.set_line_join (Cairo.LineJoin.MITER);
        cr.set_line_cap (Cairo.LineCap.BUTT);


        /* Shadow */
        /*
        cr.translate (-1.5, -1.5);
        cr.set_line_width (2.0);
        cr.set_source_rgba (0.0, 0.0, 0.0, 1.0);
        cr.append_path (path);
        cr.stroke ();
        */
        
        
        
        var padding = 40;
        var radius = 7.0;
        var shadow = new Cairo.ImageSurface (Cairo.Format.A8, (int)width + padding*2, (int)height + padding*2);
        var cr2 = new Cairo.Context (shadow);
        //cr2.set_source_surface (surface, 0.0, 0.0);
        cr2.translate (this.edges[PieceSide.LEFT].extent + padding, this.edges[PieceSide.TOP].extent + padding);
        cr2.translate (radius / 20.0, radius / 10.0);
        cr2.set_source_rgba (0.0, 0.0, 0.0, 0.0);
        cr2.paint ();
        cr2.set_source_rgba (1.0, 1.0, 1.0, 0.6666);
        cr2.append_path (path);
        cr2.fill ();
        
        cairo_surface_blur (shadow, radius);
//        cairo_surface_blur (shadow, 10.0);
        
        var shadow_texture = new Cogl.Texture.from_data (shadow.get_width(), shadow.get_height(), Cogl.TextureFlags.NO_AUTO_MIPMAP, Cogl.PixelFormat.A_8, Cogl.PixelFormat.A_8, shadow.get_stride(), shadow.get_data());
//        var mask = new Cogl.Texture.from_data ((int)width, (int)height, Cogl.TextureFlags.NO_AUTO_MIPMAP, Cogl.PixelFormat.A_8, Cogl.PixelFormat.ANY, rowstride, surface.get_data());

        this.shadow_cogl_material = new Cogl.Material ();
        this.shadow_cogl_material.set_layer (0, shadow_texture);
        this.shadow_cogl_material.set_layer_filters (0,
                                       Cogl.MaterialFilter.LINEAR,
                                       Cogl.MaterialFilter.LINEAR);

//        this.notify["scale-x"].connect (() => {
//            this.shadow_cogl_material.set_color4f (1.0f, 1.0f, 1.0f, 0.0f);
//        });
        
        

        /* Highlight */
        cr.translate (-1.0, -1.0);
        cr.scale (1.0+2.0/width, 1.0+3.0/height);
        cr.set_line_width (1.0);
        cr.set_source_rgba (1.0, 1.0, 1.0, 0.2);
        cr.append_path (this.path);
        cr.stroke ();



        surface_texture = new Cogl.Texture.from_data ((int)width, (int)height, Cogl.TextureFlags.NO_AUTO_MIPMAP, Cogl.PixelFormat.BGRA_8888_PRE, Cogl.PixelFormat.ANY, rowstride*4, surface.get_data());
//        var mask = new Cogl.Texture.from_data ((int)width, (int)height, Cogl.TextureFlags.NO_AUTO_MIPMAP, Cogl.PixelFormat.A_8, Cogl.PixelFormat.ANY, rowstride, surface.get_data());

        this.cogl_material.set_layer (2, surface_texture);
        this.cogl_material.set_layer_filters (2,
                                       Cogl.MaterialFilter.LINEAR,
                                       Cogl.MaterialFilter.LINEAR);

        try
        {
            //this.cogl_material.set_blend (
            //        "RGBA = ADD(SRC_COLOR, DST_COLOR*(1-SRC_COLOR[A]))");
//            this.cogl_material.set_layer_combine (2, "RGBA = REPLACE(PREVIOUS)");
//            this.cogl_material.set_layer_combine (2, "RGBA = REPLACE(TEXTURE)");

            this.cogl_material.set_layer_combine (2,
                    "RGB = ADD (PREVIOUS, TEXTURE)"+
                    "A = REPLACE (PREVIOUS)");

//                    "RGB = ADD_SIGNED (PREVIOUS[RGB], TEXTURE[RGB])"+
//                    "RGB = INTERPOLATE (TEXTURE, PREVIOUS, TEXTURE[A])"+
        }
        catch(Error e)
        {
            warning ("--> %s", e.message);
        }


        /*
         * Create Normal Map
         */
        /* TODO
        cr = new Cairo.Context (normal_map);
        cr.set_source_rgb (0.0, 0.0, 0.0);
        cr.paint ();
        
        cr.translate (this.edges[PieceSide.LEFT].extent, this.edges[PieceSide.TOP].extent);

        float _x = 0.0f;
        float _y = 0.0f;

        
        //Clutter.Path.
        //to_cairo_path (cr);

        for (var i=0; i < path.num_data; i += path.data.header.length)
        {
            if (path.data.header.type == Cairo.PathDataType.MOVE_TO)

            if (path.data.header.type == Cairo.PathDataType.LINE_TO)
                cr.append_path (path.data[i].point[1].x, path.data[i].point[1].y);
            
            cr.set_source_rgb (1.0, 1.0, 1.0);
            cr.stroke ();
        }
        
        //normal_map.
        normal_map.write_to_png ("normal-map.png");
        */

    /*
        var width = (uint) (x2-x1);
        var height = (uint) (y2-y1);

        this.set_surface_size (width, height);
        
        this.clear ();
        var cr = this.create ();
        
        cr.set_source_rgba (1.0, 0.0, 0.0, 1.0);
        cr.rectangle (10.0, 10.0, 20.0, 10.0);
        cr.paint ();
    */    
    }
    
    
    construct {

    /* TODO
        cairo_surface_t *mask;
        cairo_t *cr;
    
        gint pixbuf_width  = gdk_pixbuf_get_width  (game->pixbuf);
        gint pixbuf_height = gdk_pixbuf_get_height (game->pixbuf);
    
        gint size = game->puzzle_size;
        gint i;

        /* Set defaults *
        {
            /* ┌─────────────┐                 
             * │  ┌───────┐  │                 
             * │  │       │  │                 
             * │  │       │  │                 
             * │  │       │  │                 
             * │  └───────┘  │                 
             * └─────────────┘                 
             *            <--> padding
             *    <------->    size
             * <-------------> width
             *
            self->padding = (gint) (size * 0.28);
        
            self->x = x * size - self->padding;
            self->y = y * size - self->padding;
        
            self->width  = size + 2*self->padding;
            self->height = size + 2*self->padding;

            /* *
            self->id           = y * game->width + x;
            self->surface      = NULL;
            self->surface_data = NULL;    
        }
    
    
        /* Crop whole image to get puzzle-image (duplicate) *
    
        GdkPixbuf *pixbuf = gdk_pixbuf_new_subpixbuf (game->pixbuf,
                MAX (self->x, 0),
                MAX (self->y, 0),
                MIN (self->width,  pixbuf_width  - MAX (0,self->x)),
                MIN (self->height, pixbuf_height - MAX (0,self->y))
                );
    
        /* Create mask *
        {
            cr = create_cairo_context ((gint)self->width, (gint)self->height, 4,
                    &mask, &self->surface_data);
        
            cr = cairo_create (mask);
        
            //cairo_save (cr);    
            {            
                puzzle_t *top_puzzle = (y == 0)
                    ? NULL : puzzle_get ((y-1)*game->width + x);
            
                puzzle_t *left_puzzle = (x == 0)
                    ? NULL : puzzle_get (y*game->width + x-1);
            
            
            
                //cairo_translate (cr, self->padding, self->padding);

            
                for (i=0; i < EDGE_COUNT; i++)
                {
                    if (i == EDGE_TOP && top_puzzle != NULL)
                    {
                        self->edges[EDGE_TOP] = top_puzzle->edges[EDGE_BOTTOM];
                    
                        puzzle_edge_ref (puzzle_edge_get (
                                self->edges[EDGE_TOP]
                                ));
                        continue;
                    }
                
                    if (i == EDGE_LEFT && left_puzzle != NULL)
                    {
                        self->edges[EDGE_LEFT] = left_puzzle->edges[EDGE_RIGHT];
                    
                        puzzle_edge_ref (puzzle_edge_get (
                                self->edges[EDGE_LEFT]
                                ));
                        continue;
                    }
                
                    cairo_save (cr);
                    //cairo_move_to (cr, 0, 0);

                    cairo_new_path (cr);
                
                    if (
                       (i == EDGE_TOP    && y == 0     ) ||
                       (i == EDGE_RIGHT  && x == game->width-1) ||
                       (i == EDGE_BOTTOM && y == game->height-1) ||
                       (i == EDGE_LEFT   && x == 0     ) )
                    {
                        /* Puzzle board edge
                         *
                         * [?] cairo_line_to (cr, size,0);  not supported by cairo_append_path_reversed()
                         *
                        //cairo_line_to (cr, size, 0);

                        cairo_curve_to (cr, 0,0, size,0, size,0);
                    
                        //self->edges[i] = -1;
                    }
                    else
                    {
                        /*      .~mid
                         *   .(   ).      *side* determines is it a whole or a pin
                         * .__.) (.__.    *mid* is a x-cordinate for an pin      
                         *
                        gdouble side = (random() & 1) ? -1 : 1;
                        gdouble mid  = size * rand_range (0.45, 0.55, 3);

                        gdouble a = self->padding * 0.5;
                        gdouble b = self->padding * 0.4;
                    
                        gdouble c = self->padding - 2;
                        gdouble d = self->padding * 0.45;
                        gdouble e = -1;
                    
                        gdouble auto x = 0,
                                     y = 0;
                    
                        #define puzzle_curve_to(cr,x_from,y_from,x_to,y_to,distance,angle)  \
                        {                                                                   \
                            gdouble auto vx = distance * cos(angle);                        \
                            gdouble auto vy = distance * sin(angle);                        \
                                                                                            \
                            cairo_curve_to (cr, x_from,y_from, x_to-vx,y_to-vy, x_to,y_to); \
                                                                                            \
                            x = x_to + vx;                                                  \
                            y = y_to + vy;                                                  \
                        }
                    
                        //cairo_get_current_point (cr, &x, &y);
                    
                        x += 3*cos (0.0); /* determine first slope with distance of 3 *
                        y += 3*sin (0.0);
                    
                        puzzle_curve_to (cr, x,y, mid-b, e*side, 6, G_PI_4*side);
                        puzzle_curve_to (cr, x,y, mid-a, d*side, 6, G_PI_2*side);
                        puzzle_curve_to (cr, x,y, mid,   c*side, 8, 0);
                        puzzle_curve_to (cr, x,y, mid+a, d*side, 6, -G_PI_2*side);
                        puzzle_curve_to (cr, x,y, mid+b, e*side, 6, -G_PI_4*side);
                        puzzle_curve_to (cr, x,y, size,  0,      3, -G_PI*side);        
                    }
                
                    puzzle_edge_t *edge;
                
                    edge = puzzle_edge_new (
                            cairo_copy_path (cr)
                            );
                    self->edges[i] = edge->id;                

                    //cairo_restore (cr);
                }
            }
            cairo_destroy (cr);
        

            // Draw Mask
            cr = cairo_create (mask);
        
            cairo_set_line_join  (cr, CAIRO_LINE_JOIN_ROUND);
            cairo_set_line_cap   (cr, CAIRO_LINE_CAP_ROUND);
            cairo_set_line_width (cr, 0.5);
        
            //cairo_set_fill_rule (cr, CAIRO_FILL_RULE_WINDING); // CAIRO_FILL_RULE_EVEN_ODD
            puzzle_draw_edges (self, cr);
        
            cairo_fill_preserve (cr);
            cairo_stroke (cr);
        
            cairo_destroy (cr);    
        }
    
    
        /* Create surface *
        {
            cr = create_cairo_context ((gint)self->width, (gint)self->height, 4,
                    &self->surface, &self->surface_data);
    
        
            // Background
            gdk_cairo_set_source_pixbuf (cr, pixbuf,
                    (self->x < 0 ? ABS(self->x) : 0),
                    (self->y < 0 ? ABS(self->y) : 0)
                    );    
            cairo_mask_surface (cr, mask, 0, 0);        
    
        
            // Outline
            puzzle_draw_edges (self, cr);
        
            cairo_set_source_rgba (cr, .75, .75, .75, 0.25);
            //cairo_set_source_rgba (cr, 0.5, 0.5, 0.5, 0.3);

            cairo_set_line_width  (cr, 1.25);
        
            cairo_stroke (cr);
        

            cairo_destroy (cr);
        }
    */        
    
    }


    /*
    public bool hit_test (double x, double y) // TODO: this is handled internally by pick()
    {
        x = x - puzzle->x;
        y = y - puzzle->y;
    
        return (
            (x >= 0) && (x < puzzle->width) &&
            (y >= 0) && (y < puzzle->height) &&
            (puzzle->surface_data[ 4 * (int)(puzzle->width*y + x) + 3] > 128)
            );
        return false;
    }
    */


public bool align (bool snap)
{
/* TODO
    GList *iter = g_list_last (all_groups);
    
    while (iter)
    {    
        if (puzzle_align_to (self, (GList*)iter->data, snap))
            return TRUE;
        else
            iter = iter->prev;
    }
    
    // puzzle_move_to (self, x, y);
    return FALSE;
*/
    return false;
}


/* TODO
public bool align_to (GList *group, gboolean snap)
{
    if (!self || !group)
        return FALSE;
        
    if (self->group == group)
        return FALSE;

    puzzle_t *a, *b;
    GList *iter_a, *iter_b;
    
    gboolean align = FALSE;
    gdouble snap_x, snap_y, x, y;
    
    gint snap_distance = snap
        ? SNAP_DISTANCE : 1;


    iter_a = self->group;
    
    while (iter_a)
    {
        a = (puzzle_t*) iter_a->data; // puzzle, we want to align (move)
        iter_a = iter_a->next;
        iter_b = group;

        while (iter_b)
        {
            b = (puzzle_t*) iter_b->data; // constant puzzle
            iter_b = iter_b->next;
            
            x = SNAP(
                    b->x - a->x,
                    b->x - a->x - PUZZLE_SIZE,
                    b->x - a->x + PUZZLE_SIZE
                    );
            
            y = SNAP(
                    b->y - a->y,
                    b->y - a->y - PUZZLE_SIZE,
                    b->y - a->y + PUZZLE_SIZE
                    );
            
            if ((ABS(x) < snap_distance) &&
                (ABS(y) < snap_distance) )
            {    
                // puzzle overlies the other
                if ((a->x+x == b->x) &&
                    (a->y+y == b->y))
                    return FALSE;
                
                // match edges
                switch (puzzle_edges_match (b, a,
                    ((a->y+y == b->y) && (a->x+x != b->x))  ?  (a->x+x < b->x ? EDGE_LEFT : EDGE_RIGHT)  : 
                    ((a->y+y != b->y) && (a->x+x == b->x))  ?  (a->y+y < b->y ? EDGE_TOP : EDGE_BOTTOM)  :  -1
                    ))
                {
                    case -1:
                        return FALSE;
                
                    case 0:
                        if (!SNAP_CORNERS)
                            break;
                        
                    case 1:
                        align  = TRUE;
                        snap_x = x;
                        snap_y = y;
                        break;
                }
            }
        }
    }
    
    if (!align)
        return FALSE;
    
    puzzle_move_to (self,
            self->x + snap_x,
            self->y + snap_y
            );
    
    return TRUE;
}
*/

/* TODO
void puzzle_draw_edges (puzzle_t *self, cairo_t *cr)
{
    gint i;
    puzzle_edge_t *edge;
    
    cairo_save (cr);
    
    // [?] assumme that width == height
    //     and that size = width - padding*2
    //
    cairo_translate (cr, self->padding, self->padding);

    cairo_line_to (cr, 0, 0);

    gint size = self->width - 2*self->padding;
    
    
    for (i=0; i < EDGE_COUNT; i++)
    {
        edge = puzzle_edge_get (self->edges[i]);
        
        switch (i)
        {
            case EDGE_TOP:
                    cairo_append_path_normal (cr, edge->path);
                    break;
            
            case EDGE_RIGHT:
                    cairo_append_path_normal (cr, edge->path);    
                    break;

            case EDGE_BOTTOM:
                    cairo_append_path_reversed (cr, edge->path);
                    break;

            case EDGE_LEFT:
                    cairo_append_path_reversed (cr, edge->path);
                    break;                        
        }

        cairo_translate (cr, size, 0);
        cairo_rotate  (cr, G_PI_2);
    }
    
    cairo_restore (cr);
}
*/






/* TODO
public int puzzle_edges_match (puzzle_t *self, puzzle_t *puzzle, gint side)
{
    if (!puzzle || !self)
        return -1;
    
    if (side < 0)
        return 0; /* puzzles may corner

    if (puzzle == self)
        return 0;
    
    gint a = side;
    gint b = neighbor_opposite (a);
    
    /* Check if edge shape matches *
    if (puzzle_edge_match (
            puzzle_edge_get (self->edges[a]),
            puzzle_edge_get (puzzle->edges[b])
            ))
        return 1;
    else
        return -1;
}
*/





/* TODO
    public override void allocate (Clutter.ActorBox box, Clutter.AllocationFlags flags)
    {
        base.allocate (box, flags);
    }
*/

    public override void paint ()
    {
//        print ("Piece.paint()\n");
//        var cogl_texture = this.cogl_texture;        
//        var cogl_material = this.cogl_material;

//        if (cogl_texture == null || cogl_texture == null)
//            return;

//        float x, y;
//        this.get_position (out x, out y);
        
        //Cogl.set_depth_test_enabled (true);
        
//        Clutter.ActorBox box;
//        this.get_allocation_box (out box);
        
//        var scale = (box.x2 - box.x1) / this.size;
//        
//        var x1 = box.x1 - scale * this.edges[PieceSide.LEFT].extent;
//        var y1 = box.y1 - scale * this.edges[PieceSide.TOP].extent;
//        var x2 = box.x2 + scale * this.edges[PieceSide.RIGHT].extent;
//        var y2 = box.y2 + scale * this.edges[PieceSide.BOTTOM].extent;
        
        var x1 = -this.edges[PieceSide.LEFT].extent;
        var y1 = -this.edges[PieceSide.TOP].extent;
        var x2 =  this.size + this.edges[PieceSide.RIGHT].extent;
        var y2 =  this.size + this.edges[PieceSide.BOTTOM].extent;

        var tx1 = x1 / this.size;
        var ty1 = y1 / this.size;
        var tx2 = x2 / this.size;
        var ty2 = y2 / this.size;

        /* Shadow */
        Cogl.push_matrix ();
        Cogl.set_source (this.shadow_cogl_material);
        //Cogl.translate (1.0f, 2.0f, 0.0f);
        Cogl.rectangle_with_texture_coords (
                x1-40, y1-40, x2+40, y2+40,
                0.0f, 0.0f, 1.0f, 1.0f);
        Cogl.pop_matrix ();

        /* Puzzle */        
        Cogl.set_source (this.cogl_material);
        //Cogl.translate (x, y, 0.0f);
        Cogl.rectangle_with_texture_coords (
                x1, y1, x2, y2,
                //0.0f, 0.0f, 1.0f, 1.0f);
                tx1, ty1, tx2, ty2);

        /* Shadow */
//        Cogl.translate (-8.0f, -8.0f, 0.5f);
//        Cogl.set_source (this.cogl_material);
//        Cogl.rectangle_with_texture_coords (
//                x1, y1, x2, y2,
//                //0.0f, 0.0f, 1.0f, 1.0f);
//                tx1, ty1, tx2, ty2);

        //Cogl.set_depth_test_enabled (false);
    }

  
    public override void pick (Clutter.Color color)
    {
        if (!this.should_pick_paint ())
            return;

        if (this.path == null)
            return;

        Cogl.set_source_color4ub (color.red,
                                  color.green,
                                  color.blue,
                                  color.alpha);        

        Cogl.path_new ();

        //unowned Cogl.Path   cogl_path = Cogl.get_path (); //new Cogl.Path ();
        unowned Cairo.Path  path = this.path;
        Cairo.PathData     *data = null; //&path.data[0];

        
        for (var i=0; i < path.num_data; i += data->header.length)
        {
            data = &path.data[i];
            
            switch (data->header.type)
            {
                case Cairo.PathDataType.MOVE_TO:
                    Cogl.path_move_to ((float) data[1].point.x, (float) data[1].point.y);
                    break;
                    
                case Cairo.PathDataType.LINE_TO:
                    Cogl.path_line_to ((float) data[1].point.x, (float) data[1].point.y);
                    break;                 
            }
        }

        Cogl.path_fill ();


/*

        Cogl.set_path (cogl_path);
*/

        //Cogl.path_fill ();    

        /*
          Clutter.ActorBox allocation = { 0, };
          float width, height;

          clutter_actor_get_allocation_box (actor, &allocation);
          clutter_actor_box_get_size (&allocation, &width, &height);

          cogl_path_new ();

          cogl_set_source_color4ub (pick_color->red,
                                    pick_color->green,
                                    pick_color->blue,
                                    pick_color->alpha);

          // create and store a path describing a star
          cogl_path_move_to (width * 0.5, 0);
          cogl_path_line_to (width, height * 0.75);
          cogl_path_line_to (0, height * 0.75);
          cogl_path_move_to (width * 0.5, height);
          cogl_path_line_to (0, height * 0.25);
          cogl_path_line_to (width, height * 0.25);
          cogl_path_line_to (width * 0.5, height);

          cogl_path_fill ();    
        */
        //base.pick (color);
        //this.paint ();
        
        /*
        if self.should_pick_paint() == False:
            return
        cogl.path_round_rectangle(0, 0, self._width, self._height, self._arc, self._step)
        cogl.path_close()
        # Start the clip
        cogl.clip_push_from_path()
        # set color to border color
        cogl.set_source_color(color)
        # draw the rectangle for the border which is the same size and the
        # object
        cogl.path_round_rectangle(0, 0, self._width, self._height, self._arc, self._step)
        cogl.path_close()
        cogl.path_fill() 
        cogl.clip_pop()        
        */
    }

/*
    public override void map ()
    {
        base.map ();
    }

    public override void unmap ()
    {
        base.unmap ();
    }
*/

    public override bool enter_event (Clutter.CrossingEvent event)
    {
        return false;
    }

    public override bool leave_event (Clutter.CrossingEvent event)
    {
        return false;
    }

    private bool button_press (Clutter.ButtonEvent event)
    {
        print ("Piece %g,%g\n", this.x, this.y);
        return true;
    }

    private bool button_release (Clutter.ButtonEvent event)
    {
        return true;
    }
/*
    public override void hide ()
    {
    }

    public void get_available_area (Clutter.ActorBox allocation, out Clutter.ActorBox area)
    {
    }
*/

    /*
     * Draggable Interface
     */
/*
    public DragAxis drag_axis { get; set; }
    public Clutter.Actor drag_actor { get; set; }
    public bool drag_enabled { get; set; }
    public uint drag_threshold { get; set; }

    private bool dragging;
    private float mouse_x;
    private float mouse_y;


    public override bool button_press_event (Clutter.ButtonEvent event)
    {
        // Drag 
        if (event.button == 1)
        {
            //this.dragging = true;
            //this.mouse_x = event.x;
            //this.mouse_y = event.y;
            
            var action = new Clutter.DragAction ();
            action.set_drag_handle (this);
            
            this.raise_top ();
        }
        return false;
    }

    public override bool button_release_event (Clutter.ButtonEvent event)
    {
        //var action = new Clutter.DragAction ();
    
        this.dragging = false;
        //print ("buttonpress-event\n");
        return false;
    }

    public override bool motion_event (Clutter.MotionEvent event)
    {
        if (this.dragging)
        {
            this.move_by (event.x-mouse_x, event.y-mouse_y);
            this.mouse_x = event.x;
            this.mouse_y = event.y;
        }
        return false;        
    }
*/

/*
//    public virtual void allocation_changed (ActorBox p0, AllocationFlags p1)
    public virtual bool button_press_event (ButtonEvent event)
    public virtual bool button_release_event (ButtonEvent event)
    public virtual bool captured_event (Event event)
    public virtual bool enter_event (CrossingEvent event)
    public virtual bool event (void event)
    public virtual void key_focus_in ()
    public virtual void key_focus_out ()
    public virtual bool key_press_event (KeyEvent event)
    public virtual bool key_release_event (KeyEvent event)
    public virtual bool leave_event (CrossingEvent event)
    public virtual bool motion_event (MotionEvent event)
//    public virtual void paint ()
//    public virtual void parent_set (Actor? old_parent)
//    public virtual void pick (Color color)
//    public virtual bool scroll_event (ScrollEvent event)
*/
}
