
# requires
fs = require 'fs'
Math = window.Math

#read some json
chainrings = eval(fs.readFileSync('chainrings.json', 'utf8'))
casettes = eval(fs.readFileSync('casettes.json', 'utf8'))
sources = eval(fs.readFileSync('sources.json', 'utf8'))

gear = (cx, cy, outer_radius, inner_radius, number_of_teeth) ->
  path = []
  initial_x =  cx
  initial_y = outer_radius + cy
  path.push "M #{initial_x} #{initial_y}"

  for i in [0...number_of_teeth]
    angle1 = (2 * Math.PI) * (i + 0.25) / number_of_teeth
    angle2 = (2 * Math.PI) * (i + 1) / number_of_teeth
    x1 = Math.sin(angle1) * outer_radius + cx
    y1 = Math.cos(angle1) * outer_radius + cy
    path.push "L #{x1} #{y1}"
    x2 = Math.sin(angle2) * outer_radius + cx
    y2 =  Math.cos(angle2) * outer_radius + cy
    arcx1 = Math.sin(angle1) * inner_radius + cx
    arcy1 = Math.cos(angle1) * inner_radius + cx
    arcx2 = Math.sin(angle2) * inner_radius + cx
    arcy2 = Math.cos(angle2) * inner_radius + cx
    path.push "C #{arcx1} #{arcy1} #{arcx2} #{arcy2} #{x2} #{y2}"

  path.push "Z"
  path.join ""

set_gears = (cx, cy, number_of_teeth) ->
  outer_radius = number_of_teeth * Math.PI
  inner_radius = outer_radius - 10
  gear(cx, cy, outer_radius, inner_radius, number_of_teeth)


body = d3.selectAll "body"

svg = body.append("svg").attr
  class : "mainsvg"

data = [11, 12, 13, 14, 15, 17, 19, 22, 25, 28, 32].reverse()


path = svg.selectAll("path")

path.data(data)
  .enter().append("path")
  .attr
    d: (d) -> set_gears(250, 250, d)
    class: "chainring"
  .style
    transform : (d, i) -> "rotate(250, 250, #{ d }deg)"
    fill : (d) -> "rgb(#{d*5}, #{255 - d*5}, #{d*5})"









function gear(d) {
  var n = d.teeth,
      r2 = Math.abs(d.radius),
      r0 = r2 - 8,
      r1 = r2 + 8,
      r3 = d.annulus ? (r3 = r0, r0 = r1, r1 = r3, r2 + 20) : 20,
      da = Math.PI / n,
      a0 = -Math.PI / 2 + (d.annulus ? Math.PI / n : 0),
      i = -1,
      path = ["M", r0 * Math.cos(a0), ",", r0 * Math.sin(a0)];
  while (++i < n) path.push(
      "A", r0, ",", r0, " 0 0,1 ", r0 * Math.cos(a0 += da), ",", r0 * Math.sin(a0),
      "L", r2 * Math.cos(a0), ",", r2 * Math.sin(a0),
      "L", r1 * Math.cos(a0 += da / 3), ",", r1 * Math.sin(a0),
      "A", r1, ",", r1, " 0 0,1 ", r1 * Math.cos(a0 += da / 3), ",", r1 * Math.sin(a0),
      "L", r2 * Math.cos(a0 += da / 3), ",", r2 * Math.sin(a0),
      "L", r0 * Math.cos(a0), ",", r0 * Math.sin(a0));
  path.push("M0,", -r3, "A", r3, ",", r3, " 0 0,0 0,", r3, "A", r3, ",", r3, " 0 0,0 0,", -r3, "Z");
  return path.join("");
}

class Cassette

  constructor : (options) ->
    {@source, @cogs, @name} = options

  get_steps : ->
    steps = []
    for cog, i in @cogs[0..-2]
      steps.push @cogs[ i + 1 ] / cog
    steps

  pretty_steps : ->
    steps = @get_steps()
    out_string = '    '
    for step in steps
      out_string = out_string + step.toFixed 2
      out_string = out_string + ' '
    out_string = out_string + '\n'
    for cog in @cogs
      out_string = out_string + cog
      out_string = out_string + '    '
    out_string

for c in casettes
  c = new Cassette c
  steps = c.pretty_steps()
  console.log steps
  console.log ''
