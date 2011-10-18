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
 * PuzzleViewport class is a ClutterContainer with zoom, pan and scroll capabilities 
 */
//public class Puzzle.Viewport : Clutter.Actor, GtkClutter.Zoomable, GtkClutter.Scrollable, Clutter.Container

public class Puzzle.Viewport : Puzzle.Bin //, Clutter.Container
{
//    public float x_orgin;
//    public float y_orgin;
//    public float z_orgin;
    
    public Gtk.Adjustment hadjustment;
    public Gtk.Adjustment vadjustment;
//    public Gtk.Adjustment zoom_adjustment;

/*
    private Clutter.Animator child_animator;

    public void move_to (float x, float y)
    {
        this.drag_animator.set_duration (200);
        this.drag_animator.start ();
    }
*/
    construct {
    
        this.hadjustment     = new Gtk.Adjustment (0.0, -100.0, 200.0, 5.0, 15.0, 200.0);
        this.vadjustment     = new Gtk.Adjustment (0.0, -100.0, 200.0, 5.0, 15.0, 200.0);
//        this.zoom_adjustment = new Gtk.Adjustment (1.0, 0.5, 2.0, 0.5, 1.0, 1.0);

        this.hadjustment.value_changed.connect (() => {
            //this.child.x = (float) (-this.hadjustment.value);
            /* Request a resize */
            this.queue_relayout ();

        });

        this.vadjustment.value_changed.connect (() => {
            //this.child.y = (float) (-this.vadjustment.value);
            this.queue_relayout ();
        });

//        this.reactive = false;
/*
        this.allocation_changed.connect ((allocation, flags) => {	
        //this.zoom = this.zoom;
//            this.hadjustment = ;
//            this.vadjustment = ;
//            print ("Viewport width = %g\n", allocation.x2);

            //var child_allocation = Clutter.ActorBox () {x1=0.0f, y1=0.0f, x2=this.child.width, y2=this.child.height};

            var child_allocation = Clutter.ActorBox () {x1=0.0f, y1=0.0f, x2=allocation.x2, y2=allocation.y2};
            this.child.allocate (allocation, Clutter.AllocationFlags.ABSOLUTE_ORIGIN_CHANGED);
        });
*/
        
        
        this.set_fixed_position_set (true);


        this.reactive = true;
        //this.clip_to_allocation = true;



        this.set_fill (false, false);

//        this.child = new Clutter.Group ();


//        this.drag_animator = new Clutter.Animator ();
//        this.drag_animator.property_set_interpolation (this.child, "x", Clutter.Interpolation.CUBIC);
//        this.drag_animator.property_set_interpolation (this.child, "y", Clutter.Interpolation.CUBIC);
//        this.drag_animator.timeline.
        //this.drag_animator.property_set_ease_in (this.child, "x", true);
        //this.drag_animator.property_set_ease_in (this.child, "y", true);


//        this.add_actor (new Clutter.Group ());

/*
        var action = new Clutter.DragAction ();
        action.set_drag_axis (Clutter.DragAxis.NONE);
        action.set_drag_threshold (0, 0);
        //action.set_drag_handle (this.child);
        this.add_action (action);


        this.allocation_changed.connect ((box) => {
            print ("Allocation Changed\n");
        });

        this.button_press_event.connect ((event) => {
            print ("Button Press Event\n");
            return true;
        });

        this.button_press_event.connect ((event) => {
            print ("Button Press Event\n");
            return true;
        });
*/

        this.reactive = true;

        this.scroll_event.connect ((event) => {
            
            if ((event.modifier_state & Clutter.ModifierType.CONTROL_MASK) > 0)
            {
                /* Zoom */
//                if ((event.modifier_state & Clutter.ModifierType.BUTTON4_MASK) > 0)
//                    print ("Zoom In\n");

//                if ((event.modifier_state & Clutter.ModifierType.BUTTON5_MASK) > 0)
//                    print ("Zoom Out\n");
                
            }
            else
            {
                /* Pan */
                switch (event.direction)
                {
                    case Clutter.ScrollDirection.UP:
                            this.vadjustment.value -= this.vadjustment.get_step_increment();
                            break;

                    case Clutter.ScrollDirection.DOWN:
                            this.vadjustment.value += this.vadjustment.get_step_increment();
                            break;

                    case Clutter.ScrollDirection.LEFT:
                            this.hadjustment.value -= this.hadjustment.get_step_increment();
                            break;

                    case Clutter.ScrollDirection.RIGHT:
                            this.hadjustment.value += this.hadjustment.get_step_increment();
                            break;
                }
            }

//            if (event.modifier_state == Clutter.ModifierType.BUTTON4_MASK)
//            {
            
            return true;
        });




//      TODO
//        this.viewport.set_clip (0.0f, 0.0f, (float)event.width, (float)event.height);

    }
    
    
//    public Clutter.DragAction start_drag_action ()
//    {        
//        return action;
//    }
    
    
    
    
    
    public Viewport () {
    }

    /* Clutter.Container */    
/*
    public new void add_actor (Clutter.Actor actor) {
        if (this.child == null)
        {
            actor.set_parent (this);
            this.child = actor;
        }
        else
            warning ("Viewport already has a child");
    }
    
    public new void remove_actor (Clutter.Actor actor) {
        if (this.child == actor)
            this.child = null;
    }

    public void @foreach (Clutter.Callback callback) {
        callback (this.child);
    }
*/


    public override void paint ()
    {
        /*
        var allocation = this.allocation;
    
        Cogl.push_matrix ();

//        Cogl.clip_push_rectangle (0.0f, 0.0f, this.width, this.height);

        Cogl.translate (allocation.x1, allocation.y1, 0.0f);

        //Cogl.set_source_color4ub (255, 40, 40, 255);
        //Cogl.rectangle (0.0f, 0.0f, this.width, this.height);

        Cogl.translate (this.child.x, this.child.y, 0.0f);
        base.paint ();
        
//        Cogl.clip_pop ();

        // TODO: paint scrollbars
        //       ...
        
        Cogl.pop_matrix ();
        */

        //var allocation = this.allocation;
 

        base.paint ();

//        this.get_allocation_box (out box);

//  var w = box.x2 - box.x1;
//  var h = box.y2 - box.y1;
//        //var vadjustment = this.vadjustment;
        //var hadjustment = NULL;


    }


    // No need, it's a rectangle

    public override void pick (Clutter.Color color)
    {
//        if (!this.should_pick_paint ())
//            return;
        /*
        var allocation = this.allocation;
        //this.paint ();

        Cogl.push_matrix ();

        Cogl.translate (allocation.x1, allocation.y1, 0.0f);
//        Cogl.clip_push_rectangle (0.0f, 0.0f, this.width, this.height);

        Cogl.set_source_color4ub (color.red,
                                  color.green,
                                  color.blue,
                                  color.alpha);        
        Cogl.rectangle (0.0f, 0.0f, this.width, this.height);
        Cogl.translate (this.child.x, this.child.y, 0.0f);

        base.pick (color);

//        Cogl.clip_pop ();
        Cogl.pop_matrix ();
        */
        base.pick (color);
    }


    /* use the actor's allocation for the ClutterBox */

    public override void allocate (Clutter.ActorBox        box,
                                   Clutter.AllocationFlags flags)
    {
        base.allocate (box, flags);
    
        var avail_width = (box.x2 - box.x1); // - padding.left - padding.right;
        var avail_height = (box.y2 - box.y1); // - padding.top - padding.bottom;
    

        /* Child */
        var x = (float) Math.round (this.hadjustment.value);
        var y = (float) Math.round (this.vadjustment.value);

        var child_box = Clutter.ActorBox () {
                x1 = 0.0f - x, //padding.left;
                y1 = 0.0f - y, //padding.top;
                x2 = avail_width - x, // - sb_width;
                y2 = avail_height -y // - sb_height;
                };

        if (this.child != null)
            this.child.allocate (child_box, flags);
    
//        var allocation = Clutter.ActorBox () {
//                x1 = box.x1,
//                y1 = box.y1,
//                x2 = box.x1 + this.width,
//                y2 = box.y1 + this.height        
//                };

//        print ("Allocate\n");

        // TODO: allocate space for scrollbars
//        allocation.x2 = box.x2 - 0.0f; // scrollbar_width
//        allocation.y2 = box.y2 - 0.0f; // scrollbar_height

//        print ("*** Viewport.allocate: %gx%g ***\n", allocation.x2, allocation.y2);

    }


    /**
     * allocate_child:
     * @box: The box to allocate the child within
     * @flags: #Clutter.AllocationFlags, usually provided by the.
     * clutter_actor_allocate function.
     *
     * Allocates the child of an #MxBin inside the given box. This function should
     * usually only be called by subclasses of #MxBin.
     *
     * This function can be used to allocate the child of an #MxBin if no special
     * allocation requirements are needed. It is similar to
     * #mx_allocate_align_fill, except that it reads the alignment, padding and
     * fill values from the #MxBin, and will call #clutter_actor_allocate on the
     * child.
     *
     */
/*
    private new void allocate_child (Clutter.ActorBox box, Clutter.AllocationFlags flags)
    {
        print ("Viewport.allocate_child");
        
        if (this.child != null)
        {
            Clutter.ActorBox allocation = {0, 0, 0, 0};

            allocation.x1 = 0.0f; //this.padding.left;
            allocation.x2 = box.x2 - box.x1; // - this.padding.right;
            allocation.y1 = 0.0f; //this.padding.top;
            allocation.y2 = box.y2 - box.y1; // - this.padding.bottom;
            
//            print ("allocation: %gx%g\n", allocation.x2, allocation.y2);
//            allocation.x2 += this.width;
//            allocation.y2 += this.height;
//            allocate_align_fill (this.child, ref allocation,
//                                  this.x_align, this.y_align,
//                                  this.x_fill, this.y_fill);

            this.child.allocate (allocation, flags);
        }
    }
*/

    public override void get_preferred_width (float for_height,
                                              out float min_width,
                                              out float natural_width)
    {
        var min_width_tmp     = 60.0f; // FIXME this.padding.left + this.padding.right;
        var natural_width_tmp = min_width;
        var available_height  = for_height; // - this.padding.top - this.padding.bottom;
        
        if (this.child == null)
        {
            min_width      = min_width_tmp;
            natural_width  = natural_width_tmp;
        }
        else
        {
            this.child.get_preferred_width (available_height, out min_width, out natural_width);

            min_width     += min_width_tmp;
            natural_width += natural_width_tmp;
        }
    }

    public override void get_preferred_height (float for_width,
                                               out float min_height,
                                               out float natural_height)
    {
        var min_height_tmp      = 60.0f; // FIXME this.padding.top + this.padding.bottom;
        var natural_height_tmp  = min_height;
        var available_width     = for_width; // - this.padding.left - this.padding.right;

        if (this.child == null)
        {
        //    if (min_height != null)
                min_height = min_height_tmp;

        //    if (natural_height != null)
                natural_height = natural_height_tmp;
        }
        else
        {
            this.child.get_preferred_height (available_width, out min_height, out natural_height);

        //    if (min_height != null)
                min_height += min_height_tmp;

        //    if (natural_height != null)
                natural_height += natural_height_tmp;
        }
    }

    /*
     * GObject.dispose()
     */
/* FIXME?
    public override void dispose ()
    {
        if (this.child != null)
        {
            this.child.destroy ();
            this.child = null;
        }
        base.dispose ();
    }
*/











    /* GtkClutter.Zoomable */
//    public unowned Gtk.Adjustment get_adjustment () {
//        return this.zoom_adjustment;
//    }
    
//    public void set_adjustment (Gtk.Adjustment z_adjust) {
//        this.zoom_adjustment = z_adjust;
//    }
    
    
    /* GtkClutter.Scrollable */
    public void get_adjustments (out unowned Gtk.Adjustment h_adjust, out unowned Gtk.Adjustment v_adjust) {
        h_adjust = this.hadjustment;
        v_adjust = this.vadjustment;
    }
    
    public void set_adjustments (Gtk.Adjustment h_adjust, Gtk.Adjustment v_adjust) {
        this.hadjustment = h_adjust;
        this.vadjustment = v_adjust;
    }



/* XXX: Revise C code:

static void
mx_viewport_dispose (GObject *gobject)
{
  MxViewportPrivate *priv = MX_VIEWPORT (gobject)->priv;

  if (priv->hadjustment)
    {
      g_object_unref (priv->hadjustment);
      priv->hadjustment = NULL;
    }

  if (priv->vadjustment)
    {
      g_object_unref (priv->vadjustment);
      priv->vadjustment = NULL;
    }

  G_OBJECT_CLASS (mx_viewport_parent_class)->dispose (gobject);
}

void
mx_viewport_set_origin (MxViewport *viewport,
                        gfloat      x,
                        gfloat      y,
                        gfloat      z)
{
  MxViewportPrivate *priv;

  g_return_if_fail (MX_IS_VIEWPORT (viewport));

  priv = viewport->priv;

  g_object_freeze_notify (G_OBJECT (viewport));

  if (x != priv->x)
    {
      priv->x = x;
      g_object_notify (G_OBJECT (viewport), "x-origin");

      if (priv->hadjustment)
        mx_adjustment_set_value (priv->hadjustment,
                                 (float)(x));
    }

  if (y != priv->y)
    {
      priv->y = y;
      g_object_notify (G_OBJECT (viewport), "y-origin");

      if (priv->vadjustment)
        mx_adjustment_set_value (priv->vadjustment,
                                 (float)(y));
    }

  if (z != priv->z)
    {
      priv->z = z;
      g_object_notify (G_OBJECT (viewport), "z-origin");
    }

  g_object_thaw_notify (G_OBJECT (viewport));

  clutter_actor_queue_redraw (CLUTTER_ACTOR (viewport));
}

void
mx_viewport_get_origin (MxViewport *viewport,
                        gfloat     *x,
                        gfloat     *y,
                        gfloat     *z)
{
  MxViewportPrivate *priv;

  g_return_if_fail (MX_IS_VIEWPORT (viewport));

  priv = viewport->priv;

  if (x)
    *x = priv->x;

  if (y)
    *y = priv->y;

  if (z)
    *z = priv->z;
}
*/

}
