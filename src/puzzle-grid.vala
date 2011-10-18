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


///**
// * SECTION:puzzle-grid
// * @short_description: a simple container placing children in equal spaces.
// */
//[Compact]
//public class Puzzle.GridActorData
//{
//    uint row;
//    uint col;
//    //gfloat   pref_width, pref_height;
//}

//struct _MxGridActorData
//{
//  gboolean xpos_set,   ypos_set;
//  gfloat   xpos,       ypos;
//  gfloat   pref_width, pref_height;
//};


/**
 * SECTION:puzzle-grid
 * @short_description: a simple container placing children in equal spaces.
 */
public class Puzzle.Grid : Clutter.Actor, Clutter.Container // Clutter.Group
{
    private unowned Clutter.Actor[] array; // TODO rename to hash_table
    private GLib.List<Clutter.Actor> list;
    
    public uint rows { get; set; }
    public uint cols { get; set; }
    public uint spacing { get; set; }

    construct {
        this.array = null;
        this.list = null;
        this.rows = 0;
        this.cols = 0;
        
        this.spacing = (uint) Math.ceilf(Puzzle.Game.get_default().piece_size); /* FIXME: not too elegant */
    }
    
    public GLib.List<unowned Clutter.Actor> get_children ()
    {
        return this.list;
    }

    public unowned Clutter.Actor[] get_children_array ()
    {
        return this.array;
    }
    
    
    /*
     * Clutter.Container methods
     */
//  iface->add              = mx_grid_real_add;
//  iface->remove           = mx_grid_real_remove;
  
    public void @foreach (Clutter.Callback callback)
    {
        this.list.@foreach (callback);

        //for (uint i=0; i < this.rows*this.cols; i++)
        //    callback (this.children[i]);
    }
    
    public void add_actor (Clutter.Actor actor)
    {
        actor.@ref ();

        /* TODO: Animate from previous position to new one */
        actor.x = 0.0f;
        actor.y = 0.0f;

        //actor.@ref();
        actor.set_parent (this);


        if (actor is Puzzle.Grid)
        {
            /* Merge groups, take care of proper placement */            
        }
        else
        {
            if (this.array == null)
            {
                /* Insert first piece */
                this.array    = new Clutter.Actor[1]; //GLib.malloc (1 * sizeof(Clutter.Actor));
                this.array[0] = actor;
                
                this.rows = 1;
                this.cols = 1;
            }
            else
            {
                // TODO
            }
        }

        this.actor_added (actor);

        this.queue_relayout ();

        actor.unref ();
    }
    
    public void remove_actor (Clutter.Actor actor)
    {
//        uint i;

        if (this.hash_table.remove (actor))
        {
            actor.unparent ();

            this.queue_relayout ();

            this.actor_removed (actor);
        }
        
        this.list = this.list.remove (actor);

//        for (i=0; i < this.rows*this.cols; i++)
//        {
//            if (this.children[i] == actor)
//            {
//                this.children[i].unparent ();
//                this.children[i] = null;
//                //actor.unref();    
//                return;
//            }
//        }
    }
    

    /*
     * Implementations for raise, lower and sort_by_depth_order are taken from
     * ClutterBox.
     */
/*
    static void
    mx_grid_real_raise (ClutterContainer *container,
                        ClutterActor     *actor,
                        ClutterActor     *sibling)
    {
      MxGridPrivate *priv = MX_GRID (container)->priv;

      priv->list = g_list_remove (priv->list, actor);

      if (sibling == NULL)
        priv->list = g_list_append (priv->list, actor);
      else
        {
          gint index_ = g_list_index (priv->list, sibling) + 1;

          priv->list = g_list_insert (priv->list, actor, index_);
        }

      clutter_actor_queue_relayout (CLUTTER_ACTOR (container));
    }

    static void
    mx_grid_real_lower (ClutterContainer *container,
                        ClutterActor     *actor,
                        ClutterActor     *sibling)
    {
      MxGridPrivate *priv = MX_GRID (container)->priv;

      priv->list = g_list_remove (priv->list, actor);

      if (sibling == NULL)
        priv->list = g_list_prepend (priv->list, actor);
      else
        {
          gint index_ = g_list_index (priv->list, sibling);

          priv->list = g_list_insert (priv->list, actor, index_);
        }

      clutter_actor_queue_relayout (CLUTTER_ACTOR (container));
    }

    static gint
    sort_by_depth (gconstpointer a,
                   gconstpointer b)
    {
      gfloat depth_a = clutter_actor_get_depth ((ClutterActor *) a);
      gfloat depth_b = clutter_actor_get_depth ((ClutterActor *) b);

      if (depth_a < depth_b)
        return -1;

      if (depth_a > depth_b)
        return 1;

      return 0;
    }

    static void
    mx_grid_real_sort_depth_order (ClutterContainer *container)
    {
      MxGridPrivate *priv = MX_GRID (container)->priv;

      priv->list = g_list_sort (priv->list, sort_by_depth);

      clutter_actor_queue_relayout (CLUTTER_ACTOR (container));
    }
*/



// TODO
//    public new void dispose()
//    {
//        /* Destroy all of the children. This will cause them to be removed
//         from the container and unparented */
////        foreach (unowned Clutter.Actor child in this)
////        {
////            if (child != null)
////                child.destroy ();
////        }
//        this.@foreach ((Clutter.Callback) Clutter.Actor.destroy);
//        
//        base.dispose ();
//    }
    

//    static void
//    mx_grid_dispose (GObject *object)
//    {
//      MxGrid *self = (MxGrid *) object;
//      MxGridPrivate *priv;
//
//      priv = self->priv;
//
//      /* Destroy all of the children. This will cause them to be removed
//         from the container and unparented */
//      clutter_container_foreach (CLUTTER_CONTAINER (object),
//                                 (ClutterCallback) clutter_actor_destroy,
//                                 NULL);
//
//      G_OBJECT_CLASS (mx_grid_parent_class)->dispose (object);
//    }

//    static void
//    mx_grid_finalize (GObject *object)
//    {
//      MxGrid *self = (MxGrid *) object;
//      MxGridPrivate *priv = self->priv;
//
//      g_hash_table_destroy (priv->hash_table);
//
//      G_OBJECT_CLASS (mx_grid_parent_class)->finalize (object);
//    }



    
    /* Remove all pieces */
    public void remove_all ()
    {
        if (this.children != null)
        {
            uint i;
            for (i=0; i < this.rows*this.cols; i++)
                this.children[i].unref();
            
            GLib.free (this.children);
            this.children = null;
            this.rows = 0;
            this.cols = 0;        
        }
    }

    public override void paint ()
    {
        //print ("Grid.paint()\n");
        //foreach (var child in this.get_children())

//        uint row, col;
//        for (row=0; row < this.rows; row++)
//        {
//            for (col=0; col < this.cols; col++)
//            {
//                Clutter.Actor child = this.children[row*this.cols+col];
//                
//                Cogl.translate (this.x + col*this.spacing,
//                                this.y + row*this.spacing,
//                                0.0f);
//                (child as Puzzle.Piece).paint ();
//            }
//        }

        Clutter.ActorBox grid_box;
        GLib.List<unowned Clutter.Actor> child_item;

        base.paint ();

        this.get_allocation_box (out grid_box);
        grid_b.x2 = (grid_b.x2 - grid_b.x1);
        grid_b.x1 = 0.0f;
        grid_b.y2 = (grid_b.y2 - grid_b.y1);
        grid_b.y1 = 0.0f;
        

        for (child_item = this.list;
             child_item != null;
             child_item = child_item.next)
        {
            unowned Clutter.Actor child = (Clutter.Actor) child_item.data;
            Clutter.ActorBox child_box;

            assert (child != null);

            /* ensure the child is "on screen" */
            child.get_allocation_box (out child_box);

            if ((child_box.x1 < grid_box.x2)
                && (child_box.x2 > grid_box.x1)
                && (child_box.y1 < grid_box.y2)
                && (child_box.y2 > grid_box.y1)
                && child.visible) // CLUTTER_ACTOR_IS_VISIBLE ()
            {
                clutter_actor_paint (child);
            }
        }

        
        //uint i;
        //for (i=0; i < this.rows*this.cols; i++)
        //{
        //    Clutter.Actor child = this.children[i];
        //    
        //    //Cogl.translate (this.child.x, this.child.y, 0.0f);
        //    child.paint ();
        //}        
    }


//    static void
//    mx_grid_pick (ClutterActor       *actor,
//                  const ClutterColor *color)
//    {
//      MxGrid *layout = (MxGrid *) actor;
//      MxGridPrivate *priv = layout->priv;
//      GList *child_item;
//      gfloat x, y;
//      ClutterActorBox grid_b;

//      if (priv->hadjustment)
//        x = mx_adjustment_get_value (priv->hadjustment);
//      else
//        x = 0;

//      if (priv->vadjustment)
//        y = mx_adjustment_get_value (priv->vadjustment);
//      else
//        y = 0;

//      /* Chain up so we get a bounding box pained (if we are reactive) */
//      CLUTTER_ACTOR_CLASS (mx_grid_parent_class)->pick (actor, color);


//      clutter_actor_get_allocation_box (actor, &grid_b);
//      grid_b.x2 = (grid_b.x2 - grid_b.x1) + x;
//      grid_b.x1 = x;
//      grid_b.y2 = (grid_b.y2 - grid_b.y1) + y;
//      grid_b.y1 = y;

//      for (child_item = priv->list;
//           child_item != NULL;
//           child_item = child_item->next)
//        {
//          ClutterActor *child = child_item->data;
//          ClutterActorBox child_b;

//          g_assert (child != NULL);

//          /* ensure the child is "on screen" */
//          clutter_actor_get_allocation_box (CLUTTER_ACTOR (child), &child_b);

//          if ((child_b.x1 < grid_b.x2)
//              && (child_b.x2 > grid_b.x1)
//              && (child_b.y1 < grid_b.y2)
//              && (child_b.y2 > grid_b.y1)
//              && CLUTTER_ACTOR_IS_VISIBLE (child))
//            {
//              clutter_actor_paint (child);
//            }
//        }
//    }


    public override void pick (Clutter.Color color)
    {
        uint i;
        for (i=0; i < this.rows*this.cols; i++)
        {
            Clutter.Actor child = this.children[i];

            if (child != null)
            {
                //Cogl.translate (this.child.x, this.child.y, 0.0f);
                //child.pick (color);
                child.paint ();
            }        
        }
    }

    
//    public override void pick (Clutter.Color color)
//    {
//        if (!this.should_pick_paint ())
//            return;
//        
//        foreach (var child in this.get_children())
//        {
//            var piece = child as Puzzle.Piece;
//            //piece.paint ();
//                    Cogl.set_source_color4ub (color.red,
//                                  color.green,
//                                  color.blue,
//                                  color.alpha);        

//            if (piece.path == null)
//                continue;

//            Cogl.path_new ();

//            //unowned Cogl.Path   cogl_path = Cogl.get_path (); //new Cogl.Path ();
//            unowned Cairo.Path  path = piece.path;
//            Cairo.PathData     *data = null; //&path.data[0];

//            
//            for (var i=0; i < path.num_data; i += data->header.length)
//            {
//                data = &path.data[i];
//                
//                switch (data->header.type)
//                {
//                    case Cairo.PathDataType.MOVE_TO:
//                        Cogl.path_move_to ((float) data[1].point.x, (float) data[1].point.y);
//                        break;
//                        
//                    case Cairo.PathDataType.LINE_TO:
//                        Cogl.path_line_to ((float) data[1].point.x, (float) data[1].point.y);
//                        break;                 
//                }
//            }

//            Cogl.path_fill ();
//        }
//    }
//

// ================================================================================================

    /*
     * Clutter.Actor interfaces
     */



    /* use the actor's allocation for the ClutterBox */
    public override void allocate (Clutter.ActorBox        box,
                                   Clutter.AllocationFlags flags)
    {
        //Clutter.ActorBox allocation = {0, 0, 0, 0};

        //base.allocate (box, flags);
        
        // TODO: Scale to fit the parent

        uint row, col;
        for (row=0; row < this.rows; row++)
        {
            for (col=0; col < this.cols; col++)
            {
                unowned Clutter.Actor child = this.children[row*this.cols + col];

                Clutter.ActorBox allocation = {0, 0, 0, 0};
                allocation.x1 = col * this.spacing;
                allocation.y1 = row * this.spacing;
                allocation.x2 = allocation.x1 + this.spacing;
                allocation.y2 = allocation.y1 + this.spacing;
                
                child.allocate (allocation, flags);
            }
        }
    }
    
    public override void get_preferred_width (float for_height,
                                     out float min_width_out,
                                     out float natural_width_out)
    {
        natural_width_out = this.spacing * this.cols;
        min_width_out     = this.spacing * this.cols;
        for_height        = this.spacing * this.cols;
    }
    
    public override void get_preferred_height (float for_width,
                                     out float min_height_out,
                                     out float natural_height_out)
    {
        natural_height_out = this.spacing * this.rows;
        min_height_out     = this.spacing * this.rows;
        for_width          = this.spacing * this.rows;
    }
}

