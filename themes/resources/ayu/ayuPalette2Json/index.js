const colors = require("ayu");
const Color = require("ayu/dist/color").Color;
const variants = ["light", "dark", "mirage"];

const paletteJson = {};

function deepColorToHex(src, dest) {
  for (const key in src) {
    if (src[key] instanceof Color) {
      dest[key] = src[key].hex("rgb").replace(/^#/, "");
      continue;
    }
    if (dest[key] === undefined) {
      dest[key] = {};
    }
    deepColorToHex(src[key], dest[key]);
  }
}

for (const variant of variants) {
  if (paletteJson[variant] === undefined) {
    paletteJson[variant] = {};
  }
  const themeVariant = paletteJson[variant];
  const theme = colors[variant];
  deepColorToHex(theme, themeVariant);
}

console.log(JSON.stringify(paletteJson));
