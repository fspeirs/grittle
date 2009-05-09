#
# Script to generate a branch diagram in OmniGraffle
#
require 'rubygems'
require 'grit'
include Grit


def make_graphic_for_commit(c)
  shape = 'make new shape at end of graphics with properties {name:\"RoundRect\", textSize:{0.8, 1.0}, fill color:{0.718475, 1.0, 0.755425}, textPosition:{0.1, 0.0}, origin:{206.0, 270.0}, size:{121.0, 79.0}, draws shadow:false, text: {text: \"' + c.id[0,8] + '\", text: \"' + c.id[0,8] + '\", alignment: center}}'
  `osascript -e "tell application \\"Omnigraffle Professional 5\\"" -e "tell canvas of front window" -e "#{shape}" -e "end tell" -e "end tell"`
end

def make_line_between_graphics(commit, parent)
  linescript = 'make new line at end of graphics with properties {point list:{{255.7701, 269.5171}, {229.7299, 172.4829}}, head type:\"FilledArrow\", line type:curved}'
  `osascript -e "tell application \\"Omnigraffle Professional 5\\"" -e "tell canvas of front window" -e "#{linescript}" -e "end tell" -e "end tell"`
  `osascript -e "tell application \\"Omnigraffle Professional 5\\"" -e "tell canvas of front window" -e "set source of graphic -1 to #{commit}" -e "end tell" -e "end tell"`
  `osascript -e "tell application \\"Omnigraffle Professional 5\\"" -e "tell canvas of front window" -e "set destination of graphic -1 to #{parent}" -e "end tell" -e "end tell"`  
end

def layout()
  `osascript -e "tell application \\"Omnigraffle Professional 5\\"" -e "tell canvas of front window" -e "layout" -e "end tell" -e "end tell"` 
end

def draw(head)
  
end

repo = Repo.new('/Users/fspeirs/Code/Git')
commits = repo.commits('master', 150)
shapes = {}
commits.each { |c|
 shapes[c.id] = make_graphic_for_commit(c)
 puts shapes[c.id]
}

commits.each { |c|
  puts c.parents
  c.parents.each { |p|
    puts "Line: #{shapes[c.id]} --> #{shapes[p.id]}"
    if shapes.has_key? p.id then
      make_line_between_graphics(shapes[c.id], shapes[p.id])
      layout()
    end
    }
  
  }
  
  layout()