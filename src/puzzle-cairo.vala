

namespace Puzzle
{
    
    
    public Cairo.Path* cairo_path_new ()
    {
        Cairo.Path* path = malloc0 (sizeof(Cairo.Path));
        Cairo.PathData[] data = new Cairo.PathData[160]; // FIXME ..let's have a spare space for now
    /*
       path = malloc (sizeof (cairo_path_t));
        if (unlikely (path == NULL)) {
	    _cairo_error_throw (CAIRO_STATUS_NO_MEMORY);
	    return (cairo_path_t*) &_cairo_path_nil;
    */

        path->status = Cairo.Status.SUCCESS;
        path->data   = data;
        
        return path;
    }

//    public Cairo.Path cairo_path_own (Cairo.Path* path)
//    {
//        var tmp = path;
//        return tmp;
//    }

    public Cairo.Path cairo_path_copy (Cairo.Path path)
    {
        // TODO FIXME
        var copy = cairo_path_new ();
        //GLib.Memory.dup (path, (uint)sizeof(Cairo.Path));
        //copy->data       = (Cairo.PathData[]) GLib.Memory.dup (path.data, 1);

        return copy;
    }


    public void cairo_path_free (Cairo.Path? path)
    {
        if (path != null)
        {
            //if (path.data != null)
            //    delete path.data;
            
            free (path);
        }
    }

    public void cairo_path_move_to (Cairo.Path path, double x, double y)
    {
        Cairo.PathData *data = &path.data[path.num_data];

        data->header.type = Cairo.PathDataType.MOVE_TO;
        data->header.length = 2;

        /* We index from 1 to leave room for data->header*/
        data[1].point.x = x;
        data[1].point.y = y;

        path.num_data += data->header.length;
    }

    public void cairo_path_line_to (Cairo.Path path, double x, double y)
    {
        Cairo.PathData *data = &path.data[path.num_data];

        data->header.type = Cairo.PathDataType.LINE_TO;
        data->header.length = 2;

        /* We index from 1 to leave room for data->header*/
        data[1].point.x = x;
        data[1].point.y = y;

        path.num_data += data->header.length;
    }

    public void cairo_path_curve_to (Cairo.Path path, double x1, double y1, double x2, double y2, double x3, double y3)
    {
        Cairo.PathData *data = &path.data[path.num_data];

        data->header.type = Cairo.PathDataType.CURVE_TO;
        data->header.length = 4;

        /* We index from 1 to leave room for data->header*/
        data[1].point.x = x1;
        data[1].point.y = y1;
        data[2].point.x = x2;
        data[2].point.y = y2;
        data[3].point.x = x3;
        data[3].point.y = y3;

        path.num_data += data->header.length;
    }

    public void cairo_path_close (Cairo.Path path)
    {
        Cairo.PathData *data = &path.data[path.num_data];

        data->header.type = Cairo.PathDataType.CLOSE_PATH;
        data->header.length = 1;

        path.num_data += data->header.length;
    }

    public Cairo.Path cairo_path_reverse (Cairo.Path path)
    {
        Cairo.PathData *data; // = &path.data[0];
        Cairo.PathData *data_next;
        var reversed = cairo_path_new ();
        
    	double x  = 0.0;
    	double y  = 0.0;
        double x1 = 0.0; 
        double y1 = 0.0;
        int pos = 0;
        
        var elements = new GLib.List<Cairo.PathData*>();
        unowned GLib.List<Cairo.PathData*> iter;
        
        /* Find path's end point */
        for (pos = 0; pos < path.num_data;)
        {
            data = &path.data[pos];
            pos += data->header.length;
            elements.prepend (data);

            switch (data->header.type)
            {
                case Cairo.PathDataType.MOVE_TO:
                case Cairo.PathDataType.LINE_TO:
                        x1 = data[1].point.x;
                        y1 = data[1].point.y;
                        break;

                case Cairo.PathDataType.CURVE_TO:
                        x1 = data[3].point.x;
                        y1 = data[3].point.y;
                        break;
            }
        }
        
        iter = elements;
        
        while (iter != null)
        {
            data = iter.data;
            iter = iter.next;
        
            /* Get end point of segment before */
            if (iter != null)
            {
                data_next = iter.data;

                switch (data_next->header.type)
                {
                    case Cairo.PathDataType.MOVE_TO:
                    case Cairo.PathDataType.LINE_TO:
                            x = data_next[1].point.x;
                            y = data_next[1].point.y;
                            break;
                
                    case Cairo.PathDataType.CURVE_TO:
                            x = data_next[3].point.x;
                            y = data_next[3].point.y;
                            break;

                    case Cairo.PathDataType.CLOSE_PATH:
                            // TODO iter to next segment, set default x & y in case there is no op
			                x = 0.0;
			                y = 0.0;
                            break;
                }
		    }
		    else
		    {
			    x = 0.0;
			    y = 0.0;
		    }

            switch (data->header.type)
            {
                case Cairo.PathDataType.MOVE_TO:
                        cairo_path_move_to (reversed,
                        x1 - x, y1 - y);
                        break;
                    
                case Cairo.PathDataType.LINE_TO:
                        cairo_path_line_to (reversed,
                        x1 - x,  y1 - y);
                        break;
                
                case Cairo.PathDataType.CURVE_TO:
                        cairo_path_curve_to (reversed,
                        x1 - data[2].point.x,  y1 - data[2].point.y,
                        x1 - data[1].point.x,  y1 - data[1].point.y,
                        x1 - x,                y1 - y);
                        break;
                
                case Cairo.PathDataType.CLOSE_PATH:
                        //cairo_path_close (reversed);
                        // TODO flag as to close path
                        break;
            }
        }
        
        return reversed;
    }

    public bool cairo_path_match (Cairo.Path path1, Cairo.Path path2)
    {
        Cairo.PathData *data1 = &path1.data[0];
        Cairo.PathData *data2 = &path2.data[0];
                
        if (path1.num_data != path2.num_data)
            return false;
        
        for (var i=0; i < data1->header.length; i += data1->header.length)
        {
            data1 = &path1.data[i];
            data2 = &path2.data[i];

            if (data1->header.type   != data2->header.type ||
                data1->header.length != data2->header.length)
                return false;
            
            for (var p=0; p < data1->header.length; p++)
            {
                if (data1[p].point.x != data2[p].point.x ||
                    data1[p].point.y != data2[p].point.y)
                    return false;
            }
        }
        
        return true;
    }
    
    
    public void cairo_surface_blur (Cairo.ImageSurface surface, double radius)
    {
        var height    = surface.get_height ();
        var width     = surface.get_width ();
        var rowstride = surface.get_stride ();

        unowned uchar[] data = surface.get_data ();

        gaussian_iir (data, 8, width, height, width*1, //rowstride,
                      radius);
    }
    

    private void gaussian_iir (uchar[] data, int bits_per_sample, int width, int height, int rowstride, double radius)

    {
        /* coefficiens */  
        int terms = 4;

        double n_p[5]; // a1
        double n_m[5]; // a2
        double d_p[5]; // b1
        double d_m[5]; // b2
        double bd_p[5];// ab1
        double bd_m[5];// ab2

        find_gaussian_iir_coefficiens (radius, terms,
                    n_p, n_m, d_p, d_m, bd_p, bd_m
                    );
        
        int bpp = rowstride / width;
        
        bpp = 1;

        var buffer1 = new double [int.max (width, height)];
        var buffer2 = new double [int.max (width, height)];
        var tmp     = new uchar [width * height * bpp];

        /* vertical pass */
        gaussian_iir_horizontal (buffer1, buffer2, terms,
                        data, tmp, height*bpp, height, width, bpp, 
                        n_p, n_m, d_p, d_m, bd_p, bd_m);
                        //a[0], a[1], a[2], a[3], a[4],
                        //b[0], b[1], b[2], b[3], b[4]);                                             

        /* horizontal pass */
        gaussian_iir_horizontal (buffer1, buffer2, terms,
                        tmp, data, bpp, width, height, width*bpp, 
                        n_p, n_m, d_p, d_m, bd_p, bd_m);
                        //a[0], a[1], a[2], a[3], a[4],
                        //b[0], b[1], b[2], b[3], b[4]);
        
//        GLib.Memory.copy (data, tmp, width*height*bpp);
    }    


    // TODO: Rename to gaussian_iir_line
    private void gaussian_iir_horizontal (double[] buffer1, double[] buffer2, int padding,
                        uchar[] data, uchar[] tmp, int bpp, int width, int height, int rowstride, 
                        double[] n_p, double[] n_m, double[] d_p, double[] d_m, double[] bd_p, double[] bd_m)

    {        
        /* FIXME: Currently only A8 format is supported */

        /* FIXME: bpp means bits_per_pixel, not bytes_per_pixel */

        double* buf1_ptr;
        double* buf2_ptr;        
        uchar*  data1_ptr;
        uchar*  data2_ptr;
        uchar*  tmp_ptr;

        uchar* initial1;
        uchar* initial2;

        int i, j, x, y;


        for (y=0; y < height; y++)
        {
            //Memory.set (buffer1, 0, width*sizeof(double));
            //Memory.set (buffer2, 0, width*sizeof(double));

            data1_ptr = (uchar*) data + y*rowstride;
            data2_ptr = (uchar*) data + y*rowstride + (width-1)*bpp;
            buf1_ptr  = (double*) buffer1;
            buf2_ptr  = (double*) buffer2 + (width-1);

            /* Set up the first vals  */
            initial1 = data1_ptr;
            initial2 = data2_ptr;

            for (x = 0; x <= 4; x++)
            {
                buf1_ptr[0] = 0.0;
                buf2_ptr[0] = 0.0;

                for (i=0; i < x; i++) {
                    buf1_ptr[0] += n_p[i] * data1_ptr[-i*bpp]  -  d_p[i] * buf1_ptr[-i];
                    buf2_ptr[0] += n_m[i] * data2_ptr[i*bpp]   -  d_m[i] * buf2_ptr[i];
                }
                for (; i <= 4; i++) {
                    buf1_ptr[0] += (n_p[i] - bd_p[i]) * initial1[0];
                    buf2_ptr[0] += (n_m[i] - bd_m[i]) * initial2[0];
                }

                data1_ptr += bpp;
                data2_ptr -= bpp;
                buf1_ptr  += 1;
                buf2_ptr  -= 1;
            }

            for (; x < width; x++)
            {
                buf1_ptr[0] = n_p[0] * data1_ptr[-0*bpp]  -  d_p[0] * buf1_ptr[-0] +
                              n_p[1] * data1_ptr[-1*bpp]  -  d_p[1] * buf1_ptr[-1] +
                              n_p[2] * data1_ptr[-2*bpp]  -  d_p[2] * buf1_ptr[-2] +
                              n_p[3] * data1_ptr[-3*bpp]  -  d_p[3] * buf1_ptr[-3] +
                              n_p[4] * data1_ptr[-4*bpp]  -  d_p[4] * buf1_ptr[-4];                
                
                buf2_ptr[0] = n_m[0] * data2_ptr[0*bpp]   -  d_m[0] * buf2_ptr[0] +
                              n_m[1] * data2_ptr[1*bpp]   -  d_m[1] * buf2_ptr[1] +
                              n_m[2] * data2_ptr[2*bpp]   -  d_m[2] * buf2_ptr[2] +
                              n_m[3] * data2_ptr[3*bpp]   -  d_m[3] * buf2_ptr[3] +
                              n_m[4] * data2_ptr[4*bpp]   -  d_m[4] * buf2_ptr[4];                
                
                data1_ptr += bpp;
                data2_ptr -= bpp;
                buf1_ptr  += 1;
                buf2_ptr  -= 1;
            }

            /* Copy result */
            buf1_ptr = (double*) buffer1;
            buf2_ptr = (double*) buffer2;
            tmp_ptr  = (uchar*)  tmp + y*rowstride;

            for (x = 0; x < width; x++)
            {
                *tmp_ptr = (uchar) Math.round (*buf1_ptr + *buf2_ptr).clamp (0.0, 255.0);
                
                tmp_ptr  += bpp;
                buf1_ptr += 1;
                buf2_ptr += 1;
            }
        }
    }    
    
    private void find_gaussian_iir_coefficiens (double radius, int order,
                        [CCode (array_length = false)] double[]  a,
                        [CCode (array_length = false)] double[]  n_m,
                        [CCode (array_length = false)] double[]  b,
                        [CCode (array_length = false)] double[]  d_m,
                        [CCode (array_length = false)] double[]  bd_p,
                        [CCode (array_length = false)] double[]  bd_m
                        )
    {
        radius = Math.fabs (radius) + 1.0;
        
        /*  The constants used in the implemenation of a casual sequence
         *  using a 4th order approximation of the gaussian operator
         */
        double std_dev = Math.sqrt (-(radius * radius) / (2 * Math.log (1.0 / 255.0)));
        double div     = Math.sqrt (2 * Math.PI) * std_dev;
        double x0 = -1.7830 / std_dev;
        double x1 = -1.7230 / std_dev;
        double x2 =  0.6318 / std_dev;
        double x3 =  1.9970 / std_dev;
        double x4 =  1.6803 / div;
        double x5 =  3.7350 / div;
        double x6 = -0.6803 / div;
        double x7 = -0.2598 / div;
        int i;

        a[0] = x4 + x6;
        a[1] = Math.exp(x1) * (x7*Math.sin(x3) - (x6+2*x4)*Math.cos(x3)) +
                  Math.exp(x0) * (x5*Math.sin(x2) - (2*x6+x4)*Math.cos (x2));
        a[2] = 2 * Math.exp(x0+x1) * (
                  (x4+x6)*Math.cos(x3)*Math.cos(x2) - x5*Math.cos(x3)*Math.sin(x2) - x7*Math.cos(x2)*Math.sin(x3)
                  ) + x6*Math.exp(2*x0) + x4*Math.exp(2*x1);
        a[3] = Math.exp(x1+2*x0) * (x7*Math.sin(x3) - x6*Math.cos(x3)) +
                  Math.exp(x0+2*x1) * (x5*Math.sin(x2) - x4*Math.cos(x2));
        a[4] = 0.0;

        b[0] = 0.0;
        b[1] = -2 * Math.exp(x1) * Math.cos(x3) -  2 * Math.exp(x0) * Math.cos (x2);
        b[2] =  4 * Math.cos(x3) * Math.cos(x2) * Math.exp(x0 + x1) +  Math.exp(2 * x1) + Math.exp(2 * x0);
        b[3] = -2 * Math.cos(x2) * Math.exp(x0 + 2*x1) -  2*Math.cos(x3) * Math.exp(x1 + 2*x0);
        b[4] = Math.exp(2*x0 + 2*x1);

        for (i = 0; i <= 4; i++)
            d_m[i] = b[i];

        n_m[0] = 0.0;

        for (i = 1; i <= 4; i++)
            n_m[i] = a[i] - b[i] * a[0];

        {
            double sum_a, sum_n_m, sum_d;
            double _a, _b;

            sum_a   = 0.0;
            sum_n_m = 0.0;
            sum_d   = 0.0;

            for (i = 0; i <= 4; i++)
            {
                sum_a   += a[i];
                sum_n_m += n_m[i];
                sum_d   += b[i];
            }

            _a = sum_a   / (1.0 + sum_d);
            _b = sum_n_m / (1.0 + sum_d);

            for (i = 0; i <= 4; i++)
            {
                bd_p[i] = b[i]   * _a;
                bd_m[i] = d_m[i] * _b;
            }
        }    
    }

//            private void gaussian_iir (uchar[] data, int width, int height, double radius)
//            {
//                int          bytes     = 1;
//                //int          has_alpha = 0;

//                uchar[]      dest;
//                uchar[]      src;
//                uchar        *src_ptr;
//                uchar        *src_m_ptr;
//                
//                double       a[5], n_m[5];
//                double       b[5], d_m[5];
//                double       bd_p[5], bd_m[5];
//                double[]     val_p = null;
//                double[]     val_m = null;
//                double      *vp;
//                double      *vm;
//                int          i, j;
//                int          x, y, ch;
//                int          terms;
//                int          initial_p[4];
//                int          initial_m[4];
//                double       std_dev;


//                val_p = new double[int.max (width, height) * bytes];
//                val_m = new double[int.max (width, height) * bytes];

//                src  = new uchar[int.max (width, height) * bytes];
//                dest = new uchar[int.max (width, height) * bytes];


//        //        radius = Math.fabs (radius) + 1.0;
//        //        std_dev = Math.sqrt (-(radius * radius) / (2 * Math.log (1.0 / 255.0)));
//                
//                ch = 0;

//                
//                /*  derive the constants for calculating the gaussian
//                *  from the std dev
//                */
//                // a1 a2, b1 ??
//        //        find_iir_constants (std_dev, out a, out n_m, out b, out d_m, out bd_p, out bd_m);
//        //        find_iir_constants (std_dev, a, n_m, b, d_m, bd_p, bd_m);
//                find_iir_constants (radius, a, n_m, b, d_m, bd_p, bd_m);

//                print ("\na = [");
//                for (i=0; i < 5; i++)
//                    print ("%g, ", a[i]);
//                print ("]\n");
//                    
//                print ("\nb = [");
//                for (i=0; i < 5; i++)
//                    print ("%g, ", b[i]);
//                print ("]\n");
//                    
//                /*  horizontal pass  */
//                if (radius > 1.0)
//                {
//                    for (y = 0; y < height; y++)
//                    {
//                        //memset (val_p, 0, height * bytes * sizeof (double)); // TODO ??
//                        //memset (val_m, 0, height * bytes * sizeof (double));

//                        // TODO
//                        //gimp_pixel_rgn_get_col (&src_rgn, src, x + x1, y1, height);
//                        Memory.copy (src, (uchar[])((uchar*)data + y*width), width * bytes);
//                        
//                        //if (has_alpha)
//                        //    multiply_alpha (src, height, bytes);

//                        src_ptr = src;
//        //                src_m_ptr = src + (height - 1) * bytes;
//                        vp = val_p;
//        //                vm = val_m + (height - 1) * bytes;

//                        /*  Set up the first vals  */
//                        for (i = 0; i < bytes; i++)
//                        {
//                            initial_p[i] = src_ptr[i];
//        //                    initial_m[i] = src_m_ptr[i];
//                        }

//                        for (x = 0; x < width; x++)
//                        {
//                            double *vpptr;
//                            double *vmptr;
//                            terms = (x < 4) ? x : 4; // related to gaussian nth order

//                            //for (ch = 0; ch < bytes; ch++)
//                            //{
//                                vpptr = vp + ch;
//        //                        vmptr = vm + ch;
//                                for (i = 0; i <= terms; i++)
//                                {
//                                    *vpptr += a[i] * src_ptr[-i * bytes + ch]; //  -  b[i] * vp[-i * bytes + ch];
//        //                            *vpptr += a[i] * src_ptr[-i * bytes + ch]  -  b[i] * vp[-i * bytes + ch];
//        //                            *vmptr += n_m[i] * src_m_ptr[ i * bytes + ch]  -  d_m[i] * vm[ i * bytes + ch];
//                                }
//                                for (j = i; j <= 4; j++)
//                                {
//                                    *vpptr += (a[j] - bd_p[j]) * initial_p[ch];
//        //                            *vmptr += (n_m[j] - bd_m[j]) * initial_m[ch];
//                                }
//                            //}

//                            src_ptr += bytes;
//        //                    src_m_ptr -= bytes;
//                            vp += bytes;
//        //                    vm -= bytes;
//                        }


//                        //transfer_pixels (val_p, val_m, dest, bytes, height);

//                        for (x = 0; x < width; x++)
//                        {
//                            data[y*width + x] = (uchar) Math.floor (val_p[x].clamp(0.0, 255.0));
//                        }
//                        
//                        
//                        //Memory.copy ((uchar[])((uchar*)data + y*width), dest, width * bytes);


//                        /*
//                        if (direct)
//                        {
//                            gimp_pixel_rgn_set_col(&dest_rgn, dest, col + x1, y1, height);
//                        }
//                        else
//                        {
//                            for (row = 0; row < height; row++)
//                                memcpy (preview_buffer + (row * width + col) * bytes,
//                                        dest + row * bytes,
//                                        bytes);
//                        }
//                        */
//                    }

//                }

//                
//            }



//    static void
//    gauss_iir (//GimpDrawable *drawable,
//               gdouble       horz,
//               gdouble       vert,
//               //BlurMethod    method,
//               guchar       *preview_buffer,
//               gint          x1,
//               gint          y1,
//               gint          width,
//               gint          height)
//    {
//        GimpPixelRgn  src_rgn, dest_rgn;
//        gint          bytes;
//        gint          has_alpha;
//        guchar       *dest;
//        guchar       *src,  *src_ptr, *src_m_ptr;
//        gdouble       a[5], n_m[5];
//        gdouble       b[5], d_m[5];
//        gdouble       bd_p[5], bd_m[5];
//        gdouble      *val_p = NULL;
//        gdouble      *val_m = NULL;
//        gdouble      *vp, *vm;
//        gint          i, j;
//        gint          row, col, b;
//        gint          terms;
//        gdouble       progress, max_progress;
//        gint          initial_p[4];
//        gint          initial_m[4];
//        gdouble       std_dev;
//        gboolean      direct;
//        gint          progress_step;

//        direct = (preview_buffer == NULL);

//        bytes = drawable->bpp;
//        has_alpha = gimp_drawable_has_alpha (drawable->drawable_id);

//        val_p = g_new (gdouble, MAX (width, height) * bytes);
//        val_m = g_new (gdouble, MAX (width, height) * bytes);

//        src =  g_new (guchar, MAX (width, height) * bytes);
//        dest = g_new (guchar, MAX (width, height) * bytes);

//        gimp_pixel_rgn_init (&src_rgn,
//                           drawable, 0, 0, drawable->width, drawable->height,
//                           FALSE, FALSE);
//        if (direct)
//        {
//          gimp_pixel_rgn_init (&dest_rgn,
//                               drawable, 0, 0, drawable->width, drawable->height,
//                               TRUE, TRUE);
//        }


//        progress = 0.0;
//        max_progress  = (horz <= 0.0) ? 0 : width * height * horz;
//        max_progress += (vert <= 0.0) ? 0 : width * height * vert;


//        /*  First the vertical pass  */
//        if (vert > 0.0)
//        {
//          vert = fabs (vert) + 1.0;
//          std_dev = sqrt (-(vert * vert) / (2 * log (1.0 / 255.0)));

//          /* We do not want too many progress updates because they
//           * can slow down the processing significantly for very
//           * large images
//           */
//          progress_step = width / 16;

//          if (progress_step < 5)
//            progress_step = 5;

//          /*  derive the constants for calculating the gaussian
//           *  from the std dev
//           */

//          find_iir_constants (a, n_m, b, d_m, bd_p, bd_m, std_dev);

//          for (col = 0; col < width; col++)
//            {
//              memset (val_p, 0, height * bytes * sizeof (gdouble));
//              memset (val_m, 0, height * bytes * sizeof (gdouble));

//              gimp_pixel_rgn_get_col (&src_rgn, src, col + x1, y1, height);

//              if (has_alpha)
//                multiply_alpha (src, height, bytes);

//              src_ptr = src;
//              src_m_ptr = src + (height - 1) * bytes;
//              vp = val_p;
//              vm = val_m + (height - 1) * bytes;

//              /*  Set up the first vals  */
//              for (i = 0; i < bytes; i++)
//                {
//                  initial_p[i] = src_ptr[i];
//                  initial_m[i] = src_m_ptr[i];
//                }

//              for (row = 0; row < height; row++)
//                {
//                  gdouble *vpptr, *vmptr;
//                  terms = (row < 4) ? row : 4;

//                  for (b = 0; b < bytes; b++)
//                    {
//                      vpptr = vp + b; vmptr = vm + b;
//                      for (i = 0; i <= terms; i++)
//                        {
//                          *vpptr += a[i] * src_ptr[(-i * bytes) + b] - b[i] * vp[(-i * bytes) + b];
//                          *vmptr += n_m[i] * src_m_ptr[(i * bytes) + b] - d_m[i] * vm[(i * bytes) + b];
//                        }
//                      for (j = i; j <= 4; j++)
//                        {
//                          *vpptr += (a[j] - bd_p[j]) * initial_p[b];
//                          *vmptr += (n_m[j] - bd_m[j]) * initial_m[b];
//                        }
//                    }

//                  src_ptr += bytes;
//                  src_m_ptr -= bytes;
//                  vp += bytes;
//                  vm -= bytes;
//                }

//              transfer_pixels (val_p, val_m, dest, bytes, height);


//              if (has_alpha)
//                separate_alpha (dest, height, bytes);

//              if (direct)
//                {
//                  gimp_pixel_rgn_set_col(&dest_rgn, dest, col + x1, y1, height);

//                  progress += height * vert;

//                  if ((col % progress_step) == 0)
//                    gimp_progress_update (progress / max_progress);
//                }
//              else
//                {
//                  for (row = 0; row < height; row++)
//                    memcpy (preview_buffer + (row * width + col) * bytes,
//                            dest + row * bytes,
//                            bytes);
//                }
//            }

//          /*  prepare for the horizontal pass  */
//          gimp_pixel_rgn_init (&src_rgn,
//                               drawable,
//                               0, 0,
//                               drawable->width, drawable->height,
//                               FALSE, TRUE);
//        }
//        else if (!direct)
//        {
//          gimp_pixel_rgn_get_rect (&src_rgn,
//                                   preview_buffer,
//                                   x1, y1,
//                                   width, height);
//        }

//        /*  Now the horizontal pass  */
//        if (horz > 0.0)
//        {

//          /* We do not want too many progress updates because they
//           * can slow down the processing significantly for very
//           * large images
//           */
//          progress_step = height / 16;

//          if (progress_step < 5)
//            progress_step = 5;

//          horz = fabs (horz) + 1.0;

//          if (horz != vert)
//            {
//              std_dev = sqrt (-(horz * horz) / (2 * log (1.0 / 255.0)));

//              /*  derive the constants for calculating the gaussian
//               *  from the std dev
//               */
//              find_iir_constants (a, n_m, b, d_m, bd_p, bd_m, std_dev);

//            }


//          for (row = 0; row < height; row++)
//            {

//              memset (val_p, 0, width * bytes * sizeof (gdouble));
//              memset (val_m, 0, width * bytes * sizeof (gdouble));

//              if (direct)
//                {
//                  gimp_pixel_rgn_get_row (&src_rgn, src, x1, row + y1, width);
//                }
//              else
//                {
//                  memcpy (src,
//                          preview_buffer + row * width * bytes,
//                          width * bytes);
//                }


//              if (has_alpha)
//                multiply_alpha (src, width, bytes);


//              src_ptr = src;
//              src_m_ptr = src + (width - 1) * bytes;
//              vp = val_p;
//              vm = val_m + (width - 1) * bytes;

//              /*  Set up the first vals  */
//              for (i = 0; i < bytes; i++)
//                {
//                  initial_p[i] = src_ptr[i];
//                  initial_m[i] = src_m_ptr[i];
//                }

//              for (col = 0; col < width; col++)
//                {
//                  gdouble *vpptr, *vmptr;

//                  terms = (col < 4) ? col : 4;

//                  for (b = 0; b < bytes; b++)
//                    {
//                      vpptr = vp + b; vmptr = vm + b;

//                      for (i = 0; i <= terms; i++)
//                        {
//                          *vpptr += a[i] * src_ptr[(-i * bytes) + b] -
//                            b[i] * vp[(-i * bytes) + b];
//                          *vmptr += n_m[i] * src_m_ptr[(i * bytes) + b] -
//                            d_m[i] * vm[(i * bytes) + b];
//                        }
//                      for (j = i; j <= 4; j++)
//                        {
//                          *vpptr += (a[j] - bd_p[j]) * initial_p[b];
//                          *vmptr += (n_m[j] - bd_m[j]) * initial_m[b];
//                        }
//                    }

//                  src_ptr += bytes;
//                  src_m_ptr -= bytes;
//                  vp += bytes;
//                  vm -= bytes;
//                }

//              transfer_pixels (val_p, val_m, dest, bytes, width);

//              if (has_alpha)
//                separate_alpha (dest, width, bytes);

//              if (direct)
//                {
//                  gimp_pixel_rgn_set_row (&dest_rgn, dest, x1, row + y1, width);

//                  progress += width * horz;

//                  if ((row % progress_step) == 0)
//                    gimp_progress_update (progress / max_progress);
//                }
//              else
//                {
//                  memcpy (preview_buffer + row * width * bytes,
//                          dest,
//                          width * bytes);
//                }
//            }
//        }

//        /*  free up buffers  */

//        g_free (val_p);
//        g_free (val_m);

//        g_free (src);
//        g_free (dest);
//    }
    
    
}

