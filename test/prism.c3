module prism::test;

import std::math;

Color[] colors = {
	(Color){ 1, 0, 0, 1 },
	(Color){ 0, 1, 0, 1 },
	(Color){ 0, 0, 1, 1 },
	(Color){ 1, 1, 1, 1 },
	(Color){ 0, 0, 0, 1 },
	(Color){ 0.5, 0.5, 0.5, 1 },
	(Color){ 0.1, 0.2, 0.3, 1 },
	(Color){ 0.6, 0.5, 0.4, 1 },
	(Color){ 0.7, 0.8, 0.9, 1 },
	(Color){ 0.001, 0.001, 0.001, 1 },
	(Color){ 0.999, 0.999, 0.999, 1 },
	(Color){ 0.01, 0, 0, 1 },
	(Color){ 0, 0.01, 0, 1 },
	(Color){ 0, 0, 0.0, 1 },
};

fn bool almost_eq(float x, float y, float ep = 0.001) => math::abs(x - y) < ep;

module prism::test @test;

import std::io;

fn void rgb_color_space()
{
	foreach (Color c : colors) assert(c.rgb().color().almost_eq(c));
}

fn void rgba_color_space()
{
	foreach (Color c : colors) assert(c.rgba().color().almost_eq(c));
}

fn void cmy_color_space()
{
	foreach (Color c : colors) assert(c.cmy().color().almost_eq(c));
}

fn void cmyk_color_space()
{
	foreach (Color c : colors) assert(c.cmyk().color().almost_eq(c));
}

fn void hsl_color_space()
{
	foreach (Color c : colors) assert(c.hsl().color().almost_eq(c));
}

fn void hsv_color_space()
{
	foreach (Color c : colors) assert(c.hsv().color().almost_eq(c));
}

fn void yuv_color_space()
{
	foreach (Color c : colors) assert(c.yuv().color().almost_eq(c));
}

fn void xyz_color_space()
{
	foreach (Color c : colors) assert(c.xyz().color().almost_eq(c));
}

fn void lab_color_space()
{
	foreach (Color c : colors) assert(c.lab().color().almost_eq(c));
}

fn void lab_polar_color_space()
{
	foreach (Color c : colors) assert(c.lab_polar().color().almost_eq(c));
}

fn void luv_color_space()
{
	foreach (Color c : colors) assert(c.luv().color().almost_eq(c));
}

fn void luv_polar_color_space()
{
	foreach (Color c : colors) assert(c.luv_polar().color().almost_eq(c));
}

fn void oklab_color_space()
{
	foreach (Color c : colors) assert(c.oklab().color().almost_eq(c));
}

fn void oklab_polar_color_space()
{
	foreach (Color c : colors) assert(c.oklab_polar().color().almost_eq(c));
}

fn void from_temperature()
{
	assert(prism::from_temperature(1700).almost_eq((Color){ 1.0, 0.4728460609912872, 0.0, 1.0 }));  // Match flame, low pressure sodium lamps (LPS/SOX)
	assert(prism::from_temperature(1850).almost_eq((Color){ 1.0, 0.5075678825378418, 0.0, 1.0 }));  // Candle flame, sunset/sunrise
	assert(prism::from_temperature(2400).almost_eq((Color){ 1.0, 0.6151175498962402, 0.2489356100559235, 1.0 }));  // Standard incandescent lamps
	assert(prism::from_temperature(2550).almost_eq((Color){ 1.0, 0.640208899974823, 0.2967877089977264, 1.0 }));  // Soft white incandescent lamps
	assert(prism::from_temperature(2700).almost_eq((Color){ 1.0, 0.6637818813323975, 0.3408890664577484, 1.0 }));  // "Soft white" compact fluorescent and LED lamps
	assert(prism::from_temperature(3000).almost_eq((Color){ 1.0, 0.7068109512329102, 0.4213423728942871, 1.0 }));  // Warm white compact fluorescent and LED lamps
	assert(prism::from_temperature(3200).almost_eq((Color){ 1.0, 0.7327497601509094, 0.4705604314804077, 1.0 }));  // Studio lamps, photofloods, etc.
	assert(prism::from_temperature(3350).almost_eq((Color){ 1.0, 0.7509022951126099, 0.5055340528488159, 1.0 }));  // Studio "CP" light
	assert(prism::from_temperature(5000).almost_eq((Color){ 1.0, 0.8959282636642456, 0.8083687424659729, 1.0 }));  // Horizon daylight
	assert(prism::from_temperature(5000).almost_eq((Color){ 1.0, 0.8959282636642456, 0.8083687424659729, 1.0 }));  // Tubular fluorescent lamps or cool white
	assert(prism::from_temperature(5500).almost_eq((Color){ 1.0, 0.9261417388916016, 0.8775315284729004, 1.0 }));  // Vertical daylight, electronic flash
	assert(prism::from_temperature(6200).almost_eq((Color){ 1.0, 0.9618642926216126, 0.9614840745925903, 1.0 }));  // Xenon short-arc lamp [2]
	assert(prism::from_temperature(6500).almost_eq((Color){ 1.0, 0.9753435850143433, 0.9935365319252014, 1.0 }));  // Daylight, overcast
	assert(prism::from_temperature(6500).almost_eq((Color){ 1.0, 0.9753435850143433, 0.9935365319252014, 1.0 }));  // LCD or CRT screen
	assert(prism::from_temperature(15000).almost_eq((Color){ 0.7009154558181763, 0.7981580495834351, 1.0, 1.0 }));  // Clear blue poleward sky
}

fn void parse_hex_str()
{
	Color red = { 1, 0, 0, 1 };
	assert(prism::parse_hex_str("#FF0000FF")!!.almost_eq(red));
	assert(prism::parse_hex_str("#FF0000")!!.almost_eq(red));
	assert(prism::parse_hex_str("FF0000")!!.almost_eq(red));
	assert(prism::parse_hex_str("F00F")!!.almost_eq(red));
	assert(prism::parse_hex_str("F00")!!.almost_eq(red));

	if (catch err = prism::parse_hex_str("FF000")) assert(err == prism::INVALID_HEX_LENGTH);
	if (catch err = prism::parse_hex_str("ZZZ")) assert(err == prism::INVALID_HEX_CHARACTER);
}

fn void to_hex_str()
{
	Color red = { 1, 0, 0, 1 };
	assert(red.to_hex_str() == "FF0000FF");
	assert(red.to_hex_str(alpha: false) == "FF0000");
}

fn void equality()
{
	assert(prism::eq(prism::color(1, 0, 0), prism::rgba(255, 0, 0)));
	assert(prism::eq(prism::color(1, 0, 0), prism::rgb(255, 0, 0)));
}

fn void equality_operator()
{
	assert(prism::color(1, 0, 0) == prism::color(1, 0, 0));
	assert(prism::rgba(255, 0, 0) == prism::rgba(255, 0, 0));
}

fn void distance()
{
	Color c0 = prism::parse_hex_str("000001")!!;
	assert(almost_eq(c0.distance(prism::parse_hex_str("000002")!!), 0.420));
	assert(almost_eq(c0.distance(prism::parse_hex_str("000003")!!), 0.832));
	assert(almost_eq(c0.distance(prism::parse_hex_str("ffffff")!!), 99.981));
}

fn void saturation()
{
	assert(prism::parse_hex_str("6598CC")!!.saturate(0.2).to_hex_str() == "5097E0FF");
	assert(prism::parse_hex_str("75E0EF")!!.desaturate(0.2).to_hex_str() == "84D4DFFF");
}

fn void lightness()
{
	assert(prism::parse_hex_str("6598CC")!!.lighten(0.2).to_hex_str() == "B1CBE5FF");
	assert(prism::parse_hex_str("75E0EF")!!.darken(0.2).to_hex_str() == "1ACAE3FF");
}

fn void mix()
{
	assert(prism::parse_hex_str("FFFFFF")!!.mix(prism::parse_hex_str("000000")!!).to_hex_str() == "7F7F7FFF");
	assert(prism::parse_hex_str("FF0000")!!.mix(prism::parse_hex_str("00FF00")!!).to_hex_str() == "7F7F00FF");
}

fn void lerp()
{
	assert(prism::parse_hex_str("FFFFFF")!!.lerp(prism::parse_hex_str("000000")!!, 0.5).to_hex_str() == "7F7F7FFF");
	assert(prism::parse_hex_str("FF0000")!!.lerp(prism::parse_hex_str("00FF00")!!, 0.5).to_hex_str() == "7F7F00FF");
}

fn void parse_html_name()
{
	assert(prism::parse_html_name("HONEYDEW")!!.almost_eq(prism::parse_hex_str(HtmlName.HONEYDEW)!!));
	assert(prism::parse_html_name("turquoise")!!.almost_eq(prism::parse_hex_str(HtmlName.TURQUOISE)!!));
}

fn void html_name_to_color()
{
	$foreach $c : HtmlName::values:
		$c.color();
	$endforeach

	assert(HtmlName.HONEYDEW.color().almost_eq(prism::parse_hex_str(HtmlName.HONEYDEW)!!));
	assert(HtmlName.TURQUOISE.color().almost_eq(prism::parse_hex_str(HtmlName.TURQUOISE)!!));
}

fn void operator_overloads()
{
	Color c = { 0.5, 0.5, 0.5, 0.5 };
	assert(c * 2 == (Color){ 1, 1, 1, 1 });
	assert(c / 2 == (Color){ 0.25, 0.25, 0.25, 0.25 });
	assert(c + 0.5f == (Color){ 1, 1, 1, 1 });
	assert(c - 0.5f == (Color){ 0, 0, 0, 0 });

	assert(prism::rgba(255, 255, 0, 0).to(Color) == prism::color(1, 1, 0, 0));
}

fn void to_string()
{
	Color c = prism::color(1, 1, 1, 1);

	assert(c.to_str() == "Color(1, 1, 1, 1)");
	assert(c.rgb().to_str() == "ColorRGB(255, 255, 255)");
	assert(c.rgba().to_str() == "ColorRGBA(255, 255, 255, 255)");
	assert(c.cmy().to_str() == "ColorCMY(0, 0, 0)");
	assert(c.cmyk().to_str() == "ColorCMYK(0, 0, 0, 0)");
	assert(c.hsl().to_str() == "ColorHSL(0, 0, 100)");
	assert(c.hsv().to_str() == "ColorHSV(0, 0, 100)");
}

fn void color_value()
{
	assert(prism::color(1, 0, 0, 0).value() == 0xff000000);
	assert(prism::color(1, 1, 0, 0).value() == 0xffff0000);
	assert(prism::color(1, 1, 1, 0).value() == 0xffffff00);
	assert(prism::color(1, 1, 1, 1).value() == 0xffffffff);
}
