/*
 * Puzzle!
 *
 * this file was based on MxBin by Emmanuele Bassi
 *
 * Copyright © 2009 Intel Corporation.
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

/**
 * SECTION:puzzle-bin
 * @short_description: a simple container with one actor.
 *
 * #PuzzleBin is a simple abstract container capable of having only one
 * #ClutterActor as a child. #PuzzleBin does not allocate the child itself,
 * therefore any subclasses are required to implement the
 * #ClutterActorClass.allocate function.
 * #puzzle_bin_allocate_child() can be used if no special allocation requirements
 * are needed.
 *
 * TODO #MxFrame is a simple implementation of #MxBin that can be used as a single
 * actor container that implements alignment and padding.
 *
 */

//public class Puzzle.Bin : Puzzle.Widget, Clutter.Container//, Puzzle.Focusable
public class Puzzle.Bin : Clutter.Actor, Clutter.Container//, Puzzle.Focusable
{
    private Clutter.Actor? _child;
    public  Clutter.Actor?  child
    {
        get {
            return this._child;
        }
        set {
            if (this._child == value)
                return;

            if (this._child != null)
            {
                var old_child = this._child;
                this._child = null;
                old_child.unparent();
                //this.actor_removed.emit (this.child);
            }

            if (value != null)
            {
                this._child = value;
                this._child.set_parent (this);
                //this.actor_added.emit (this.child);
            }

            this.queue_relayout ();
        }
    }
  
  
//    private bool child_has_space;

//    private float _x_align; // { get; set; default=0.5f; }
//    private float _y_align; // { get; set; default=0.5f; }

//    private bool _x_fill; // { get; set; default=true; }
//    private bool _y_fill; // { get; set; default=true; }


    public float x_align { get; set; default=0.5f; }
    public float y_align { get; set; default=0.5f; }

    public bool x_fill { get; set; default=true; }
    public bool y_fill { get; set; default=true; }

//    static void clutter_container_iface_init (ClutterContainerIface *iface);
//    static void mx_bin_focusable_iface_init (MxFocusableIface *iface);

//    G_DEFINE_ABSTRACT_TYPE_WITH_CODE (MxBin, mx_bin, MX_TYPE_WIDGET,
//                                      G_IMPLEMENT_INTERFACE (CLUTTER_TYPE_CONTAINER,
//                                                             clutter_container_iface_init)
//                                      G_IMPLEMENT_INTERFACE (MX_TYPE_FOCUSABLE,
//                                                             mx_bin_focusable_iface_init));
/*
    void
    _mx_bin_get_align_factors (MxBin   *bin,
                               gdouble *x_align,
                               gdouble *y_align)
    {
      MxBinPrivate *priv = bin->priv;
      gdouble factor;

      switch (priv->x_align)
        {
        case MX_ALIGN_START:
          factor = 0.0;
          break;

        case MX_ALIGN_MIDDLE:
          factor = 0.5;
          break;

        case MX_ALIGN_END:
          factor = 1.0;
          break;

        default:
          factor = 0.0;
          break;
        }

      if (x_align)
        *x_align = factor;

      switch (priv->y_align)
        {
        case MX_ALIGN_START:
          factor = 0.0;
          break;

        case MX_ALIGN_MIDDLE:
          factor = 0.5;
          break;

        case MX_ALIGN_END:
          factor = 1.0;
          break;

        default:
          factor = 0.0;
          break;
        }

      if (y_align)
        *y_align = factor;
    }
*/

    /*
     * Clutter.Container interfaces
     */
    public new void add_actor (Clutter.Actor actor)
    {
        this.child = actor;
//        this.set_child (actor);
    }

    public new void remove_actor (Clutter.Actor actor)
    {
        if (this.child == actor)
            this.child = null;
//            this.set_child (null);
    }

    public new void @foreach (Clutter.Callback callback) 
    {
        if (this.child != null)
            callback (this.child);
    }


/*
    static MxFocusable*
    mx_bin_accept_focus (MxFocusable *focusable, MxFocusHint hint)
    {
      MxBinPrivate *priv = MX_BIN (focusable)->priv;

      if (MX_IS_FOCUSABLE (priv->child))
        return mx_focusable_accept_focus (MX_FOCUSABLE (priv->child), hint);
      else
        return NULL;
    }

    static void
    mx_bin_focusable_iface_init (MxFocusableIface *iface)
    {
      iface->accept_focus = mx_bin_accept_focus;
    }
*/

    /*
     * Clutter.Actor interfaces
     */
    public override void paint ()
    {
        /* allow MxWidget to paint the background */
        //base.paint ();

        /* then paint our child */
        if (this.child != null) // && this.child_has_space) // TODO
        {
            //Cogl.translate (this.child.x, this.child.y, 0.0f);
            this.child.paint ();
        }
    }

    public override void pick (Clutter.Color pick_color)
    {

        if (this.child != null)
        {
            //Cogl.translate (this.child.x, this.child.y, 0.0f);
            //this.child.pick (pick_color);
            this.child.paint ();
        }
    }


    /* use the actor's allocation for the ClutterBox */
    public override void allocate (Clutter.ActorBox        box,
                                   Clutter.AllocationFlags flags)
    {
        Clutter.ActorBox allocation = {0, 0, 0, 0};

//        base.allocate (box, flags);

        /* make the child (the ClutterBox) fill the parent;
         * note that this allocation box is relative to the
         * coordinates of the whole button actor, so we can't just
         * use the box passed into this function; instead, it
         * is adjusted to span the whole of the actor, from its
         * top-left corner (0,0) to its bottom-right corner
         * (width,height)
         */
        /*
        allocation.x1 = this.child.x;
        allocation.y1 = this.child.y;
        allocation.x2 = this.child.x + this.child.width;
        allocation.y2 = this.child.y + this.child.height;
        */
//        allocation.x1 = this.width / 2; // (box.x2 - box.x1) / 2;
//        allocation.y1 = this.height / 2; // (box.y2 - box.y1) / 2;
//        allocation.x2 = allocation.x1 + this.child.width;
//        allocation.y2 = allocation.y1 + this.child.height;


//        print ("Bin.allocate()\n");
//        box.x2 = box.x1 + allocation.x2;
//        box.y2 = box.y1 + allocation.y2;

//        print ("Allocate %gx%g\n", allocation.x2, allocation.y2);

//        base.allocate (allocation, flags);

//        this.child.allocate (allocation, flags);
        this.child.allocate (allocation, flags);
//        this.allocate_child (allocation, flags);
    }

    /**
     * mx_bin_allocate_child:
     * @bin: An #MxBin
     * @box: The box to allocate the child within
     * @flags: #ClutterAllocationFlags, usually provided by the.
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
    public new void allocate_child (Clutter.ActorBox        box,
                                    Clutter.AllocationFlags flags)
    {
        if (this.child != null)
        {
            //MxPadding padding;
            Clutter.ActorBox allocation = {0, 0, 0, 0};

            //mx_widget_get_padding (MX_WIDGET (bin), &padding);

            //allocation.x1 = padding.left;
            //allocation.x2 = box->x2 - box->x1 - padding.right;
            //allocation.y1 = padding.top;
            //allocation.y2 = box->y2 - box->y1 - padding.bottom;

            allocation.x1 = 0.0f;
            allocation.x2 = box.x2 - box.x1;
            allocation.y1 = 0.0f;
            allocation.y2 = box.y2 - box.y1;

            //allocate_align_fill (this.child, // TODO FIXME
            //                     allocation,
            //                     this.x_align,
            //                     this.y_align,
            //                     this.x_fill,
            //                     this.y_fill);

            this.child.allocate (allocation, flags);
        }
        else
        {
            print ("*\n* NO CHILD IN Puzzle.Bin\n*\n");
        }
    }

    public override void get_preferred_width (float for_height,
                                     out float min_width_out,
                                     out float natural_width_out)
    {
        float min_width, natural_width;
        float available_height;
        //MxPadding padding = { 0, };

        //mx_widget_get_padding (MX_WIDGET (self), &padding);

        available_height = for_height; // - padding.top - padding.bottom;

        min_width = natural_width = 0.0f; //padding.left + padding.right;

        if (this.child == null)
        {
            //if (min_width_out != null)
                min_width_out = min_width;

            //if (natural_width_out != null)
                natural_width_out = natural_width;
        }
        else
        {
            this.child.get_preferred_width (available_height,
                                            out min_width,
                                            out natural_width);

            //if (min_width_out != null)
                min_width_out += min_width;

            //if (natural_width_out != null)
                natural_width_out += natural_width;
        }
        
        min_width_out += 20.0f;
        natural_width_out += 20.0f;
    }

    public override void get_preferred_height (float for_width,
                                               out float min_height_out,
                                               out float natural_height_out)
    {
        float min_height, natural_height;
        float available_width;
        //MxPadding padding = { 0, };

        //mx_widget_get_padding (MX_WIDGET (self), &padding);

        available_width = for_width; // - padding.left - padding.right;

        min_height = natural_height = 0.0f; //padding.top + padding.bottom;

        if (this.child == null)
        {
            //if (min_height_out != null)
                min_height_out = min_height;

            //if (natural_height_out != null)
                natural_height_out = natural_height;
        }
        else
        {
            this.child.get_preferred_height (available_width,
                                             out min_height_out,
                                             out natural_height_out);

            //if (min_height_out != null)
                min_height_out += min_height;

            //if (natural_height_out != null)
                natural_height_out += natural_height;
        }

        min_height_out += 20.0f;
        natural_height_out += 20.0f;
    }

/*
    static void
    mx_bin_dispose (GObject *gobject)
    {
      MxBinPrivate *priv = MX_BIN (gobject)->priv;

      if (priv->child)
        {
          clutter_actor_destroy (priv->child);
          priv->child = NULL;
        }

      G_OBJECT_CLASS (mx_bin_parent_class)->dispose (gobject);
    }

    static void
    mx_bin_set_property (GObject      *gobject,
                         guint         prop_id,
                         const GValue *value,
                         GParamSpec   *pspec)
    {
      MxBin *bin = MX_BIN (gobject);

      switch (prop_id)
        {
        case PROP_CHILD:
          mx_bin_set_child (bin, g_value_get_object (value));
          break;

        case PROP_X_ALIGN:
          mx_bin_set_alignment (bin,
                                g_value_get_enum (value),
                                bin->priv->y_align);
          break;

        case PROP_Y_ALIGN:
          mx_bin_set_alignment (bin,
                                bin->priv->x_align,
                                g_value_get_enum (value));
          break;

        case PROP_X_FILL:
          mx_bin_set_fill (bin,
                           g_value_get_boolean (value),
                           bin->priv->y_fill);
          break;

        case PROP_Y_FILL:
          mx_bin_set_fill (bin,
                           bin->priv->x_fill,
                           g_value_get_boolean (value));
          break;

        default:
          G_OBJECT_WARN_INVALID_PROPERTY_ID (gobject, prop_id, pspec);
        }
    }

    static void
    mx_bin_get_property (GObject    *gobject,
                         guint       prop_id,
                         GValue     *value,
                         GParamSpec *pspec)
    {
      MxBinPrivate *priv = MX_BIN (gobject)->priv;

      switch (prop_id)
        {
        case PROP_CHILD:
          g_value_set_object (value, priv->child);
          break;

        case PROP_X_FILL:
          g_value_set_boolean (value, priv->x_fill);
          break;

        case PROP_Y_FILL:
          g_value_set_boolean (value, priv->y_fill);
          break;

        case PROP_X_ALIGN:
          g_value_set_enum (value, priv->x_align);
          break;

        case PROP_Y_ALIGN:
          g_value_set_enum (value, priv->y_align);
          break;

        default:
          G_OBJECT_WARN_INVALID_PROPERTY_ID (gobject, prop_id, pspec);
        }
    }
*/
//    static void
//    mx_bin_class_init (MxBinClass *klass)
//    {
//      GObjectClass *gobject_class = G_OBJECT_CLASS (klass);
//      ClutterActorClass *actor_class = CLUTTER_ACTOR_CLASS (klass);
//      GParamSpec *pspec;
//
//      g_type_class_add_private (klass, sizeof (MxBinPrivate));
//
//      gobject_class->set_property = mx_bin_set_property;
//      gobject_class->get_property = mx_bin_get_property;
//      gobject_class->dispose = mx_bin_dispose;
//
//      actor_class->get_preferred_width = mx_bin_get_preferred_width;
//      actor_class->get_preferred_height = mx_bin_get_preferred_height;
//      actor_class->paint = mx_bin_paint;
//      actor_class->pick = mx_bin_pick;
//
//      /**
//       * MxBin:child:
//       *
//       * The child #ClutterActor of the #MxBin container.
//       */
//      pspec = g_param_spec_object ("child",
//                                   "Child",
//                                   "The child of the Bin",
//                                   CLUTTER_TYPE_ACTOR,
//                                   MX_PARAM_READWRITE);
//      g_object_class_install_property (gobject_class, PROP_CHILD, pspec);
//
//      /**
//       * MxBin:x-align:
//       *
//       * The horizontal alignment of the #MxBin child.
//       */
//      pspec = g_param_spec_enum ("x-align",
//                                 "X Align",
//                                 "The horizontal alignment",
//                                 MX_TYPE_ALIGN,
//                                 MX_ALIGN_MIDDLE,
//                                 MX_PARAM_READWRITE);
//      g_object_class_install_property (gobject_class, PROP_X_ALIGN, pspec);
//
//      /**
//       * MxBin:y-align:
//       *
//       * The vertical alignment of the #MxBin child.
//       */
//      pspec = g_param_spec_enum ("y-align",
//                                 "Y Align",
//                                 "The vertical alignment",
//                                 MX_TYPE_ALIGN,
//                                 MX_ALIGN_MIDDLE,
//                                 MX_PARAM_READWRITE);
//      g_object_class_install_property (gobject_class, PROP_Y_ALIGN, pspec);
//
//      /**
//       * MxBin:x-fill:
//       *
//       * Whether the child should fill the horizontal allocation
//       */
//      pspec = g_param_spec_boolean ("x-fill",
//                                    "X Fill",
//                                    "Whether the child should fill the "
//                                    "horizontal allocation",
//                                    FALSE,
//                                    MX_PARAM_READWRITE);
//      g_object_class_install_property (gobject_class, PROP_X_FILL, pspec);
//
//      /**
//       * MxBin:y-fill:
//       *
//       * Whether the child should fill the vertical allocation
//       */
//      pspec = g_param_spec_boolean ("y-fill",
//                                    "Y Fill",
//                                    "Whether the child should fill the "
//                                    "vertical allocation",
//                                    FALSE,
//                                    MX_PARAM_READWRITE);
//      g_object_class_install_property (gobject_class, PROP_Y_FILL, pspec);
//    }

//    static void
//    mx_bin_init (MxBin *bin)
//    {
//      bin->priv = MX_BIN_GET_PRIVATE (bin);
//
//      bin->priv->x_align = MX_ALIGN_MIDDLE;
//      bin->priv->y_align = MX_ALIGN_MIDDLE;
//      bin->priv->child_has_space = TRUE;
//    }

    /**
     * mx_bin_set_child:
     * @bin: a #MxBin
     * @child: a #ClutterActor, or %NULL
     *
     * Sets @child as the child of @bin.
     *
     * If @bin already has a child, the previous child is removed.
     */
/*
    public void set_child (Clutter.Actor? actor)
    {
        if (this.child == actor)
            return;

        if (this.child != null)
        {
            var old_child = this.child;

            this.child = null;
            old_child.unparent();

//            this.actor_removed.emit (this.child);
        }

        if (actor != null)
        {
            this.child = actor;
            this.child.set_parent (this);
//            this.actor_added.emit (this.child);
            message ("*** CHILD DEFINED ***\n");
        }

        this.queue_relayout ();
    }
*/
    /**
     * mx_bin_get_child:
     * @bin: a #MxBin
     *
     * Retrieves a pointer to the child of @bin.
     *
     * Return value: (transfer none): a #ClutterActor, or %NULL
     */
//    public unowned Clutter.Actor get_child ()
//    {
//        return this.child;
//    }

    /**
     * mx_bin_set_alignment:
     * @bin: a #MxBin
     * @x_align: horizontal alignment
     * @y_align: vertical alignment
     *
     * Sets the horizontal and vertical alignment of the child
     * inside a #MxBin.
     */
/*    void
    mx_bin_set_alignment (MxBin  *bin,
                          MxAlign x_align,
                          MxAlign y_align)
    {
      MxBinPrivate *priv;
      gboolean changed = FALSE;

      g_return_if_fail (MX_IS_BIN (bin));

      priv = bin->priv;

      g_object_freeze_notify (G_OBJECT (bin));

      if (priv->x_align != x_align)
        {
          priv->x_align = x_align;
          g_object_notify (G_OBJECT (bin), "x-align");
          changed = TRUE;
        }

      if (priv->y_align != y_align)
        {
          priv->y_align = y_align;
          g_object_notify (G_OBJECT (bin), "y-align");
          changed = TRUE;
        }

      if (changed)
        clutter_actor_queue_relayout (CLUTTER_ACTOR (bin));

      g_object_thaw_notify (G_OBJECT (bin));
    }
*/
    /**
     * mx_bin_get_alignment:
     * @bin: a #MxBin
     * @x_align: return location for the horizontal alignment, or %NULL
     * @y_align: return location for the vertical alignment, or %NULL
     *
     * Retrieves the horizontal and vertical alignment of the child
     * inside a #MxBin, as set by mx_bin_set_alignment().
     */
/*
    void
    mx_bin_get_alignment (MxBin   *bin,
                          MxAlign *x_align,
                          MxAlign *y_align)
    {
      MxBinPrivate *priv;

      g_return_if_fail (MX_IS_BIN (bin));

      priv = bin->priv;

      if (x_align)
        *x_align = priv->x_align;

      if (y_align)
        *y_align = priv->y_align;
    }
*/
    /**
     * mx_bin_set_fill:
     * @bin: a #MxBin
     * @x_fill: %TRUE if the child should fill horizontally the @bin
     * @y_fill: %TRUE if the child should fill vertically the @bin
     *
     * Sets whether the child of @bin should fill out the horizontal
     * and/or vertical allocation of the parent
     */
    public void set_fill (bool x_fill,
                          bool y_fill)
    {
        bool changed = false;

        this.freeze_notify (); // GObject

        if (this._x_fill != x_fill)
        {
            this._x_fill = x_fill;
            changed = true;

            //this.notify["x-fill"] ();
        }

        if (this._y_fill != y_fill)
        {
            this._y_fill = y_fill;
            changed = true;

            //this.notify["y-fill"] ();
        }

        if (changed)
            this.queue_relayout (); // Clutter.Actor

        this.thaw_notify (); // GObject
    }

    /**
     * mx_bin_get_fill:
     * @bin: a #MxBin
     * @x_fill: (out): return location for the horizontal fill, or %NULL
     * @y_fill: (out): return location for the vertical fill, or %NULL
     *
     * Retrieves the horizontal and vertical fill settings
     */
    public void get_fill (out bool x_fill,
                          out bool y_fill)
    {
        x_fill = this._x_fill;
        y_fill = this._y_fill;
    }
}
