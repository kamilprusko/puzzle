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

public class Puzzle.Group : Puzzle.Grid // Clutter.Group
{

//    public int get_n_children ();
//    public unowned Clutter.Actor get_nth_child (int index_);


/*
    public void add_actor (Clutter.Actor actor)
    {    
        if (actor is Puzzle.Group)
            this.add_group (actor as Puzzle.Group);

        else if (actor is Puzzle.Piece)
            this.add_piece (actor as Puzzle.Piece);
    }

    public void remove_actor (Clutter.Actor actor)
    {
        if (actor is Puzzle.Piece)
            this.remove_piece (actor as Puzzle.Piece);
    }

    public void add_group (Puzzle.Group group)
    {
    }    

    public void add_piece (Puzzle.Piece piece)
    {        
        piece.@ref();
    }    
*/


//    /* Remove piece */
//    public void remove_piece (Puzzle.Piece piece)
//    {
//    }



    /* Find if groups can be conected */
    public bool find_alignment (Puzzle.Group group, out float dx, out float dy, out float angle)
    {
        /* TODO: rotations */
        
        int group_col_min = (int) Math.floorf ((group.x - this.x) / this.spacing);
        int group_col_max = (int) Math.ceilf ((group.x - this.x) / this.spacing);

        int group_row_min = (int) Math.floorf ((group.y - this.y) / this.spacing);
        int group_row_max = (int) Math.ceilf ((group.y - this.y) / this.spacing);

        var group_children = group.get_children ();
     
        return false;   
    }

    
    /* Find unconnected subgroups within a group */
    public GLib.List<Puzzle.Group> @break ()
    {
        GLib.SList<unowned Clutter.Actor>[] actors = new GLib.SList<unowned Clutter.Actor> [this.rows*this.cols];

        // TODO: rewrite it to more vala-ish code
        //GLib.SList** assoc = GLib.malloc0 (sizeof(GLib.SList*)*this.rows*this.cols);

        var assoc = new GLib.HashTable<unowned Clutter.Actor, unowned GLib.SList<unowned Clutter.Actor>>(GLib.direct_hash, GLib.direct_equal);
        
        var children = this.get_children ();
        
        /* Each piece has its own group at start */
        for (int i=0; i < this.rows*this.cols; i++)
        {
            if (children[i] != null)
            {
            //    assoc[i] = null;
            //else{
                actors[i].prepend (children[i]);
                //assoc[i] = (GLib.SList*) actors[i];

                assoc.insert (children[i], actors[i]);
            }
        }
        
        /* Associate neighboring pieces */
        for (int row=0; row < this.rows-1; row++)
        {
            for (int col=0; col < this.cols-1; col++)
            {
                if (children[row*this.cols + col] == null)
                    continue;
                
                var current = row*this.cols + col;
                var right   = current + 1;
                var below   = current + this.cols;
                
                if (children[right] != null) // right
                {
                    unowned GLib.SList<unowned Clutter.Actor> list_current = assoc.lookup (children[current]);
                    unowned GLib.SList<unowned Clutter.Actor> list_right   = assoc.lookup (children[right]);
                                        
                    list_current.concat (list_right.copy()); // TODO.. there's no need for copy

                    assoc.replace (children[right], list_current);
                }

                if (children[right] != null) // below
                {
                    unowned GLib.SList<unowned Clutter.Actor> list_current = assoc.lookup (children[current]);
                    unowned GLib.SList<unowned Clutter.Actor> list_below   = assoc.lookup (children[below]);
                                        
                    list_current.concat (list_below.copy()); // TODO.. there's no need for copy

                    assoc.replace (children[below], list_current);
                }

            //    if (children[right] != null) // right
            //    {
            //        (*assoc[current]).concat ((*assoc[right]));
            //        assoc[right] = assoc[current];
            //    }                

            //    if (children[below] != null) // top
            //    {
            //        (*assoc[current]).concat ((*assoc[bottom]));
            //        assoc[bottom] = assoc[current];
            //    }                
            }
        }
        
        /* Find subgroups and break */    
        GLib.List<Puzzle.Group> groups = new GLib.List<Puzzle.Group>();

        var lists = assoc.get_values ();
        // void *prev = null;      

        print ("Break group into:\n");
        foreach (var list in lists)
        {
            print ("- subgroup of #%d\n", (int)list.length ());
            //if (list.data != prev)
            //    groups.prepend (list);
            //prev = list.data;
        }
        print ("\n");

        return groups;
    }
    
//    public GLib.Array<weak Puzzle.Piece> get_children ();
    
    
    /* Container */
//        public void add (params Clutter.Actor[] actors);
//        [CCode (vfunc_name = "add")]
//        public abstract void add_actor (Clutter.Actor actor);
//        public void add_valist (Clutter.Actor first_actor, void* var_args);
//        public void child_get (Clutter.Actor actor, ...);
//        public void child_get_property (Clutter.Actor child, string property, GLib.Value value);
//        public void child_set (Clutter.Actor actor, ...);
//        public void child_set_property (Clutter.Actor child, string property, GLib.Value value);
//        [NoWrapper]
//        public virtual void create_child_meta (Clutter.Actor actor);
//        [NoWrapper]
//        public virtual void destroy_child_meta (Clutter.Actor actor);
//        public unowned Clutter.Actor find_child_by_name (string child_name);
//        [CCode (cname = "clutter_container_class_find_child_property")]
//        public class unowned Clutter.ParamSpecColor find_child_property (string property_name);
//        public abstract void @foreach (Clutter.Callback callback);
//        public virtual void foreach_with_internals (Clutter.Callback callback);
//        public virtual unowned Clutter.ChildMeta get_child_meta (Clutter.Actor actor);
//        public GLib.List<weak Clutter.Actor> get_children ();
//        [CCode (cname = "clutter_container_class_list_child_properties")]
//        public class unowned Clutter.ParamSpecColor list_child_properties (uint n_properties);
//        [CCode (vfunc_name = "lower")]
//        public virtual void lower_child (Clutter.Actor actor, Clutter.Actor? sibling = null);
//        [CCode (vfunc_name = "raise")]
//        public virtual void raise_child (Clutter.Actor actor, Clutter.Actor? sibling = null);
//        public void remove (params Clutter.Actor[] actors);
//        [CCode (vfunc_name = "remove")]
//        public abstract void remove_actor (Clutter.Actor actor);
//        public void remove_valist (Clutter.Actor first_actor, void* var_args);
//        public virtual void sort_depth_order ();
//        public signal void actor_added (Clutter.Actor actor);
//        public signal void actor_removed (Clutter.Actor actor);
//        public signal void child_notify (Clutter.Actor actor, Clutter.ParamSpecColor pspec);


    
    private GLib.List<Puzzle.Edge> outer_edges;



    public unowned GLib.List<Puzzle.Edge> get_outer_edges ()
    {
        return this.outer_edges;
    }

        
}
