# Applescript shell-outs for chart building

def osax_graffle_shell(calls)
  osax = calls.map{|r| '"'+r+'" -e '}.join(" ")  # joins the incoming osax calls in prep for osascript
  full_call = 'osascript -e "tell application \\"Omnigraffle Professional 5\\"" -e "tell canvas of front window" -e'+osax+'"end tell" -e "end tell"'
  res = `#{full_call}`
#  puts "\n: #{full_call}"
  res.match(/graphic id [0-9]+/)[0] rescue nil
end

def make_graphic_for_commit(commit, shell_out = true) 
  shape=[] << 'make new shape at end of graphics with properties {name:\"RoundRect\", textSize:{0.8, 1.0}, fill color:{0.718475, 1.0, 0.755425}, textPosition:{0.1, 0.0}, origin:{206.0, 270.0}, size:{121.0, 79.0}, draws shadow:false, text: {text: \"' + commit.id[0,8] + '\", text: \"' + commit.id[0,8] + '\", alignment: center}}'

  shape = osax_graffle_shell( shape ) if shell_out
  return shape
end

def make_graphic_for_tag(tag, shell_out = true)
  tag=[] << 'make new shape at end of graphics with properties {fill color: {0.760290, 0.952503, 1.000000}, origin: {60.000000, 84.000000}, size: {140.000000, 66.000000}, text: {text: \"' + tag.name + '\", text: \"' + tag.name + '\", alignment: center}, draws shadow: false}'

  tag = osax_graffle_shell( tag ) if shell_out
  return tag
end

def make_graphic_for_head(head, shell_out = true)
  head=[] << 'make new shape at end of graphics with properties {name: \"Circle\", textSize: {0.800000, 0.700000}, fill color: {0.960518, 0.679012, 1.000000}, textPosition: {0.100000, 0.150000}, origin: {160.000000, 120.112358}, size: {118.000000, 39.775280}, text: {text: \"' + head.name + '\", text: \"' + head.name + '\", alignment: center}, draws shadow: false}'

  head = osax_graffle_shell( head ) if shell_out
  return head
end

def make_line_between_graphics(commit, parent, shell_out = true)
  linescript=[] << 'make new line at end of graphics with properties {point list:{{255.7701, 269.5171}, {229.7299, 172.4829}}, head type:\"FilledArrow\", line type:curved}'
  linescript    << "set source of graphic -1 to #{commit}"
  linescript    << "set destination of graphic -1 to #{parent}"

  linescript = osax_graffle_shell( linescript ) if shell_out
  return linescript
end

def layout(shell_out = true)
  finish = "layout"
  
  finish = osax_graffle_shell( finish ) if shell_out
  return finish
end

def draw(head)
  
end
