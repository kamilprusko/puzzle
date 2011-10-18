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
    public float rand_range (float min, float max, int steps)
    {
	    return (float)(min + (Random.double_range(0.0, max-min) % steps) / (steps-1));
    }
/*
    public void curve_to (Cairo.Context cr, ref double x1, ref double y1, double x2, double y2, double distance, double angle)
    {
        var vx = distance * Math.cos(angle);
        var vy = distance * Math.sin(angle);

        cr.curve_to (x1, y1, x2-vx, y2-vy, x2, y2);
        //cr.rel_curve_to // TODO
        
        x1 = x2 + vx;
        y1 = y2 + vy;
    }
*/
    public struct Point //: Cairo.PathDataPoint
    {
        public float x;
        public float y;
    }
}


public class Puzzle.Edge : Object
{
    public Cairo.Path path;
    public Cairo.Path path_reversed;

    public weak Piece piece;
    public weak Edge  peer;

    public float length;
    public float extent;


    construct {
    }

    public Edge (float length)
    {
        this.length = length;
        this.extent = (float) Math.ceil (0.3 * this.length); // wideness
        //this.piece  = parent_piece;
        
        this.set_shaped (true);
        //this.prepare (0);
    }

    public void set_path (Cairo.Path path)
    {
//        this.path = cairo_path_copy (path);
        this.path_reversed = cairo_path_reverse (path);
        this.path          = cairo_path_reverse (this.path_reversed);
    }
    
    public unowned Cairo.Path get_path ()
    {   
        return this.path;
    }

    public void reverse ()
    {
        //cairo_path_free (this.path);

//        var tmp = this.get_path();
//        
//        this.path = cairo_path_own (this.path_reversed);
//        this.path_reversed = cairo_path_own (tmp); 
                
        //return this.path_opposite;
    }

//    public unowned Cairo.Path get_path_opposite ()
//    {
//        return this.path_opposite;
//    }    
    
    public void set_shaped (bool shaped)
    {
        if (shaped)
        {
            this.path          = this.create_path (1, false);
            this.path_reversed = cairo_path_reverse (this.path);      
        }
        else
        {
            this.path          = this.create_path (0, false);
            this.path_reversed = cairo_path_reverse (this.path);
        }
    }
    
    /* Create edge`s path (without rotation) */
    private Cairo.Path create_path (int32 seed, bool opposite)
    {
        //var path = new Clutter.Path ();
        var path = cairo_path_new ();
        
        //path.num_data = data.length;

//        for (var i=0; i < data.length; i++)
//        {

//        path.add_line_to (0, 0);
        var side = opposite ? -1.0 : 1.0;
        cairo_path_line_to (path, 0.0, 0.0); /* move_to would make appended edges/paths uncontinous */
 
        if (seed == 0)
        {
            /*
             * .________.
             */
            cairo_path_line_to (path, (int) Math.floor(this.length), 0);
        }
        else
        {
		    /*      .~mid
		     *   .(   ).      *side* determines is it a whole or a pin
		     * .__.) (.__.    *mid* is a x-cordinate for an pin      
		     */

// /* TODO

//            points[0] = Cairo.PathDataPoint () { x=0.0, y=0.0 };
//            points[7] = Cairo.PathDataPoint () { x=this.length, y=0.0 };

            var rand = new Rand();
            rand.set_seed (6);

    //        this.points = new Point[18];
//            var mid = this.length * rand_range (0.45f, 0.55f, 3);
            //var side = rand.boolean() ? -1 : 1;

                                   
//            var padding = 0.2;

//            var a = padding * 0.5;
//            var b = padding * 0.4;

//            var c = padding - 2.0;
//            var d = padding * 0.45;
//            var e = -1.0;

//            var x = 0.0;
//            var y = 0.0;

//            // determine first slope with distance of 0.1
//            x += 0.1 * Math.cos (0.0);
//            y += 0.1 * Math.sin (0.0);

//            points[1].y
//            points[6].y

//            cairo_path_curve_to (path,
//                    points[0].x+0.1*this.length, points[0].y-this.extent,
//                    points[7].x-0.1*this.length, points[7].y-this.extent,
//                    points[7].x, points[7].y
//                    );

            var extent = (float) (side * 0.9f * this.extent);
            var length = (float) this.length;


            Puzzle.Point points[10];

            points[0].x =  0.0f;
            points[0].y =  0.0f;
            
            points[1].x =  0.20f * length;
            points[1].y = -0.1f * extent;

            points[2].x =  0.45f * length;
            points[2].y =  0.0f * extent;

            points[3].x =  0.5f * length - 0.5f * extent;
            points[3].y =  0.25f * extent;

            points[4].x =  0.5f * length - 0.5f * extent;
            points[4].y =  1.0f * extent;

            points[5].x =  0.5f * length + 0.5f * extent;
            points[5].y =  1.0f * extent;

            points[6].x =  0.5f * length + 0.5f * extent;
            points[6].y =  0.25f * extent;

            points[7].x =  0.55f * length;
            points[7].y =  0.0f * extent;

            points[8].x =  0.80f * length;
            points[8].y = -0.1f * extent;

            points[9].x =  length;
            points[9].y =  0.0f;


            cairo_path_from_control_points (path,
                    points[0], points[1], points[2]);

            cairo_path_from_control_points (path,
                    points[1], points[2], points[3]);

            cairo_path_from_control_points (path,
                    points[2], points[3], points[4]);

            cairo_path_from_control_points (path,
                    points[3], points[4], points[5]);

            cairo_path_from_control_points (path,
                    points[4], points[5], points[6]);

            cairo_path_from_control_points (path,
                    points[5], points[6], points[7]);

            cairo_path_from_control_points (path,
                    points[6], points[7], points[8]);

            cairo_path_from_control_points (path,
                    points[7], points[8], points[9]);

            cairo_path_line_to (path, length, 0.0);

//            cairo_path_line_to (path, points[1].x, points[1].y);
//            cairo_path_line_to (path, points[2].x, points[2].y);
//            cairo_path_line_to (path, points[3].x, points[3].y);
//            cairo_path_line_to (path, points[4].x, points[4].y);
//            cairo_path_line_to (path, points[5].x, points[5].y);
//            cairo_path_line_to (path, points[6].x, points[6].y);
//            cairo_path_line_to (path, points[7].x, points[7].y);

//            cairo_path_line_to (path, points[0].x, points[0].y);
//            cairo_path_line_to (path, points[1].x, points[1].y);
//            cairo_path_line_to (path, points[2].x, points[2].y);
//            cairo_path_line_to (path, points[3].x, points[3].y);
//            cairo_path_line_to (path, points[4].x, points[4].y);
//            cairo_path_line_to (path, points[5].x, points[5].y);
//            cairo_path_line_to (path, points[6].x, points[6].y);
//            cairo_path_line_to (path, points[7].x, points[7].y);
            
//            cairo_path_line_to (path,
//                    (int) Math.floor (this.length) / 3,
//                    (int) Math.floor (side * this.extent * 0.9)
//                    );
        }

        //cairo_path_line_to (path, (int) Math.floor(this.length), 0);

        
        return path;
    }

    public override void dispose ()
    {
        /*
        if (this.path != null)
            cairo_path_free (this.path);

        if (this.path_opposite != null)
            cairo_path_free (this.path_opposite);

        this.path = null;
        this.path_opposite = null;
        */
    }

    public bool match (Edge other_edge)
    {
        return cairo_path_match (this.path_reversed, other_edge.path);
        
        /*
	    cairo_path_t *path_a = edge_a->path;
	    cairo_path_t *path_b = edge_b->path;
	
	    if (path_a->num_data != path_b->num_data)
		    return FALSE;
	
	    if (edge_a == edge_b)
		    return TRUE;
	
	    /* Iterarte by path segments *
	    gint j, k;
	
	    for (j=0; j < path_a->num_data; j += path_a->data[j].header.length)
	    {
		    cairo_path_data_t *path_data_a = &path_a->data[j];
		    cairo_path_data_t *path_data_b = &path_b->data[j];
		
		    if ((path_data_a->header.type   != path_data_b->header.type)  ||
			    (path_data_a->header.length != path_data_b->header.length))
			    return FALSE;
		
		    // iter by segment points
		    for (k=1; k < path_data_a->header.length; k++)
			    if ((path_data_a[k].point.x != path_data_b[k].point.x) ||
				    (path_data_a[k].point.y != path_data_b[k].point.y))
				    return FALSE;
	    }
	    */
	    return true;
    }

}


namespace Puzzle
{

    void cairo_path_from_control_points (Cairo.Path path,
                                         Puzzle.Point a,  Puzzle.Point b,  Puzzle.Point c)
    {
//        cairo_path_curve_to (path,
//                    a.x, a.y,
//                    b.x, b.y,
//                    c.x, c.y
//                    );
        cairo_path_curve_to (path,
                    0.25f*a.x + 0.75f*b.x,
                    0.25f*a.y + 0.75f*b.y,
                    0.25f*c.x + 0.75f*b.x,
                    0.25f*c.y + 0.75f*b.y,                    
                    0.50f*b.x + 0.50f*c.x,
                    0.50f*b.y + 0.50f*c.y
                    );
    }
}

