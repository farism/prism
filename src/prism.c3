module prism;

import std::math, std::io;

macro max3(a, b, c) @private => math::max(a, math::max(b, c));
macro min3(a, b, c) @private => math::min(a, math::min(b, c));
macro cbrt(value) => math::pow(value, 0.333333333333333f);

const float XYZ_EPSILON @private = 216.0f / 24389.0f;
const float XYZ_KAPPA @private = 24389.0f / 27.0f;
const float XYZ_GAMMA @private = 2.4f;
const float XYZ_WHITE_X @private = 95.047f;
const float XYZ_WHITE_Y @private = 100.000f;
const float XYZ_WHITE_Z @private = 108.883f;
const ColorXYZ XYZ_WHITE @private = (ColorXYZ){ XYZ_WHITE_X, XYZ_WHITE_Y, XYZ_WHITE_Z };
const String HEX_CHARS_UPPERCASE @private = "0123456789ABCDEF";

excuse
{
	HTML_NAME_NOT_FOUND,
	INVALID_HEX_LENGTH,
	INVALID_HEX_CHARACTER,
}

struct Color
{
	<* red 0-1 *>
	float r;
	<* green 0-1 *>
	float g;
	<* blue 0-1 *>
	float b;
	<* alpha 0-1 *>
	float a;
}

struct ColorRGB
{
	<* red 0-255 *>
	char r;
	<* green 0-255 *>
	char g;
	<* blue 0-255 *>
	char b;
}

struct ColorRGBA
{
	<* red 0-255 *>
	char r;
	<* green 0-255 *>
	char g;
	<* blue 0-255 *>
	char b;
	<* alpha 0-1 *>
	char a;
}

struct ColorRGBX
{
	<* red 0-255 *>
	char r;
	<* green 0-255 *>
	char g;
	<* blue 0-255 *>
	char b;
	<* alpha 0-1 *>
	char a;
}

// CMY colors are reverse of rgb and as 100%
struct ColorCMY
{
	<* Cyan 0 to 100 *>
	float c;
	<* Magenta 0 to 100 *>
	float m;
	<* Yellow 0 to 100 *>
	float y;
}

// CMYK colors are used in printing
struct ColorCMYK
{
	<* Cyan 0 to 1 *>
	float c;
	<* Magenta 0 to 1 *>
	float m;
	<* Yellow 0 to 1 *>
	float y;
	<* Black 0 to 1 *>
	float k;
}

struct ColorHSL
{
	<* hue 0 to 360 *>
	float h;
	<* saturation 0 to 100 *>
	float s;
	<* lightness 0 to 100 *>
	float l;
}

struct ColorHSV
{
	<* hue 0 to 360 *>
	float h;
	<* saturation 0 to 100 *>
	float s;
	<* value 0 to 100 *>
	float v;
}

// YUV originally a television color format, still used in digital movies
struct ColorYUV
{
	<* 0 to 1 *>
	float y;
	<* -0.5 to 0.5 *>
	float u;
	<* -0.5 to 0.5 *>
	float v;
}

struct ColorXYZ
{
	<* range 0.0 to `XYZ_WHITE_X` *>
	float x;
	<* range 0.0 to `XYZ_WHITE_Y` *>
	float y;
	<* range 0.0 to `XYZ_WHITE_Z` *>
	float z;
}

struct ColorLAB
{
	<* lightness, range 0.0 (black) to 100.0 (white) *>
	float l;
	<* green (min) to red (max) *>
	float a;
	<* blue (min) to yellow (max) *>
	float b;
}

// LAB in polar coordinates
// Also known as: CIELCh, CIEHLC
// not to be confused with ColorPolarLUV == ColorHCL!
struct ColorLABPolar
{
	float l;  // lightness, range 0.0 (black) to 100.0 (white)
	float c;  // chroma, range 0.0 to max
	float h;  // hue angle, range 0.0 to 360.0
}

// (red: 0, yellow: 90, green: 180, blue: 270)

//  ----- CIE-XYZ <-> CIE-LUV -----
struct ColorLUV
{
	<* lightness, range 0.0 to 100.0 *>
	float l;
	<* red to green *>
	float u;
	<* blue to yellow *>
	float v;
}

struct ColorLUVPolar
{
	<* hue angle, range 0.0 to 360.0 *>
	float h;
	<* chroma *>
	float c;
	<* luminance *>
	float l;
}

<* Alias for PolarLUV, as it might be better known as HCL *>
alias ColorHCL = ColorLUVPolar;

struct ColorOklab
{
	<* perceived lightness *>
	float l;
	<* greenless/redness *>
	float a;
	<* blueless/yellowless *>
	float b;
}

struct ColorOklabPolar
{
	<* perceived lightness *>
	float l;
	<* chroma *>
	float c;
	<* hue *>
	float h;
}

// constructors

fn Color color(float r, float g, float b, float a = 1) => (Color){ r, g, b, a };
fn ColorRGB rgb(char r, char g, char b) => (ColorRGB){ r, g, b };
fn ColorRGBA rgba(char r, char g, char b, char a = 255) => (ColorRGBA){ r, g, b, a };
fn ColorCMY cmy(float c, float m, float y) => (ColorCMY){ c, m, y };
fn ColorCMYK cmyk(float c, float m, float y, float k) => (ColorCMYK){ c, m, y, k };
fn ColorHSL hsl(float h, float s, float l) => (ColorHSL){ h, s, l };
fn ColorHSV hsv(float h, float s, float v) => (ColorHSV){ h, s, v };
fn ColorYUV yuv(float y, float u, float v) => (ColorYUV){ y, u, v };
fn ColorXYZ xyz(float x, float y, float z) => (ColorXYZ){ x, y, z };
fn ColorLAB lab(float l, float a, float b) => (ColorLAB){ l, a, b };
fn ColorLABPolar lab_polar(float l, float c, float h) => (ColorLABPolar){ l, c, h };
fn ColorLUV luv(float l, float u, float v) => (ColorLUV){ l, u, v };
fn ColorLUVPolar luv_polar(float h, float c, float l) => (ColorLUVPolar){ h, c, l };
fn ColorOklab oklab(float l, float u, float v) => (ColorOklab){ l, u, v };
fn ColorOklabPolar oklab_polar(float l, float c, float h) => (ColorOklabPolar){ l, c, h };

// conversions to Color

fn Color Color.color(self) => self;
fn Color ColorRGB.color(self) => to_color(self);
fn Color ColorRGBA.color(self) => to_color(self);
fn Color ColorCMY.color(self) => to_color(self);
fn Color ColorCMYK.color(self) => to_color(self);
fn Color ColorHSL.color(self) => to_color(self);
fn Color ColorHSV.color(self) => to_color(self);
fn Color ColorYUV.color(self) => to_color(self);
fn Color ColorXYZ.color(self) => to_color(self);
fn Color ColorLAB.color(self) => to_color(self);
fn Color ColorLABPolar.color(self) => to_color(self);
fn Color ColorLUV.color(self) => to_color(self);
fn Color ColorLUVPolar.color(self) => to_color(self);
fn Color ColorOklab.color(self) => to_color(self);
fn Color ColorOklabPolar.color(self) => to_color(self);

// conversions to arbitrary color spaces

macro Color.to(self, $Type) => to(self, $Type);
macro ColorRGB.to(self, $Type) => to(self, $Type);
macro ColorRGBA.to(self, $Type) => to(self, $Type);
macro ColorCMY.to(self, $Type) => to(self, $Type);
macro ColorCMYK.to(self, $Type) => to(self, $Type);
macro ColorHSL.to(self, $Type) => to(self, $Type);
macro ColorHSV.to(self, $Type) => to(self, $Type);
macro ColorYUV.to(self, $Type) => to(self, $Type);
macro ColorXYZ.to(self, $Type) => to(self, $Type);
macro ColorLAB.to(self, $Type) => to(self, $Type);
macro ColorLABPolar.to(self, $Type) => to(self, $Type);
macro ColorLUV.to(self, $Type) => to(self, $Type);
macro ColorLUVPolar.to(self, $Type) => to(self, $Type);
macro ColorOklab.to(self, $Type) => to(self, $Type);
macro ColorOklabPolar.to(self, $Type) => to(self, $Type);

// colors to hex str

fn String Color.to_hex_str(self, bool alpha = true) => to_hex_str(self.color(), alpha);
fn String ColorRGB.to_hex_str(self, bool alpha = true) => to_hex_str(self.color(), alpha);
fn String ColorRGBA.to_hex_str(self, bool alpha = true) => to_hex_str(self.color(), alpha);
fn String ColorCMY.to_hex_str(self, bool alpha = true) => to_hex_str(self.color(), alpha);
fn String ColorCMYK.to_hex_str(self, bool alpha = true) => to_hex_str(self.color(), alpha);
fn String ColorHSL.to_hex_str(self, bool alpha = true) => to_hex_str(self.color(), alpha);
fn String ColorHSV.to_hex_str(self, bool alpha = true) => to_hex_str(self.color(), alpha);
fn String ColorYUV.to_hex_str(self, bool alpha = true) => to_hex_str(self.color(), alpha);
fn String ColorXYZ.to_hex_str(self, bool alpha = true) => to_hex_str(self.color(), alpha);
fn String ColorLAB.to_hex_str(self, bool alpha = true) => to_hex_str(self.color(), alpha);
fn String ColorLABPolar.to_hex_str(self, bool alpha = true) => to_hex_str(self.color(), alpha);
fn String ColorLUV.to_hex_str(self, bool alpha = true) => to_hex_str(self.color(), alpha);
fn String ColorLUVPolar.to_hex_str(self, bool alpha = true) => to_hex_str(self.color(), alpha);
fn String ColorOklab.to_hex_str(self, bool alpha = true) => to_hex_str(self.color(), alpha);
fn String ColorOklabPolar.to_hex_str(self, bool alpha = true) => to_hex_str(self.color(), alpha);

// colors to print str

fn String Color.to_str(self) => string::tformat("%s(%.2g, %.2g, %.2g, %.2g)", Color::name, self.r, self.g, self.b, self.a);
fn String ColorRGB.to_str(self) => string::tformat("%s(%s, %s, %s)", ColorRGB::name, self.r, self.g, self.b);
fn String ColorRGBA.to_str(self) => string::tformat("%s(%s, %s, %s, %s)", ColorRGBA::name, self.r, self.g, self.b, self.a);
fn String ColorCMY.to_str(self) => string::tformat("%s(%.2g, %.2g, %.2g)", ColorCMY::name, self.c, self.m, self.y);
fn String ColorCMYK.to_str(self) => string::tformat("%s(%.2g, %.2g, %.2g, %.2g)", ColorCMYK::name, self.c, self.m, self.y, self.k);
fn String ColorHSL.to_str(self) => string::tformat("%s(%g, %g, %g)", ColorHSL::name, self.h, self.s, self.l);
fn String ColorHSV.to_str(self) => string::tformat("%s(%g, %g, %g)", ColorHSV::name, self.h, self.s, self.v);
fn String ColorYUV.to_str(self) => string::tformat("%s(%g, %g, %g)", ColorYUV::name, self.y, self.u, self.v);
fn String ColorXYZ.to_str(self) => string::tformat("%s(%g, %g, %g)", ColorXYZ::name, self.x, self.y, self.z);
fn String ColorLAB.to_str(self) => string::tformat("%s(%g, %g, %g)", ColorLAB::name, self.l, self.a, self.b);
fn String ColorLABPolar.to_str(self) => string::tformat("%s(%g, %g, %g)", ColorLABPolar::name, self.l, self.c, self.h);
fn String ColorLUV.to_str(self) => string::tformat("%s(%g, %g, %g)", ColorLUV::name, self.l, self.u, self.v);
fn String ColorLUVPolar.to_str(self) => string::tformat("%s(%g, %g, %g)", ColorLUVPolar::name, self.h, self.c, self.l);
fn String ColorOklab.to_str(self) => string::tformat("%s(%g, %g, %g)", ColorOklab::name, self.l, self.a, self.b);
fn String ColorOklabPolar.to_str(self) => string::tformat("%s(%g, %g, %g)", ColorOklabPolar::name, self.l, self.c, self.h);

// conversion to numeric value

fn uint Color.value(self) => color_value(self);
fn uint ColorRGB.value(self) => self.color().value();
fn uint ColorRGBA.value(self) => self.color().value();
fn uint ColorCMY.value(self) => self.color().value();
fn uint ColorCMYK.value(self) => self.color().value();
fn uint ColorHSL.value(self) => self.color().value();
fn uint ColorHSV.value(self) => self.color().value();
fn uint ColorYUV.value(self) => self.color().value();
fn uint ColorXYZ.value(self) => self.color().value();
fn uint ColorLAB.value(self) => self.color().value();
fn uint ColorLABPolar.value(self) => self.color().value();
fn uint ColorLUV.value(self) => self.color().value();
fn uint ColorLUVPolar.value(self) => self.color().value();
fn uint ColorOklab.value(self) => self.color().value();
fn uint ColorOklabPolar.value(self) => self.color().value();

// shorthand methods to convert from Color to another color space

fn ColorRGB Color.rgb(self) => self.to(ColorRGB);
fn ColorRGBA Color.rgba(self) => self.to(ColorRGBA);
fn ColorCMY Color.cmy(self) => self.to(ColorCMY);
fn ColorCMYK Color.cmyk(self) => self.to(ColorCMYK);
fn ColorHSL Color.hsl(self) => self.to(ColorHSL);
fn ColorHSV Color.hsv(self) => self.to(ColorHSV);
fn ColorYUV Color.yuv(self) => self.to(ColorYUV);
fn ColorXYZ Color.xyz(self) => self.to(ColorXYZ);
fn ColorLAB Color.lab(self) => self.to(ColorLAB);
fn ColorLABPolar Color.lab_polar(self) => self.to(ColorLABPolar);
fn ColorLUV Color.luv(self) => self.to(ColorLUV);
fn ColorLUVPolar Color.luv_polar(self) => self.to(ColorLUVPolar);
fn ColorOklab Color.oklab(self) => self.to(ColorOklab);
fn ColorOklabPolar Color.oklab_polar(self) => self.to(ColorOklabPolar);

// operator overloads

fn Color Color.mult(Color c, float v) @operator(*) => (Color){ c.r * v, c.g * v, c.b * v, c.a * v };
fn Color Color.div(Color c, float v) @operator(/) => (Color){ c.r / v, c.g / v, c.b / v, c.a / v };
fn Color Color.add(Color c, float v) @operator(+) => (Color){ c.r + v, c.g + v, c.b + v, c.a + v };
fn Color Color.sub(Color c, float v) @operator(-) => (Color){ c.r - v, c.g - v, c.b - v, c.a - v };

// equality checks

fn bool Color.eq(Color c1, Color c2) @operator(==) => c1.r == c2.r && c1.g == c2.g && c1.b == c2.b && c1.a == c2.a;
fn bool ColorRGB.eq(self, ColorRGB other) @operator_s(==) => eq(self, other);
fn bool ColorRGBA.eq(self, ColorRGBA other) @operator_s(==) => eq(self, other);
fn bool ColorCMY.eq(self, ColorCMY other) @operator_s(==) => eq(self, other);
fn bool ColorCMYK.eq(self, ColorCMYK other) @operator_s(==) => eq(self, other);
fn bool ColorHSL.eq(self, ColorHSL other) @operator_s(==) => eq(self, other);
fn bool ColorHSV.eq(self, ColorHSV other) @operator_s(==) => eq(self, other);
fn bool ColorYUV.eq(self, ColorYUV other) @operator_s(==) => eq(self, other);
fn bool ColorXYZ.eq(self, ColorXYZ other) @operator_s(==) => eq(self, other);
fn bool ColorLAB.eq(self, ColorLAB other) @operator_s(==) => eq(self, other);
fn bool ColorLABPolar.eq(self, ColorLABPolar other) @operator_s(==) => eq(self, other);
fn bool ColorLUV.eq(self, ColorLUV other) @operator_s(==) => eq(self, other);
fn bool ColorLUVPolar.eq(self, ColorLUVPolar other) @operator_s(==) => eq(self, other);
fn bool ColorOklab.eq(self, ColorOklab other) @operator_s(==) => eq(self, other);
fn bool ColorOklabPolar.eq(self, ColorOklabPolar other) @operator_s(==) => eq(self, other);

macro bool Color.almost_eq(self, other_color, float ep = 0.01f) => almost_eq(self, other_color, ep);

// shorthand manipulation methods for Color

macro Color Color.lerp(self, other_color, float amount) => lerp(self, other_color, amount);
macro Color Color.mix(self, other_color) => mix(self, other_color);
macro Color Color.clip(self) => clip(&self);
macro float Color.distance(self, other_color) => delta_e00(self.lab(), other_color.lab());

macro Color Color.saturate(self, float amount) => saturate(self, amount);
macro Color Color.desaturate(self, float amount) => desaturate(self, amount);
macro Color Color.lighten(self, float amount) => lighten(self, amount);
macro Color Color.darken(self, float amount) => darken(self, amount);
macro float Color.get_luminosity(self) => get_luminosity(self);
macro Color Color.set_luminosity(self, float amount) => set_luminosity(self, amount);
macro float Color.get_saturation(self) => get_saturation(self);
macro Color Color.set_saturation(self, float amount) => set_saturation(self, amount);

macro Color Color.blend_normal(self, src) => blend_normal(self, src);
macro Color Color.blend_darken(self, src) => blend_darken(self, src);
macro Color Color.blend_multiply(self, src) => blend_multiply(self, src);
macro Color Color.blend_linear_burn(self, src) => blend_linear_burn(self, src);
macro Color Color.blend_color_burn(self, src) => blend_color_burn(self, src);
macro Color Color.blend_lighten(self, src) => blend_lighten(self, src);
macro Color Color.blend_screen(self, src) => blend_screen(self, src);
macro Color Color.blend_linear_dodge(self, src) => blend_linear_dodge(self, src);
macro Color Color.blend_color_dodge(self, src) => blend_color_dodge(self, src);
macro Color Color.blend_overlay(self, src) => blend_overlay(self, src);
macro Color Color.blend_hard_light(self, src) => blend_hard_light(self, src);
macro Color Color.blend_soft_light(self, src) => blend_soft_light(self, src);
macro Color Color.blend_difference(self, src) => blend_difference(self, src);
macro Color Color.blend_exclusion(self, src) => blend_exclusion(self, src);
macro Color Color.blend_color(self, src) => blend_color(self, src);
macro Color Color.blend_luminosity(self, src) => blend_luminosity(self, src);
macro Color Color.blend_hue(self, src) => blend_hue(self, src);
macro Color Color.blend_saturation(self, src) => blend_saturation(self, src);

macro to(from, $Type)
{
	Color color = from.color();

	$switch ($Type):
		$case Color:
			return to_color(from);
		$case ColorRGB:
			return color_to_rgb(color);
		$case ColorRGBA:
			return color_to_rgba(color);
		$case ColorCMY:
			return color_to_cmy(color);
		$case ColorCMYK:
			return color_to_cmyk(color);
		$case ColorHSL:
			return color_to_hsl(color);
		$case ColorHSV:
			return color_to_hsv(color);
		$case ColorYUV:
			return color_to_yuv(color);
		$case ColorXYZ:
			return color_to_xyz(color);
		$case ColorLAB:
			return color_to_lab(color);
		$case ColorLABPolar:
			return color_to_lab_polar(color);
		$case ColorLUV:
			return color_to_luv(color);
		$case ColorLUVPolar:
			return color_to_luv_polar(color);
		$case ColorOklab:
			return color_to_oklab(color);
		$case ColorOklabPolar:
			return color_to_oklab_polar(color);
		$case String:
			return from.to_str();
	$endswitch
}

macro Color to_color(from)
{
	$switch ($Typeof(from)):
		$case ColorRGB:
			return rgb_to_color(from);
		$case ColorRGBA:
			return rgba_to_color(from);
		$case ColorCMY:
			return cmy_to_color(from);
		$case ColorCMYK:
			return cmyk_to_color(from);
		$case ColorHSL:
			return hsl_to_color(from);
		$case ColorHSV:
			return hsv_to_color(from);
		$case ColorYUV:
			return yuv_to_color(from);
		$case ColorXYZ:
			return xyz_to_color(from);
		$case ColorLAB:
			return lab_to_color(from);
		$case ColorLABPolar:
			return lab_polar_to_color(from);
		$case ColorLUV:
			return luv_to_color(from);
		$case ColorLUVPolar:
			return luv_polar_to_color(from);
		$case ColorOklab:
			return oklab_to_color(from);
		$case ColorOklabPolar:
			return oklab_polar_to_color(from);
	$endswitch
}

fn uint color_value(Color c)
{
	ColorRGBA rgba = c.rgba();

	return (rgba.r << 24 | rgba.g << 16 | rgba.b << 8 | rgba.a);
}

fn ColorRGB color_to_rgb(Color c) @private
{
	return { (char)(c.r * 255), (char)(c.g * 255), (char)(c.b * 255) };
}

fn Color rgb_to_color(ColorRGB c) @private
{
	return { c.r / 255f, c.g / 255f, c.b / 255f, 1 };
}

fn ColorRGBA color_to_rgba(Color c) @private
{
	return { (char)(c.r * 255), (char)(c.g * 255), (char)(c.b * 255), (char)(c.a * 255) };
}

fn Color rgba_to_color(ColorRGBA c) @private
{
	return { c.r / 255f, c.g / 255f, c.b / 255f, c.a / 255f };
}

fn ColorCMY color_to_cmy(Color c) @private
{
	return { (1 - c.r) * 100f, (1 - c.g) * 100f, (1 - c.b) * 100f };
}

fn Color cmy_to_color(ColorCMY c) @private
{
	return { 1 - c.c / 100f, 1 - c.m / 100f, 1 - c.y / 100f, 1 };
}

fn ColorCMYK color_to_cmyk(Color c) @private
{
	float k = 1 - max3(c.r, c.g, c.b);
	if (k == 1)
	{
		return { 0, 0, 0, 100.0f };
	}

	var t = fn float(float v, float k) @inline => (1 - v - k) / (1 - k) * 100.0f;

	return { t(c.r, k), t(c.g, k), t(c.b, k), k = k * 100.0f };
}

fn Color cmyk_to_color(ColorCMYK c) @private
{
	float k = c.k / 100f;
	float cy = c.c / 100f;
	float m = c.m / 100f;
	float y = c.y / 100f;
	float r = 1 - math::min(1f, cy * (1 - k) + k);
	float g = 1 - math::min(1f, m * (1 - k) + k);
	float b = 1 - math::min(1f, y * (1 - k) + k);

	return { r, g, b, 1 };
}

fn ColorHSL color_to_hsl(Color c) @private
{
	float min = min3(c.r, c.g, c.b);
	float max = max3(c.r, c.g, c.b);
	float delta = max - min;

	float h;
	if (max == min)
	{
		h = 0;
	}
	else if (c.r == max)
	{
		h = (c.g - c.b) / delta;
	}
	else if (c.g == max)
	{
		h = 2 + (c.b - c.r) / delta;
	}
	else if (c.b == max)
	{
		h = 4 + (c.r - c.g) / delta;
	}

	h = math::min(h * 60.0f, 360.0f);
	if (h < 0) h += 360;

	float l = (min + max) / 2.0f;

	float s;
	if (max == min)
	{
		s = 0;
	}
	else if (l <= 0.5)
	{
		s = delta / (max + min);
	}
	else
	{
		s = delta / (2.0f - max - min);
	}

	return { h, s * 100f, l * 100f };
}

fn Color hsl_to_color(ColorHSL c) @private
{
	c.h /= 360;
	c.s /= 100;
	c.l /= 100;

	float r = c.l;
	float g = c.l;
	float b = c.l;

	if (c.s != 0)
	{
		float q = c.l < 0.5f ? c.l * (1f + c.s) : c.l + c.s - c.l * c.s;
		float p = 2f * c.l - q;
		float o = 1f / 3f;

		var hue_to_rgb = fn float(float p, float q, float t) @inline
		{
			if (t < 0f) t += 1f;
			if (t > 1f) t -= 1f;
			if (t < 1f / 6f) return p + (q - p) * 6f * t;
			if (t < 1f / 2f) return q;
			if (t < 2f / 3f) return p + (q - p) * (2f / 3f - t) * 6f;
			return p;
		};

		r = hue_to_rgb(p, q, c.h + o);
		g = hue_to_rgb(p, q, c.h);
		b = hue_to_rgb(p, q, c.h - o);
	}

	return { r, g, b, 1 };
}

fn ColorHSV color_to_hsv(Color c) @private
{

	float min = min3(c.r, c.g, c.b);
	float max = max3(c.r, c.g, c.b);
	float delta = max - min;

	float h;
	if (max == min)
	{
		h = 0;
	}
	else if (c.r == max)
	{
		h = (c.g - c.b) / delta;
	}
	else if (c.g == max)
	{
		h = 2 + (c.b - c.r) / delta;
	}
	else if (c.b == max)
	{
		h = 4 + (c.r - c.g) / delta;
	}

	h = math::min(h * 60.0f, 360.0f);
	if (h < 0) h += 360f;

	float s;
	if (max == min)
	{
		s = 0;
	}
	else
	{
		s = delta / max * 100.0f;
	}

	float v = max * 100.0f;

	return { h, s, v };
}

fn Color hsv_to_color(ColorHSV c) @private
{
	float h = c.h / 60.0f;
	float s = c.s / 100.0f;
	float v = c.v / 100.0f;
	float f = h - math::floor(h);
	float p = v * (1 - s);
	float q = v * (1 - (s * f));
	float t = v * (1 - (s * (1 - f)));

	switch (math::floor(h) % 6)
	{
		case 0:
			return (Color){ v, t, p, 1 };
		case 0:
			return (Color){ v, t, p, 1 };
		case 1:
			return (Color){ q, v, p, 1 };
		case 2:
			return (Color){ p, v, t, 1 };
		case 3:
			return (Color){ p, q, v, 1 };
		case 4:
			return (Color){ t, p, v, 1 };
		case 5:
			return (Color){ v, p, q, 1 };
		default:
			return (Color){};
	}
}

fn ColorYUV color_to_yuv(Color c) @private
{
	float y = (c.r * +0.29900f) + (c.g * +0.58700f) + (c.b * +0.11400f);
	float u = (c.r * -0.14713f) + (c.g * -0.28886f) + (c.b * +0.43600f);
	float v = (c.r * +0.61500f) + (c.g * -0.51499f) + (c.b * -0.10001f);

	return { y, u, v };
}

fn Color yuv_to_color(ColorYUV c) @private
{
	float r = math::clamp(c.y + (c.u * +0.00000f) + (c.v * +1.13983f), 0, 1);
	float g = math::clamp(c.y + (c.u * -0.39465f) + (c.v * -0.58060f), 0, 1);
	float b = math::clamp(c.y + (c.u * +2.02311f) + (c.v * +0000000f), 0, 1);

	return { r, g, b, 1 };
}

fn float[2] xyz_uv(ColorXYZ c) @private
{
	float t = c.x + c.y + c.z;
	float x = t == 0 ? 0 : c.x / t;
	float y = t == 0 ? 0 : c.y / t;
	float u = 2.0 * x / ((6.0 * y) + 1.5 - x);
	float v = 4.5 * y / ((6.0 * y) + 1.5 - x);

	return { u, v };
}

fn ColorXYZ color_to_xyz(Color c) @private
{
	var ftrans = fn float(float u, float gamma) @inline => u > 0.03928 ? math::pow((u + 0.055f) / 1.055f, gamma) : u / 12.92f;

	float r = ftrans(c.r, 2.4);
	float g = ftrans(c.g, 2.4);
	float b = ftrans(c.b, 2.4);
	float x = XYZ_WHITE_Y * ((r * 0.412453) + (g * 0.357580) + (b * 0.180423));
	float y = XYZ_WHITE_Y * ((r * 0.212671) + (g * 0.715160) + (b * 0.072169));
	float z = XYZ_WHITE_Y * ((r * 0.019334) + (g * 0.119193) + (b * 0.950227));

	return { x, y, z };
}

fn ColorXYZ lab_to_xyz(ColorLAB c) @private
{
	float x;
	float y;
	float z;

	if (c.l <= 0)
	{
		y = 0;
	}
	else if (c.l <= 8)
	{
		y = c.l * XYZ_WHITE_Y / XYZ_KAPPA;
	}
	else if (c.l <= 100)
	{
		y = XYZ_WHITE_Y * math::pow((c.l + 16.0f) / 116.0f, 3);
	} else
	{
		y = XYZ_WHITE_Y;
	}

	float fy;
	if (y <= XYZ_EPSILON * XYZ_WHITE_Y)
	{
		fy = (XYZ_KAPPA / 116.0f) * y / XYZ_WHITE_Y + 16.0f / 116.0f;
	}
	else
	{
		fy = cbrt(y / XYZ_WHITE_Y);
	}

	float fx = fy + (c.a / 500.0f);
	if (math::pow(fx, 3) <= XYZ_EPSILON)
	{
		x = XYZ_WHITE_X * (fx - 16.0f / 116.0f) / (XYZ_KAPPA / 116.0f);
	}
	else
	{
		x = XYZ_WHITE_X * math::pow(fx, 3);
	}

	float fz = fy - (c.b / 200.0f);
	if (math::pow(fz, 3) <= XYZ_EPSILON)
	{
		z = XYZ_WHITE_Z * (fz - 16.0f / 116.0f) / (XYZ_KAPPA / 116.0f);
	}
	else
	{
		z = XYZ_WHITE_Z * math::pow(fz, 3);
	}

	return { x, y, z };
}

fn ColorXYZ luv_to_xyz(ColorLUV c) @private
{
	if (c.l <= 0 && c.u == 0 && c.v == 0)
	{
		return {};
	}

	float[2] uv = xyz_uv(XYZ_WHITE);
	float u = c.l == 0 ? uv[0] : c.u / (13.0f * c.l) + uv[0];
	float v = c.l == 0 ? uv[1] : c.v / (13.0f * c.l) + uv[1];
	float y = c.l > 8
	? XYZ_WHITE_Y * math::pow((c.l + 16.0f) / 116.0f, 3.0f)
	: XYZ_WHITE_Y * c.l / XYZ_KAPPA;
	float x = 9.0f * y * u / (4.0f * v);
	float z = -x / 3.0f - y * 5.0f + (y / v) * 3.0f;

	return { x, y, z };
}

fn Color xyz_to_color(ColorXYZ c) @private
{
	var gtrans = fn float(float u) @inline => u > 0.00304 ? 1.055f * math::pow(u, (1.0f / XYZ_GAMMA)) - 0.055f : 12.92f * u;

	float r = gtrans(((c.x * 3.240479) - (c.y * 1.53715) - (c.z * 0.498535)) / XYZ_WHITE_Y);
	float g = gtrans((-(c.x * 0.969256) + (c.y * 1.875992) + (c.z * 0.041556)) / XYZ_WHITE_Y);
	float b = gtrans(((c.x * 0.055648) - (c.y * 0.204043) + (c.z * 1.057311)) / XYZ_WHITE_Y);
	// float fixup_color;

	return { r, g, b, 1 };
}

struct Polar @private
{
	float l, c, h;
}

macro polar(l, a, b) @private
{
	Polar p = {};
	p.l = l;
	p.c = math::sqrt(a * a + b * b);
	p.h = math::rad_to_deg(math::atan2(b, a));
	while (p.h > 360.0) p.h = p.h - 360;
	while (p.h < 0.0) p.h = p.h + 360;

	return p;
}

fn ColorLAB color_to_lab(Color c) @private
{
	var f = fn float(float t) @inline => t > XYZ_EPSILON ? cbrt(t) : (XYZ_KAPPA / 116.0f) * t + 16.0f / 116.0f;

	ColorXYZ xyz = c.xyz();
	float xr = xyz.x / XYZ_WHITE_X;
	float yr = xyz.y / XYZ_WHITE_Y;
	float zr = xyz.z / XYZ_WHITE_Z;
	float xt = f(xr);
	float yt = f(yr);
	float zt = f(zr);
	float l = yr > XYZ_EPSILON ? 116.0f * cbrt(yr) - 16.0f : yr * XYZ_KAPPA;
	float a = 500.0f * (xt - yt);
	float b = 200.0f * (yt - zt);

	return { l, a, b };
}

fn ColorLAB lab_polar_to_lab(ColorLABPolar c) @private
{
	float r = math::deg_to_rad(c.h);
	float a = c.c * math::cos(r);
	float b = c.c * math::sin(r);

	return { c.l, a, b };
}

fn Color lab_to_color(ColorLAB c) @private
{
	return lab_to_xyz(c).color();
}

fn ColorLABPolar color_to_lab_polar(Color c) @private
{
	ColorLAB c2 = c.lab();
	Polar p = polar(c2.l, c2.a, c2.b);

	return { p.l, p.c, p.h };
}

fn Color lab_polar_to_color(ColorLABPolar c) @private
{
	return lab_polar_to_lab(c).color();
}

fn ColorLUV color_to_luv(Color c) @private
{
	ColorXYZ xyz = c.xyz();
	float[2] uv1 = xyz_uv(xyz);
	float[2] uv2 = xyz_uv(XYZ_WHITE);
	float y = xyz.y / XYZ_WHITE_Y;

	float l = y > XYZ_EPSILON
	? 116.0f * cbrt(y) - 16.0f
	: XYZ_KAPPA * y;
	float u = 13.0f * l * (uv1[0] - uv2[0]);
	float v = 13.0f * l * (uv1[1] - uv2[1]);

	return { l, u, v };
}

fn ColorLUVPolar color_to_luv_polar(Color c) @private
{
	ColorLUV c2 = c.luv();
	Polar p = polar(c2.l, c2.u, c2.v);

	return { p.h, p.c, p.l };
}

fn ColorLUV luv_polar_to_luv(ColorLUVPolar c) @private
{
	float r = math::deg_to_rad(c.h);
	float u = c.c * math::cos(r);
	float v = c.c * math::sin(r);

	return { c.l, u, v };
}

fn Color luv_to_color(ColorLUV c) @private
{
	return luv_to_xyz(c).color();
}

fn Color luv_polar_to_color(ColorLUVPolar c) @private
{
	return luv_polar_to_luv(c).color();
}

fn ColorOklab color_to_oklab(Color c) @private
{
	float l_ = cbrt((0.4121656120f * c.r + 0.5362752080f * c.g + 0.0514575653f * c.b));
	float m = cbrt((0.2118591070f * c.r + 0.6807189584f * c.g + 0.1074065790f * c.b));
	float s = cbrt((0.0883097947f * c.r + 0.2818474174f * c.g + 0.6302613616f * c.b));
	float l = l_ * 0.2104542553f + m * +0.7936177850f + s * -0.0040720468f;
	float a = l_ * 1.9779984951f + m * -2.4285922050f + s * +0.4505937099f;
	float b = l_ * 0.0259040371f + m * +0.7827717662f + s * -0.8086757660f;

	return { l, a, b };
}

fn ColorOklab oklab_polar_to_oklab(ColorOklabPolar c) @private
{
	float hrad = math::deg_to_rad(c.h);
	float a = c.c * math::cos(hrad);
	float b = c.c * math::sin(hrad);

	return { c.l, a, b };
}

fn Color oklab_to_color(ColorOklab c) @private
{
	float l = math::pow(c.l + 0.3963377774f * c.a + 0.2158037573f * c.b, 3);
	float m = math::pow(c.l - 0.1055613458f * c.a - 0.0638541728f * c.b, 3);
	float s = math::pow(c.l - 0.0894841775f * c.a - 1.2914855480f * c.b, 3);
	float r = +4.0767245293f * l - 3.3072168827f * m + 0.2307590544f * s;
	float g = -1.2681437731f * l + 2.6093323231f * m - 0.3411344290f * s;
	float b = -0.0041119885f * l - 0.7034763098f * m + 1.7068625689f * s;

	return { r, g, b, 1 };
}

fn ColorOklabPolar color_to_oklab_polar(Color c) @private
{
	ColorOklab c2 = c.oklab();
	Polar p = polar(c2.l, c2.a, c2.b);

	return { p.l, p.c, p.h };
}

fn Color oklab_polar_to_color(ColorOklabPolar c) @private
{
	return oklab_polar_to_oklab(c).color();
}

macro bool eq(color1, color2)
{
	return color1.color() == color2.color();
}

macro bool almost_eq(color1, color2, float ep)
{
	Color c1 = color1.color();
	Color c2 = color2.color();

	return math::abs(c1.r - c2.r) < ep && math::abs(c1.g - c2.g) < ep && math::abs(c1.b - c2.b) < ep;
}

macro Color lerp(color1, color2, float amount)
{
	Color a = color1.color();
	Color b = color2.color();
	float t = math::clamp(amount, 0, 1);

	return { a.r + (b.r - a.r) * t, a.g + (b.g - a.g) * t, a.b + (b.b - a.b) * t, a.a + (b.a - a.a) * t };
}

macro Color mix(color1, color2)
{
	return lerp(color1, color2, 0.5);
}

fn void clip(Color* c)
{
	float l = get_luminosity(*c);
	float n = min3(c.r, c.g, c.b);
	float x = max3(c.r, c.g, c.b);

	Color c2;
	if (n < 0) c2 = (((*c - l) * l) / (l - n)) + l;
	if (x > 1) c2 = (((*c - l) * (1 - l)) / (x - l)) + l;

	c.r = c2.r;
	c.g = c2.g;
	c.b = c2.b;
	c.a = c2.a;
}

macro Color alpha_fix(backdrop, source, Color mixed) @private
{
	Color bd = backdrop.color();
	Color src = source.color();
	float alpha = (src.a + bd.a * (1.0f - src.a));

	if (alpha == 0) return {};

	float t0 = src.a * (1 - bd.a);
	float t1 = src.a * bd.a;
	float t2 = (1 - src.a) * bd.a;
	float r = (t0 * src.r + t1 * mixed.r + t2 * bd.r) / alpha;
	float g = (t0 * src.g + t1 * mixed.g + t2 * bd.g) / alpha;
	float b = (t0 * src.b + t1 * mixed.b + t2 * bd.b) / alpha;

	return { r, g, b, alpha };
}

macro Color lighten(c, float amount)
{
	ColorHSL hsl = c.color().hsl();
	hsl.l = math::clamp(hsl.l + amount * 100, 0f, 100f);

	return hsl.color();
}

macro Color darken(c, float amount) => lighten(c, -amount);

macro Color saturate(c, float amount)
{
	ColorHSL hsl = c.color().hsl();
	hsl.s = math::clamp(hsl.s + amount * 100, 0f, 100);

	return hsl.color();
}

macro Color desaturate(c, float amount) => saturate(c, -amount);

macro Color spin(c, float degrees)
{
	ColorHSL hsl = c.hsl();
	hsl.h = hsl.h + degrees;
	while (hsl.h < 0) hsl.h += 360;
	while (hsl.h >= 360) hsl.h -= 360;

	return hsl.color();
}

fn float screen(float bd, float src)
{
	return 1 - (1 - bd) * (1 - src);
}

fn float hard_light(float bd, float src)
{
	return src <= 0.5 ? bd * 2 * src : screen(bd, 2 * src - 1);
}

fn float soft_light(float bd, float src)
{
	return (1 - 2 * src) * math::sqr(bd) + 2 * src * bd;
}

macro float get_luminosity(color)
{
	Color c = color.color();
	return c.r * 0.3f + c.g * 0.59f + c.b * 0.11f;
}

macro Color set_luminosity(color, float amount)
{
	Color c = color.color();
	float d = amount - get_luminosity(c);
	Color result = color(c.r + d, c.g + d, c.b + d);
	clip(&result);

	return result;
}

macro float get_saturation(color)
{
	Color c = color.color();
	return max3(c.r, c.g, c.b) - min3(c.r, c.g, c.b);
}

macro Color set_saturation(color, float amount)
{
	Color c = color.color();
	float sat_c = get_saturation(c);

	if (sat_c > 0) return (c - min3(c.r, c.g, c.b)) * amount / sat_c;

	return c;
}

macro Color blend_normal(backdrop, source)
{
	return alpha_fix(bd, src, src);
}

macro Color blend_darken(backdrop, source)
{
	Color bd = backdrop.color();
	Color src = source.color();
	float r = math::min(bd.r, src.r);
	float g = math::min(bd.g, src.g);
	float b = math::min(bd.b, src.b);

	return alpha_fix(bd, src, { r, g, b, 0 });
}

macro Color blend_multiply(backdrop, source)
{
	Color bd = backdrop.color();
	Color src = source.color();
	float r = bd.r * src.r;
	float g = bd.g * src.g;
	float b = bd.b * src.b;

	return alpha_fix(bd, src, { r, g, b, 0 });
}

macro Color blend_linear_burn(backdrop, source)
{
	Color bd = backdrop.color();
	Color src = source.color();
	float r = bd.r + src.r - 1;
	float g = bd.g + src.g - 1;
	float b = bd.b + src.b - 1;

	return alpha_fix(bd, src, { r, g, b, 0 });
}

macro Color blend_color_burn(backdrop, source)
{
	var burn = fn float(float c_bd, float c_src) @inline => c_bd == 1 ? 1 : c_src == 0 ? 0 : 1.0f - math::min(1.0f, (1.0f - c_bd) / c_src);

	Color bd = backdrop.color();
	Color src = source.color();
	float r = burn(bd.r, src.r);
	float g = burn(bd.g, src.g);
	float b = burn(bd.b, src.b);

	return alpha_fix(bd, src, { r, g, b, 0 });
}

macro Color blend_lighten(backdrop, source)
{
	Color bd = backdrop.color();
	Color src = source.color();
	float r = math::max(bd.r, src.r);
	float g = math::max(bd.g, src.g);
	float b = math::max(bd.b, src.b);

	return alpha_fix(bd, src, { r, g, b, 0 });
}

macro Color blend_screen(backdrop, source)
{
	Color bd = backdrop.color();
	Color src = source.color();
	float r = screen(bd.r, src.r);
	float g = screen(bd.g, src.g);
	float b = screen(bd.b, src.b);

	return alpha_fix(bd, src, { r, g, b, 0 });
}

macro Color blend_linear_dodge(backdrop, source)
{
	Color bd = backdrop.color();
	Color src = source.color();
	float r = bd.r + src.r;
	float g = bd.g + src.g;
	float b = bd.b + src.b;

	return alpha_fix(bd, src, { r, g, b, 0 });
}

macro Color blend_color_dodge(backdrop, source)
{
	var dodge = fn float(float c_bd, float c_src) @inline => c_bd == 0 ? 0 : c_src == 1 ? 1 : 1.0f - math::min(1.0f, c_bd / (1 - c_src));

	Color bd = backdrop.color();
	Color src = source.color();
	float r = dodge(bd.r, src.r);
	float g = dodge(bd.g, src.g);
	float b = dodge(bd.b, src.b);

	return alpha_fix(bd, src, { r, g, b, 0 });
}

macro Color blend_overlay(backdrop, source)
{
	Color bd = backdrop.color();
	Color src = source.color();
	float r = hard_light(src.r, bd.r);
	float g = hard_light(src.g, bd.g);
	float b = hard_light(src.b, bd.b);

	return alpha_fix(bd, src, { r, g, b, 0 });
}

macro Color blend_hard_light(backdrop, source)
{
	Color bd = backdrop.color();
	Color src = source.color();
	float r = hard_light(bd.r, src.r);
	float g = hard_light(bd.g, src.g);
	float b = hard_light(bd.b, src.b);

	return alpha_fix(bd, src, { r, g, b, 0 });
}

macro Color blend_soft_light(backdrop, source)
{
	Color bd = backdrop.color();
	Color src = source.color();
	float r = soft_light(bd.r, src.r);
	float g = soft_light(bd.g, src.g);
	float b = soft_light(bd.b, src.b);

	return alpha_fix(bd, src, { r, g, b, 0 });
}

macro Color blend_difference(backdrop, source)
{
	Color bd = backdrop.color();
	Color src = source.color();
	float r = math::abs(bd.r - src.r);
	float g = math::abs(bd.g - src.g);
	float b = math::abs(bd.b - src.b);

	return alpha_fix(bd, src, { r, g, b, 0 });
}

macro Color blend_exclusion(backdrop, source)
{
	var blend = fn float(float bd, float src) @inline => bd + src - 2 * bd * src;

	Color bd = backdrop.color();
	Color src = source.color();
	float r = blend(bd.r, src.r);
	float g = blend(bd.g, src.g);
	float b = blend(bd.b, src.b);

	return alpha_fix(bd, src, { r, g, b, 0 });
}

macro Color blend_color(backdrop, source)
{
	Color bd = backdrop.color();
	Color src = source.color();
	Color result = set_luminosity(src, get_luminosity(bd));

	return alpha_fix(bd, src, result);
}

macro Color blend_luminosity(backdrop, source)
{
	Color bd = backdrop.color();
	Color src = source.color();
	Color result = set_luminosity(bd, get_luminosity(src));

	return alpha_fix(bd, src, result);
}

macro Color blend_hue(backdrop, source)
{
	Color bd = backdrop.color();
	Color src = source.color();
	Color result = set_luminosity(set_saturation(src, get_saturation(bd)), get_luminosity(bd));

	return alpha_fix(bd, src, result);
}

macro Color blend_saturation(backdrop, source)
{
	Color bd = backdrop.color();
	Color src = source.color();
	Color result = set_luminosity(set_saturation(bd, get_saturation(src)), get_luminosity(bd));

	return alpha_fix(bd, src, result);
}

fn Color? parse_hex_str(String text)
{
	String s = text[0] == '#' ? text[1..] : text;

	if (s.len != 3 && s.len != 4 && s.len != 6 && s.len != 8) return INVALID_HEX_LENGTH~;

	var hex = fn char?(char c) @inline
	{
		if (c >= '0' && c <= '9') return (char)(c - '0');
		if (c >= 'a' && c <= 'f') return (char)(c - 'a') + 10;
		if (c >= 'A' && c <= 'F') return (char)(c - 'A') + 10;

		return INVALID_HEX_CHARACTER~;
	};

	bool is_short = s.len == 3 || s.len == 4;
	char r0 = hex(s[is_short ? 0 : 0])!;
	char r1 = hex(s[is_short ? 0 : 1])!;
	char g0 = hex(s[is_short ? 1 : 2])!;
	char g1 = hex(s[is_short ? 1 : 3])!;
	char b0 = hex(s[is_short ? 2 : 4])!;
	char b1 = hex(s[is_short ? 2 : 5])!;
	char alpha = 255;

	if (s.len == 8)
	{
		char a0 = hex(s[is_short ? 3 : 6])!;
		char a1 = hex(s[is_short ? 3 : 7])!;
		alpha = a0 * 16 + a1;
	}

	return rgba(r0 * 16 + r1, g0 * 16 + g1, b0 * 16 + b1, alpha).color();
}

fn String to_hex_str(Color color, bool alpha = true)
{
	String fmt = alpha ? "%02X%02X%02X%02X" : "%02X%02X%02X";
	ColorRGBA c = color.rgba();

	return string::tformat(fmt, c.r, c.g, c.b, c.a);
}

fn Color from_temperature(float kelvin)
{
	var slope_up = fn float(float k, float a, float b, float c, float d, float e) @inline => a + b * math::pow(k + e, 3.0f) * math::exp(c * (k + e)) + d * math::ln(k);
	var slope_down = fn float(float k, float a, float b, float c, float d, float e) @inline => a + b * math::pow(k + e, c) + d * math::ln(k);
	var from_linear = fn float(float v) @inline => v > 0.0031308f ? 1.055f * math::pow(v, 1.0f / 2.4f) - 0.055f : v * 12.92f;

	float t = kelvin / 10000.0f;
	float r = 0;
	float g = 0;
	float b = 0;

	// red
	if (kelvin <= 6600)
	{
		r = 1;
	}
	else
	{
		r = from_linear(slope_down(t, 0.32068362618584273f, 0.19668730877673762f, -1.5139012907556737f, -0.013883432789258415f, -0.21298613432655075f));
	}

	// green
	if (kelvin <= 6600)
	{
		g = from_linear(slope_up(t, 1.226916242502167f, -1.3109482654223614f, -5.089297600846147f, 0.6453936305542096f, -0.44267061967913873f));
	}
	else
	{
		g = from_linear(slope_down(t, 0.4860175851734596f, 0.1802139719519286f, -1.397716496795082f, -0.00803698899233844f, -0.14573069517701578f));
	}

	// blue
	if (kelvin >= 6600)
	{
		b = 1;
	}
	else if (kelvin <= 1900)
	{
		b = 0;
	}
	else
	{
		b = from_linear(slope_up(t, 1.677499032830161, -0.02313594016938082, -4.221279555918655, 1.6550275798913296, -1.1367244820333684));
	}

	return { r, g, b, 1 };
}

fn float delta_e00(ColorLAB c1, ColorLAB c2, float kL = 1f, float kC = 1f, float kH = 1f) @private
{
	var diff_atan = fn float(float x, float y) @inline => x == 0 && y == 0 ? 0 : x >= 0 ? math::rad_to_deg(math::atan2(x, y)) : math::rad_to_deg(math::atan2(x, y)) + 360;

	float twentyfive_to_seventh = 6103515625;  // 25^7
	float cm = 0.5f * (math::sqrt(math::pow(c1.a, 2) + math::pow(c1.b, 2f)) + math::sqrt(math::pow(c2.a, 2f) + math::pow(c2.b, 2f)));
	float cm7 = math::pow(cm, 7f);
	float g = 0.5f * (1f - math::sqrt(cm7 / (cm7 + twentyfive_to_seventh)));
	float aa1 = (1f + g) * c1.a;  // aa1 is c1.a prime
	float aa2 = (1f + g) * c2.a;
	float cc1 = math::sqrt(math::pow(aa1, 2f) + math::pow(c1.b, 2f));
	float cc2 = math::sqrt(math::pow(aa2, 2f) + math::pow(c2.b, 2f));
	float h1 = diff_atan(c1.b, aa1);
	float h2 = diff_atan(c2.b, aa2);
	float lm = 0.5f * (c1.l + c2.l);
	float ccm = 0.5f * (cc1 + cc2);

	float delta_h = h2 - h1 + 360f;
	if (cc1 == 0 || cc2 == 0)
	{
		delta_h = 0;
	}
	else if (math::abs(h2 - h1) <= 180f)
	{
		delta_h = h2 - h1;
	}
	else if (h2 - h1 > 180f)
	{
		delta_h = h2 - h1 - 360f;
	}

	float hm = 0.5f * (h1 + h2 - 360f);
	if (cc1 == 0 || cc2 == 0)
	{
		hm = h1 + h2;
	}
	else if (math::abs(h2 - h1) <= 180f)
	{
		hm = 0.5f * (h1 + h2);
	}
	else if (h2 - h1 > 180f)
	{
		hm = 0.5f * (h1 + h2 + 360f);
	}

	float deltaL = c2.l - c1.l;
	float delta_cc = cc2 - cc1;
	float delta_hh = 2 * math::sqrt(cc1 * cc2) * math::sin(math::deg_to_rad(0.5f * delta_h));
	float delta_theta = 30f * math::exp(-1 * math::pow((hm - 275f) / 25f, 2f));
	float t = 1f - 0.17f * math::cos(math::deg_to_rad(hm - 30f)) + 0.24f * math::cos(math::deg_to_rad(2f * hm)) + 0.32f * math::cos(math::deg_to_rad(3 * hm + 6f)) - 0.20f * math::cos(math::deg_to_rad(4f * hm - 63f));
	float rc = 2f * math::sqrt(math::pow(ccm, 7f) / (math::pow(ccm, 7) + twentyfive_to_seventh));
	float sl = 1f + 0.015f * math::pow((lm - 50f), 2f) / math::sqrt(20f + math::pow((lm - 50f), 2f));
	float sc = 1f + 0.045f * ccm;
	float sh = 1f + 0.015f * ccm * t;
	float rt = -math::sin(math::deg_to_rad(2 * delta_theta)) * rc;

	return math::sqrt(math::pow(deltaL / (kL * sl), 2f) + math::pow(delta_cc / (kC * sc), 2f) + math::pow(delta_hh / (kH * sh), 2f) + rt * (delta_cc / (kC * sc)) * (delta_hh / (kH * sh)));
}

constdef HtmlName : inline String
{
	ALICEBLUE = "F0F8FF",
	ANTIQUEWHITE = "FAEBD7",
	AQUA = "00FFFF",
	AQUAMARINE = "7FFFD4",
	AZURE = "F0FFFF",
	BEIGE = "F5F5DC",
	BISQUE = "FFE4C4",
	BLACK = "000000",
	BLANCHEDALMOND = "FFEBCD",
	BLUE = "0000FF",
	BLUEVIOLET = "8A2BE2",
	BROWN = "A52A2A",
	BURLYWOOD = "DEB887",
	CADETBLUE = "5F9EA0",
	CHARTREUSE = "7FFF00",
	CHOCOLATE = "D2691E",
	CORAL = "FF7F50",
	CORNFLOWERBLUE = "6495ED",
	CORNSILK = "FFF8DC",
	CRIMSON = "DC143C",
	CYAN = "00FFFF",
	DARKBLUE = "00008B",
	DARKCYAN = "008B8B",
	DARKGOLDENROD = "B8860B",
	DARKGRAY = "A9A9A9",
	DARKGREY = "A9A9A9",
	DARKGREEN = "006400",
	DARKKHAKI = "BDB76B",
	DARKMAGENTA = "8B008B",
	DARKOLIVEGREEN = "556B2F",
	DARKORANGE = "FF8C00",
	DARKORCHID = "9932CC",
	DARKRED = "8B0000",
	DARKSALMON = "E9967A",
	DARKSEAGREEN = "8FBC8F",
	DARKSLATEBLUE = "483D8B",
	DARKSLATEGRAY = "2F4F4F",
	DARKSLATEGREY = "2F4F4F",
	DARKTURQUOISE = "00CED1",
	DARKVIOLET = "9400D3",
	DEEPPINK = "FF1493",
	DEEPSKYBLUE = "00BFFF",
	DIMGRAY = "696969",
	DIMGREY = "696969",
	DODGERBLUE = "1E90FF",
	FIREBRICK = "B22222",
	FLORALWHITE = "FFFAF0",
	FORESTGREEN = "228B22",
	FUCHSIA = "FF00FF",
	GAINSBORO = "DCDCDC",
	GHOSTWHITE = "F8F8FF",
	GOLD = "FFD700",
	GOLDENROD = "DAA520",
	GRAY = "808080",
	GREY = "808080",
	GREEN = "008000",
	GREENYELLOW = "ADFF2F",
	HONEYDEW = "F0FFF0",
	HOTPINK = "FF69B4",
	INDIANRED = "CD5C5C",
	INDIGO = "4B0082",
	IVORY = "FFFFF0",
	KHAKI = "F0E68C",
	LAVENDER = "E6E6FA",
	LAVENDERBLUSH = "FFF0F5",
	LAWNGREEN = "7CFC00",
	LEMONCHIFFON = "FFFACD",
	LIGHTBLUE = "ADD8E6",
	LIGHTCORAL = "F08080",
	LIGHTCYAN = "E0FFFF",
	LIGHTGOLDENRODYELLOW = "FAFAD2",
	LIGHTGRAY = "D3D3D3",
	LIGHTGREY = "D3D3D3",
	LIGHTGREEN = "90EE90",
	LIGHTPINK = "FFB6C1",
	LIGHTSALMON = "FFA07A",
	LIGHTSEAGREEN = "20B2AA",
	LIGHTSKYBLUE = "87CEFA",
	LIGHTSLATEGRAY = "778899",
	LIGHTSLATEGREY = "778899",
	LIGHTSTEELBLUE = "B0C4DE",
	LIGHTYELLOW = "FFFFE0",
	LIME = "00FF00",
	LIMEGREEN = "32CD32",
	LINEN = "FAF0E6",
	MAGENTA = "FF00FF",
	MAROON = "800000",
	MEDIUMAQUAMARINE = "66CDAA",
	MEDIUMBLUE = "0000CD",
	MEDIUMORCHID = "BA55D3",
	MEDIUMPURPLE = "9370DB",
	MEDIUMSEAGREEN = "3CB371",
	MEDIUMSLATEBLUE = "7B68EE",
	MEDIUMSPRINGGREEN = "00FA9A",
	MEDIUMTURQUOISE = "48D1CC",
	MEDIUMVIOLETRED = "C71585",
	MIDNIGHTBLUE = "191970",
	MINTCREAM = "F5FFFA",
	MISTYROSE = "FFE4E1",
	MOCCASIN = "FFE4B5",
	NAVAJOWHITE = "FFDEAD",
	NAVY = "000080",
	OLDLACE = "FDF5E6",
	OLIVE = "808000",
	OLIVEDRAB = "6B8E23",
	ORANGE = "FFA500",
	ORANGERED = "FF4500",
	ORCHID = "DA70D6",
	PALEGOLDENROD = "EEE8AA",
	PALEGREEN = "98FB98",
	PALETURQUOISE = "AFEEEE",
	PALEVIOLETRED = "DB7093",
	PAPAYAWHIP = "FFEFD5",
	PEACHPUFF = "FFDAB9",
	PERU = "CD853F",
	PINK = "FFC0CB",
	PLUM = "DDA0DD",
	POWDERBLUE = "B0E0E6",
	PURPLE = "800080",
	REBECCAPURPLE = "663399",
	RED = "FF0000",
	ROSYBROWN = "BC8F8F",
	ROYALBLUE = "4169E1",
	SADDLEBROWN = "8B4513",
	SALMON = "FA8072",
	SANDYBROWN = "F4A460",
	SEAGREEN = "2E8B57",
	SEASHELL = "FFF5EE",
	SIENNA = "A0522D",
	SILVER = "C0C0C0",
	SKYBLUE = "87CEEB",
	SLATEBLUE = "6A5ACD",
	SLATEGRAY = "708090",
	SLATEGREY = "708090",
	SNOW = "FFFAFA",
	SPRINGGREEN = "00FF7F",
	STEELBLUE = "4682B4",
	TAN = "D2B48C",
	TEAL = "008080",
	THISTLE = "D8BFD8",
	TOMATO = "FF6347",
	TURQUOISE = "40E0D0",
	VIOLET = "EE82EE",
	WHEAT = "F5DEB3",
	WHITE = "FFFFFF",
	WHITESMOKE = "F5F5F5",
	YELLOW = "FFFF00",
	YELLOWGREEN = "9ACD32",
}

fn Color HtmlName.color(HtmlName self) => parse_hex_str(self)!!;
fn ColorRGBA HtmlName.rgba(HtmlName self) => self.color().rgba();

fn Color? parse_html_name(String name)
{
	String upper = name.to_upper_tcopy();

	$foreach $i, $x : HtmlName::names:
		if (upper == $x) return parse_hex_str(HtmlName::values[$i]);
	$endforeach

	return HTML_NAME_NOT_FOUND~;
}
