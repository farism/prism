# prism

## Overview

Prism implements the following color spaces:

```
Color       // 128 bit (4 `float` channels)
ColorRGBA   // 32 bit (4 `char` channels)
ColorRGB    // 24 bit (3 `char` channels)
ColorCMY
ColorCMYK
ColorHSL
ColorHSV
ColorYUV
ColorXYZ
ColorLAB
ColorLABPolar
ColorLUV
ColorLUVPolar
ColorOklab
ColorOklabPolar
```

`Color` is the base type that all color spaces convert through.

`ColorRGBA` can be used to reduce memory usage, or `ColorRGB` if you do not need the alpha channel.

## Function API

The following functions and macros are available as methods for all color spaces:

```c3
color_value()  // convert to a `uint`
color()        // convert to a base `Color`
to()           // convert to the specified color space
to_str()       // pretty formatted string
to_hex_str()   // hex string
eq()           // equality check
```

The following functions and macros are only available as methods for the `Color` type:

```c3
almost_equal()
lerp()
mix()
clip()
distance()
saturate()
desaturate()
lighten()
darken()
get_luminosity()
set_luminosity()
get_saturation()
set_saturation()
blend_normal()
blend_darken()
blend_multiply()
blend_linear_burn()
blend_color_burn()
blend_lighten()
blend_screen()
blend_linear_dodge()
blend_color_dodge()
blend_overlay()
blend_hard_light()
blend_soft_light()
blend_difference()
blend_exclusion()
blend_color()
blend_luminosity()
blend_hue()
blend_saturation()

// shorthand conversions
rgb()
rgba()
cmy()
cmyk()
hsl()
hsv()
yuv()
xyz()
lab()
lab_polar()
luv()
luv_polar()
oklab()
oklab_polar()
```

## There are multiple ways to convert between color spaces

### 1. Use shorthand methods

```c3
Color red = {1, 0, 0, 1};

assert(red.rgb().color().hsl().color() == red);
```

### 2. Use `to` methods

```c3
ColorRGBA red = {255, 0, 0, 255};

assert(red.to(Color).to(ColorRGBA) == red);
```

## 3. Use `to` macro directly

## Create a `Color`

```c3
Color red = {1, 0, 0, 1};

assert(prism::to(red, ColorRGBA) == prism::rgba(255, 0, 0));
```

## Convert to a `uint`

```c3
assert(prism::color(1, 0, 0).value() == 0xFF0000FF);
```

## Use other color spaces, like `ColorRGBA`

```c3
ColorRGBA red = {255, 0, 0, 255};
ColorRGBA red = prism::rgba(255, 0, 0, 255);
ColorRGBA red = prism::rgba(255, 0, 0);
assert(red.value() == 0xFF0000FF);
```

## Convert between Color and other color spaces

```c3
Color red = {1, 0, 0, 1};
ColorRGBA red_rgba = red.rgba();
ColorHSL red_hsl = red.hsl();

// convert back to color
Color red = red_rgba.color();
```

## Convert between arbitrary color spaces

```c3
ColorRGBA red = prism::rgba(255, 0, 0);

// convert to color first
ColorHSL red_hsl = red.color().hsl();

// or use `to`
ColorHSL red_hsl = red.to(ColorHSL);
```

## Perform equality checks

```c3
assert(prism::color(1, 0, 0) == prism::color(1, 0, 0));

// between arbitrary types
assert(prism::color(1, 0, 0) == prism::rgba(255, 0, 0));
```

## Parse hex string

```c3
Color red = {1, 0, 0, 1};

assert(prism::parse_hex_str("#FF0000FF") == red);
assert(prism::parse_hex_str("#FF0000") == red);

// shorthand format
assert(prism::parse_hex_str("#F00F") == red);
assert(prism::parse_hex_str("#F00") == red);
```

## To hex string

```c3
assert(prism::color(1, 0, 0).to_hex_str() == "FF000000"); // alpha is `true` by default

assert(prism::color(1, 0, 0).to_hex_str(alpha: false) == "FF0000");
```

## HTMLName

The `HTMLName` type is a `constdef` with values being each colors hex string.

### Converting to a color

```c3
Color honeydew = HtmlName.HONEYDEW.color();
```

### Parsing an HTML name

```c3
assert(prism::parse_html_name("honeydew")!! == HtmlName.HONEYDEW.color());
```