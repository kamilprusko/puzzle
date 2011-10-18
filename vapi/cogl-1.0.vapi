/* cogl-1.0.vapi generated by vapigen, do not modify. */

[CCode (cprefix = "Cogl", lower_case_cprefix = "cogl_", gir_namespace = "Cogl", gir_version = "1.0")]
namespace Cogl {
	[Compact]
	[CCode (cname = "CoglHandle", cheader_filename = "cogl/cogl.h")]
	public class Bitmap : Cogl.Handle {
		public static GLib.Type error_get_type ();
		public static GLib.Quark error_quark ();
		public static bool get_size_from_file (string filename, out int width, out int height);
		public static Cogl.Bitmap new_from_file (string filename) throws GLib.Error;
	}
	[Compact]
	[CCode (cname = "CoglHandle", cheader_filename = "cogl/cogl.h")]
	public class Buffer : Cogl.Handle {
		public static GLib.Type access_get_type ();
		public static GLib.Type bit_get_type ();
		public uint get_size ();
		public Cogl.BufferUpdateHint get_update_hint ();
		public uchar map (Cogl.BufferAccess access);
		public static GLib.Type map_hint_get_type ();
		public bool set_data (size_t offset, [CCode (array_length_type = "size_t")] uint8[] data);
		public void set_update_hint (Cogl.BufferUpdateHint hint);
		public static GLib.Type target_get_type ();
		public void unmap ();
		public static GLib.Type update_hint_get_type ();
	}
	[Compact]
	[CCode (cheader_filename = "cogl/cogl.h")]
	public class Framebuffer {
	}
	[Compact]
	[CCode (ref_function = "cogl_handle_ref", unref_function = "cogl_handle_unref", cheader_filename = "cogl/cogl.h")]
	public class Handle {
		[CCode (cname = "cogl_is_bitmap")]
		public bool is_bitmap ();
		[CCode (cname = "cogl_is_buffer")]
		public bool is_buffer ();
		[CCode (cname = "cogl_is_material")]
		public bool is_material ();
		[CCode (cname = "cogl_is_offscreen")]
		public bool is_offscreen ();
		[CCode (cname = "cogl_is_pixel_buffer")]
		public bool is_pixel_buffer ();
		[CCode (cname = "cogl_is_program")]
		public bool is_program ();
		[CCode (cname = "cogl_is_shader")]
		public bool is_shader ();
		[CCode (cname = "cogl_is_texture")]
		public bool is_texture ();
		[CCode (cname = "cogl_is_vertex_buffer")]
		public bool is_vertex_buffer ();
	}
	[Compact]
	[CCode (ref_function = "cogl_material_ref", unref_function = "cogl_material_unref", cname = "CoglHandle", cheader_filename = "cogl/cogl.h")]
	public class Material : Cogl.Handle {
		[CCode (has_construct_function = false)]
		public Material ();
		public static GLib.Type alpha_func_get_type ();
		public Cogl.Material copy ();
		public static GLib.Type filter_get_type ();
		public static void foreach_layer (Cogl.Material material, Cogl.MaterialLayerCallback callback);
		public void get_ambient (out Cogl.Color ambient);
		public void get_color (out Cogl.Color color);
		public static void get_depth_range (Cogl.Material material, float near_val, float far_val);
		public static bool get_depth_test_enabled (Cogl.Material material);
		public static Cogl.DepthTestFunction get_depth_test_function (Cogl.Material material);
		public static bool get_depth_writing_enabled (Cogl.Material material);
		public void get_diffuse (out Cogl.Color diffuse);
		public void get_emission (out Cogl.Color emission);
		public static bool get_layer_point_sprite_coords_enabled (Cogl.Material material, int layer_index);
		public unowned GLib.List<Cogl.MaterialLayer> get_layers ();
		public int get_n_layers ();
		public float get_point_size ();
		public float get_shininess ();
		public void get_specular (out Cogl.Color specular);
		public static unowned Cogl.Bitmap get_user_program (Cogl.Material material);
		public void remove_layer (int layer_index);
		public void set_alpha_test_function (Cogl.MaterialAlphaFunc alpha_func, float alpha_reference);
		public void set_ambient (Cogl.Color ambient);
		public void set_ambient_and_diffuse (Cogl.Color color);
		public bool set_blend (string blend_string) throws Cogl.BlendStringError;
		public void set_blend_constant (Cogl.Color constant_color);
		public void set_color (Cogl.Color color);
		public void set_color4f (float red, float green, float blue, float alpha);
		public void set_color4ub (uchar red, uchar green, uchar blue, uchar alpha);
		public static bool set_depth_range (Cogl.Material material, float near_val, float far_val) throws GLib.Error;
		public static void set_depth_test_enabled (Cogl.Material material, bool enable);
		public static void set_depth_test_function (Cogl.Material material, Cogl.DepthTestFunction function);
		public static void set_depth_writing_enabled (Cogl.Material material, bool enable);
		public void set_diffuse (Cogl.Color diffuse);
		public void set_emission (Cogl.Color emission);
		public void set_layer (int layer_index, Cogl.Texture texture);
		public bool set_layer_combine (int layer_index, string blend_string) throws Cogl.BlendStringError;
		public void set_layer_combine_constant (int layer_index, Cogl.Color constant);
		public void set_layer_filters (int layer_index, Cogl.MaterialFilter min_filter, Cogl.MaterialFilter mag_filter);
		public void set_layer_matrix (int layer_index, Cogl.Matrix matrix);
		public static bool set_layer_point_sprite_coords_enabled (Cogl.Material material, int layer_index, bool enable) throws GLib.Error;
		public static void set_layer_wrap_mode (Cogl.Material material, int layer_index, Cogl.MaterialWrapMode mode);
		public static void set_layer_wrap_mode_p (Cogl.Material material, int layer_index, Cogl.MaterialWrapMode mode);
		public static void set_layer_wrap_mode_s (Cogl.Material material, int layer_index, Cogl.MaterialWrapMode mode);
		public static void set_layer_wrap_mode_t (Cogl.Material material, int layer_index, Cogl.MaterialWrapMode mode);
		public void set_point_size (float point_size);
		public void set_shininess (float shininess);
		public void set_specular (Cogl.Color specular);
		public static void set_user_program (Cogl.Material material, Cogl.Bitmap program);
		public static GLib.Type wrap_mode_get_type ();
	}
	[Compact]
	[CCode (cname = "CoglHandle", cheader_filename = "cogl/cogl.h")]
	public class MaterialLayer : Cogl.Handle {
		public Cogl.MaterialFilter get_mag_filter ();
		public Cogl.MaterialFilter get_min_filter ();
		public unowned Cogl.Texture? get_texture ();
		public Cogl.MaterialLayerType get_type ();
		public static Cogl.MaterialWrapMode get_wrap_mode_p (Cogl.MaterialLayer layer);
		public static Cogl.MaterialWrapMode get_wrap_mode_s (Cogl.MaterialLayer layer);
		public static Cogl.MaterialWrapMode get_wrap_mode_t (Cogl.MaterialLayer layer);
		public static GLib.Type type_get_type ();
	}
	[Compact]
	[CCode (ref_function = "cogl_object_ref", unref_function = "cogl_object_unref", cheader_filename = "cogl/cogl.h")]
	public class Object {
		public void* get_user_data (Cogl.UserDataKey key);
		public void set_user_data (Cogl.UserDataKey key, Cogl.UserDataDestroyCallback destroy);
	}
	[Compact]
	[CCode (ref_function = "cogl_offscreen_ref", unref_function = "cogl_offscreen_unref", cname = "CoglHandle", cheader_filename = "cogl/cogl.h")]
	public class Offscreen : Cogl.Handle {
		[CCode (cname = "cogl_pop_draw_buffer")]
		public static void pop_draw_buffer ();
		[CCode (cname = "cogl_push_draw_buffer")]
		public static void push_draw_buffer ();
		[CCode (instance_pos = -1)]
		public void set_draw_buffer (Cogl.BufferTarget target);
		[CCode (has_construct_function = false)]
		public Offscreen.to_texture (Cogl.Texture handle);
	}
	[Compact]
	[CCode (cheader_filename = "cogl/cogl.h")]
	public class PangoFontMap {
		[CCode (type = "PangoFontMap*", has_construct_function = false)]
		public PangoFontMap ();
		public void clear_glyph_cache ();
		public unowned Pango.Context create_context ();
		public unowned Pango.Renderer get_renderer ();
		public bool get_use_mipmapping ();
		public void set_resolution (double dpi);
		public void set_use_mipmapping (bool value);
	}
	[Compact]
	[CCode (cheader_filename = "cogl/cogl.h")]
	public class PangoRenderer {
	}
	[Compact]
	[CCode (cheader_filename = "cogl/cogl.h")]
	public class PangoRendererClass {
	}
	[Compact]
	[CCode (copy_function = "cogl_path_copy", cheader_filename = "cogl/cogl.h")]
	public class Path {
		[CCode (type = "void", has_construct_function = false)]
		public Path ();
		public static void arc (float center_x, float center_y, float radius_x, float radius_y, float angle_1, float angle_2);
		public static void close ();
		public unowned Cogl.Path copy ();
		public static void curve_to (float x_1, float y_1, float x_2, float y_2, float x_3, float y_3);
		public static void ellipse (float center_x, float center_y, float radius_x, float radius_y);
		public static void fill ();
		public static void fill_preserve ();
		public static GLib.Type fill_rule_get_type ();
		public static Cogl.PathFillRule get_fill_rule ();
		public static void line (float x_1, float y_1, float x_2, float y_2);
		public static void line_to (float x, float y);
		public static void move_to (float x, float y);
		public static void polygon ([CCode (array_length = false)] float[] coords, int num_points);
		public static void polyline ([CCode (array_length = false)] float[] coords, int num_points);
		public static void rectangle (float x_1, float y_1, float x_2, float y_2);
		public static void rel_curve_to (float x_1, float y_1, float x_2, float y_2, float x_3, float y_3);
		public static void rel_line_to (float x, float y);
		public static void rel_move_to (float x, float y);
		public static void round_rectangle (float x_1, float y_1, float x_2, float y_2, float radius, float arc_step);
		public static void set_fill_rule (Cogl.PathFillRule fill_rule);
		public static void stroke ();
		public static void stroke_preserve ();
	}
	[Compact]
	[CCode (cheader_filename = "cogl/cogl.h")]
	public class PixelArray {
	}
	[Compact]
	[CCode (cheader_filename = "cogl/cogl.h")]
	public class PixelBuffer : Cogl.Handle {
		public PixelBuffer (uint size);
		public PixelBuffer.for_size (uint width, uint height, Cogl.PixelFormat format, uint stride);
	}
	[Compact]
	[CCode (ref_function = "cogl_program_ref", unref_function = "cogl_program_unref", cname = "CoglHandle", cheader_filename = "cogl/cogl.h")]
	public class Program : Cogl.Handle {
		[CCode (cname = "cogl_create_program", has_construct_function = false)]
		public Program ();
		public void attach_shader (Cogl.Shader shader_handle);
		public int get_uniform_location (string uniform_name);
		public void link ();
		public static void uniform_1f (int uniform_no, float value);
		public static void uniform_1i (int uniform_no, int value);
		public static void uniform_float (int uniform_no, int size, [CCode (array_length_pos = 2.9)] float[] value);
		public static void uniform_int (int uniform_no, int size, [CCode (array_length_pos = 2.9)] int[] value);
		public static void uniform_matrix (int uniform_no, int size, bool transpose, [CCode (array_length_pos = 2.9)] float[] value);
		public void use ();
	}
	[Compact]
	[CCode (ref_function = "cogl_shader_ref", unref_function = "cogl_shader_unref", cname = "CoglHandle", cheader_filename = "cogl/cogl.h")]
	public class Shader : Cogl.Handle {
		[CCode (cname = "cogl_create_shader", has_construct_function = false)]
		public Shader (Cogl.ShaderType shader_type);
		public void compile ();
		public string get_info_log ();
		public Cogl.ShaderType get_type ();
		public bool is_compiled ();
		public void source (string source);
	}
	[Compact]
	[CCode (ref_function = "cogl_texture_ref", unref_function = "cogl_texture_unref", cname = "CoglHandle", cheader_filename = "cogl/cogl.h")]
	public class Texture : Cogl.Handle {
		public Texture.from_bitmap (Cogl.Bitmap bmp_handle, Cogl.TextureFlags flags, Cogl.PixelFormat internal_format);
		public Texture.from_data (uint width, uint height, Cogl.TextureFlags flags, Cogl.PixelFormat format, Cogl.PixelFormat internal_format, uint rowstride, [CCode (array_length = false)] uchar[] data);
		public Texture.from_file (string filename, Cogl.TextureFlags flags, Cogl.PixelFormat internal_format) throws GLib.Error;
		public int get_data (Cogl.PixelFormat format, uint rowstride, uchar[] data);
		public Cogl.PixelFormat get_format ();
		public uint get_height ();
		public int get_max_waste ();
		public uint get_rowstride ();
		public uint get_width ();
		public bool is_sliced ();
		public bool set_region (int src_x, int src_y, int dst_x, int dst_y, uint dst_width, uint dst_height, int width, int height, Cogl.PixelFormat format, uint rowstride, uchar[] data);
		public Texture.with_size (uint width, uint height, Cogl.TextureFlags flags, Cogl.PixelFormat internal_format);
	}
	[Compact]
	[CCode (cheader_filename = "cogl/cogl.h")]
	public class UserDataKey {
		public int unused;
	}
	[Compact]
	[CCode (cheader_filename = "cogl/cogl.h")]
	public class Vector3 {
		public float x;
		public float y;
		public float z;
	}
	[Compact]
	[CCode (ref_function = "cogl_vertex_buffer_ref", unref_function = "cogl_vertex_buffer_unref", cname = "CoglHandle", cheader_filename = "cogl/cogl.h")]
	public class VertexBuffer : Cogl.Handle {
		[CCode (has_construct_function = false)]
		public VertexBuffer (uint n_vertices);
		public void add (string attribute_name, uchar n_components, Cogl.AttributeType type, bool normalized, uint16 stride, void* pointer);
		public void @delete (string attribute_name);
		public void disable (string attribute_name);
		public void draw (Cogl.VerticesMode mode, int first, int count);
		public void draw_elements (Cogl.VerticesMode mode, Cogl.VertexBufferIndices indices, int min_index, int max_index, int indices_offset, int count);
		public void enable (string attribute_name);
		public uint get_n_vertices ();
		public void submit ();
	}
	[Compact]
	[CCode (cname = "CoglHandle", cheader_filename = "cogl/cogl.h")]
	public class VertexBufferIndices : Cogl.Handle {
		public VertexBufferIndices (Cogl.IndicesType indices_type, void* indices_array, int indices_len);
		public static unowned Cogl.VertexBufferIndices get_for_quads (uint n_indices);
		public Cogl.IndicesType get_type ();
	}
	[CCode (type_id = "COGL_TYPE_ANGLE", cheader_filename = "cogl/cogl.h")]
	public struct Angle {
		public Cogl.Fixed cos ();
		public Cogl.Fixed sin ();
		public Cogl.Fixed tan ();
	}
	[CCode (has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public struct Color {
		public uchar red;
		public uchar green;
		public uchar blue;
		public uchar alpha;
		public uint32 padding0;
		public uint32 padding1;
		public uint32 padding2;
		public Cogl.Color copy ();
		public static bool equal (void* v1, void* v2);
		public float get_alpha ();
		public uint get_alpha_byte ();
		public float get_alpha_float ();
		public float get_blue ();
		public uint get_blue_byte ();
		public float get_blue_float ();
		public float get_green ();
		public uint get_green_byte ();
		public float get_green_float ();
		public float get_red ();
		public uint get_red_byte ();
		public float get_red_float ();
		public void init_from_4f (float red, float green, float blue, float alpha);
		public void init_from_4fv (float color_array);
		public void init_from_4ub (uchar red, uchar green, uchar blue, uchar alpha);
		public void premultiply ();
		public void set_alpha (float alpha);
		public void set_alpha_byte (uint alpha);
		public void set_alpha_float (float alpha);
		public void set_blue (float blue);
		public void set_blue_byte (uint blue);
		public void set_blue_float (float blue);
		public void set_from_4f (float red, float green, float blue, float alpha);
		public void set_from_4ub (uchar red, uchar green, uchar blue, uchar alpha);
		public void set_green (float green);
		public void set_green_byte (uint green);
		public void set_green_float (float green);
		public void set_red (float red);
		public void set_red_byte (uint red);
		public void set_red_float (float red);
		public void unpremultiply ();
	}
	[CCode (type_id = "COGL_TYPE_FIXED", cheader_filename = "cogl/cogl.h")]
	public struct Fixed {
		public Cogl.Fixed atan ();
		public Cogl.Fixed atan2 (Cogl.Fixed b);
		public Cogl.Fixed cos ();
		public Cogl.Fixed div (Cogl.Fixed b);
		public static Cogl.Fixed log2 (uint x);
		public Cogl.Fixed mul (Cogl.Fixed b);
		public Cogl.Fixed mul_div (Cogl.Fixed b, Cogl.Fixed c);
		public static uint pow (uint x, Cogl.Fixed y);
		public uint pow2 ();
		public Cogl.Fixed sin ();
		public Cogl.Fixed sqrt ();
		public Cogl.Fixed tan ();
	}
	[CCode (type_id = "COGL_TYPE_MATRIX", cheader_filename = "cogl/cogl.h")]
	public struct Matrix {
		public float xx;
		public float yx;
		public float zx;
		public float wx;
		public float xy;
		public float yy;
		public float zy;
		public float wy;
		public float xz;
		public float yz;
		public float zz;
		public float wz;
		public float xw;
		public float yw;
		public float zw;
		public float ww;
		[CCode (array_length = false)]
		public weak float[] inv;
		public uint type;
		public uint flags;
		public static bool equal (void* v1, void* v2);
		public Matrix.from_array ([CCode (array_length = false)] float[] array);
		public void frustum (float left, float right, float bottom, float top, float z_near, float z_far);
		[CCode (array_length = false)]
		public unowned float[] get_array ();
		public bool get_inverse (out Cogl.Matrix inverse);
		public Matrix.identity ();
		[CCode (cname = "cogl_matrix_multiply")]
		public Matrix.multiply (Cogl.Matrix a, Cogl.Matrix b);
		public void ortho (float left, float right, float bottom, float top, float z_near, float z_far);
		public void perspective (float fov_y, float aspect, float z_near, float z_far);
		public void rotate (float angle, float x, float y, float z);
		public void scale (float sx, float sy, float sz);
		public void transform_point (ref float x, ref float y, ref float z, ref float w);
		public void translate (float x, float y, float z);
	}
	[CCode (type_id = "COGL_TYPE_TEXTURE_VERTEX", cheader_filename = "cogl/cogl.h")]
	public struct TextureVertex {
		public float x;
		public float y;
		public float z;
		public float tx;
		public float ty;
		public Cogl.Color color;
	}
	[CCode (cprefix = "COGL_ATTRIBUTE_TYPE_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum AttributeType {
		BYTE,
		UNSIGNED_BYTE,
		SHORT,
		UNSIGNED_SHORT,
		FLOAT
	}
	[CCode (cprefix = "COGL_BITMAP_ERROR_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum BitmapError {
		FAILED,
		UNKNOWN_TYPE,
		CORRUPT_IMAGE
	}
	[CCode (cprefix = "COGL_BUFFER_ACCESS_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum BufferAccess {
		READ,
		WRITE,
		READ_WRITE
	}
	[CCode (cprefix = "COGL_BUFFER_BIT_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum BufferBit {
		COLOR,
		DEPTH,
		STENCIL
	}
	[CCode (cprefix = "COGL_BUFFER_MAP_HINT_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum BufferMapHint {
		DISCARD
	}
	[CCode (cprefix = "COGL_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum BufferTarget {
		WINDOW_BUFFER,
		OFFSCREEN_BUFFER
	}
	[CCode (cprefix = "COGL_BUFFER_UPDATE_HINT_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum BufferUpdateHint {
		STATIC,
		DYNAMIC,
		STREAM
	}
	[CCode (cprefix = "COGL_DEPTH_TEST_FUNCTION_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum DepthTestFunction {
		NEVER,
		LESS,
		EQUAL,
		LEQUAL,
		GREATER,
		NOTEQUAL,
		GEQUAL,
		ALWAYS
	}
	[CCode (cprefix = "COGL_DRIVER_ERROR_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum DriverError {
		UNKNOWN_VERSION,
		INVALID_VERSION
	}
	[CCode (cprefix = "COGL_ERROR_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum Error {
		UNSUPPORTED
	}
	[CCode (cprefix = "COGL_FEATURE_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum FeatureFlags {
		TEXTURE_RECTANGLE,
		TEXTURE_NPOT,
		TEXTURE_YUV,
		TEXTURE_READ_PIXELS,
		SHADERS_GLSL,
		OFFSCREEN,
		OFFSCREEN_MULTISAMPLE,
		OFFSCREEN_BLIT,
		FOUR_CLIP_PLANES,
		STENCIL_BUFFER,
		VBOS,
		PBOS,
		UNSIGNED_INT_INDICES,
		DEPTH_RANGE,
		TEXTURE_NPOT_BASIC,
		TEXTURE_NPOT_MIPMAP,
		TEXTURE_NPOT_REPEAT,
		POINT_SPRITE,
		TEXTURE_3D,
		SHADERS_ARBFP
	}
	[CCode (cprefix = "COGL_FOG_MODE_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum FogMode {
		LINEAR,
		EXPONENTIAL,
		EXPONENTIAL_SQUARED
	}
	[CCode (cprefix = "COGL_INDICES_TYPE_UNSIGNED_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum IndicesType {
		BYTE,
		SHORT,
		INT
	}
	[CCode (cprefix = "COGL_MATERIAL_ALPHA_FUNC_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum MaterialAlphaFunc {
		NEVER,
		LESS,
		EQUAL,
		LEQUAL,
		GREATER,
		NOTEQUAL,
		GEQUAL,
		ALWAYS
	}
	[CCode (cprefix = "COGL_MATERIAL_FILTER_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum MaterialFilter {
		NEAREST,
		LINEAR,
		NEAREST_MIPMAP_NEAREST,
		LINEAR_MIPMAP_NEAREST,
		NEAREST_MIPMAP_LINEAR,
		LINEAR_MIPMAP_LINEAR
	}
	[CCode (cprefix = "COGL_MATERIAL_LAYER_TYPE_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum MaterialLayerType {
		TEXTURE
	}
	[CCode (cprefix = "COGL_MATERIAL_WRAP_MODE_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum MaterialWrapMode {
		REPEAT,
		CLAMP_TO_EDGE,
		AUTOMATIC
	}
	[CCode (cprefix = "COGL_PATH_FILL_RULE_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum PathFillRule {
		NON_ZERO,
		EVEN_ODD
	}
	[CCode (cprefix = "COGL_PIXEL_FORMAT_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum PixelFormat {
		ANY,
		A_8,
		RGB_565,
		RGBA_4444,
		RGBA_5551,
		YUV,
		G_8,
		RGB_888,
		BGR_888,
		RGBA_8888,
		BGRA_8888,
		ARGB_8888,
		ABGR_8888,
		RGBA_8888_PRE,
		BGRA_8888_PRE,
		ARGB_8888_PRE,
		ABGR_8888_PRE,
		RGBA_4444_PRE,
		RGBA_5551_PRE
	}
	[CCode (cprefix = "COGL_READ_PIXELS_COLOR_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum ReadPixelsFlags {
		BUFFER
	}
	[CCode (cprefix = "COGL_SHADER_TYPE_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum ShaderType {
		VERTEX,
		FRAGMENT
	}
	[CCode (cprefix = "COGL_TEXTURE_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum TextureFlags {
		NONE,
		NO_AUTO_MIPMAP,
		NO_SLICING,
		NO_ATLAS
	}
	[CCode (cprefix = "COGL_TEXTURE_PIXMAP_X11_DAMAGE_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum TexturePixmapX11ReportLevel {
		RAW_RECTANGLES,
		DELTA_RECTANGLES,
		BOUNDING_BOX,
		NON_EMPTY
	}
	[CCode (cprefix = "COGL_VERTICES_MODE_", has_type_id = false, cheader_filename = "cogl/cogl.h")]
	public enum VerticesMode {
		POINTS,
		LINE_STRIP,
		LINE_LOOP,
		LINES,
		TRIANGLE_STRIP,
		TRIANGLE_FAN,
		TRIANGLES
	}
	[CCode (cprefix = "COGL_BLEND_STRING_ERROR_", cheader_filename = "cogl/cogl.h")]
	public errordomain BlendStringError {
		PARSE_ERROR,
		ARGUMENT_PARSE_ERROR,
		INVALID_ERROR,
		GPU_UNSUPPORTED_ERROR,
	}
	[CCode (cheader_filename = "cogl/cogl.h", has_target = false)]
	public delegate void FuncPtr ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public delegate bool MaterialLayerCallback (Cogl.Material material, int layer_index);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public delegate void UserDataDestroyCallback ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int AFIRST_BIT;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int A_BIT;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int BGR_BIT;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int CLUTTER_COGL_HAS_GL;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int FIXED_0_5;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int FIXED_1;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int FIXED_2_PI;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int FIXED_BITS;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int FIXED_EPSILON;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int FIXED_MAX;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int FIXED_MIN;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int FIXED_PI;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int FIXED_PI_2;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int FIXED_PI_4;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int FIXED_Q;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int HAS_GL;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int HAS_X11;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int HAS_XLIB;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int PIXEL_FORMAT_24;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int PIXEL_FORMAT_32;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int PREMULT_BIT;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int RADIANS_TO_DEGREES;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int SQRTI_ARG_10_PERCENT;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int SQRTI_ARG_5_PERCENT;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int SQRTI_ARG_MAX;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int TEXTURE_MAX_WASTE;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int UNORDERED_MASK;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public const int UNPREMULT_MASK;
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static GLib.Type attribute_type_get_type ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void begin_gl ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static GLib.Type blend_string_error_get_type ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static bool check_extension (string name, string ext);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void clear (Cogl.Color color, uint buffers);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void clip_ensure ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void clip_pop ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void clip_push (float x_offset, float y_offset, float width, float height);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void clip_push_from_path ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void clip_push_from_path_preserve ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void clip_push_rectangle (float x0, float y0, float x1, float y1);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void clip_push_window_rect (float x_offset, float y_offset, float width, float height);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void clip_push_window_rectangle (int x_offset, int y_offset, int width, int height);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void clip_stack_restore ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void clip_stack_save ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static GLib.Type depth_test_function_get_type ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void disable_fog ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static Cogl.Fixed double_to_fixed (double value);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static int double_to_int (double value);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static uint double_to_uint (double value);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static GLib.Type driver_error_get_type ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void end_gl ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static GLib.Type error_get_type ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static GLib.Type feature_flags_get_type ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static bool features_available (Cogl.FeatureFlags features);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void flush ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static GLib.Type fog_mode_get_type ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void frustum (float left, float right, float bottom, float top, float z_near, float z_far);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static bool get_backface_culling_enabled ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void get_bitmasks (int red, int green, int blue, int alpha);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static bool get_depth_test_enabled ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static Cogl.FeatureFlags get_features ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void get_modelview_matrix (Cogl.Matrix matrix);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static unowned GLib.OptionGroup get_option_group ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static unowned Cogl.Path get_path ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static unowned Cogl.FuncPtr get_proc_address (string name);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void get_projection_matrix (Cogl.Matrix matrix);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void get_viewport (float[] v);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static GLib.Type indices_type_get_type ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static bool is_path (Cogl.Bitmap handle);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static bool is_vertex_buffer_indices (Cogl.Bitmap handle);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void ortho (float left, float right, float bottom, float top, float near, float far);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void pango_ensure_glyph_cache_for_layout (Pango.Layout layout);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void pango_render_layout (Pango.Layout layout, int x, int y, Cogl.Color color, int flags);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void pango_render_layout_line (Pango.LayoutLine line, int x, int y, Cogl.Color color);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void pango_render_layout_subpixel (Pango.Layout layout, int x, int y, Cogl.Color color, int flags);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void perspective (float fovy, float aspect, float z_near, float z_far);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static GLib.Type pixel_format_get_type ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void polygon (Cogl.TextureVertex[] vertices, bool use_color);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void pop_framebuffer ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void pop_matrix ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void push_framebuffer (Cogl.Framebuffer buffer);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void push_matrix ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void read_pixels (int x, int y, int width, int height, Cogl.ReadPixelsFlags source, Cogl.PixelFormat format, uchar pixels);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static GLib.Type read_pixels_flags_get_type ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void rectangle (float x_1, float y_1, float x_2, float y_2);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void rectangle_with_multitexture_coords (float x1, float y1, float x2, float y2, float tex_coords, int tex_coords_len);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void rectangle_with_texture_coords (float x1, float y1, float x2, float y2, float tx1, float ty1, float tx2, float ty2);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void rectangles ([CCode (array_length = false)] float[] verts, uint n_rects);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void rectangles_with_texture_coords ([CCode (array_length = false)] float[] verts, uint n_rects);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void rotate (float angle, float x, float y, float z);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void scale (float x, float y, float z);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void set_backface_culling_enabled (bool setting);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void set_depth_test_enabled (bool setting);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void set_fog (Cogl.Color fog_color, Cogl.FogMode mode, float density, float z_near, float z_far);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void set_framebuffer (Cogl.Framebuffer buffer);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void set_modelview_matrix (Cogl.Matrix matrix);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void set_path (Cogl.Path path);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void set_projection_matrix (Cogl.Matrix matrix);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void set_source (Cogl.Material material);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void set_source_color (Cogl.Color color);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void set_source_color4f (float red, float green, float blue, float alpha);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void set_source_color4ub (uchar red, uchar green, uchar blue, uchar alpha);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void set_source_texture (Cogl.Texture texture_handle);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void set_viewport (int x, int y, int width, int height);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static int sqrti (int x);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void transform (Cogl.Matrix matrix);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void translate (float x, float y, float z);
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static GLib.Type vertices_mode_get_type ();
	[CCode (cheader_filename = "cogl/cogl.h")]
	public static void viewport (uint width, uint height);

    
    /*
     * Custom code
     */
	public static void path_new ();
	public static void path_line_to (float x, float y);
	public static void path_move_to (float x, float y);
	public static void path_fill ();
}
