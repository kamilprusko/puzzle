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
    public enum GameState {
	    NONE    = 0, // or default
        PLAYING = 0x001,
        PAUSED  = 0x011,
        SOLVED  = 0x100
    }
}

public struct Puzzle.PieceDragData
{
    Clutter.Actor      handle;
    Clutter.DragAction action;
    Clutter.Animation  animation;

    Puzzle.Group       nearest_piece;
    Puzzle.PieceSide   nearest_piece_side;
    float              nearest_distance;
    float              nearest_angle;    

    float              offset_x;
    float              offset_y;
}



public struct Puzzle.Nearest
{
    Clutter.Actor  actor;
    float          distance;
    float          angle;
    float          dx;
    float          dy;
}


public class Puzzle.Game : Object
{
    public string file;
    //Gdk.Pixbuf pixbuf;
    //Gtk.Widget view;
//    public Puzzle.Window window; // TODO: it should be a list of windows
    
    public Clutter.Actor stage; // This is actually Cairo.Group, child of Puzzle.Viewport
    // double x,y,z;
    
    private int rows; // in puzzles
    private int cols;
    
    //private int puzzle_size; // in pixels

    private int state; // NONE PLAYING PAUSED SOLVED
    
    //private bool _is_solved;
    
    private GLib.Timer timer;
    private PieceDragData drag_data;

    private static weak Puzzle.Game instance;
    
    public static Puzzle.Game get_default ()
    {
        return Puzzle.Game.instance;
    }
    
    
    construct {
        this.timer = new GLib.Timer ();

    	Gdk.Pixbuf pixbuf = null;

        Puzzle.Game.instance = this;

	    this.stage = new Clutter.Group ();	
	    this.drag_data = PieceDragData ();
	    /* TODO
	    if (!filename)
		    return FALSE;

	    else
	    {
		    pixbuf = gdk_pixbuf_new_from_file (
				    filename, &error);
		
		    if (error != NULL)
		    {
			    g_message (error->message);
			    g_clear_error (&error);
			
			    return FALSE;
		    }
	    }

	    if (!pixbuf)
		    return FALSE;
	
	
	    puzzle_reset_game ();
	

	    /* Game Params *
	    {
		    game->filename = g_strdup (filename);
		    game->pixbuf   = pixbuf;
		
		    game->puzzle_size  = PUZZLE_SIZE;
		
		    game->width  = gdk_pixbuf_get_width (pixbuf) / game->puzzle_size;
		    game->height = gdk_pixbuf_get_height(pixbuf) / game->puzzle_size;

		    game->solved = FALSE;
	    }
	
	
	    /* Init Puzzles *
	    {
		    gint x, y;
		
		    for (y = 0; y < game->height; y++)
		    for (x = 0; x < game->width; x++)
			    puzzle_new (game, x, y);
	    }
	
	    //gtk_widget_activate	(game->canvas);	
	    //gtk_widget_grab_focus (game->canvas);
	    gtk_widget_queue_draw (game->canvas);
	    return true;
	    */
    }
    
    public GLib.List<Puzzle.Piece> pieces;
    

    
    public void pause ()
    {
        // if (state & PAUSED)
        {
            this.timer.stop ();
            //this.paused.emit ();
        }
    }

    public void resume ()
    {
        // if ((state & PAUSED) == false)
        {
            this.timer.@continue ();
            //this.resumed.emit ();
        }
    }
    
    public bool reset ()
    {
        return true;
    }
    
    /* TODO: This should be in Piece.size */
    public float piece_size;

    
    public bool new_game (string uri)
    {
        //var edges_limit = 3;

        /* Open Image */
        Cogl.Texture texture;
        //Gdk.Pixbuf   pixbuf;

        try
        {
            /* TODO
            var file = new File.new_for_uri (uri);
            if (!file.query_exists())
                return false;
            
            file.load_contents_async (Cancellable? cancellable =null, out string contents, out size_t length =null, out string etag_out =null);
            */

            var min_piece_size = 60.0f;
            var pieces_limit = 40;

        
            var filename = Filename.from_uri (uri);
            //pixbuf = new Gdk.Pixbuf.from_file (filename);
            //var pixbuf = Gdk.Pixbuf.from_file_at_scale (
            //        string filename, int width, int height, bool preserve_aspect_ratio)
            
            // void scale (Gdk.Pixbuf dest, int dest_x, int dest_y, int dest_width, int dest_height, 
            //        double offset_x, double offset_y, double scale_x, double scale_y, Gdk.InterpType interp_type);
            
        	texture = new Cogl.Texture.from_file (filename, Cogl.TextureFlags.NO_AUTO_MIPMAP,
        	                                                Cogl.PixelFormat.RGBA_8888_PRE);

            /* FIXME: there's needed 2px padding around picture */

            /* Try to get number of pieces from preferences, but not make pieces too small */
            this.piece_size = (int) Math.round (Math.sqrt (
                    (texture.get_width() * texture.get_height()) / pieces_limit
                    ));
            if (piece_size < min_piece_size)
                piece_size = min_piece_size;

            /* Get number of rows and columns for that piece-size */
        	this.cols = (int) Math.floor (texture.get_width() / piece_size);
        	this.rows = (int) Math.floor (texture.get_height() / piece_size);

            /* There can be left unused space, so enlarge piece-size if possible */
            this.piece_size = float.min(
                    (int) Math.floor (texture.get_width() / this.cols),
                    (int) Math.floor (texture.get_height() / this.rows)
                    );

            if (this.cols < 2 && this.rows < 2)
            {
                /* No fun, image too small */
                /* TODO: show error dialog, OK opens new dialog */
                return false;
            }
        }
        catch (Error e)
        {
            error (e.message);
        }
        
        /* Create Edges */
//        {                        
//            //new Cairo.ImageSurface (Cairo.Format.ARGB32, );
////            var surface = new Cairo.ImageSurface (Cairo.Format.A8, piece_size*3, piece_size*2);
////            var cr      = new Cairo.Context (surface);
////            cr.translate (piece_size, piece_size);
//            this.edges = new Puzzle.Edge[edges_limit];

//            for (var i=0; i < edges.length; i++)
//            {
//                this.edges[i] = new Puzzle.Edge (piece_size);
//                this.edges[i].prepare (i);
//            }
//        }

        /* Create Pieces */
        {
            var container = this.stage as Clutter.Container;
            
            this.pieces = new GLib.List<Puzzle.Piece> (); //[this.rows*this.cols];
            
            var tx0 = (float) Math.floor ((texture.get_width() - this.cols * piece_size) / 2.0);
            var ty0 = (float) Math.floor ((texture.get_height() - this.rows * piece_size) / 2.0);
            
            for (var y=0; y < this.rows; y++)
            {
                for (var x=0; x < this.cols; x++)
                {
                    var piece = new Puzzle.Piece (piece_size);
                    
                    piece.set_texture (texture, 
                            tx0 + (x)*piece_size,   ty0 + (y)*piece_size,
                            tx0 + (x+1)*piece_size, ty0 + (y+1)*piece_size
                            );
                    //piece.set_anchor_point_from_gravity (
                    //        Clutter.Gravity.CENTER
                    //        );
                    
                    //piece.reactive = true;
                    //piece.rotation_angle_z = 15.0f;                    

                    this.setup_piece (x, y, piece);


//                    if (false)
//                    {
//                        piece.set_position (
//                                x * piece_size,
//                                y * piece_size
//                                );
//                        container.add_actor (piece);
//                        piece.reactive = true;
//                        this.add_actions (piece);
//                    }
//                    else
                    {
                        /* wrap to a group */
                        var group = new Puzzle.Group ();
                        group.set_anchor_point_from_gravity (Clutter.Gravity.CENTER);
                        group.set_position (x * piece_size, y * piece_size);
                        group.add_actor (piece);

                        // TODO: Random rotation
                        //piece.set_z_rotation_from_gravity (0.0, Clutter.Gravity.CENTER);

                        /* Drag, Swipe, Rotate Action */
                        group.reactive = true;
                        this.add_actions (group);                        

//                        piece.reactive = true;
//                        this.add_actions (piece);                        
                        
                        container.add_actor (group);
                    }

                }
            }
        }

        this.shuffle ();

        this.started ();

        /* Start timer */
        this.timer.reset ();
        this.timer.start ();

        return true;
    }

//    public unowned Piece? get_piece (uint x, uint y)
//    {
//        if (x >= 0 && y >= 0 && x < this.cols && y < this.rows)
//            return this.pieces[y*this.cols + x];

//        return null;
//    }





        /* Find nearest pieces */
        //float x1 = actor.x + actor.rotation_center_x + delta_x - 1.666f*actor.width;
        //float y1 = actor.y + actor.rotation_center_y + delta_y - 1.666f*actor.height;

        //actor.get_action ("drag");
        //return;


    /*
    
    Group #1
    
    Group #2


    
    */

    private void find_nearest (Clutter.Actor actor, out Clutter.Actor actor_nearest, out float actor_dx, out float actor_dy, out float actor_angle)
    {
        Clutter.Container parent = actor.get_parent() as Clutter.Container; // this.stage
        
        float bounding_box_multiply = 1.0f;
        // float bounding_box_multiply = 1.414213562f; // if rotations_enabled

        float snap_distance   = 10.0f + 0.10f * this.piece_size; /* Actually, if piecies of different size, no snapping */
        float unsnap_distance = snap_distance;
        float distance        = float.MAX;
        float angle           = 0.0f;

        /* Make it harder to unsnap */
        //if (this.nearest != group2)
        //    unsnap_distance *= 1.5f;


        Puzzle.Group group1 = actor as Puzzle.Group;

        float group_x1 = group1.x +                 group1.width  * bounding_box_multiply - unsnap_distance;
        float group_y1 = group1.y +                 group1.height * bounding_box_multiply - unsnap_distance;
        float group_x2 = group1.x + group1.width  + group1.width  * bounding_box_multiply + unsnap_distance;
        float group_y2 = group1.y + group1.height + group1.height * bounding_box_multiply + unsnap_distance;

        Puzzle.Nearest nearest = Puzzle.Nearest () {
                actor  = null
            };


        /*
         * Iterate stage children
         */
        foreach (Clutter.Actor sibling in parent.get_children())
        {
            if (sibling == actor)
                continue;

            if ((sibling is Puzzle.Group) == false)
                continue;
            
            Puzzle.Group group2 = sibling as Puzzle.Group;
            
            /* Check groups box collision */
            if (group2.x < group_x1 || group2.x > group_x2 ||
                group2.y < group_y1 || group2.y > group_y2)
                continue;
            
            bool pieces_match = true;

            /*
             * Iterate children of Group 1
             */
            foreach (Clutter.Actor child1 in group1.get_children())
            {
                Puzzle.Piece     piece1      = child1 as Puzzle.Piece;
                Puzzle.PieceSide piece1_side = Puzzle.PieceSide.TOP;

                snap_distance   = float.min (10.0f + 0.10f * piece1.size, 0.5f*piece1.size); // it should be constant
                unsnap_distance = snap_distance;               // it should be constant
                distance        = float.MAX;

                /* Make it harder to unsnap */
                if (this.nearest != group2)
                    unsnap_distance *= 1.5f;

                
                /* FIXME: positions do not match */

                /* ...unsnap distance is always bigger or equal snap distance, so this will suffice */
                float piece_x1 = group2.x - group1.y + child1.x - child1.width  * bounding_box_multiply - unsnap_distance;
                float piece_y1 = group2.y - group1.y + child1.y - child1.height * bounding_box_multiply - unsnap_distance;
                float piece_x2 = group2.x - group1.y + child1.x + child1.width  * bounding_box_multiply + unsnap_distance;
                float piece_y2 = group2.y - group1.y + child1.y + child1.height * bounding_box_multiply + unsnap_distance;

                ///* ...unsnap distance is always bigger or equal snap distance, so this will suffice */
                //float piece_x1 = group1.x + child1.x - child1.width  * bounding_box_multiply - unsnap_distance;
                //float piece_y1 = group1.x + child1.y - child1.height * bounding_box_multiply - unsnap_distance;
                //float piece_x2 = group1.x + child1.x + child1.width  * bounding_box_multiply + unsnap_distance;
                //float piece_y2 = group1.x + child1.y + child1.height * bounding_box_multiply + unsnap_distance;

                
//                Cogl.Matrix piece1_matrix,
//                            piece1_matrix_inv,
//                            piece2_matrix,
//                            tmp;
//                    
//                piece1_matrix = piece1.get_transformation_matrix ();
//                piece1_matrix.transform_point (ref a_center[0], ref a_center[1], ref a_center[2], ref a_center[3]);
                                
                /*
                 * Iterate children of Group 2
                 */
                foreach (var child2 in group2.get_children())
                {
                    Puzzle.Piece     piece2      = child2 as Puzzle.Piece;
                    Puzzle.PieceSide piece2_side = Puzzle.PieceSide.TOP;

                    /* Check pieces box collision */
                    if (piece2.x < piece_x1 || piece2.x > piece_x2 ||
                        piece2.y < piece_y1 || piece2.y > piece_y2)
                        continue;
                    
//                    piece2_matrix = piece2.get_transformation_matrix ();        
//                    a_matrix.translate (a.x, a.y, 0.0f);
//                    b_matrix.translate (b.x, b.y, 0.0f);
//                    a_matrix.get_inverse (out a_matrix_inv);
//                    a_matrix.translate (-a.width/2.0f, -a.height/2.0f, 0.0f);
//                    a_matrix_inv.translate (a.width/2.0f, a.height/2.0f, 0.0f);
//                    a_matrix_inv.get_inverse (out a_matrix);

//                    float piece1_center[4] = { piece1.size/2.0f, piece1.size/2.0f, 0.0f, 0.0f };
//                    float piece2_center[4] = { piece2.size/2.0f, piece2.size/2.0f, 0.0f, 0.0f };
                    
//                    tmp.multiply (a_matrix_inv, b_matrix);
                    
//                    a_matrix.transform_point (ref a_center[0], ref a_center[1], ref a_center[2], ref a_center[3]);
//                    b_matrix.transform_point (ref b_center[0], ref b_center[1], ref b_center[2], ref b_center[3]);

                    float vector[2] = {
                            (group2.x + piece2.x) - (group1.x + piece1.x),
                            (group2.y + piece2.y) - (group1.y + piece1.y)
                            };
                    
//                    float vector[2] = {
//                            (piece2.x + piece2_matrix.wx + piece2_center[0]) - (piece1.x + piece1_matrix.wx  + piece1_center[0]),
//                            (piece2.y + piece2_matrix.wy + piece2_center[1]) - (piece1.y + piece1_matrix.wy  + piece1_center[1])
//                            };


                    /* Check overlapping, snap only if pieces does not overlap */
//                    if (Math.fabs(vector[0]) < piece_size && Math.fabs(vector[1]) < piece_size)
//                        continue;
                    
                    //a_matrix_inv.transform_point (ref vector[0], ref vector[1], ref vector[2], ref vector[3]);
                    var vector_angle = Math.atan2f (vector[1], vector[0]) * 180.0f / Math.PI;
                    
                    var piece1_angle = piece1.rotation_angle_z + vector_angle + 90;
                    var piece2_angle = piece2.rotation_angle_z + vector_angle - 90;

                    if (piece1_angle < 0)
                        piece1_angle = 360 + (piece1_angle % 360);

                    if (piece2_angle < 0)
                        piece2_angle = 360 + (piece2_angle % 360);
                    
                    piece1_side = (PieceSide)(int) Math.floor (((piece1_angle + 45) % 360) / 90);
                    piece2_side = (PieceSide)(int) Math.floor (((piece2_angle + 45) % 360) / 90);
                    
                    var dx = piece1.x - (piece2.x + (piece2_side == PieceSide.LEFT ? -piece1.size : (piece2_side == PieceSide.RIGHT  ? piece2.size : 0.0f)));                    
                    var dy = piece1.y - (piece2.y + (piece2_side == PieceSide.TOP  ? -piece1.size : (piece2_side == PieceSide.BOTTOM ? piece2.size : 0.0f)));


                    distance = dx*dx + dy*dy;

//                    if (current_nearest_piece == piece2)
//                    {
//                        /* Check snap distance */
//                        if (distance > unsnap_distance*unsnap_distance)
//                            continue;
//                        
//                        /* Find nearest piece */
//                        if (distance*0.5 >= this.drag_data.nearest_distance)
//                            continue;
//                    }
//                    else
//                    {
                        print ("finding nearest...\n");

                        /* Check snap distance */
                        if (distance > snap_distance*snap_distance)                            
                            continue;

                        /* Find nearest piece */
                        if (distance >= this.drag_data.nearest_distance)
                            continue;
//                    }

                    
                        print ("found nearest\n");
                    
//                    /* Check edge match */
//                    var edge1 = piece1.get_edge (piece1_side);
//                    var edge2 = piece2.get_edge (piece2_side);
//                    
//                    if (edge1.match (edge2))
//                    {
                        nearest.actor    = sibling;
                        nearest.distance = float.min (distance, nearest.distance);
                        nearest.angle    = (float)(sibling.rotation_angle_z - actor.rotation_angle_z);
                        nearest.dx       = (sibling.x + child2.x) - (actor.x + child1.x); // XXX is it ok?
                        nearest.dy       = (sibling.y + child2.y) - (actor.y + child1.y);
////                        dx = group2.x + piece2.x - (piece2_side == PieceSide.LEFT
////                                    ? -piece1.piece_size : (piece_side == PieceSide.RIGHT  ? piece2.size : 0.0f));
////                        dy = group2.y + piece2.y - (piece1_side == PieceSide.TOP
////                                    ? -piece1.size : (piece2_side == PieceSide.BOTTOM ? piece2.size : 0.0f));
//                    }
                }
            }
            
            if (pieces_match && nearest.distance < distance)
            {
                actor_nearest  = nearest.actor;
                //actor_distance = nearest.distance;
                actor_angle    = nearest.angle;
                actor_dx       = nearest.dx;
                actor_dy       = nearest.dy;            
                break;
            }
        }

//        actor_nearest  = nearest.actor;
////        actor_distance = nearest.distance;
//        actor_angle    = nearest.angle;
//        actor_dx       = nearest.dx;
//        actor_dy       = nearest.dy;
    }


    Clutter.Actor nearest;

    private void on_piece_drag_begin (Clutter.DragAction action, Clutter.Actor actor, float event_x, float event_y,
                                      Clutter.ModifierType modifier)
    {
        if (actor is Puzzle.Group)
        {
            this.nearest = null;
            
            var handle = new Clutter.Clone (actor);
            handle.x = actor.x;
            handle.y = actor.y;
            handle.rotation_angle_z = actor.rotation_angle_z;
            handle.set_anchor_point_from_gravity (actor.get_anchor_point_gravity());

            var container = actor.get_parent() as Clutter.Container;
            container.add_actor (handle);

            action.set_drag_handle (handle);

            actor.raise_top ();
            actor.hide ();
            
            handle.raise_top ();
            handle.animate (Clutter.AnimationMode.EASE_OUT_EXPO, 300,
                    "scale-x", 1.03,
                    "scale-y", 1.03
                    );
            
            //actor.set_z_rotation_from_gravity (45.0, Clutter.Gravity.CENTER);
            
            //if (actor.rotation_angle_z == 0.0)
            //    actor.animate (Clutter.AnimationMode.EASE_OUT_EXPO, 500, "rotation-angle-z", 45.0);
            //actor.transform_stage_point ();
        }
    }

    private void on_piece_drag_motion (Clutter.DragAction action, Clutter.Actor actor, float delta_x, float delta_y)
    {
        var handle = action.get_drag_handle ();
    
//        Puzzle.Group nearest = this.drag_data.nearest_piece;
        Clutter.Actor nearest;
        float dx, dy, angle;

        actor.x = Math.roundf (actor.x);
        actor.y = Math.roundf (actor.y);
        actor.width  = Math.roundf (actor.width);
        actor.height = Math.roundf (actor.height);        
        
        
        this.find_nearest (actor, out nearest, out dx, out dy, out angle);        
 
                
        if (nearest != null)
        {
            if (this.nearest != nearest)
            {
                /*
                 * Snap to nearest
                 */
                print ("Snap to nearest\n");
                this.nearest = nearest;
                
//                Puzzle.Piece piece = actor as Piece;               
                
//                /* FIXME Fix some wobbling due to DragAction/floating point inaccuracy */
//                if (Math.fabs (this.drag_data.handle.x - this.drag_data.nearest_piece.x + x) < 1.75 && 
//                    Math.fabs (this.drag_data.handle.y - this.drag_data.nearest_piece.y + y) < 1.75)
//                    return;
                
                // handle.animate (Clutter.AnimationMode.EASE_OUT_BACK, 200,
                handle.animate (Clutter.AnimationMode.EASE_OUT_EXPO, 150,
                        "x", actor.x + dx,
                        "y", actor.y + dy
                        );
            }
        }
        else
        {
            if (this.nearest != null)
            {
                /*
                 * Unsnap
                 */
                print ("Unsnap\n");
                this.nearest = null;
                
                if (Math.fabs(actor.x - this.drag_data.handle.x) < 2.0f &&
                    Math.fabs(actor.y - this.drag_data.handle.y) < 2.0f)
                {
                    handle.set_position (actor.x, actor.y);
                }
                else
                {
                    handle.animate (Clutter.AnimationMode.EASE_OUT_EXPO, 200,
                            "x", actor.x,
                            "y", actor.y,
                            "rotation-angle-z", actor.rotation_angle_z
                            );
                }
            }
        }
    }

    private void on_piece_drag_end (Clutter.DragAction action, Clutter.Actor actor, float event_x, float event_y,
                                    Clutter.ModifierType modifier)
    {
        var handle = action.get_drag_handle ();
//        Piece piece = actor as Piece;

        /* End dragging */
        if (handle != null)
        {
            /* FIXME: If handle is has animated position,
             *        get position end point from that animation
             */          
            actor.set_position (handle.x, handle.y);
            actor.set_scale (handle.scale_x, handle.scale_y);
            actor.animate (Clutter.AnimationMode.EASE_OUT_EXPO, 300,
                    "scale-x", 1.00,
                    "scale-y", 1.00
                    );
            actor.show ();

            var container = handle.get_parent() as Clutter.Container;
            container.remove_actor (handle);
        }


        /* Group */
        if (this.nearest != null)
        {
//                        Clutter.Actor     nearest = this.drag_data.nearest_piece;
//            //            Clutter.Container parent;
//                        
//                        var group = nearest.group != null ? nearest.group : piece.group;
//                        
//                        if (group == null)
//                        {
//                            var parent = actor.get_parent ();
//                            
//                            group = new Puzzle.Group ();
//                            
//                            
//                            parent.add_actor (group);
//                        }
//                        
//                        actor.get_parent () as Clutter.Container;
//                        
//                        // TODO
//                        if (group != actor)
//                        {
//                            (actor.get_parent () as Clutter.Container).remove (actor);
//                            group.add_actor (actor);
//                        }
//                        
//                        if (group != actor)
//                        {
//                            (nearest.get_parent () as Clutter.Container).remove (nearest);
//                            group.add_actor (nearest);
//                        }
//                        
//                        /* New Group */
//            //            group.move_anchor_point_from_gravity (Clutter.Gravity.CENTER);


//            //            group.set_position (
//            //                    0.0f,
//            //                    0.0f
//            //                    );
//            //            
//            //            nearest.set_position (
//            //                    0.0f, 0.0f
//            //                    );
//            //            
//            //            actor.set_position (
//            //                    actor.x - group.x,
//            //                    actor.y - group.y
//            //                    );
//                        
//                        actor.reactive = false;
//                        nearest.reactive = false;

//                       
//            //            GLib.Idle.add (() => {
//            //                print ("destroy actions\n");
//            //                this.remove_actions (actor);
//            //                this.remove_actions (nearest);
//            //                return false;
//            //            });
//                        
//                        group.reactive = true;
//                        this.add_actions (group);


//                        
//                        /* Join Group */
//                        
//                        
//                        /* Join Groups */
//                        
        }


        /* TODO Sort pieces table by Y, then by X */

    }


    public void add_actions (Clutter.Actor actor)
    {
        var action = new Clutter.DragAction ();
        //action.set_drag_threshold (0, 0);
        //action.set_drag_axis (Clutter.DragAxis.NONE);

        action.drag_begin.connect (this.on_piece_drag_begin);
        action.drag_motion.connect (this.on_piece_drag_motion);
        action.drag_end.connect (this.on_piece_drag_end);

        actor.add_action_with_name ("drag-action", action);
    }

    public void remove_actions (Clutter.Actor actor)
    {
        actor.remove_action_by_name ("drag-action");
        //actor.clear_actions ();
    }




    public void setup_piece (uint x, uint y, Piece piece)
    {
        if (x < this.cols && y < this.rows)
        {
            var top  = this.pieces.nth_data (this.cols-1) as Puzzle.Piece;
            var left = this.pieces.nth_data (0) as Puzzle.Piece;

            if (left == null)
                piece.get_edge (PieceSide.LEFT).set_shaped (false);
            else
                piece.get_edge (PieceSide.LEFT).set_path (
                            left.get_edge (PieceSide.RIGHT).path_reversed);
                //piece.set_edge (left.get_edge (PieceSide.RIGHT));
//                piece.get_edge (PieceSide.LEFT).reverse ();
            
            if (top == null)
                piece.get_edge (PieceSide.TOP).set_shaped (false);
            else
                piece.get_edge (PieceSide.TOP).set_path (
                            top.get_edge (PieceSide.BOTTOM).path_reversed);
//                piece.get_edge (PieceSide.TOP).reverse ();

            if (x == this.cols-1)
                piece.get_edge (PieceSide.RIGHT).set_shaped (false);

            if (y == this.rows-1)
                piece.get_edge (PieceSide.BOTTOM).set_shaped (false);



//            if (left != null)
//                piece.get_edge (PieceSide.LEFT).get_opposite (piece.get_edge (PieceSide.RIGHT));
//                //piece.get_edge (PieceSide.LEFT).join (piece.get_edge (PieceSide.RIGHT)

//            if (top != null)
//                piece.get_edge (PieceSide.BOTTOM).join (piece.get_edge (PieceSide.RIGHT)


            piece.prepare ();

            this.pieces.prepend (piece);
        }
    }
    
    public void shuffle ()
    {
        /* TODO
	    if (!game || !game->canvas)
		    return FALSE;
	
	    puzzle_new_game (g_strdup (game->filename));

	
	    {
		    GList *iter = all_puzzles;		
		    puzzle_t *puzzle;
		
		    gdouble width  = MAX (game->puzzle_size * game->width,  game->canvas->allocation.width)  - game->puzzle_size;
		    gdouble height = MAX (game->puzzle_size * game->height, game->canvas->allocation.height) - game->puzzle_size;
		
		
		    while (iter)
		    {
			    puzzle = (puzzle_t*) iter->data;
			    iter   = iter->next; 	

			    puzzle->x = (gint)(rand_range (0, width,  (gint)width));
			    puzzle->y = (gint)(rand_range (0, height, (gint)height));		
		    }
	    }
	
	    gtk_widget_queue_draw (game->canvas);
        */
    }
    
    public bool is_solved ()
    {
        /* TODO
	    if (!all_groups || all_groups->next) // check if only one group left
		    return FALSE;

	    if (game->solved)
		    return TRUE;
	
	    // Sort puzzles in group by id
	    // when there is only one group left, we can use 'all_puzzles' or 'layers' to sort puzzles
	    {			
		    GList *iter, *group;
			    group = g_list_copy (all_puzzles);			
			    group = g_list_sort (group, puzzle_sort_by_id);
			    iter  = group;	
		
		    puzzle_t *puzzle = (puzzle_t*) group->data;
		    gdouble x = puzzle->x,
				    y = puzzle->y;

		    iter = group;	
		
		    while (iter)
		    {
			    puzzle = (puzzle_t*) iter->data;
			
			    if (puzzle)
			    {
				    if (y > puzzle->y || (x > puzzle->x && y == puzzle->y))
				    {
					    g_message ("Puzzles not solved.");
					    //g_free (group);
					    return FALSE;
				    }
				    x = puzzle->x;
				    y = puzzle->y;
			    }
			    iter = iter->next;
		    }

		    //g_free (group);
	    }
	

	    game->solved = TRUE;
	
	    // User solved the puzzle - show dialog 
	    puzzle_solved_dialog ();

	    return game->solved;
	    */
	    return false;
	}
    
    
    public void show_solved_dialog ()
    {
        print ("Solved in %gs\n", this.timer.elapsed());
    }









        
    
    
    public void show_dialog (Gtk.Window? parent_window)
    {        
        var dialog = new Gtk.FileChooserDialog ("Choose Picture", parent_window, Gtk.FileChooserAction.OPEN);
        dialog.set_modal (true);
        //dialog.set_current_folder_uri ();

        var filter = new Gtk.FileFilter ();
        filter.set_name ("Supported image files");
        filter.add_pixbuf_formats ();
        dialog.add_filter (filter);

		/* Buttons */
		var button = new Gtk.Button.with_mnemonic ("_New Game");
		button.set_can_default (true);
		button.show ();
		
		button.clicked.connect (() => {
		    dialog.response (Gtk.ResponseType.OK);
		});
        
		dialog.add_button (Gtk.Stock.CANCEL, Gtk.ResponseType.CANCEL);
		dialog.add_action_widget (button, Gtk.ResponseType.OK);

        dialog.response.connect (this.on_dialog_response);

        dialog.present ();
    }


    private void on_dialog_response (Gtk.Dialog dialog, int response_id)
    {
        if (response_id == Gtk.ResponseType.OK)
        {
            var filechooser = dialog as Gtk.FileChooserDialog;
            this.new_game (filechooser.get_uri ());
            //print ("New Game\n");
        }

        dialog.destroy ();
    }




    /*
     * Signals
     */
    public virtual signal void started () {
        
    }

    public virtual signal void paused () {    
    }

    public virtual signal void resumed () {    
    }

    public virtual signal void solved () {
        this.timer.stop ();
        print ("\nYeah!!! Solved in %gs\n", this.timer.elapsed());    
    }    
}


//public float SNAP (float a, float b, float c)
//{
//    if (Math.fabs(a) < Math.fabs(b))
//        return Math.fabs(a) < Math.fabs(c) ? a : c;
//    else
//        return Math.fabs(b) < Math.fabs(c) ? b : c;
//}
